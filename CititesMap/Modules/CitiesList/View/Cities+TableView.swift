//
//  Cities+TableViewDelegate.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import UIKit

// MARK: - Table View Delegate
extension CitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height * 0.125
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = citiesViewModel?.getCitiesCount() ?? 0
        if indexPath.row == count - 1 && count != lastCount {
            print("\(count) = \(lastCount)")
            lastCount = count
            loadData()
        } else if indexPath.row == count - 1 {
            let toastLabel = UILabel()
            toastLabel.showToast(message: Constants.keyWords.noMoreToShow,
                                 multiline: true,
                                 image: Constants.Images.noConnectionImage)
            
        }
    }
    
    // navigate to map
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

// MARK: - Table View Data Source
extension CitiesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesViewModel?.getCitiesCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.cityCell, for: indexPath) as? CityCell
        guard let cell = cell else { return CityCell()}
        
        let cityInfo = citiesViewModel?.getCityNameAndImage(index: indexPath.row)
        cell.configure(cityName: cityInfo?.0 ?? "", data: cityInfo?.1)
        
        return cell
    }
    
    
}
