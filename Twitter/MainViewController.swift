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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotoBuyCredits), name: NSNotification.Name(rawValue: "gotobuycredits"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotoChangeUser), name: NSNotification.Name(rawValue: "gotochangeuser"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshViews() {
        self.initViews()
    }

    override func viewWillLayoutSubviews() {
        super .viewWillLayoutSubviews()
        self.initViews()
    }
    
    func initViews() {
        self.imgProfile.layer.borderColor = UIColor.white.cgColor
        self.imgProfile.layer.borderWidth = 3
        self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.size.height / 2.0
        
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
        
        self.lblCredits.text = String(AppData.shared.credits)
        let followCount = Int(AppData.shared.jsonData["followercount"] as? String ?? "") ?? 0
        
        self.lblFollowerCount.text = String(followCount) + " Followers"
    }
    
    @IBAction func onHomeTab(_ sender: Any) {
        
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
        self.navigationController?.popViewController(animated: true)
    }
    
}
