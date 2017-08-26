//
//  ContactUsViewController.swift
//  Twitter
//
//  Created by Dev on 7/28/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import Alamofire
import SystemConfiguration

class ContactUsViewController: UIViewController , UITextFieldDelegate, UITextViewDelegate{

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMessage: UITextView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var imgLoading: UIImageView!
    
    
    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.lblEmailAddress.text = NSLocalizedString("Email Adress", comment: "")
        self.lblMessage.text = NSLocalizedString("Message", comment: "")
        self.btnSend.setTitle(NSLocalizedString("Send", comment: ""), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSend(_ sender: Any) {
        
        
        self.txtEmail.resignFirstResponder()
        self.txtMessage.resignFirstResponder()
        
        if (self.txtEmail.text == "" || self.txtMessage.text == "") {
            self.showDefaultAlert(title: "Error", message: "Please input email address and message.")
            return
        }
        
        if (!self.isValidEmail(testStr: self.txtEmail.text!)) {
            self.showDefaultAlert(title: "", message: NSLocalizedString("Invalid Mail Adress!", comment: ""))
            return
        }
        
        
        let urlString: String = "https://www.twfollo.com/retweet/takipci_twitter_mail.php"
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let email = self.txtEmail.text ?? ""
        let message = self.txtMessage.text ?? ""
        let param: [String: Any] = ["twusername333": username, "email": email, "msg": message]
        
        let gif = UIImage.gifImageWithName(name: "loading")
        self.imgLoading.image = gif
        self.loadingView.isHidden = false
        
        if (!isInternetAvailable()) {
            self.loadingView.isHidden = true
            self.showDefaultAlert(title: NSLocalizedString("Failed!", comment: ""), message: "There is no internet connection.")
            return
        }
        
        
        Alamofire.request(urlString, method: .post, parameters: param,
                          encoding: URLEncoding.default)
            .responseJSON { response in
                
                self.loadingView.isHidden = true
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    
                    self.showDefaultAlert(title: NSLocalizedString("Failed!", comment: ""), message: "")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let result = response.result.value as? String else {
                    self.showDefaultAlert(title: NSLocalizedString("Failed!", comment: ""), message: "")
                    
                    print("didn't get todo object as JSON from API")
                    print("Error: \(String(describing: response.result.error))")
                    return
                }
                
                if (result == "1") {
                    let alertController = UIAlertController(title: "", message: NSLocalizedString("Message Sent!", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotohome"), object: nil)
                    })
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "", message: "Message Failed-Try Again", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
        }
        
        
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        txtMessage.becomeFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        txtMessage.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtEmail.resignFirstResponder()
        self.txtMessage.resignFirstResponder()
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
    
    
}
