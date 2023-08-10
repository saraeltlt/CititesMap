//
//  CitiesViewController.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import UIKit

class CitiesViewController: BaseViewController {
    // MARK: - OUTLETS
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var imagePlaceHolder: UIImageView!
    @IBOutlet private weak var citiesTableView: UITableView!
    @IBOutlet private weak var loadingIndecator: UIActivityIndicatorView!
    var citiesViewModel: CitiesViewModel?
    let refreshControl = UIRefreshControl()
    var lastCount = 0
    
    // MARK: - viewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesViewModel = CitiesViewModel(repository: CityRepository(remoteDataSource: RemoteSource.shared, localDataSource: LocalSource.shared))
        configureNavigationBar()
        initTableView()
        setupBindings()
        citiesViewModel?.fetchCities()
    }

    // MARK: - set logo navigation bar
    func configureNavigationBar() {
        guard let navigationController = navigationController else { return }
        // set logo as left item
        let logoImageView = UIImageView.init(image: Constants.Images.globeImage)
        logoImageView.frame = Constants.Dimentions.logoFrame
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: Constants.Dimentions.logoWidth)
        let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: Constants.Dimentions.logoHeight)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItem =  imageItem
       
        //set attributed title
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(ciColor: .red),
            .font: Constants.Dimentions.font,
        ]
        navigationController.navigationBar.titleTextAttributes = textAttributes
        self.title = Constants.keyWords.appName
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
                        if citiesViewModel.getCitiesCount() == 0 &&
                            !citiesViewModel.isSearching &&
                            !citiesViewModel.isNetworkConnected() {
                            self.imagePlaceHolder.image = Constants.Images.noConnectionImage
                            self.imagePlaceHolder.isHidden = false
                        } else {
                            self.imagePlaceHolder.isHidden = true
                            self.loadingIndecator.stopAnimating()
                            self.citiesTableView.reloadData()
                            self.updateNoSearchResultVisibility()
                        }
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
        
        citiesViewModel?.filterCities(with: searchText)
        
        if searchBar.text!.isEmpty{
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func updateNoSearchResultVisibility() {
        if citiesViewModel?.getCitiesCount() == 0 {
            self.imagePlaceHolder.image = Constants.Images.noSearchImage
            self.imagePlaceHolder.isHidden = false
         } else {
             self.imagePlaceHolder.isHidden = true
         }
     }
    
}
