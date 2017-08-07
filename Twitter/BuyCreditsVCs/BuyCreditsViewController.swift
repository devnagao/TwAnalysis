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
import SwiftyStoreKit
//import StoreKit


//extension SKProduct {
//    
//    func priceAsString() -> String {
//        var formatter : NumberFormatter? = nil
//        if formatter == nil {
//            formatter = NumberFormatter()
//        }
//        
//        formatter?.formatterBehavior = NumberFormatter.Behavior.behavior10_4
//        formatter?.numberStyle = NumberFormatter.Style.currency
//        formatter?.locale = self.priceLocale
//        
//        return (formatter?.string(from: self.price))!
//    }
//}


class BuyCreditsViewController: UIViewController { //, SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var imgLoading: UIImageView!
    
    @IBOutlet weak var lbl250Credits: UILabel!
    @IBOutlet weak var lbl500Credits: UILabel!
    @IBOutlet weak var lbl1000Credits: UILabel!
    @IBOutlet weak var lbl2500Credits: UILabel!
    @IBOutlet weak var lbl5000Credits: UILabel!
    @IBOutlet weak var lbl10000Credits: UILabel!
    
    var productIds : [String] = ["credits_250", "credits_500", "credits_1000", "credits_2500", "credits_5000", "credits_10000"]
    var titles : [String] = []
    var prices : [String] = []
    
    var deliveryFormat: String = ""
    
    var resultString: String = ""

//    let receiptRequest = SKReceiptRefreshRequest()
    
//    func getProductsRequest()->SKProductsRequest {
//        if (productsRequest == nil) {
//            productsRequest = SKProductsRequest(productIdentifiers: NSSet(array: self.productIds) as! Set<String>)
//            productsRequest?.delegate = self
//        }
//        return productsRequest!
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setLabels()
        
        self.loadingView.isHidden = true
        
//        self.productsRequest = self.getProductsRequest()
//        self.productsRequest?.start()
//        SKPaymentQueue.default().add(self)
        
        
//        receiptRequest.delegate = self
        
        
        
    }
    
    func setLabels() {
        self.lbl250Credits.text = "250 " + NSLocalizedString("Credits", comment: "")
        self.lbl500Credits.text = "500 " + NSLocalizedString("Credits", comment: "")
        self.lbl1000Credits.text = "1000 " + NSLocalizedString("Credits", comment: "")
        self.lbl2500Credits.text = "2500 " + NSLocalizedString("Credits", comment: "")
        self.lbl5000Credits.text = "5000 " + NSLocalizedString("Credits", comment: "")
        self.lbl10000Credits.text = "10000 " + NSLocalizedString("Credits", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func on250(_ sender: Any) {
        
        let gif = UIImage.gifImageWithName(name: "loading")
        self.imgLoading.image = gif
        self.loadingView.isHidden = false
        
        self.purchase(productId: "credits_250")
    }
    
    @IBAction func on500(_ sender: Any) {

        let gif = UIImage.gifImageWithName(name: "loading")
        self.imgLoading.image = gif
        self.loadingView.isHidden = false
        
        self.purchase(productId: "credits_500")
    }
    
    @IBAction func on1000(_ sender: Any) {

        let gif = UIImage.gifImageWithName(name: "loading")
        self.imgLoading.image = gif
        self.loadingView.isHidden = false
        
        self.purchase(productId: "credits_1000")
    }
    
    @IBAction func on2500(_ sender: Any) {

        let gif = UIImage.gifImageWithName(name: "loading")
        self.imgLoading.image = gif
        self.loadingView.isHidden = false
        
        self.purchase(productId: "credits_2500")
    }
    
    @IBAction func on5000(_ sender: Any) {

        let gif = UIImage.gifImageWithName(name: "loading")
        self.imgLoading.image = gif
        self.loadingView.isHidden = false
        
        self.purchase(productId: "credits_5000")
    }
    
    @IBAction func on10000(_ sender: Any) {
 
        let gif = UIImage.gifImageWithName(name: "loading")
        self.imgLoading.image = gif
        self.loadingView.isHidden = false
        
        self.purchase(productId: "credits_10000")
    }
    
    
    func purchase(productId: String) {
        
        SwiftyStoreKit.purchaseProduct(productId, atomically: true) { result in
            self.loadingView.isHidden = true
            if case .success(let purchase) = result {
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                
                let appleValidator = AppleReceiptValidator(service: .production)
                SwiftyStoreKit.verifyReceipt(using: appleValidator, password: "") { result in
                    
                    if case .success(let receipt) = result {
                        
                        
                        let purchaseResult = SwiftyStoreKit.verifySubscription(
                            type: .autoRenewable,
                            productId: productId,
                            inReceipt: receipt)
                        print("Verify receipt success: \(receipt)")
                        
                        let receiptData = receipt.description.data(using: .utf8)
                        let receiptString = receiptData?.base64EncodedString(options: [])
                        self.verifyTransaction(receiptData: receiptString!)
                        
                        switch purchaseResult {
                        case .purchased(let expiryDate, let receiptItems):
                            print("Product is valid until \(expiryDate)")
                        case .expired(let expiryDate, let receiptItems):
                            print("Product is expired since \(expiryDate)")
                        case .notPurchased:
                            print("This product has never been purchased")
                        }
                    } else {
                        // receipt verification error
                    }
                }
            } else {
                // purchase error
            }
        }

    }
    
    func verifyTransaction(receiptData: Any) {
        
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
        let param: [String: Any] = ["twusername333": username, "getoperation": "buycredits", "receipt": receiptData]
        
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
                var protected: Int = 1
                guard let protectedString = json["protected"] as? String else {
                    protected = 1
                    return
                }
                
                protected = Int(protectedString)!
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
