//
//  BuyCreditsViewController.swift
//  Twitter
//
//  Created by Dev on 7/28/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import Alamofire
import SystemConfiguration
import Foundation
import StoreKit

class BuyCreditsViewController: UIViewController {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var imgLoading: UIImageView!
    
    var resultString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadingView.isHidden = true
        
        var productIdentifiers = Set<ProductIdentifier>()
        productIdentifiers.insert("credits_250")
        productIdentifiers.insert("credits_500")
        productIdentifiers.insert("credits_1000")
        productIdentifiers.insert("credits_5000")
        productIdentifiers.insert("credits_10000")
        
        IAP.requestProducts(productIdentifiers) { (response, error) in
            if let products = response?.products, !products.isEmpty {
                for product in products {
                    self.resultString += product.productIdentifier
                }
                
            } else if let invalidProductIdentifiers = response?.invalidProductIdentifiers {
                self.resultString = "Invalid product identifiers: " + invalidProductIdentifiers.description
                
            } else if let error = error as NSError? {
                if error.code == SKError.Code.paymentCancelled.rawValue {
                    self.resultString = ""
                    
                } else {
                    self.resultString = error.localizedDescription
                }
            }
            print(self.resultString)
        }
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func on250(_ sender: Any) {
        
        self.purchase(productID: "credits_250")
    }
    
    @IBAction func on500(_ sender: Any) {
        self.purchase(productID: "credits_500")
    }
    
    @IBAction func on1000(_ sender: Any) {
        self.purchase(productID: "credits_1000")
    }
    
    @IBAction func on2500(_ sender: Any) {
        self.purchase(productID: "credits_2500")
    }
    
    @IBAction func on5000(_ sender: Any) {
        self.purchase(productID: "credits_5000")
    }
    
    @IBAction func on10000(_ sender: Any) {
        self.purchase(productID: "credits_10000")
    }
    
    func purchase(productID: String) {
        IAP.purchaseProduct(productID, handler: { (productIdentifier, error) in
            if let identifier = productIdentifier {
                self.resultString = identifier
                
            } else if let error = error as NSError? {
                if error.code == SKError.Code.paymentCancelled.rawValue {
                    self.resultString = ""
                    
                } else {
                    self.resultString = error.localizedDescription
                }
            }
            
            self.validateReceipt()
        })
    }
    
    func validateReceipt() {
        
        IAP.validateReceipt("2dbc5006fff544d58c1c4d0fa6446e42") { (statusCode, products, json) in
            
            var receipt: [String: Any] = [:]
            
            if statusCode == ReceiptStatus.noRecipt.rawValue {
                // No Receipt in main bundle
                self.resultString = "No receipt"
            } else {
                // Get products with their expire date.
                var productString = ""
                if let products = products {
                    for (productID, _) in products {
                        productString += productID + " "
                    }
                }
                self.resultString = "\(statusCode ?? -999): \(productString)"
                
                receipt = json!
            }
            
            self.sendReceipt(receipt: receipt)
            
        }
    }
    
    func sendReceipt(receipt: Any) {
        
        let gif = UIImage.gifImageWithName(name: "loading")
        self.imgLoading.image = gif
        self.loadingView.isHidden = false
        
        if (!isInternetAvailable()) {
            self.loadingView.isHidden = true
            self.showDefaultAlert(title: "Error", message: "There is no internet connection.")
            return
        }
        
        let urlString: String = "https://www.twfollo.com/retweet/twapi.php"
        
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let param: [String: Any] = ["twusername333": username, "getoperation": "buycredits", "receipt": receipt]
        
        Alamofire.request(urlString, method: .post, parameters: param,
                          encoding: URLEncoding.default)
            .responseJSON { response in
                self.imgLoading.image = nil
                self.loadingView.isHidden = true
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    
                    self.showDefaultAlert(title: "Error", message: "")
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
                
                self.completionPurchase()
                let protected = Int(json["protected"] as! String) ?? 1
                if (protected == 0) {
                    self.showDefaultAlert(title: "", message: NSLocalizedString("Your account is private. Please make your account public.", comment: ""))
                }
                
        }
    }
    
    
    func completionPurchase() {
        
        let alertController = UIAlertController(title: "Success" as String, message: NSLocalizedString("Do you want to see other applications of us?", comment: "") as String, preferredStyle: UIAlertControllerStyle.alert)
        let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: UIAlertActionStyle.default) { (action) in
            UIApplication.shared.open(URL(string: "https://itunes.apple.com/developer/erkan-eroglu/id667357099")!, options: [:], completionHandler: nil)
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        
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
    
    
    func showDefaultAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
