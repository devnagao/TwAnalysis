//
//  SettingsViewController.swift
//  Twitter
//
//  Created by Dev on 7/28/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var btnContactUs: UIButton!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var btnBuyCredits: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.btnContactUs.setTitle(self.getLocalizedString(string: "Contact Us"), for: .normal)
        self.btnRate.setTitle(self.getLocalizedString(string: "Rate This App"), for: .normal)
        self.btnShare.setTitle(self.getLocalizedString(string: "Share This App"), for: .normal)
        self.btnOther.setTitle(self.getLocalizedString(string: "Other Apps"), for: .normal)
        self.btnChange.setTitle(self.getLocalizedString(string: "Change Username"), for: .normal)
        self.btnBuyCredits.setTitle(self.getLocalizedString(string: "Buy Credits"), for: .normal)
        
    }
    
    func getLocalizedString(string: String) -> String {
        return NSLocalizedString(string, comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onRate(_ sender: Any) {
        if (UIApplication.shared.canOpenURL(URL(string: "itms-apps://itunes.apple.com/app/id1263893870")!)) {
            UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id1263893870")!, options: [:], completionHandler: nil)
        }
        
    }

    @IBAction func onShare(_ sender: Any) {

#if DEBUG
        
        let textToShare = "Twfollow is awesome!  Check out this website about it!"
    
        if let myWebsite = NSURL(string: "https://itunes.apple.com/us/app/test-twitter/id1263893870?ls=1&mt=8") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
            let excludeActivities = [UIActivityType.mail, .postToFacebook, .postToTwitter, .message] as [UIActivityType]
            activityVC.excludedActivityTypes = excludeActivities
        
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }

#else

        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setSubject("Twfollow is awesome!")
        picker.setMessageBody("https://itunes.apple.com/us/app/test-twitter/id1263893870?ls=1&mt=8", isHTML: true)
    
        self.present(picker, animated: true, completion: nil)
    
#endif
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onOtherApps(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: "https://itunes.apple.com/developer/erkan-eroglu/id667357099")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func onChangeUser(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotochangeuser"), object: nil)
    }
    
    @IBAction func onBuyCredits(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotobuycredits"), object: nil)
    }
    
}
