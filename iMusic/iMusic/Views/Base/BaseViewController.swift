//
//  BaseViewController.swift
//  iMusic
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    /**
     * Show the loader
     *
     * - parameters:
     *      -show: show / hide the loader
     *      -status: message included in the loader (optional)
     */
    public func showLoader(_ show: Bool, status: String? = nil) {
        if let status = status {
            show == true ? SVProgressHUD.show(withStatus: status) : SVProgressHUD.dismiss()
            return
        }
        show == true ? SVProgressHUD.show() : SVProgressHUD.dismiss()
    }
    
    /**
     * Show alert
     *
     * - parameters:
     *      -title: title for the alert
     *      -message: message for the alert
     *      -actionTitle: action title for the alert
     */
    public func showAlertWith(title: String, message: String, actionTitle: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(
            title: actionTitle,
            style: .default,
            handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
}

