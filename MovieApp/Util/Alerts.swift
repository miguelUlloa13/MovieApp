//
//  Alerts.swift
//  MovieApp
//
//  Created by Miguel Angel Bric Ulloa on 30/03/23.
//

import Foundation
import UIKit

class AlertModel {
    func simpleAlert(vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Accept", style: .default, handler: nil)
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
