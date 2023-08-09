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
    @IBOutlet private weak var loadingIndecator: UIActivityIndicatorView!
    var citiesViewModel: CitiesViewModel?
    let refreshControl = UIRefreshControl()
    
    // MARK: - viewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let core = LocalSource()
        let city = City(country: "test", name: "test1", id: "123", coord: Coord(lon: "45.0", lat: "60.0"), image: Data())
        core.saveCities([city]) { result in
            switch result {
            case .success:
                print("City saved successfully.")
                // Fetch cities using fetchCities function
                core.fetchCities { result in
                    switch result {
                    case .success(let cities):
                        print("Fetched cities: \(cities)")
                    case .failure(let error):
                        print("Error fetching cities: \(error)")
                    }
                }
                
            case .failure(let error):
                print("Error saving city: \(error)")
            }
        }
        
       citiesViewModel = CitiesViewModel(repository: CityRepository(remoteDataSource: RemoteSource(), localDataSource: LocalSource()))
        initTableView()
        setupBindings()
        citiesViewModel?.fetchCities()
    }
    
    // MARK: - initalize table view
    private func  initTableView() {
         let nib = UINib(nibName: Constants.Identifiers.cityCell, bundle: nil)
         citiesTableView.register(nib, forCellReuseIdentifier: Constants.Identifiers.cityCell)
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        citiesTableView.refreshControl = refreshControl
     }

    @objc func loadData() {
        citiesViewModel?.fetchCities()
        refreshControl.endRefreshing()
    }

    // MARK: - set up binding
    private func setupBindings() {
        guard let citiesViewModel = citiesViewModel else { return }
        citiesViewModel.bindCities.bind({ [weak self] isLoading in
            guard let self = self, let data = isLoading else { return }
                DispatchQueue.main.async {
                    if data == false {
                        self.loadingIndecator.startAnimating()
                    } else {
                        DispatchQueue.main.async {
                            self.loadingIndecator.stopAnimating()
                            self.citiesTableView.reloadData()
                        }
                    }
                }
        })
    }
    
}
// MARK: - Search Handling
extension CitiesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let _ = searchBar.text else {return}
        searchBar.resignFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //perform search
        print("perform search with \(searchText)")
    }

}
