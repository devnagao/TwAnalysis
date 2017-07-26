//
//  LoginViewController.swift
//  Twitter
//
//  Created by Dev on 7/26/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameView.layer.cornerRadius = 3
        self.btnContinue.layer.cornerRadius = 3
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func onContinue(_ sender: Any) {
        
        
        
        
    }

}

