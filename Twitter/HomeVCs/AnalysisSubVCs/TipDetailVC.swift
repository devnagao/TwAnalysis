//
//  TipDetailVC.swift
//  Twitter
//
//  Created by Dev on 7/27/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class TipDetailVC: UIViewController {
    
    @IBOutlet weak var lblTipCounter: UILabel!
    @IBOutlet weak var lblTipTitle: UILabel!
    @IBOutlet weak var lblTipContent: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    var totalTip : Int = 0
    var tipCounter : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        totalTip = Int(AppData.shared.jsonData["totaltip"] as! CFNumber)
        
        self.showTip()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onNext(_ sender: Any) {
        
        if tipCounter >= totalTip {
            return
        }
        
        tipCounter += 1
        self.showTip()
    }
    
    
    @IBAction func onPrev(_ sender: Any) {
        if tipCounter == 1 {
            self.navigationController?.popViewController(animated: true)
        }
        
        tipCounter -= 1
        self.showTip()
    }
    
    @IBAction func onContinue(_ sender: Any) {
        
        if tipCounter >= totalTip {
            return
        }
        
        tipCounter += 1
        self.showTip()
    }
    
    
    func showTip() {
        
        if (tipCounter >= 10) {
            self.btnNext.isHidden = true
            self.btnContinue.isHidden = true
        } else {
            self.btnNext.isHidden = false
            self.btnContinue.isHidden = false
        }
        
        self.lblTipCounter.text = "Tip " + String(tipCounter) + "/" + String(totalTip)
        self.lblTipTitle.text = "TIP " + String(tipCounter)
        
        let tipString = "tip" + String(tipCounter)
        self.lblTipContent.text = AppData.shared.jsonData[tipString] as? String ?? ""

        
    }
    
}
