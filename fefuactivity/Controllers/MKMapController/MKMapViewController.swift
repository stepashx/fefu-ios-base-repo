//
//  MKMapViewController.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 06.12.2021.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class MKMapViewController: UIViewController {
    
    @IBOutlet weak var mKMapView: MKMapView!
    
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var typeCollection: UICollectionView!
    @IBOutlet weak var startButton: BaseButton!
    
    @IBAction func didTapStartButton(_ sender: Any) {
        startView.isHidden = true
        inProcessView.isHidden = false
        isPaused = false
        
        newActivityDate = Date()
        startTimeForTimer = Date()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdater), userInfo: nil, repeats: true)
        
        locationManager.startUpdatingLocation()
    }
    
    @objc func timerUpdater() {
        let time = Date().timeIntervalSince(startTimeForTimer!)
        
        currentDuration = time
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.allowedUnits = [.hour, .minute, .second]
        timeFormatter.zeroFormattingBehavior = .pad
        
        timerLabel.text = timeFormatter.string(from: time + newActivityDuration)
    }
    
    @IBOutlet weak var inProcessView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    private var isPaused: Bool = true
    
    private let coreDataContainer = FEFUCoreDataContainer.instance
    private var timer: Timer?
    private var startTimeForTimer: Date?
    private var previousRouteSegment: MKPolyline?
    private var currentDuration = TimeInterval()
    
    private var newActivityDate: Date?
    private var newActivityDistance = CLLocationDistance()
    private var newActivityDuration = TimeInterval()
    private var newActivityType: String?
    
    @IBAction func didTapPauseButton(_ sender: Any) {
        userLocationsHistory = []
        userLocation = nil
        
        if !isPaused {
            pauseButton.setImage(UIImage(named: "resume"), for: .normal)
            
            newActivityDuration += currentDuration
            currentDuration = TimeInterval()
            timer?.invalidate()
            
            locationManager.stopUpdatingLocation()
        } else {
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            
            startTimeForTimer = Date()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdater), userInfo: nil, repeats: true)
            locationManager.startUpdatingLocation()
        }
        
        isPaused = !isPaused
        
        newActivityDate = Date()
    }
    
    @IBAction func didTapFinishButton(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        
        let context = coreDataContainer.context
        let activity = CoreDataActivity(context: context)
        
        newActivityDuration += currentDuration
        timer?.invalidate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let newActivityStartTime = dateFormatter.string(from: newActivityDate!)
        let newActivityEndTime = dateFormatter.string(from: newActivityDate! + newActivityDuration)
        
        activity.date = newActivityDate
        activity.distance = newActivityDistance
        activity.duration = newActivityDuration
        activity.endTime = newActivityEndTime
        activity.startTime = newActivityStartTime
        activity.type = newActivityType
        
        coreDataContainer.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    
    private var activityTypeCollectionViewCellIdentifier = "ActivityTypeCollectionViewCell"
    
    private let activitiesTypeData: [ActivityTypeCellModel] = [
        ActivityTypeCellModel(type: "Велосипед", title: "На велике"),
        ActivityTypeCellModel(type: "Бег", title: "На пробежке"),
        ActivityTypeCellModel(type: "Ходьба", title: "Прогулка")
    ]
    
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
            
            if oldValue != nil {
                newActivityDistance += userLocation.distance(from: oldValue!)
            }
            
            distanceLabel.text = String(format: "%.2f км", newActivityDistance / 1000)
            mKMapView.setRegion(region, animated: true)
            userLocationsHistory.append(userLocation)
        }
    }
    
    fileprivate var userLocationsHistory: [CLLocation] = [] {
        didSet {
            let coordinates = userLocationsHistory.map { $0.coordinate }
            
            if let previousRoute = previousRouteSegment, !userLocationsHistory.isEmpty {
                mKMapView.removeOverlay(previousRoute as MKOverlay)
                previousRouteSegment = nil
            }
            
            if userLocationsHistory.isEmpty {
                previousRouteSegment = nil
            }
            
            let route = MKPolyline(coordinates: coordinates, count: coordinates.count)
            
            previousRouteSegment = route
            
            mKMapView.addOverlay(route)
        }
    }
    
    private let userLocationIdentifier = "user_icon"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Новая активность"

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        mKMapView.showsUserLocation = true
        mKMapView.delegate = self
        mKMapView.userTrackingMode = .follow
        
        typeCollection.dataSource = self
        typeCollection.delegate = self
        typeCollection.register(UINib(nibName: activityTypeCollectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: activityTypeCollectionViewCellIdentifier)
        
        startView.layer.cornerRadius = 25
        startView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        inProcessView.isHidden = true
        inProcessView.layer.cornerRadius = 25
        inProcessView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        newActivityType = "Неопознанная активность"
        typeLabel.text = newActivityType
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

extension MKMapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activitiesTypeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newActivityType = activitiesTypeData[indexPath.row]
        
        let activityTypeCell = typeCollection.dequeueReusableCell(withReuseIdentifier: activityTypeCollectionViewCellIdentifier, for: indexPath)
        
        guard let cell = activityTypeCell as?
                ActivityTypeCollectionViewCell else {
                    return UICollectionViewCell()
        }
        
        cell.addFields(model: newActivityType)
        
        return cell
    }
}

extension MKMapViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as?
            ActivityTypeCollectionViewCell {
            cell.cardTypeView.layer.borderWidth = 2
            cell.cardTypeView.layer.borderColor = UIColor.blue.cgColor
            
            newActivityType = cell.activityType
            typeLabel.text = cell.activityTitle
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ActivityTypeCollectionViewCell {
            cell.cardTypeView.layer.borderColor = UIColor.gray.cgColor
            cell.cardTypeView.layer.borderWidth = 1
        }
    }
}
