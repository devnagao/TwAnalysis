//
//  UserPanelViewController.swift
//  Twitter
//
//  Created by Dev on 7/27/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class UserPanelViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let languageCode = Locale.preferredLanguages[0]
        
        self.loadingView.isHidden = true
        
        let url = "https://twfollo.com/conditional/twitter.php?user=" + username + "&language=" + languageCode
        
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
    
    
    // UIWebView Delegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let gif = UIImage.gifImageWithName(name: "loading")
        self.loadingImageView.image = gif
        self.loadingView.isHidden = false
        
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.loadingView.isHidden = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadingView.isHidden = true
    }
    
}
