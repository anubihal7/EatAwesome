
//

import UIKit
import GoogleMaps
import Starscream
import SocketIO
import Alamofire

class TrackOrderVC: CustomController,GMSMapViewDelegate
{
    
    @IBOutlet var btnBack: UIBarButtonItem!
    @IBOutlet var mapView: GMSMapView!
    
    
    var start_lat = 0.0
    var start_long = 0.0
    
    var stop_lat = 0.0
    var stop_long = 0.0
    
   // var received_socket_lat : Double = 30.681252174494368
  //  var received_socket_long : Double = 76.70192921857249
    
    var received_socket_lat : Double = 0.0
    var received_socket_long : Double = 0.0
    
    var orderid = ""
    
    
    var polyline = GMSPolyline()
    
    var source_marker = GMSMarker()
    var destination_marker = GMSMarker()
    var order_marker = GMSMarker()
    
    var socketTimer = Timer()
    // var socketTracker: WebSocket!
    let manager = SocketManager(socketURL: URL(string: APIAddress.BASE_URL)!, config: [.log(true), .compress])
    var socket : SocketIOClient!
    var name: String?
    var resetAck: SocketAckEmitter?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //  AppDefaults.shared.app_LATITUDE = "0.0"
        //  AppDefaults.shared.app_LONGITUDE = "0.0"
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        print(orderid)
        
        //   Location.shared.InitilizeGPS()
        //   Location.shared.start_location_updates()
        
        self.getMyCurrentLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        SocketHelper.shared.disconnectSocket()
    }
    
    func getMyCurrentLocation()
    {
        //  stop_lat = Double(AppDefaults.shared.app_LATITUDE)!
        //   stop_long = Double(AppDefaults.shared.app_LONGITUDE)!
        
        if (stop_lat != 0.0 && stop_lat != 0.0)
        {
            Location.shared.stop_location_updates()
            self.setupDetails()
        }
        else
        {
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 3.0)
            //  {
            //      Location.shared.start_location_updates()
            //      self.getMyCurrentLocation()
            //  }
        }
    }
    
    func setupDetails()
    {
        self.connect_socket_with_server()
        self.DRAW_ROUTE_ON_MAP()
    }
    
    @IBAction func moveBACK(_ sender: Any)
    {
        //self.disconnect_socket_sharing()
        self.moveBACK(controller: self)
    }
    
    
    
    
    
    //MARK:  DRAWING ROUTE ON MAP
    func DRAW_ROUTE_ON_MAP()
    {
        self.mapView.clear()
        
        var directionURL =  "https://maps.googleapis.com/maps/api/directions/json?origin=\(start_lat),\(start_long)&destination=\(stop_lat),\(stop_long)&key=AIzaSyACMxnVzccKPbpGhbqt7ILDXA7H7yPvbMk"
        print(directionURL as Any)
        directionURL += "&mode=" + "drive"
        Alamofire.request(directionURL).responseJSON
            { response in
                
                if let JSON = response.result.value
                {
                    let mapResponse: [String: AnyObject] = JSON as! [String : AnyObject]
                    
                    let routesArray = (mapResponse["routes"] as? Array) ?? []
                    
                    let routes = (routesArray.first as? Dictionary<String, AnyObject>) ?? [:]
                    //--------Dash line lat-long for starting point ----------\\
                    let dictArray = (routes["legs"] as? Array) ?? []
                    let dict = (dictArray.first as? Dictionary<String, AnyObject>) ?? [:]
                    let steps = (dict["steps"] as? Array) ?? []
                    
                    let stepsDict = (steps.first as? Dictionary<String, AnyObject>) ?? [:]
                    let startLocation = stepsDict["start_location"]
                    let lat = startLocation?["lat"] as? NSNumber ?? 0.0
                    let lng = startLocation?["lng"] as? NSNumber ?? 0.0
                    
                    // let dotCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
                    let dotCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: lat), longitude: CLLocationDegrees(truncating: lng))
                    //--------Route polypoints----------\\
                    let overviewPolyline = (routes["overview_polyline"] as? Dictionary<String,AnyObject>) ?? [:]
                    let polypoints = (overviewPolyline["points"] as? String) ?? ""
                    let line  = polypoints
                    self.addPolyLine(encodedString: line, coordinate:dotCoordinate , dotCoordinate:dotCoordinate)
                    
                }
                else
                {
                    // MBProgressHUD.hide(for: self.view, animated: true)
                }
        }
        
    }
    
    
    //MARK:  ADD POLYLINE ON MAP
    func addPolyLine(encodedString: String, coordinate: CLLocationCoordinate2D ,dotCoordinate : CLLocationCoordinate2D)
    {
        
        let dotPath :GMSMutablePath = GMSMutablePath()
        // add coordinate to your path
        dotPath.add(CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude))
        dotPath.add(CLLocationCoordinate2DMake(dotCoordinate.latitude, dotCoordinate.longitude))
        
        let dottedPolyline  = GMSPolyline(path: dotPath)
        dottedPolyline.map = self.mapView
        dottedPolyline.strokeWidth = 5.0
        let styles: [Any] = [GMSStrokeStyle.solidColor(UIColor.green), GMSStrokeStyle.solidColor(UIColor.clear)]
        let lengths: [Any] = [10, 5]
        dottedPolyline.spans = GMSStyleSpans(dottedPolyline.path!, styles as! [GMSStrokeStyle], lengths as! [NSNumber], GMSLengthKind.rhumb)
        
        //---------Route Polyline---------\\
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3
        polyline.strokeColor = Appcolor.get_category_theme()
        
        polyline.map = self.mapView
        self.ShowMapPin_source()
    }
    
    
    //MARK:  SHOW SOURCE PIN IN MAP
    func ShowMapPin_source()
    {
        mapView.delegate = self
        source_marker = GMSMarker()
        
        let camera = GMSCameraPosition.camera(withLatitude: start_lat, longitude: start_long, zoom: 13.0)
        self.mapView.camera = camera
        self.mapView.mapType = .normal
        
        source_marker.position = CLLocationCoordinate2D(latitude: start_lat, longitude: start_long)
        source_marker.title = "Order pick-up Location"
        source_marker.snippet = ""
        source_marker.icon = GMSMarker.markerImage(with: UIColor.orange)
        source_marker.map = mapView
        self.ShowMapPin_destination()
    }
    
    
    //MARK:  SHOW DESTINATION PIN IN MAP
    func ShowMapPin_destination()
    {
        self.mapView.delegate = self
        destination_marker = GMSMarker()
        self.mapView.mapType = .normal
        
        destination_marker.position = CLLocationCoordinate2D(latitude: stop_lat, longitude: stop_long)
        destination_marker.title = "Order destination Location"
        destination_marker.snippet = ""
        destination_marker.icon = GMSMarker.markerImage(with: UIColor.green)
        destination_marker.map = mapView
        
        self.add_pin_on_map_from_socket_lat_longs()
    }
    
    
    var markerAdded = false
    func add_pin_on_map_from_socket_lat_longs()
    {
        if(markerAdded == false)
        {
            markerAdded = true
            self.mapView.delegate = self
            order_marker.map = nil
            order_marker = GMSMarker()
            self.mapView.mapType = .normal
            order_marker.iconView?.tintColor = Appcolor.get_category_theme()
            order_marker.icon = GMSMarker.markerImage(with: Appcolor.get_category_theme())
            order_marker.snippet = "Your order is here!"
            order_marker.map = self.mapView
        }
        
        
        // Keep Rotation Short
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        order_marker.rotation = 1.0
        CATransaction.commit()

        // Movement
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        let coordnates = CLLocationCoordinate2D(latitude: received_socket_lat, longitude: received_socket_long)
        order_marker.position = coordnates

        // Center Map View
        let camera = GMSCameraUpdate.setTarget(coordnates)
        mapView.animate(with: camera)

        CATransaction.commit()
    }
    
    func updateMarker(coordinates: CLLocationCoordinate2D, degrees: CLLocationDegrees, duration: Double)
    {
        // Keep Rotation Short
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        order_marker.rotation = degrees
        CATransaction.commit()

        // Movement
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        order_marker.position = coordinates

        // Center Map View
        let camera = GMSCameraUpdate.setTarget(coordinates)
        mapView.animate(with: camera)

        CATransaction.commit()
    }
    
    
    //MARK:  CONFIGURE SOCKECT SHARING FOR LIVE LOCATION
    func connect_socket_with_server()
    {
        SocketHelper.shared.connectSocket
            { (success) in
                
                print(success)
                SocketHelper.Events.data.emit(params: ["methodName":"getLocation","orderId":self.orderid])
                self.receiveEventsFromSocket()
        }
    }
    
    
    
    func receiveEventsFromSocket()
    {
        SocketHelper.Events.data.listen { [weak self] (result) in
            
            print(result)
            let data = result as? NSArray
            if (data?.count ?? 0 > 0)
            {
                let dic = data?.object(at: 0)as? NSDictionary
                if(dic?.count ?? 0 > 0)
                {
                    let dicData = dic?.value(forKey: "data")as? NSDictionary
                    if(dicData?.count ?? 0 > 0)
                    {
                        let lAT = dicData?.value(forKey: "lastLatitude") as? String ?? ""
                        let lONG = dicData?.value(forKey: "lastLongitude") as? String ?? ""
                        self?.update_driverLocation(lat: lAT, long: lONG)
                    }
                }
                
            }
        }
    }
    
    
    func update_driverLocation(lat:String,long:String)
    {
        if (lat.count == 0)
        {
            self.received_socket_lat = Double(30.681252174494368)
            self.received_socket_long = Double(76.70192921857249)
        }
        else
        {
            self.received_socket_lat = Double(lat) ?? 30.681252174494368
            self.received_socket_long = Double(long) ?? 76.70192921857249
        }
        
        self.add_pin_on_map_from_socket_lat_longs()
    }
    
}


