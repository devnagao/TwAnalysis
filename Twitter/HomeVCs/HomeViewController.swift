//
//  HomeViewController.swift
//  Twitter
//
//  Created by Dev on 7/27/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblRetordersCount: UILabel!
    
    @IBOutlet weak var statusHeight: NSLayoutConstraint!
    @IBOutlet weak var retordersCountHeight: NSLayoutConstraint!
    
    @IBOutlet weak var analysisContainerView: UIView!
    
    @IBOutlet weak var userpanelView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
