//
//  SettingsViewController.swift
//  Twitter
//
//  Created by Dev on 7/28/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
