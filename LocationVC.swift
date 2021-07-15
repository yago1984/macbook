//
//  LocationVC.swift
//  cocinita_ios
//
//  Created by Enrique yair Elias Martinez.
//

import UIKit
import MapKit

class LocationVC: UIViewController {
    @IBOutlet weak var Mimapa: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LocationShop()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func LocationShop() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 26.109096, longitude: -80.229793)
        annotation.title = "La Causa Limeña"
        Mimapa.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        Mimapa.setRegion(region, animated: true)
    }

}


 

