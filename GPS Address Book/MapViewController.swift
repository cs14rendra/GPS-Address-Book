//
//  FirstViewController.swift
//  GPS Address Book
//
//  Created by surendra kumar on 7/2/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit
import  MapKit
import RealmSwift
import AlertOnboarding



class MapViewController: UIViewController {
    

    //MARK: - IBOutlets
    @IBOutlet var mapView : MKMapView!
    
    var newCoordinate : CLLocationCoordinate2D?
    var longPress : UILongPressGestureRecognizer?
    var isAnnotationAdded : Bool = false
    let locationmanager = CLLocationManager()
    var isTableSizeMoreThanTen = false
    
    // Alert 
    
    var alertView: AlertOnboarding!
    var arrayOfImage = ["item1", "item2", "item3","item4"]
    var arrayOfTitle = ["SAVE ADDRESS", "STORED ADDRESS", "SHARE","NAVIGATE"]
    var arrayOfDescription = ["Just Press and Hold on map, tap on marker, and choose action to save address or navigation to the marker",
                              "Easily view stored address using tab bar button, option to remove then if you don't want use that address ",
                              "Share Address to your freind/family, the exact location of any place","Navigate to stored address any time, by just clicking on the navigation button"]
    
    
    
    
    //MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if let loaction = mapView.userLocation.location{
            centerLocation(location: loaction)
        }
        mapView.userTrackingMode = .follow
        mapView.showsPointsOfInterest = true
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.mapPressed))
        mapView.addGestureRecognizer(longPress!)
        mapView.delegate = self
        let defaults = UserDefaults.standard
        defaults.register(defaults: ["rate10":false])
        self.alertView = AlertOnboarding(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.requestAuthorization()
        checkTableSize()
        //if !isAppAlreadyLaunchedOnce(){
            self.cutomizeAlertView()
            self.alertView.show()
           
        //}
    }
    
    func mapPressed(){
        let touchPoint = longPress?.location(in: mapView)
        let newCoordinate = mapView.convert(touchPoint!, toCoordinateFrom: mapView)
        guard !isAnnotationAdded else {return}
        isAnnotationAdded = true
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = "Pin Action"
        mapView.addAnnotation(annotation)
        
    }

    func requestAuthorization(){
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            return
        case .denied,.restricted:
            self.showDeniedAlert()
        default:
            locationmanager.requestWhenInUseAuthorization()
        }
    }
    
    func showDeniedAlert(){
        let alertController = UIAlertController(title: "Your Location", message: "Location is required to follow you on map. Please enable it in Settings.", preferredStyle: .alert)
        let setting = UIAlertAction(title: "Settings", style: .default) { (action) in
            
            if let AppSetting = URL(string: UIApplicationOpenSettingsURLString){
                UIApplication.shared.open(AppSetting, options: [:], completionHandler: nil)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancel)
        alertController.addAction(setting)
        present(alertController, animated: true, completion: nil)
    }
    
    func centerLocation(location: CLLocation){
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(location.coordinate, 400, 400), animated: true)
    }
    
    func openPopUp(){
        self.performSegue(withIdentifier: "pop", sender: self)
        }
    
    func showDirection(view : MKAnnotationView){
        
        let isGoogleMapOn : Bool = UserDefaults.standard.bool(forKey: "nav")
        let canOPen : Bool = UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)
        if isGoogleMapOn && canOPen{
            UIApplication.shared.open(URL(string:"comgooglemaps://?saddr=\(self.mapView.userLocation.coordinate.latitude),\(self.mapView.userLocation.coordinate.longitude)&daddr=\(view.annotation!.coordinate.latitude),\(view.annotation!.coordinate.longitude)&directionsmode=transit")!, options: [:], completionHandler: nil)
            mapView.removeAnnotationExceptUser()
            return
        }
        let anno = view.annotation
        let place = MKPlacemark(coordinate: (anno?.coordinate)!)
        let destination = MKMapItem(placemark: place)
        destination.name = "Destination"
        let regiondistance : CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegionMakeWithDistance((anno?.coordinate)!, regiondistance, regiondistance)
        let option  = [MKLaunchOptionsMapCenterKey:NSValue(mkCoordinate : regionSpan.center),MKLaunchOptionsMapSpanKey:NSValue(mkCoordinateSpan : regionSpan.span),MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
        MKMapItem.openMaps(with: [destination], launchOptions: option)
        mapView.removeAnnotationExceptUser()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pop"{
            let dst = segue.destination as! PopUp
            //dst.delegate = self
            dst.locationfromMain = self.newCoordinate
    }
        if segue.identifier == "purchase"{
            let dst = segue.destination as! RateViewController
            dst.leftString = "Purchase"
            dst.rightString = "Rate"
            dst.msg = "To save more address, you need to Purchase it OR you can rate us 5-Star and write Review on App Store."
            dst.toptitle = "Upgrade"
            dst.isFromMapViewController = true
        }
}
    
    func checkTableSize() {
     
        AddressBookDB.sharedInstance.fetchAddress { address in
            let tablesize = Array(address).count
            print(tablesize)
            let th : Int = 8
            if (tablesize >= th){
                self.isTableSizeMoreThanTen = true
                print("YES")
            }else{
                self.isTableSizeMoreThanTen = false
                print("NO")
            }
        }

        
    }

    
}


    //MARK: - Extensions
extension MapViewController : MKMapViewDelegate{
    

    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        for item in views {
            if item.annotation is MKUserLocation{
                item.canShowCallout = true
                let btn2 = UIButton()
                btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                btn2.setImage(UIImage(named : "Add"), for: .normal)
                item.leftCalloutAccessoryView = btn2
                }
            }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView : MKAnnotationView?
        if annotation is MKUserLocation{
            return nil
        }else{
        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PinIdentifire") ?? MKAnnotationView()
        annotationView?.image = UIImage(named: "Pin")
        annotationView?.canShowCallout = true
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.setImage(UIImage(named : "Navigate"), for: .normal)
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named : "Add"), for: .normal)
        annotationView?.rightCalloutAccessoryView = btn
        annotationView?.leftCalloutAccessoryView = btn2
        annotationView?.isDraggable = true
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.newCoordinate = view.annotation?.coordinate
        if (control == view.leftCalloutAccessoryView){
            
            print("IStabele : \(isTableSizeMoreThanTen)")
            
            let defaults = UserDefaults.standard
            if isTableSizeMoreThanTen && !defaults.bool(forKey: "rate10") {
                self.performSegue(withIdentifier: "purchase", sender: self)
                self.isAnnotationAdded = false
                self.mapView.removeAnnotationExceptUser()
                return
            }
            self.openPopUp()
            self.isAnnotationAdded = false
            self.mapView.removeAnnotationExceptUser()
        }
        
        if(control == view.rightCalloutAccessoryView){
            self.showDirection(view: view)
            self.isAnnotationAdded = false
            self.mapView.removeAnnotationExceptUser()
            }
        }
}

extension MKMapView {
    
    func removeAnnotationExceptUser(){
        for anno in self.annotations {
            if !(anno is MKUserLocation){
                self.removeAnnotation(anno)
            }
        }
    }
}

extension MapViewController {
    
    
    func cutomizeAlertView(){
        self.alertView.colorForAlertViewBackground = UIColor.white
        self.alertView.percentageRatioWidth = 0.95
        self.alertView.percentageRatioHeight = 0.93
        self.alertView.colorButtonText = RED
        self.alertView.colorCurrentPageIndicator = RED
        self.alertView.colorPageIndicator = RED.withAlphaComponent(0.30)
        self.alertView.colorTitleLabel = RED.withAlphaComponent(0.70)
        self.alertView.colorButtonBottomBackground = RED.withAlphaComponent(0.27)
        
        
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }

}
