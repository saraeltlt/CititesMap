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
    var citiesViewModel: CitiesViewModel?
    let refreshControl = UIRefreshControl()
    
    // MARK: - viewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       citiesViewModel = CitiesViewModel(repository: CityRepository(remoteDataSource: RemoteSource(), localDataSource: LocalSource()))
        initTableView()
        setupTabGesture()
        setupBindings()
        citiesViewModel?.fetchCities()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        citiesTableView.refreshControl = refreshControl
    }
    private func  initTableView() {
         let nib = UINib(nibName: Constants.Identifiers.cityCell, bundle: nil)
         citiesTableView.register(nib, forCellReuseIdentifier: Constants.Identifiers.cityCell)
     }

    private func setupTabGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    private func setupBindings() {
        guard let citiesViewModel = citiesViewModel else { return }
        citiesViewModel.bindCities.bind({ [weak self] isLoading in
            guard let self = self, let data = isLoading else { return }
                DispatchQueue.main.async {
                    if data == false {
                        //self.networkIndecator.startAnimating()
                    } else {
                        //self.networkIndecator.stopAnimating()
                        DispatchQueue.main.async {
                            self.citiesTableView.reloadData()
                        }
                    }
                }
        })
    }


    @objc private func loadData() {
        citiesViewModel?.fetchCities()
        refreshControl.endRefreshing()
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
         let count = citiesViewModel?.getCitiesCount() ?? 0
         if indexPath.row == count - 1 {
            loadData()
        }
    }

 
    
    // navigate to map
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SELECTED")
        guard let navigationController = navigationController,
              let citiesViewModel = citiesViewModel else { return }
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
        return citiesViewModel?.getCitiesCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:Constants.Identifiers.cityCell,
                                                 for: indexPath) as? CityCell
        guard let cell = cell else { return CityCell()}
        let cityName = citiesViewModel?.getCityName(index: indexPath.row) ?? ""
        cell.configure(cityName: cityName, data: nil)
        return cell
    }
    
    
}
