//
//  ViewController.swift
//  trklocation
//
//  Created by Blake Symington on 26/5/20.
//  Copyright © 2020 Blake Symington. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var device_uuid: String = ""
    var api_host: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // initialize the location manager
           locationManager = CLLocationManager()
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.allowsBackgroundLocationUpdates = true

           // request location services authorization
        if CLLocationManager.authorizationStatus() == .notDetermined {
             locationManager.requestAlwaysAuthorization()
           }

           // enable location services (choose constant polling or significant changes)
           if CLLocationManager.locationServicesEnabled() {
             locationManager.startUpdatingLocation()
           }
         device_uuid = UIDevice.current.identifierForVendor!.uuidString
         api_host = "loc.example.net"
    }
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
         locationManager.startUpdatingLocation()
       }
     }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      // get location
      if let location = locations.last {

         let url:NSURL = NSURL(string: "http://" + api_host + "/location/")!
      let request:NSMutableURLRequest = NSMutableURLRequest(url:url as URL)
      request.httpMethod = "POST"

          // create request body
          var httpRequestBody = "device_id=" + self.device_uuid
          httpRequestBody += "&latitude=" + String(location.coordinate.latitude)
          httpRequestBody += "&longitude=" + String(location.coordinate.longitude)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let timestamp = formatter.string(from: location.timestamp)
          httpRequestBody += "&timestamp=" + String(timestamp)
          httpRequestBody += "&altitude=" + String(location.altitude)
          httpRequestBody += "&course=" + String(location.course)
          httpRequestBody += "&speed=" + String(location.speed)
        httpRequestBody += "&vertical_acc=" + String(location.verticalAccuracy)
        httpRequestBody += "&horizontal_acc=" + String(location.horizontalAccuracy)
        request.httpBody = httpRequestBody.data(using: String.Encoding.utf8)

      let session = URLSession.shared
      let task = session.dataTask(with: request as URLRequest) { (
              data, response, error) in
        print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
            // debug:
            // print(data)
            // print(response)
            // print(error)
          }

          task.resume()
        }
    }

    


}

