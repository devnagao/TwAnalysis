//
//  MainViewController.swift
//  Twitter
//
//  Created by Dev on 7/28/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var lblCredits: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblFollowerCount: UILabel!
    
    @IBOutlet weak var btnHomeTab: UIView!
    @IBOutlet weak var btnBuyCreditsTab: UIView!
    @IBOutlet weak var btnSettingsTab: UIView!
    
    @IBOutlet weak var viewHome: UIView!
    @IBOutlet weak var viewBuyCredits: UIView!
    @IBOutlet weak var viewSettings: UIView!
    
    @IBOutlet weak var lblHomeTab: UILabel!
    @IBOutlet weak var lblBuycreditsTab: UILabel!
    @IBOutlet weak var lblSettingsTab: UILabel!
    
    @IBOutlet weak var btnChangeUser: UIButton!
    
    
    var openUrlId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotoHome), name: NSNotification.Name(rawValue: "gotohome"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotoBuyCredits), name: NSNotification.Name(rawValue: "gotobuycredits"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotoChangeUser), name: NSNotification.Name(rawValue: "gotochangeuser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotoUserPanel), name: NSNotification.Name(rawValue: "gotouserpanel"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let customernot = AppData.shared.jsonData["customernot"] as? String
        if (customernot != "") {
            self.showDefaultAlert(title: "", message: customernot!, buttonTitle: "Close")
        }
        
        if openUrlId == "buycredits" {
            self.gotoBuyCredits()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshViews() {
        self.initViews()
    }

    func initViews() {
        
        self.imgProfile.layer.borderColor = UIColor.white.cgColor
        self.imgProfile.layer.borderWidth = 3
        self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.size.height / 2.0
        
        let imageURLString = AppData.shared.jsonData["imageurl"] as! String
        if (imageURLString != "") {
            let imageUrl : URL = URL(string: imageURLString)!
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                let imageData: NSData = NSData(contentsOf: imageUrl)!
                
                // When from background thread, UI needs to be updated on main_queue
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)!
                    self.imgProfile.image = image
                }
            }
        }
        
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        self.lblUsername.text = username
        
        self.lblCredits.text = String(AppData.shared.credits)
        let followCount = AppData.shared.jsonData["followercount"] as? String ?? "0"
        
        self.lblFollowerCount.text = followCount + " " + NSLocalizedString("Followers", comment: "")
        
        self.lblHomeTab.text = NSLocalizedString("Start", comment: "")
        self.lblBuycreditsTab.text = NSLocalizedString("Buy Credits", comment: "")
        self.lblSettingsTab.text = NSLocalizedString("Settings", comment: "")
        
        self.btnChangeUser.setTitle(NSLocalizedString("Change Username", comment: ""), for: .normal)
        
        
    }
    
    @IBAction func onHomeTab(_ sender: Any) {
        
        self.gotoHome()
    }
    
    func gotoHome() {
        self.btnHomeTab.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 100/255.0, blue: 1.0, alpha: 1.0)
        self.btnBuyCreditsTab.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 131/255.0, blue: 208/255.0, alpha: 1.0)
        self.btnSettingsTab.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 131/255.0, blue: 208/255.0, alpha: 1.0)
        
        self.viewHome.isHidden = false
        self.viewBuyCredits.isHidden = true
        self.viewSettings.isHidden = true
    }
    
    
    @IBAction func onBuyCreditsTab(_ sender: Any) {
        
        self.gotoBuyCredits()
    }
    
    func gotoBuyCredits() {
        self.btnHomeTab.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 131/255.0, blue: 208/255.0, alpha: 1.0)
        self.btnBuyCreditsTab.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 100/255.0, blue: 1.0, alpha: 1.0)
        self.btnSettingsTab.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 131/255.0, blue: 208/255.0, alpha: 1.0)
        
        self.viewHome.isHidden = true
        self.viewBuyCredits.isHidden = false
        self.viewSettings.isHidden = true
    }
    
    @IBAction func onSettings(_ sender: Any) {
        
        
        self.btnHomeTab.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 131/255.0, blue: 208/255.0, alpha: 1.0)
        self.btnBuyCreditsTab.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 131/255.0, blue: 208/255.0, alpha: 1.0)
        self.btnSettingsTab.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 100/255.0, blue: 1.0, alpha: 1.0)
        
        self.viewHome.isHidden = true
        self.viewBuyCredits.isHidden = true
        self.viewSettings.isHidden = false
    }

    
    @IBAction func onBack(_ sender: Any) {
        self.gotoChangeUser()
    }
    
    func gotoChangeUser() {
        
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        
        self.navigationController?.pushViewController(loginVC!, animated: true)
    }
    
    
    func showDefaultAlert(title: String, message: String, buttonTitle: String) {
        let alertController = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        if (self.view.frame.origin.y < 0) {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let screenHeight = UIScreen.main.bounds.size.height
            self.view.frame.origin.y = -(keyboardSize.height - screenHeight * 90 / 1334.0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func gotoUserPanel() {
        let vc : UserPanelViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserPanelViewController") as! UserPanelViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "gotouserpanel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotoUserPanel), name: NSNotification.Name(rawValue: "gotouserpanel"), object: nil)
    }
}
