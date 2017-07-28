//
//  TipDetailVC.swift
//  Twitter
//
//  Created by Dev on 7/27/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import Alamofire
import SystemConfiguration

class TipDetailVC: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var imgLoading: UIImageView!
    
    @IBOutlet weak var lblShowButton: UILabel!
    @IBOutlet weak var btnShow: UIView!
    
    @IBOutlet weak var lblTipCounter: UILabel!
    @IBOutlet weak var lblTipTitle: UILabel!
    @IBOutlet weak var lblTipContent: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    var totalTip : Int = 0
    var tipCounter : Int = 1
    var tipCost : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        totalTip = Int(AppData.shared.jsonData["totaltip"] as! CFNumber)
        tipCost = Int(AppData.shared.jsonData["tipcost"] as! CFNumber)
        
        self.lblShowButton.text = "SHOW (" + String(tipCost)
        
        self.loadingView.isHidden = true
        self.lblTipContent.text = "xxxxxxxx xxxxxxxxxxxxxxxxxx xxxxxxxxxx     xxxxxxxxxxxxxx."
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
    
    @IBAction func onShow(_ sender: Any) {
        
        let credits = AppData.shared.credits
        if credits < tipCost {
            self.showDefaultAlert(title: "", message: "Your need more credits to show.")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotobuycredits"), object: nil)
            return
        }
        
        let gif = UIImage.gifImageWithName(name: "loading")
        self.imgLoading.image = gif
        self.loadingView.isHidden = false
        
        if (!isInternetAvailable()) {
            self.loadingView.isHidden = true
            self.showDefaultAlert(title: "Error", message: "There is no internet connection.")
            return
        }
        
        let urlString: String = "https://www.twfollo.com/retweet/twapi.php"
        
        let param: [String: Any] = ["twusername333": AppData.shared.username!, "getoperation": "reducecredits"]
        
        Alamofire.request(urlString, method: .post, parameters: param,
                          encoding: URLEncoding.default)
            .responseJSON { response in
                self.imgLoading.image = nil
                self.loadingView.isHidden = true
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    
                    self.showDefaultAlert(title: "Error", message: "Cannot connect web service.")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    self.showDefaultAlert(title: "Error", message: "Empty Data")
                    
                    print("didn't get todo object as JSON from API")
                    print("Error: \(String(describing: response.result.error))")
                    return
                }
                
                AppData.shared.jsonData = json
                AppData.shared.credits = Int(json["credits"] as! CFNumber)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
                
                self.showTipContent()
                
        }
        
    }
    
    func showTip() {
        tipCost = Int(AppData.shared.jsonData["tipcost"] as! CFNumber)
        self.lblShowButton.text = "SHOW (" + String(tipCost)

        if (tipCounter >= 10) {
            self.btnNext.isHidden = true
            self.btnContinue.isHidden = true
        } else {
            self.btnNext.isHidden = false
            self.btnContinue.isHidden = false
        }
        
        self.lblTipCounter.text = "Tip " + String(tipCounter) + "/" + String(totalTip)
        self.lblTipTitle.text = "TIP " + String(tipCounter)
        
        self.lblTipContent.text = "xxxxxxxx xxxxxxxxxxxxxxxxxx xxxxxxxxxx     xxxxxxxxxxxxxx."
        
        self.btnShow.isHidden = false
        self.btnContinue.isHidden = true
    }
    
    func showTipContent() {
        
        let tipString = "tip" + String(tipCounter)
        self.lblTipContent.text = AppData.shared.jsonData[tipString] as? String ?? ""

        self.btnShow.isHidden = true
        self.btnContinue.isHidden = false
    }
    
    
    func showDefaultAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }

    
}
