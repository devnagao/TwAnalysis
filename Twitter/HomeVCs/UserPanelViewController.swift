//
//  UserPanelViewController.swift
//  Twitter
//
//  Created by Dev on 7/27/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class UserPanelViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let languageCode = Locale.preferredLanguages[0]
        
        let url = "https://twfollo.com/conditional/twitter.php?user=" + username + "&language=" + languageCode
//        let url = "twitter://buycredits"
        
        self.webView.loadRequest(URLRequest(url: URL(string: url)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    @IBAction func onClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
