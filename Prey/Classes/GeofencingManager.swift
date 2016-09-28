//
//  GeofencingManager.swift
//  Prey
//
//  Created by Javier Cala Uribe on 9/06/16.
//  Copyright © 2016 Fork Ltd. All rights reserved.
//

import Foundation
import CoreLocation

// Prey geofencing definitions
enum kGeofence: String {
    case IN         = "geofencing_in"
    case OUT        = "geofencing_out"
    case INFO       = "info"
    case NAME       = "name"
    case ZONEID     = "id"
}


class GeofencingManager:NSObject, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    static let sharedInstance = GeofencingManager()
    override fileprivate init() {
        
        // Init location manager
        geoManager = CLLocationManager()

        // Init object
        super.init()
        
        // Delegate location manager
        geoManager.delegate = self
    }

    var geoManager: CLLocationManager
    
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        PreyLogger("GeofencingManager: Did start monitoring for region")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        PreyLogger("GeofencingManager Error: \(error)")
    }

    // Enter Region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        PreyLogger("GeofencingManager: Did enter region")
    
        if let regionIn:CLCircularRegion = region as? CLCircularRegion {
            let params = getParamteresToSend(regionIn, withZoneInfo:kGeofence.IN.rawValue)
            sendNotifyToPanel(params)
        }
    }
    
    // Exit Region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        PreyLogger("GeofencingManager: Did exit region")
        
        if let regionIn:CLCircularRegion = region as? CLCircularRegion {
            let params = getParamteresToSend(regionIn, withZoneInfo:kGeofence.OUT.rawValue)
            sendNotifyToPanel(params)
        }
    }
    
    // Params to send
    func getParamteresToSend(_ region:CLCircularRegion, withZoneInfo zoneInfo:String) -> [String: Any] {
        
        let regionInfo:[String: Any] = [
            kGeofence.ZONEID.rawValue       : region.identifier,
            kLocation.lng.rawValue          : region.center.latitude,
            kLocation.lat.rawValue          : region.center.longitude,
            kLocation.accuracy.rawValue     : region.radius,
            kLocation.method.rawValue       : "native"]

        let params:[String: Any] = [
            kGeofence.INFO.rawValue         : regionInfo,
            kGeofence.NAME.rawValue         : zoneInfo]
        
        return params
    }
    
    // Send to panel
    func sendNotifyToPanel(_ params:[String: Any]) {
        // Check userApiKey isn't empty
        if let username = PreyConfig.sharedInstance.userApiKey {
            PreyHTTPClient.sharedInstance.userRegisterToPrey(username, password:"x", params:params, messageId:nil, httpMethod:Method.POST.rawValue, endPoint:eventsDeviceEndpoint, onCompletion:PreyHTTPResponse.checkDataSend(nil))
        } else {
            PreyLogger("Error send data auth")
        }
    }
}
