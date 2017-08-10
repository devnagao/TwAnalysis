//
//  WelcomeVC.swift
//  Twitter
//
//  Created by Dev on 7/27/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblContents: UILabel!
    
    @IBOutlet weak var btnAnalysis: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblWelcome.text = NSLocalizedString("Welcome", comment: "")
        lblContents.text = NSLocalizedString("Welcome to the best application on the market to learn how to increase your followers.", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
