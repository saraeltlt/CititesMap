//
//  CityMapViewController.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import UIKit
import MapKit

class CityMapViewController: UIViewController {
    // MARK: - Outlits
    @IBOutlet private  weak var cityMapView: MKMapView!
    
    // MARK: - Variable
    private var cityName: String?
    private var cityLat: Double?
    private var cityLon: Double?
    var mapViewModel: CityMapViewModel?
    
    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCityData()
        setMap()
    }
    
    // MARK: - setCityData
    private func setCityData() {
        guard let mapViewModel = mapViewModel else {return}
        cityName = mapViewModel.getCityName()
        cityLat = mapViewModel.getCityCoord().0
        cityLon = mapViewModel.getCityCoord().1
        setNavigationTitle()
    }
    // MARK: - setCityData
    func setNavigationTitle() {
        guard let navigationController = navigationController else { return }
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(ciColor: .red),
            .font: Constants.Dimentions.font,
        ]
        navigationController.navigationBar.titleTextAttributes = textAttributes
        self.title = cityName
    }
    // MARK: - setMap
    private func setMap() {
        guard let cityLat = cityLat, let cityLon = cityLon else {return}

        let cityCoordinate = CLLocationCoordinate2D(latitude: cityLat, longitude: cityLon)
        
        // centered map view
        let region = MKCoordinateRegion(center: cityCoordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        cityMapView.setRegion(region, animated: true)
        
        // map annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = cityCoordinate
        
        //set title
        annotation.title = cityName
        cityMapView.addAnnotation(annotation)
    }
}
