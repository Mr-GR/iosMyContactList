//
//  MapViewController.swift
//  MyContactList
//
//  Created by Manuel Guevara Reyes on 3/4/24.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var sgmtMapType: UISegmentedControl!
    var locationManager = CLLocationManager()
    
    var contacts:[Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func mapTypeChanged(_ sender: Any) {
        switch sgmtMapType.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default: break
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        var fetchedObject: [NSManagedObject] = []
        do {
            fetchedObject = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        contacts = fetchedObject as! [Contact]
        self.mapView.removeAnnotations(self.mapView.annotations)
        for contact in contacts {
            let address = "\(contact.streetAddress!), \(contact.city!), \(contact.state!) "
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) {(placemarks, error) in
                self.processAddressResponse(contact, withPlaceMarks: placemarks, error: error)
            }
        }
    }
        
        private func processAddressResponse(_ contact: Contact, withPlaceMarks placemarks: [CLPlacemark]?,
                                             error: Error?) {
            if let error = error {
                print("Geocode Error: \(error)")
            }
            else {
                var bestMatch: CLLocation?
                if let placemarks = placemarks, placemarks.count > 0 {
                    bestMatch = placemarks.first?.location
                }
                if let coordinate = bestMatch?.coordinate {
                    let mp = MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    mp.title = contact.contactName
                    mp.subtitle = contact.streetAddress
                    mapView.addAnnotation(mp)
                    
                }
                else {
                    print("Didn't find any matching locations")
                }
            }
        }
        
        @IBAction func findUser(_ sender: Any) {
           
           // the below show you the user
            // mapView.showsUserLocation = true
           // mapView.setUserTrackingMode(.follow, animated: true)
            
            // this one shows you all the annotations. 
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            
            var span = MKCoordinateSpan()
            span.latitudeDelta = 0.2
            span.longitudeDelta = 0.2
            let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            mapView.setRegion(viewRegion, animated: true)
            let mp = MapPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            
            mp.title = "You"
            mp.subtitle = "Are here"
            mapView.addAnnotation(mp)
            
        }
        
    }
