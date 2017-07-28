//
//  AnalysisVC.swift
//  Twitter
//
//  Created by Dev on 7/27/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import Alamofire
import SystemConfiguration


class AnalysisVC: UIViewController {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var imgLoading: UIImageView!
    
    @IBOutlet weak var lblFollowerCount: UILabel!
    @IBOutlet weak var lblFriendsCount: UILabel!
    @IBOutlet weak var lblTweetCount: UILabel!
    @IBOutlet weak var lblFollowerIncrease: UILabel!
    @IBOutlet weak var lblFriendsIncrease: UILabel!
    @IBOutlet weak var lblAverageRT: UILabel!
    @IBOutlet weak var lblAverageFAV: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let gif = UIImage.gifImageWithName(name: "loading")
        self.imgLoading.image = gif
        self.loadingView.isHidden = false
        
        if (!isInternetAvailable()) {
            self.loadingView.isHidden = true
            self.showDefaultAlert(title: "Error", message: "There is no internet connection.")
            return
        }
        
        let urlString: String = "https://twfollo.com/retweet/twanalysis.php"
        let param: [String: Any] = ["twusername333": AppData.shared.username!]
        Alamofire.request(urlString, method: .post, parameters: param,
                          encoding: URLEncoding.default)
            .responseJSON { response in
                self.imgLoading.image = nil
                self.loadingView.isHidden = true
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    
                    self.showDefaultAlert(title: "Login Failed", message: "")
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
                
                self.setValues(jsonData: json)
                
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setValues(jsonData: [String: Any]) {
        
        self.lblFollowerCount.text = String(describing: jsonData["followerCount"] as! CFNumber)
        self.lblFriendsCount.text = String(describing: jsonData["friendsCount"] as! CFNumber)
        self.lblTweetCount.text = String(describing: jsonData["tweetCount"] as! CFNumber)
        self.lblFollowerIncrease.text = String(describing: jsonData["followerincrease"] as! CFNumber)
        self.lblFriendsIncrease.text = String(describing: jsonData["friendsincrease"] as! CFNumber)
        self.lblAverageRT.text = String(describing: jsonData["averageRT"] as! CFNumber)
        self.lblAverageFAV.text = String(describing: jsonData["averageFAV"] as! CFNumber)
        
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

    
    func showDefaultAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
