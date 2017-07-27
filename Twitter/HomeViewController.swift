//
//  HomeViewController.swift
//  Twitter
//
//  Created by Dev on 7/27/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var lblCredits: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblFollowerCount: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblRetordersCount: UILabel!
    
    @IBOutlet weak var statusHeight: NSLayoutConstraint!
    @IBOutlet weak var retordersCountHeight: NSLayoutConstraint!
    
    @IBOutlet weak var analysisContainerView: UIView!
    
    @IBOutlet weak var userpanelView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageURLString = AppData.shared.jsonData["imageurl"] as? String
        if (imageURLString != "") {
            let imageUrl : URL = URL(string: imageURLString!)!
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                let imageData:NSData = NSData(contentsOf: imageUrl)!
                
                // When from background thread, UI needs to be updated on main_queue
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    self.imgProfile.image = image
                }
            }
        }
        
        self.lblUsername.text = AppData.shared.username
        self.lblCredits.text = (AppData.shared.jsonData["credits"] as! String) ?? "0"
        
        let followCount = (AppData.shared.jsonData["followercount"] as? String) ?? "0"
        self.lblFollowerCount.text = followCount + " Followers"
        
        let status = Int(AppData.shared.jsonData["status"] as! String) ?? 0
        if (status > 0) {
            self.lblStatus.text = String(status) + " Followers are on the way."
        } else {
            self.statusHeight.constant = 0;
            self.view.layoutIfNeeded()
        }
            
        let retordersCount = AppData.shared.jsonData["retorderscount"] as! Int
        if (retordersCount > 0) {
            self.lblRetordersCount.text = String(retordersCount) + " RT-FAV orders are on the way."
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
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.imgProfile.layer.borderColor = UIColor.white.cgColor
        self.imgProfile.layer.borderWidth = 3
        self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.size.height / 2.0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func onBack(_ sender: Any) {
        self.tabBarController?.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onUserPanel(_ sender: Any) {
        
        let vc : UserPanelViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserPanelViewController") as! UserPanelViewController
        self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
