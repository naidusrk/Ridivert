//
//  RideViewController.swift
//  Ridevert
//
//  Created by savaram, Ramakrishna on 26/07/2018.
//  Copyright © 2018 savaram, Ramakrishna. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RideViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    @IBOutlet weak var riderMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        
        riderMapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        riderMapView.mapType = .standard
        riderMapView.isZoomEnabled = true
        riderMapView.isScrollEnabled = true
        riderMapView.showsUserLocation  = true
        
        if let coor = riderMapView.userLocation.location?.coordinate{
            
            
            riderMapView.setCenter(coor, animated: true)
            
//            let customLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(17.3721006, 78.4107146)
//
//            riderMapView.userLocation = customLocation

        }

        getLatLongFromZipCode()
        
        
      
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    func getLatLongFromZipCode()
    {
        let address = "500072"
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                
                if let pmCircularRegion = placemark.region as? CLCircularRegion {
                    
                    let maxDistance = self.locationManager.maximumRegionMonitoringDistance
                    
                    //let metersAcross = pmCircularRegion.radius * 2
                    
                    //let metersAcross = 50

                    print("maxDistance is \(maxDistance)")
                    if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                        
                        self.riderMapView.delegate = self
                        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinates.latitude,
                                                                                     longitude: coordinates.longitude), radius: maxDistance, identifier: "pin")
                        
                        region.notifyOnExit = true
                        region.notifyOnEntry = true
                        self.locationManager.startMonitoring(for: region)

                        // 4. setup annotation
                        let restaurantAnnotation = MKPointAnnotation()
                        restaurantAnnotation.coordinate = coordinates;
                        restaurantAnnotation.title = placemark.subAdministrativeArea ;
                        self.riderMapView.addAnnotation(restaurantAnnotation)
                        
                        //draw a circle
                        
                        let location = CLLocation(latitude: coordinates.latitude as CLLocationDegrees, longitude: coordinates.longitude as CLLocationDegrees)
                        let circle = MKCircle.init(center: location.coordinate, radius: maxDistance)
                        self.riderMapView.add(circle)
                        
                    }
                    else {
                        print("System can't track regions")
                    }
                   
                    
                }
                
                
            }
        })

        
        
//        let geocoder = CLGeocoder()
//        let dic = [NSTextCheckingZIPKey: "500072"]
//        
//        geocoder.geocodeAddressDictionary(dic) { (placemark, error) in
//            
//            if((error) != nil){
//                print(error!)
//            }
//            if let placemark = placemark?.first {
//                let lat = placemark.location!.coordinate.latitude
//                let long = placemark.location!.coordinate.longitude
//                
//            }
//            
//        }
        
    }
    
//    func startMonitoring()
//    {
//
//        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
//
//            // 2. region data
//            let title = "Lorrenzillo's"
//            let coordinate = CLLocationCoordinate2DMake(37.703026, -121.759735)
//            let regionRadius = 300.0
//
//            // 3. setup region
//            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
//                                                                         longitude: coordinate.longitude), radius: regionRadius, identifier: title)
//            locationManager.startMonitoring(for: region)
//
//            // 4. setup annotation
//            let restaurantAnnotation = MKPointAnnotation()
//            restaurantAnnotation.coordinate = coordinate;
//            restaurantAnnotation.title = "\(title)";
//            riderMapView.addAnnotation(restaurantAnnotation)
//
//            // 5. setup circle
//            let circle = MKCircle(centerCoordinate: coordinate, radius: regionRadius)
//            riderMapView.add(circle)
//        }
//        else {
//            print("System can't track regions")
//        }
//    }
    
//   internal func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let circleRenderer = MKCircleRenderer(overlay: overlay)
//        circleRenderer.strokeColor = UIColor.red
//        circleRenderer.lineWidth = 1.0
//        return circleRenderer
//    }
    
    
   
    
    func mapView(_ mapView: MKMapView!, rendererFor overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return nil
        }
    }
    // 6. draw circle
    
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        showAlert()
        
        if region is CLCircularRegion {
            // Do what you want if this information
            self.handleEvent(forRegion: region)
        }
        
    }
    
    // 2. user exit region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        if region is CLCircularRegion {
            // Do what you want if this information
            self.handleEvent(forRegion: region)
        }
        
        showAlert()

    }
    
    func showAlert()
    {
        
        let alertController = UIAlertController(title: "Hello  Coders", message: "Visit www.simplifiedios.net to learn xcode", preferredStyle: .alert)
        
        //then we create a default action for the alert...
        //It is actually a button and we have given the button text style and handler
        //currently handler is nil as we are not specifying any handler
        let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
        
        //now we are adding the default action to our alertcontroller
        alertController.addAction(defaultAction)
        
        //and finally presenting our alert using this method
        present(alertController, animated: true, completion: nil)
        
        
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        

        
       let userLocation:CLLocation = locations[0] as CLLocation
         // manager.stopUpdatingLocation()
//
//        let location = locations[0] as CLLocation
//        let geoCoder = CLGeocoder()
//        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error) -> Void in
//            let placeMarks = data as! [CLPlacemark]
//            let loc: CLPlacemark = placeMarks[0]
//
//            self.riderMapView.centerCoordinate = location.coordinate
//            _ = loc.locality
//            let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
//            self.riderMapView.setRegion(reg, animated: true)
//            self.riderMapView.showsUserLocation = true
//
//        })
        
        
    }
    
    
    
    func handleEvent(forRegion region: CLRegion!) {
        
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        
        print("Error \(error)")
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RideViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}


