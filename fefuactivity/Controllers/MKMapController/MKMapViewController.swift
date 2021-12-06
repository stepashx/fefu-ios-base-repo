//
//  MKMapViewController.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 06.12.2021.
//

import UIKit
import CoreLocation
import MapKit

class MKMapViewController: UIViewController {
    
    @IBOutlet weak var mKMapView: MKMapView!
    
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        return manager
    }()
    
    var userLocation: CLLocation? {
        didSet {
            guard let userLocation = userLocation else {
                return
            }
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mKMapView.setRegion(region, animated: true)
            
            userLocationsHistory.append(userLocation)
        }
    }
    
    fileprivate var userLocationsHistory: [CLLocation] = [] {
        didSet {
            let coordinates = userLocationsHistory.map { $0.coordinate }
            
            let route = MKPolyline(coordinates: coordinates, count: coordinates.count)
            
            mKMapView.addOverlay(route)
        }
    }
    
    private let userLocationIdentifier = "user_icon"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Новая активность"

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        mKMapView.showsUserLocation = true
        mKMapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
    }
}

extension MKMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            return
        }
        
        userLocation = currentLocation
    }
}

extension MKMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let render = MKPolylineRenderer(polyline: polyline)
            render.fillColor = UIColor.blue
            render.strokeColor = UIColor.blue
            render.lineWidth = 5
            
            return render
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKUserLocation {
            let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: userLocationIdentifier)
            
            let view = dequedView ?? MKAnnotationView(annotation: annotation, reuseIdentifier: userLocationIdentifier)
            view.image = UIImage(named: "ic_user_location")
            return view
        }
        
        return nil
    }
}
