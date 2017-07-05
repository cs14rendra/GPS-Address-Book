//
//  BookDetailsViewController.swift
//  GPS Address Book
//
//  Created by surendra kumar on 7/2/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit
import MapKit

class BookDetailsViewController: UIViewController {

 
    @IBOutlet var mapView: MKMapView!
    var lat : Double?
    var lon : Double?
    var titleName : String?
    var coordinate : CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    var globalLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinate!, 400, 400), animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate!
        annotation.title = self.titleName
        mapView.addAnnotation(annotation)
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func showDirection(){
        let isGoogleMapOn : Bool = UserDefaults.standard.bool(forKey: "nav")
        let canOPen : Bool = UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)
        if isGoogleMapOn && canOPen{
            UIApplication.shared.open(URL(string:"comgooglemaps://?saddr=\(globalLocation.latitude),\(globalLocation.longitude)&daddr=\(self.coordinate!.latitude),\(self.coordinate!.longitude)&directionsmode=transit")!, options: [:], completionHandler: nil)
               // mapView.removeAnnotationExceptUser()
            return
        }
        
        let place = MKPlacemark(coordinate: coordinate!)
        let destination = MKMapItem(placemark: place)
        destination.name = self.titleName
        let regiondistance : CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinate!, regiondistance, regiondistance)
        let option  = [MKLaunchOptionsMapCenterKey:NSValue(mkCoordinate : regionSpan.center),MKLaunchOptionsMapSpanKey:NSValue(mkCoordinateSpan : regionSpan.span),MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
        MKMapItem.openMaps(with: [destination], launchOptions: option)
        //mapView.removeAnnotationExceptUser()
    }

    @IBAction func navigate(_ sender: Any) {
        self.showDirection()
    }
    
}

extension BookDetailsViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let anno = self.mapView.dequeueReusableAnnotationView(withIdentifier: "user") ?? MKAnnotationView()
        anno.image = UIImage(named: "Pin")
        
        return anno
    }
}

extension BookDetailsViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        globalLocation = (locations.first?.coordinate)!
        locationManager.stopUpdatingLocation()
    }
}
