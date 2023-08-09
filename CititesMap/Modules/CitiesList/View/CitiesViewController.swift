//
//  CitiesViewController.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import UIKit

class CitiesViewController: UIViewController {
    // MARK: - OUTLETS
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var imagePlaceHolder: UIImageView!
    @IBOutlet private weak var citiesTableView: UITableView!
    let citiesViewModel = CitiesViewModel()
    
    // MARK: - viewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
 // for test only
       let x = RemoteSource()
        x.fetchAPICities(page: 1) { (cities: Result<[City], Error>) in
            switch cities {
            case .success(let responseData):
                print("SUCCESS \(responseData.count)")
            case .failure(let error):
                print ("ERROR \(error.localizedDescription)")
            }
        }
//...
        
    }
    
    func  initTableView() {
        let nib = UINib(nibName: Constants.Identifiers.cityCell, bundle: nil)
        citiesTableView.register(nib, forCellReuseIdentifier: Constants.Identifiers.cityCell)
        
    }

}
// MARK: - Search Handling
extension CitiesViewController: UISearchBarDelegate {
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let _ = searchBar.text else {return}
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //perform search
        print("perform search with \(searchText)")
    }

}
// MARK: - Table View
extension CitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height * 0.125
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotationTransform
        cell.alpha=0.5
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha=1.0
        }
    }
    
    // navigate to map
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SELECTED")
        guard let navigationController = navigationController else { return }
        let storyboard = UIStoryboard(name: Constants.Identifiers.CityMapStroyBoard, bundle: nil)
        let viewControllerID = Constants.Identifiers.cityMapVC
        guard let cityMapVC = storyboard
            .instantiateViewController(withIdentifier: viewControllerID) as? CityMapViewController else { return }
        cityMapVC.mapViewModel = citiesViewModel.navigateToMap(index: indexPath.row)
        navigationController.pushViewController(cityMapVC, animated: true)
    }
}
extension CitiesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:Constants.Identifiers.cityCell,
                                                 for: indexPath) as? CityCell
        guard let cell = cell else { return CityCell()}
        cell.configure(cityName: "City", data: nil)
        return cell
    }
    
    
}
