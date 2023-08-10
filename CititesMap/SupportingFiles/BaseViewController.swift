//
//  BaseViewController.swift
//  CititesMap
//
//  Created by Sara Eltlt on 10/08/2023.
//

import UIKit
class BaseViewController : UIViewController {
    
     func monitorConnection() {
        NetworkMonitor.shared.startMonitoring { isConnected in
            if !isConnected {
                DispatchQueue.main.async {
                    let toastLabel = UILabel()
                    toastLabel.showToast(message: Constants.keyWords.noConnection,
                                         multiline: true,
                                         image: Constants.Images.noConnectionImage)
                }
            }
        }
    }
}
