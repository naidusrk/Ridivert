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
import UserNotifications
import CoreData

class RideViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    
    
    let visitCoredataManager = CoreDataManager(modelName: "Mapping")
    
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance:Double = 0
    var totalDistance:Double = 0
    var toggleState = 1
    var pauseCount:Int = 0

    var messageSubtitle = "Staff Meeting in 20 minutes"
    var isInsideRegion:Bool = false
    var isOutsideRegion:Bool = false

    var dollarPrice :Float = 0.0
    var regionBackGroundColor = UIColor()

    
    var selectedDataDic = NSDictionary()
     var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    @IBOutlet weak var riderMapView: MKMapView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var rideButton: UIButton!
    @IBOutlet weak var campaignPriceLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet var boundaryView: UIView!
    @IBOutlet weak var boundaryMilesLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var circularView: UIView!
    @IBOutlet var milesView: UIView!
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        campaignPriceLabel.text = ""
        campaignPriceLabel.isHidden = true
        UNUserNotificationCenter.current().requestAuthorization(options:
            [[.alert, .sound, .badge]],
                                                                completionHandler: { (granted, error) in
                                                                    // Handle Error
        })
    
         addMilesView()
        self.setNavigationBarItem()
        riderMapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        
        
        riderMapView.mapType = .standard
        riderMapView.isZoomEnabled = true
        riderMapView.isScrollEnabled = true
        riderMapView.showsUserLocation  = true
        
        self.locationManager.requestAlwaysAuthorization()

        if let coor = riderMapView.userLocation.location?.coordinate{
            
            
            riderMapView.setCenter(coor, animated: true)
            
//            let customLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(17.3721006, 78.4107146)
//
//            riderMapView.userLocation = customLocation

        }

      
        // setupData()
        
        
      
        // Do any additional setup after loading the view.
    }
    
    
    
   
    
    
    func sendNotification(message:String) {
        let content = UNMutableNotificationContent()
        content.title = "Ridivert"
        content.subtitle = message
        content.body = ""
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        
        let requestIdentifier = "demoNotification"
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request,
                                               withCompletionHandler: { (error) in
                                                // Handle error
        })
    }
    
    @IBAction func rideButtonClicked(_ sender: Any) {
        
        getLatLongFromZipCode(pincode: selectedDataDic["zipcode"] as! String)
        milesView.isHidden  = true
    }
    
    
    
    func addBoundaryView()
    
    {
        riderMapView.addSubview(boundaryView)
        boundaryView.isHidden = false
        milesLabel.text = String(format:"%.2f miles", totalDistance)
        

        
    }
    
    
    
    func updatePriceLabelsColor(miles:Double)
    
    {
        

        if(isInsideRegion)
        {
            campaignPriceLabel.isHidden = false

        let distance:String = String(format:"%f", miles)
        campaignPriceLabel.backgroundColor = UIColor.green
        campaignPriceLabel.text =   String(format:"$ %.2f", distance)
        regionBackGroundColor = UIColor.green
            boundaryMilesLabel.text = String(format:"%.2f miles", totalDistance)

        }
            
            
        if (isOutsideRegion)
        
        {
            campaignPriceLabel.isHidden = false

            regionBackGroundColor = UIColor.red
            campaignPriceLabel.backgroundColor = UIColor.red
            let distance:String = String(format:"$ %.2f", miles)
            campaignPriceLabel.text = distance
            boundaryMilesLabel.text = String(format:"%.2f miles", totalDistance)

            
        }
        
        
    }
    
    
    
    @IBAction func pauseButtonClicked(_ sender: UIButton) {
        
        
        let playBtn = sender as UIButton
        if toggleState == 1 {
            toggleState = 2
            pauseCount += 1
            playBtn.setTitle("Play",for: .normal)
        } else {
            toggleState = 1
            playBtn.setTitle("Pause",for: .normal)
        }
        
         saveUserlocations(miles: totalDistance, latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude, selectedDataDic: selectedDataDic,pauseCount: pauseCount)
        
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        
        for region: CLRegion? in locationManager.monitoredRegions {
            if let aRegion = region {
                
                locationManager.stopMonitoring(for: aRegion)
            }
        }

        isOutsideRegion = false
        isInsideRegion = false
    }
    
    
    
    
    func setupData() {
        // 1. check if system can monitor regions
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            
            // 2. region data
            let title = "Lorrenzillo's"
            let coordinate = CLLocationCoordinate2DMake(50.259290, 19.015630)
            let regionRadius = 300.0
            
            // 3. setup region
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                                         longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            locationManager.startMonitoring(for: region)
            
            // 4. setup annotation
            let restaurantAnnotation = MKPointAnnotation()
            restaurantAnnotation.coordinate = coordinate;
            restaurantAnnotation.title = "\(title)";
            riderMapView.addAnnotation(restaurantAnnotation)
            
            // 5. setup circle
            let circle = MKCircle.init(center: coordinate, radius: regionRadius)
            riderMapView.add(circle)
        }
        else {
            print("System can't track regions")
        }
    }
    
    
    func getLatLongFromZipCode(pincode:String)
    {
        
        let address = pincode
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                
                if let pmCircularRegion = placemark.region as? CLCircularRegion {
                    
                    //let maxDistance = self.locationManager.maximumRegionMonitoringDistance
                    
                    //let meterAcross = pmCircularRegion.radius * 2
                    
                    let meterAcross = 1380
                    
                   // let meterAcross = self.selectedDataDic["limit"] as! String
                    

                    print("metersAcross is \(meterAcross)")
                    if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                        
                        self.riderMapView.delegate = self
                        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinates.latitude,
                                                                                     longitude: coordinates.longitude), radius: CLLocationDistance(meterAcross), identifier: "pin")
                        
                        region.notifyOnExit = true
                        region.notifyOnEntry = true

                        // 4. setup annotation
                        let restaurantAnnotation = MKPointAnnotation()
                        restaurantAnnotation.coordinate = coordinates;
                        restaurantAnnotation.title = placemark.subAdministrativeArea ;
                        self.riderMapView.addAnnotation(restaurantAnnotation)
                        
                        //draw a circle
                        
                        let location = CLLocation(latitude: coordinates.latitude as CLLocationDegrees, longitude: coordinates.longitude as CLLocationDegrees)
                        let circle = MKCircle.init(center: location.coordinate, radius: CLLocationDistance(meterAcross))
                        
                        self.riderMapView.add(circle)
                        
                        if CLLocationManager.locationServicesEnabled() {
                            
                             self.locationManager?.delegate = self
                             self.locationManager?.pausesLocationUpdatesAutomatically = true
                            self.locationManager.requestAlwaysAuthorization()
                        }
                        
                        self.locationManager.startMonitoring(for: region)
                         self.locationManager.startUpdatingLocation()

                        
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
    
    
    func createLocalNotification()
    {
      
    let content = UNMutableNotificationContent()
    content.title = "Meeting Reminder"
    content.subtitle = messageSubtitle
    content.body = "Don't forget to bring coffee."
    content.badge = 1
        
    }
    
    
    func showAlert()
    {
        
        var topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
        topWindow?.rootViewController = UIViewController()
        topWindow?.windowLevel = UIWindowLevelAlert + 1
        let alert: UIAlertController =  UIAlertController(title: "APNS", message: "received Notification", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (alertAction) in
            topWindow?.isHidden = true
            topWindow = nil
        }))
        
        topWindow?.makeKeyAndVisible()
        topWindow?.rootViewController?.present(alert, animated: true, completion:nil)
        
    }

   
    
    func mapView(_ mapView: MKMapView!, rendererFor overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor  = UIColor(red: 255.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.1)
            circle.alpha = 0.1
            circle.lineWidth = 1
            return circle
        } else {
            return nil
        }
    }
    // 6. draw circle
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        print("----->entered regions")


    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Started Monitoring Region: \(region.identifier)")
        

        //getLatLongFromZipCode(pincode: selectedDataDic["zipcode"] as! String)



    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        
        isOutsideRegion = false
        isInsideRegion = true

        sendNotification(message:"Entered Selected Region")
        updatePriceLabelsColor(miles: totalDistance)

        DispatchQueue.main.async {
            //self.showAlert()
            self.boundaryView.isHidden    = true
            
        }

        
        
        if region is CLCircularRegion {
            // Do what you want if this information
            self.handleEvent(forRegion: region)
        }
        
    }
    
    // 2. user exit region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        
        isOutsideRegion = true
        isInsideRegion = false

        sendNotification(message:"Exited Selected Region")

      updatePriceLabelsColor(miles: totalDistance)
        
        DispatchQueue.main.async {
            //self.showAlert()
            self.addBoundaryView()
        }

//        if region is CLCircularRegion {
//            // Do what you want if this information
//            self.handleEvent(forRegion: region)
//        }
//
        print("----->exited regions")


    }
    
   

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
       // manager.stopUpdatingLocation()

        if startLocation == nil {
            startLocation = locations.first
        } else {
            let lastLocation = locations.last
            let distance = startLocation.distance(from: lastLocation!)
            startLocation = lastLocation
            traveledDistance += distance
            
            print("traveledDistance in meters is \(traveledDistance)")

            totalDistance = traveledDistance.inMiles()
            
            updatePriceLabelsColor(miles: totalDistance)
            
                
               // saveUserlocations(miles: traveledDistance, latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude, selectedDataDic: selectedDataDic)
          
            
        }
        
        print("total distance in miles is \(totalDistance)")
        
        
        
        
        
//       let userLocation:CLLocation = locations[0] as CLLocation
//         // manager.stopUpdatingLocation()
//
//        let location = locations[0] as CLLocation
//        let geoCoder = CLGeocoder()
//        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error) -> Void in
//
//            if((data?.count)!>0)
//            {
//            let placeMarks = data as! [CLPlacemark]
//            let loc: CLPlacemark = placeMarks[0]
//
//            self.riderMapView.centerCoordinate = location.coordinate
//            _ = loc.locality
//            let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
//            self.riderMapView.setRegion(reg, animated: true)
//            self.riderMapView.showsUserLocation = true
//
//            }
//
//        })
        
        
    }
    
    func saveUserlocations(miles:Double,latitude:Double,longitude:Double,selectedDataDic:NSDictionary,pauseCount:Int)
    {
        
        let managedObjectContext = visitCoredataManager.managedObjectContext
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Map", in: managedObjectContext)
        
        if let entityDescription = entityDescription {
            // Create Managed Object
            let list = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
            
            list.setValue(latitude, forKey: "latitude")
            list.setValue(longitude, forKey: "longitude")
            list.setValue(selectedDataDic["name"], forKey: "name")
            list.setValue(miles, forKey: "miles")
           // list.setValue(selectedDataDic["name"], forKey: "campaignid")
            list.setValue(NSDate(), forKey: "timestamp")

            print(list)
            
            do {
                // Save Changes
                try managedObjectContext.save()
                
            } catch {
                // Error Handling
            }
        }
        
        
        let managedObjectContext1 = self.visitCoredataManager.managedObjectContext
        
        let lists = self.fetchLocationRecordsForEntity("Map", inManagedObjectContext: managedObjectContext1)
        
        
        
        
        
    }
    
    
    private func fetchLocationRecordsForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        
        
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        //        let predicate = NSPredicate(format: "timestamp>= %@",reducedDate as NSDate)
        //        fetchRequest.predicate = predicate
        
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            
            
            if let records = records as? [NSManagedObject] {
                result = records
                
            }
            
            for location in result {
                print("fetched values is \(location.value(forKey: "name")!)"  )
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
    
    
    
    func handleEvent(forRegion region: CLRegion!) {
        
        
        
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        
        print("Error \(error)")
    }
    
    
    //Circular view methods
    
    func addMilesView()
        
    {
        
        milesView.isHidden   = false
        self.view .addSubview(milesView)
        milesView.backgroundColor = UIColor.clear
        milesView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        circularView.layer.cornerRadius = circularView.frame.size.width/2
        circularView.clipsToBounds = true
        circularView.layer.borderColor = UIColor.white.cgColor
        circularView.layer.backgroundColor = UIColor.red.cgColor
        circularView.layer.borderWidth = 5.0
        milesLabel.text = String(format:"%.2f miles", totalDistance)
        
        _ = buttonCornerRadius(selectedButton: rideButton, backGroundHexcolor: "#F14C1D", borderColor: "#FFFFFF", textColor: "#FFFFFF", borderWidth: 1, cornerRadius: 15, opacity: 1.0, isEnabled: true)
        
        
        
        
        
        
    }
    
   
    
    
    func buttonCornerRadius( selectedButton : UIButton, backGroundHexcolor :String , borderColor : String, textColor : String, borderWidth :  CGFloat,  cornerRadius :  CGFloat , opacity : Float,
                             isEnabled: Bool) -> UIButton {
        
        
        let backGroundColor = hexStringToUIColor(hex: backGroundHexcolor)
        selectedButton.backgroundColor = backGroundColor
        
        let borderColor = hexStringToUIColor(hex: borderColor)
        selectedButton.layer.borderColor = borderColor.cgColor
        selectedButton.layer.borderWidth = borderWidth
        selectedButton.layer.cornerRadius = cornerRadius
        selectedButton.layer.opacity = opacity
        selectedButton.setTitleColor(UIColor.white, for: .normal)
        selectedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return selectedButton
        
        
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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

extension CLLocationDistance {
    func inMiles() -> CLLocationDistance {
        return self*0.00062137
    }
    
    func inKilometers() -> CLLocationDistance {
        return self/1000
    }
}


