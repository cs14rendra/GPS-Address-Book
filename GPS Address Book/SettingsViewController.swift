//
//  SettingsViewController.swift
//  GPS Address Book
//
//  Created by surendra kumar on 7/4/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    @IBOutlet var navigationSwitch: UISwitch!
     var isAppearedOnce = false
    var shouldIShowRateDialog : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tracker()
        defaults.register(defaults: ["nav" : false])
        if defaults.bool(forKey: "nav"){
            navigationSwitch.setOn(true, animated: false)
        }else{
            navigationSwitch.setOn(false, animated: false)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard shouldIShowRateDialog else {return}
        if !isAppearedOnce{
            isAppearedOnce = true
            self.performSegue(withIdentifier: "rate", sender: self)
        }
    }
    @IBAction func mySwitch(_ sender: UISwitch) {
        if sender.isOn{
            defaults.set(true, forKey: "nav")
            print("NV ON")
        }else{
            defaults.set(false, forKey: "nav")
        }
    }
   
    @IBAction func rateUs(_ sender: Any) {
        let url : URL = URL(string: "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(APP_ID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=7")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
   
    @IBAction func share(_ sender: Any) {
        let acivity1 = DESCRIPTION
        let activity2 = APP_URL
        let activity = UIActivityViewController(activityItems: [acivity1,activity2], applicationActivities: nil)
        
        
        activity.popoverPresentationController?.sourceView = self.view
        
        present(activity, animated: true, completion: nil)
        

    }
   

    func tracker(){
        let defaults = UserDefaults.standard
        defaults.register(defaults: ["time":1])
        let oldtime = defaults.integer(forKey: "time")
        if (oldtime <= 3){
            let newtime = oldtime + 1
            defaults.set(newtime, forKey: "time")
        }else{
            shouldIShowRateDialog = true
        }
    }

}
