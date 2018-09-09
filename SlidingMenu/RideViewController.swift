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


class RideViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate{
    let visitCoredataManager = CoreDataManager(modelName: "Mapping")
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance:Double = 0
    var totalDistance:Double = 0
    var toggleState = 1
    var pauseCount:Int = 0
    var selectedCircularRegion = CLRegion()
    var isCampaignRunning:Bool = false

    var messageSubtitle = "Staff Meeting in 20 minutes"
    var isInsideRegion:Bool = false
    var isOutsideRegion:Bool = false
    var isRegionMonitoringStarted:Bool = false

    var dollarPrice :Float = 0.0
    var regionBackGroundColor = UIColor()

    
    var selectedDataDic = NSDictionary()
    var selectedCampaignId:String = ""
     var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    @IBOutlet weak var riderMapView: MKMapView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var circularPriceLabel: UILabel!

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
        
        
        self.slideMenuController()?.delegate = self as SlideMenuControllerDelegate
        
        

        stopMonitoringRegions()
        
        checkifIsAnyCampaignSelected()
        
        if isCampaignRunning {
            rideButton.setTitle("Stop riding", for: .normal)
        }
        else
        {
            rideButton.setTitle("Start riding", for: .normal)
            
        }

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

        
        if let userLocation = self.locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation, 200, 200)
            riderMapView.setRegion(viewRegion, animated: false)
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showBoundaryView(_:)))
        tap.delegate = self as! UIGestureRecognizerDelegate // This is not required
        riderMapView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cancelCampaignTapped(_:)), name:NSNotification.Name(rawValue: "CancelRideTapped"), object: nil)

        // setupData()
        
        
      
        // Do any additional setup after loading the view.
    }
    
    
    
    func campaignCancelled()
    
    {
        stopMonitoringRegions()
        
    }

    
    @objc func cancelCampaignTapped(_ notification:Notification) {
        // Do something now
        stopMonitoringRegions()
        
    }
    @objc func showBoundaryView(_ sender: UITapGestureRecognizer) {
        
        print("Hello World")
        
        updatePriceLabelsColor(miles: totalDistance)
        
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
        
        if(selectedDataDic.count > 0)
        {
            
            if(rideButton.titleLabel?.text == "Stop riding")
            {
                stopButtonClicked(stopButton)
                milesView.isHidden = true
            }
            
            else
            
            {
                getLatLongFromZipCode(pincode: selectedDataDic["zipcode"] as! String)

            }
            
        milesView.isHidden  = true
            
        }
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
           let distance:String = String(format:"%.3f", miles)
           campaignPriceLabel.backgroundColor = UIColor.green
           campaignPriceLabel.text =   String(format:"$ %.3f", distance)
           regionBackGroundColor = UIColor.green
           boundaryMilesLabel.text = String(format:"%.3f miles", totalDistance)

        }
            
            
        if (isOutsideRegion)
        
        {
            campaignPriceLabel.isHidden = false

            regionBackGroundColor = UIColor.red
            campaignPriceLabel.backgroundColor = UIColor.red
            let distance:String = String(format:"$ %.3f", miles)
            campaignPriceLabel.text = distance
            boundaryMilesLabel.text = String(format:"%.3f miles", totalDistance)

            
        }
        
        
    }
    
    
    
    @IBAction func pauseButtonClicked(_ sender: UIButton) {
        
        
        let playBtn = sender as UIButton
        if toggleState == 1 {
            toggleState = 2
            pauseCount += 1
            playBtn.setTitle("Resume",for: .normal)
            locationManager.stopMonitoring(for: selectedCircularRegion)
            locationManager.stopUpdatingLocation()
        } else {
            toggleState = 1
            playBtn.setTitle("Pause",for: .normal)
            
            locationManager.startUpdatingLocation()

            locationManager.startMonitoring(for: selectedCircularRegion)

        }
        
        visitCoredataManager.saveUserlocations(miles: totalDistance, latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude, selectedDataDic: selectedDataDic,pauseCount: pauseCount,isCampaignRunning: true)
        
       
        
        
        
        
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        
      
        stopMonitoringRegions()
        
       visitCoredataManager.saveUserlocations(miles: totalDistance, latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude, selectedDataDic: selectedDataDic,pauseCount: pauseCount,isCampaignRunning: false)
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoring(for: selectedCircularRegion)
        self.boundaryView.isHidden = true
        addMilesView()

    }
    
    
    func stopMonitoringRegions()
    {
        
        if(locationManager != nil)
        {
        
           for region: CLRegion? in self.locationManager.monitoredRegions {
            if let aRegion = region {
                
                locationManager.stopMonitoring(for: aRegion)
                locationManager.stopUpdatingLocation()

            }
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
                AlertMessage.disPlayAlertMessage(titleMessage: "Ridivert", alertMsg: (error?.localizedDescription)!)
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                
                if let pmCircularRegion = placemark.region as? CLCircularRegion {
                    
                    //let maxDistance = self.locationManager.maximumRegionMonitoringDistance
                    
                    //let meterAcross = pmCircularRegion.radius * 2
                    
                  //  let meterAcross = 1300
                    
                     let meterAcross = self.selectedDataDic["limit"] as! String
                    

                    print("metersAcross is \(meterAcross)")
                    if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                        
                        self.riderMapView.delegate = self
                        
                        self.selectedCircularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinates.latitude,
                                                                                                      longitude: coordinates.longitude), radius: CLLocationDistance(meterAcross)!, identifier: "pin")

//
                        //testing region
                        
//                        let location1: CLLocationCoordinate2D = CLLocationCoordinate2DMake(17.4840265, 78.3866567)
//
//
//                        let region = CLCircularRegion(center: location1, radius: CLLocationDistance(meterAcross), identifier: "pin")
//
                        
                        self.selectedCircularRegion.notifyOnExit = true
                        self.selectedCircularRegion.notifyOnEntry = true

                        // 4. setup annotation
                        let restaurantAnnotation = MKPointAnnotation()
                        restaurantAnnotation.coordinate = coordinates;
                        restaurantAnnotation.title = placemark.subAdministrativeArea ;
                        self.riderMapView.addAnnotation(restaurantAnnotation)
                        
                        //draw a circle
                        
                        let location = CLLocation(latitude: coordinates.latitude as CLLocationDegrees, longitude: coordinates.longitude as CLLocationDegrees)
                        
                         // let location = CLLocation(latitude: location1.latitude as CLLocationDegrees, longitude: location1.longitude as CLLocationDegrees)

                        
                        let circle = MKCircle.init(center: location.coordinate, radius: CLLocationDistance(meterAcross)!)
                        
                        self.riderMapView.add(circle)
                        
                        if CLLocationManager.locationServicesEnabled() {
                            
                             self.locationManager?.delegate = self
                             self.locationManager?.pausesLocationUpdatesAutomatically = true
                             self.locationManager.requestAlwaysAuthorization()
                        }
                        
                        self.locationManager.startMonitoring(for: self.selectedCircularRegion)
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
            circle.alpha = 0.5
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
        
        
     isRegionMonitoringStarted = true
        //getLatLongFromZipCode(pincode: selectedDataDic["zipcode"] as! String)
        
       // visitCoredataManager.saveUserlocations(miles: 123.434, latitude: 1.2332432, longitude:1.345435, selectedDataDic: selectedDataDic,pauseCount: 2,isCampaignRunning: true)


    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        
        isOutsideRegion = false
        isInsideRegion = true

        sendNotification(message:"Entered Selected Region")
     //   updatePriceLabelsColor(miles: totalDistance)
        
        visitCoredataManager.saveUserlocations(miles: totalDistance, latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude, selectedDataDic: selectedDataDic,pauseCount: pauseCount,isCampaignRunning: true)


        
        let lists = visitCoredataManager.fetchSelectedCampaign("Map", inManagedObjectContext: visitCoredataManager.managedObjectContext, campaignId:selectedDataDic["campaignId"] as! String)
        
        print("saved locations is \(lists)")
        
        
        
        DispatchQueue.main.async {
          //  self.showAlert()
            self.boundaryView.isHidden    = true
            
        }

    }
    
    func createPolyline() {
        

        let point1 = CLLocationCoordinate2DMake(17.491983, 78.3892372);
        let point2 = CLLocationCoordinate2DMake(17.4987411, 78.3818385);
        let point3 = CLLocationCoordinate2DMake(17.4966542, 78.4133373);
        
        let points: [CLLocationCoordinate2D]
        points = [point1, point2, point3]
        
        let geodesic = MKGeodesicPolyline(coordinates: points, count: 5)
        riderMapView.add(geodesic)
        
        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region1 = MKCoordinateRegion(center: point1, span: span)
            self.riderMapView.setRegion(region1, animated: true)
        })
    }
    
    // 2. user exit region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        isOutsideRegion = true
        isInsideRegion = false
        sendNotification(message:"Exited Selected Region")
    //  updatePriceLabelsColor(miles: totalDistance)
        //self.showAlert()

        DispatchQueue.main.async {


            if(self.isRegionMonitoringStarted)
            {
            self.addBoundaryView()
                
            }
            
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
            print("total distance in miles is \(totalDistance)")
            totalDistance = traveledDistance.inMiles()
            updatePriceLabelsColor(miles: totalDistance)
        }

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
    
    
    
    
    func handleEvent(forRegion region: CLRegion!) {
        
        
        
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        
        print("Error \(error)")
    }
    
    
    //Circular view methods
    
    func addMilesView()
        
    {
        
        
        
        let selectedCampaign  = visitCoredataManager.fetchAllCampaigns("Map", inManagedObjectContext: visitCoredataManager.managedObjectContext)
        
        
        if(selectedCampaign.count > 0)
        {
            let runningCampaign = selectedCampaign.last
            
            if(runningCampaign != nil)
            {
                milesLabel.text = String(format:"%.3f miles", runningCampaign?.value(forKey: "miles") as! Double)
                circularPriceLabel.text = String(format:" $ %.3f", runningCampaign?.value(forKey: "miles") as! Double)
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                let myString = formatter.string(from: runningCampaign?.value(forKey: "timestamp") as! Date) // string purpose I add here
                dateLabel.text = myString
                
                circularView.isHidden = false

            }
            else
            
            {
                circularView.isHidden = true
            }
            
            
            milesView.isHidden   = false
            self.view .addSubview(milesView)
            milesView.backgroundColor = UIColor.clear
            milesView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
            circularView.layer.cornerRadius = circularView.frame.size.width/2
            circularView.clipsToBounds = true
            circularView.layer.borderColor = UIColor.white.cgColor
            circularView.layer.backgroundColor = UIColor.red.cgColor
            circularView.layer.borderWidth = 5.0
            
          }
        
        else
        
        {
            circularView.isHidden = true
            milesView.isHidden   = false
            self.view .addSubview(milesView)
            milesView.backgroundColor = UIColor.clear
            milesView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
            
            
        }
        
       

        
        
        _ = buttonCornerRadius(selectedButton: rideButton, backGroundHexcolor: "#F14C1D", borderColor: "#FFFFFF", textColor: "#FFFFFF", borderWidth: 1, cornerRadius: 15, opacity: 1.0, isEnabled: true)
        
        
        
        
        
        
    }
    
   
    
    func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        let objDateformat: DateFormatter = DateFormatter()
        objDateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strTime: String = objDateformat.string(from: dateToConvert as Date)
        let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
        let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
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
    
    
    func checkifIsAnyCampaignSelected()
    {
        
        let selectedCampaign  = visitCoredataManager.fetchAllCampaigns("Map", inManagedObjectContext: visitCoredataManager.managedObjectContext)
        
        for location in selectedCampaign {
            print("fetched values is \(location.value(forKey: "isCampaignRunning")!)"  )
            isCampaignRunning =  location.value(forKey: "isCampaignRunning")! as! Bool
        }
        
        
        
        
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
        if(self.locationManager.monitoredRegions.count > 0)
        {
            AlertMessage.disPlayAlertMessage(titleMessage: "Ridivert", alertMsg: "Please stop the running campaign")
            
        }
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


