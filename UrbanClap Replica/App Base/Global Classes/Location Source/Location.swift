
//

import Foundation
import CoreLocation
import MapKit



class Location: NSObject, CLLocationManagerDelegate
{
    static let shared = Location()
    var locationManager = CLLocationManager()
    
    var lat = 0.0
    var lng = 0.0
    
    var islocationNeed = false
    
    private override init()
    {
        super.init()
        
    }
    
    func InitilizeGPS()
    {
        // self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            // locationManager.distanceFilter = 10
           // locationManager.allowsBackgroundLocationUpdates = true
            // locationManager.pausesLocationUpdatesAutomatically = true
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func stop_location_updates()
    {
        islocationNeed = false
        locationManager.stopUpdatingLocation()
    }
    
    func start_location_updates()
    {
        islocationNeed = true
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        
        lat = location.coordinate.latitude
        lng = location.coordinate.longitude
        
        AppDefaults.shared.app_LATITUDE = "\(lat)"
        AppDefaults.shared.app_LONGITUDE = "\(lng)"
        
      //  AppDefaults.shared.app_LATITUDE = "33.3699198"
      //  AppDefaults.shared.app_LONGITUDE = "-104.6008557"
        
        print(lat)
        print(lng)
        
        stop_location_updates()
                
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        lat = 0.0
        lng = 0.0
        
        if (islocationNeed == true)
        {
           InitilizeGPS()
        }
        
    }
    
    func GetCurrentLocation() -> CLLocationCoordinate2D
    {
        var locat = CLLocationCoordinate2D()
        
        locat.latitude = lat
        locat.longitude = lng
        return locat
    }
    
    func showAlertAppDelegate(title : String,message : String,buttonTitle : String,window: UIWindow)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil))
        if #available(iOS 13.0, *)
        {
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
        else
        {
            // Fallback on earlier versions
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
}

