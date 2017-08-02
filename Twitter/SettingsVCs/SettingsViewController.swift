//
//  SettingsViewController.swift
//  Twitter
//
//  Created by Dev on 7/28/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
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
        if (UIApplication.shared.canOpenURL(URL(string: "itms-apps://itunes.apple.com/app/id1265362897")!)) {
            UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id1265362897")!, options: [:], completionHandler: nil)
        }
        
    }

    @IBAction func onShare(_ sender: Any) {
        let textToShare = "Twitter is awesome!  Check out this website about it!"
        
        if let myWebsite = NSURL(string: "https://itunes.apple.com/us/app/test-twitter/id1265362897?ls=1&mt=8") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            let excludeActivities = [UIActivityType.mail, .postToFacebook, .postToTwitter, .message] as [UIActivityType]
            activityVC.excludedActivityTypes = excludeActivities
            
            self.present(activityVC, animated: true, completion: nil)
        }
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
