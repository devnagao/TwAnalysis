//
//  HomeViewController.swift
//  Twitter
//
//  Created by Dev on 7/27/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import Alamofire

protocol HomeVCDelegate: class {
    func gotoUserPanel() 
}

class HomeViewController: UIViewController {
    
    weak var delegate: HomeVCDelegate?

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblRetordersCount: UILabel!
    
    @IBOutlet weak var statusHeight: NSLayoutConstraint!
    @IBOutlet weak var retordersCountHeight: NSLayoutConstraint!
    
    @IBOutlet weak var analysisContainerView: UIView!
    
    @IBOutlet weak var userpanelView: UIView!
    
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblUserPanelContents: UILabel!
    
    @IBOutlet weak var btnUserPanel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnUserPanel.setTitle(NSLocalizedString("User Panel", comment: ""), for: .normal)
        
        lblWelcome.text = NSLocalizedString("Welcome", comment: "")
        lblUserPanelContents.text = NSLocalizedString("Open your user panel to buy followers and RT-FAV with your credits.", comment: "")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let urlString: String = "https://twfollo.com/retweet/twapi.php"
        let param: [String: Any] = ["twusername333": username]
        
//        let gif = UIImage.gifImageWithName(name: "loading")
//        self.loadingImageView.image = gif
//        self.loadingView.isHidden = false
//        
        
        Alamofire.request(urlString, method: .post, parameters: param,
                          encoding: URLEncoding.default)
            .responseJSON { response in
                
//                self.loadingView.isHidden = true
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    
//                    self.showDefaultAlert(title: "Login Failed", message: "")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
//                    self.showDefaultAlert(title: "Login Failed", message: "")
                    
                    print("didn't get todo object as JSON from API")
                    return
                }
                
                print("The title is: " + (json["url2"] as! String))
                
                AppData.shared.jsonData = json
                
                var credits: Int = 0
                guard let creditsString = json["credits"] as? String else {
                    credits = 0
                    AppData.shared.credits = credits
                    
                    self.refresh()
                    return
                }
                credits = Int(creditsString)!
                
                AppData.shared.credits = credits
                
                self.refresh()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)

        }
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh() {
        let retordersCount = AppData.shared.jsonData["retorderscount"] as! Int
        if (retordersCount > 0) {
            self.lblRetordersCount.text = String(retordersCount) + " " + NSLocalizedString("RT-FAV orders", comment: "") + " " + NSLocalizedString("are on the way.", comment: "")
        } else {
            self.retordersCountHeight.constant = 0;
            self.view.layoutIfNeeded()
        }
        
        let auth = AppData.shared.jsonData["auth"] as! Int
        if (auth == 1) {
            self.analysisContainerView.isHidden = false
            self.userpanelView.isHidden = true
        } else if (auth == 0) {
            self.analysisContainerView.isHidden = true
            self.userpanelView.isHidden = false
        }
        
        guard let statusString = AppData.shared.jsonData["status"] as? String else {
            self.statusHeight.constant = 0;
            self.view.layoutIfNeeded()
            return
        }
        
        let status = Int(statusString)
        if (status! > 0) {
            self.lblStatus.text = statusString + " " + NSLocalizedString("Followers", comment: "") + " " + NSLocalizedString("are on the way.", comment: "")
        } else {
            self.statusHeight.constant = 0;
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func onUserPanel(_ sender: Any) {
        delegate?.gotoUserPanel()
                
    }
    
    
    
}
