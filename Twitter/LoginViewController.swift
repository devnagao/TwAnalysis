
import UIKit
import Alamofire
import SystemConfiguration

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingImageView: UIImageView!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var lblTwitterName: UILabel!
    
    
    let greenColor: UIColor = UIColor(colorLiteralRed: 49/255.0, green: 187/255.0, blue: 29/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameView.layer.cornerRadius = 3
        self.btnContinue.layer.cornerRadius = 3
        
        self.txtUsername.text = UserDefaults.standard.string(forKey: "username")
        if (self.txtUsername.text != "" && self == self.navigationController?.viewControllers[0]) {
            self.login()
        }
        
        self.lblNavTitle.text = NSLocalizedString("Welcome", comment: "")
        self.lblTwitterName.text = NSLocalizedString("Enter your twitter username:", comment: "")
        self.btnContinue.setTitle(NSLocalizedString("Continue", comment: ""), for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self == self.navigationController?.viewControllers[0])
        {
            self.btnBack.isHidden = true            
        }
        
        if (self.txtUsername.text == "") {
            self.btnContinue.isEnabled = false
            self.btnContinue.backgroundColor = UIColor.gray
        } else {
            self.btnContinue.isEnabled = true
            self.btnContinue.backgroundColor = greenColor
        }
    }
    
    func login() {
        
        if (txtUsername.text != "") {
            self.btnContinue.isEnabled = true
            self.btnContinue.backgroundColor = greenColor
        } else {
            self.btnContinue.isEnabled = false
            self.btnContinue.backgroundColor = UIColor.gray
            return
        }
        
        let urlString: String = "https://twfollo.com/retweet/twapi.php"
        let param: [String: Any] = ["twusername333": self.txtUsername.text!]
        
        let gif = UIImage.gifImageWithName(name: "loading")
        self.loadingImageView.image = gif
        self.loadingView.isHidden = false
        
        if (!isInternetAvailable()) {
            self.loadingView.isHidden = true
            self.showDefaultAlert(title: "Login Failed", message: "There is no internet connection.")
            return
        }
        
        
        Alamofire.request(urlString, method: .post, parameters: param,
                          encoding: URLEncoding.default)
            .responseJSON { response in
                
                self.loadingView.isHidden = true
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    
                    self.showDefaultAlert(title: "Login Failed", message: "")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    self.showDefaultAlert(title: "Login Failed", message: "")
                    
                    print("didn't get todo object as JSON from API")
                    print("Error: \(String(describing: response.result.error))")
                    return
                }
                
                print("The title is: " + (json["url2"] as! String))
                
                UserDefaults.standard.set(self.txtUsername.text, forKey: "username")
                AppData.shared.jsonData = json
                
                var credits: Int = 0
                guard let creditsString = json["credits"] as? String else {
                    credits = 0
                    AppData.shared.credits = credits
                    
                    let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                    self.navigationController?.pushViewController(mainVC, animated: true)
                    return
                }
                credits = Int(creditsString)!
                
                AppData.shared.credits = credits
                
                let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                self.navigationController?.pushViewController(mainVC, animated: true)
        }
    }

    @IBAction func onContinue(_ sender: Any) {
        self.txtUsername.resignFirstResponder()
        self.login()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtUsername.resignFirstResponder()
        self.login()
        return true
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 30
        let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if (newString.length > maxLength) {
            return false
        }
        
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = (string.components(separatedBy: cs)).joined(separator: "")
        
        if (textField.text != "") {
            self.btnContinue.isEnabled = true
            self.btnContinue.backgroundColor = greenColor
        } else {
            self.btnContinue.isEnabled = false
            self.btnContinue.backgroundColor = UIColor.gray
        }
        
        return string == filtered
    }
    
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func showDefaultAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

