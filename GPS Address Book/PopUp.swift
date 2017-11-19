//
//  PopUp.swift
//  GPS Address Book
//
//  Created by surendra kumar on 7/2/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MapKit


class PopUp: UIViewController, UITextFieldDelegate {

   
    var locationfromMain : CLLocationCoordinate2D?
    @IBOutlet weak var details: SkyFloatingLabelTextField!
    @IBOutlet weak var placeName: SkyFloatingLabelTextField!
    @IBOutlet weak var popView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popView.layer.cornerRadius = 10.0
        popView.layer.masksToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag+1) as? UITextField{
            nextTextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return false
    }
    
    @IBAction func clk(_ sender: UIButton) {
        let placeName = self.placeName.text ?? ""
        let details =   self.details.text ?? ""
        
        if placeName != "" {
        let address = Address()
        address.name = placeName
        address.details = details
        address.lat = (locationfromMain?.latitude)!
        address.lon = (locationfromMain?.longitude)!
        AddressBookDB.sharedInstance.storeAddress(address: address)
        }
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //transition.type = kCATransitionReveal
        //transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
        
    }
    
}
