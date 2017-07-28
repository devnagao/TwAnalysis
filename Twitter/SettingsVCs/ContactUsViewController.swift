//
//  ContactUsViewController.swift
//  Twitter
//
//  Created by Dev on 7/28/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController , UITextFieldDelegate, UITextViewDelegate{

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMessage: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSend(_ sender: Any) {
        
        
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        txtEmail.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        txtMessage.resignFirstResponder()
    }
    
}
