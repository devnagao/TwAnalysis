//
//  LoginViewController.swift
//  Twitter
//
//  Created by Dev on 7/26/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import Alamofire
import SystemConfiguration

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameView.layer.cornerRadius = 3
        self.btnContinue.layer.cornerRadius = 3
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func onContinue(_ sender: Any) {
        
        self.txtUsername.resignFirstResponder()
        
        let urlString: String = "https://twfollo.com/retweet/twapi.php"
        let param: [String: Any] = ["twusername333": self.txtUsername.text!]
        
        let gif = UIImage.gifImageWithName(name: "loading")
        self.loadingImageView.image = gif
        self.loadingView.isHidden = false

        if (!isInternetAvailable()) {
            self.loadingView.isHidden = true
            self.showDefaultAlert(title: "Login Failed", message: "There is no internet connection.")
            return
        }
        
        Alamofire.request(urlString, method: .post, parameters: param,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                
                self.loadingView.isHidden = true
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    
                    self.showDefaultAlert(title: "Login Failed", message: "")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    self.showDefaultAlert(title: "Login Failed", message: "")
                    
                    print("didn't get todo object as JSON from API")
                    print("Error: \(String(describing: response.result.error))")
                    return
                }
                
                print("The title is: " + (json["url2"] as! String))
                
                AppData.shared.username = self.txtUsername.text!
                AppData.shared.jsonData = json
                let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabbarVC") as! UITabBarController
                self.navigationController?.pushViewController(mainVC, animated: true)
        }

        
        
    }
    
    func showDefaultAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtUsername.resignFirstResponder()
        
        return true
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

