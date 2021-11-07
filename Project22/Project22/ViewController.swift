//
//  ViewController.swift
//  Project22
//
//  Created by Hümeyra Şahin on 7.11.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
// MARK: Location Manager
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways{
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable(){
                    startScanning()
                }
            }
        }
    }
    
    func startScanning(){
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")

        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity){
        UIView.animate(withDuration: 1){
        switch distance {
        case .immediate:
            self.view.backgroundColor = .red
            self.distanceReading.text = "HERE"
        case .near:
            self.view.backgroundColor = .green
            self.distanceReading.text = "NEAR"
        case .far:
            self.view.backgroundColor = .blue
            self.distanceReading.text = "FAR"
        @unknown default:
            self.view.backgroundColor = .gray
            self.distanceReading.text = "UNKNOWN"
        }
            
      }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first{
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
            
    }

}

