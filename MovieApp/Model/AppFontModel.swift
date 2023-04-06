//
//  FontAppModel.swift
//  MovieApp
//
//  Created by Miguel Angel Bric Ulloa on 27/03/23.
//
import UIKit
import Foundation

class AppFontModel {
    
    // MARK: - Properties
    var label: UILabel
    var text: String
    
    init(label: UILabel, text: String) {
        self.label = label
        self.text = text
    }

    // MARK: - Methods
     
    func applyChanges(size: CGFloat = 17, textColor: UIColor = .black, textAlignment: NSTextAlignment = .center) {
        label.text = text
        label.font = .Futura(size: size)
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
     }

    
}
