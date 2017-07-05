//
//  RateViewController.swift
//  GPS Address Book
//
//  Created by surendra kumar on 7/4/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit

class RateViewController: UIViewController, IAPHelperDelegate {
    
   
    var leftString = "Cancel"
    var rightString = "Rate"
    var msg = "If you Enjoy using this App, please rate us 5-Star on App store. It would be greate encouragement for us to continue improving the product"
    var isFromMapViewController = false
    var toptitle = "Encourage Us"
    
    
    @IBOutlet var encourage: UILabel!
    @IBOutlet var details: UILabel!
    @IBOutlet var left: UIButton!
    @IBOutlet var right: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        encourage.text = toptitle
        details.text = msg
        left.setTitle(leftString, for: .normal)
        right.setTitle(rightString, for: .normal)
        IAPHelper.sharedInstance.delegate = self
    }

    @IBAction func btnClick(_ sender: Any) {
        
        guard !isFromMapViewController else {
            print("purchase Item")
            IAPHelper.sharedInstance.requestProductInfo()
            //IAPHelper.sharedInstance.purchaseItem()
            dismiss(animated: true, completion: nil)
            return
        }
        let defaults = UserDefaults.standard
        defaults.set(-3, forKey: "time")
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func rate(_ sender: UIButton) {
        
    
        guard !isFromMapViewController else {
            print("frommapViewController")
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "rate10")
            
            let url : URL = URL(string: "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(APP_ID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=7")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            dismiss(animated: true, completion: nil)
            
            return
        }
        
        let url : URL = URL(string: "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(APP_ID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=7")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        let defaults = UserDefaults.standard
        defaults.set(-3, forKey: "time")
        dismiss(animated: true, completion: nil)
    }
    
    func purchasedItem() {
        // Item is purchsed so set value 
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "rate10")
        print("After Purchase : \(defaults.bool(forKey: "rate10"))")
    }
    
}
