//
//  MapViewController.swift
//  Entrega-2p
//
//  Created by Christopher Alan Estrada Gonzalez on 10/04/18.
//  Copyright © 2018 UX Lab - ISC Admin. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    var latitude = ""
    var longitude = ""
    
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(latitude)
        // Do any additional setup after loading the view.
        //Aquí es donde se ponen los valores iniciales
        let coordinate: CLLocationCoordinate2D =  CLLocationCoordinate2DMake(Double(latitude)!, Double(longitude)!)
        let distance: CLLocationDistance = 1000
        let region = MKCoordinateRegionMakeWithDistance(coordinate, distance, distance)
        map.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
//        present(UIViewController(), animated: true, completion: nil)
//        print("done")
//        dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "backTableView", sender: self)

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
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
