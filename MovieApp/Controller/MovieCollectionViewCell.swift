//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Miguel Angel Bric Ulloa on 03/04/23.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    // Views
    @IBOutlet weak var MovieCVCView: UIView!
    @IBOutlet weak var ReleaseAndRateView: UIView!
    
    // Labels
    @IBOutlet weak var MovieOverviewLbl: UILabel!
    @IBOutlet weak var MovieTitleLbl: UILabel!
    @IBOutlet weak var MovieRateLbl: UILabel!
    @IBOutlet weak var MovieReleaseDateLbl: UILabel!
    
    // Image
    @IBOutlet weak var MovieImg: UIImageView!
    @IBOutlet weak var StarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        MovieCVCView.layer.cornerRadius = 20
        MovieCVCView.layer.borderColor = UIColor.link.cgColor
        MovieCVCView.layer.borderWidth = 1
        MovieCVCView.backgroundColor = .systemGray6.withAlphaComponent(0.7)
        ReleaseAndRateView.backgroundColor = .clear
        
        setUpImage()
        setUpLabels()
        
    }
    
    // MARK: - Methods
    
        // Funcion para personlizar la imagen de la pelicula
    func setUpImage() {
        MovieImg.layer.cornerRadius = 20
        MovieImg.contentMode = .scaleAspectFill
    }
    
        // Funcion para personalizar el titulo y la descripcion de la pelicula
    func setUpLabels() {
        
        // Titulo de la pelicula
        MovieTitleLbl.font = .Futura(size: 20)
        MovieTitleLbl.numberOfLines = 0
        MovieTitleLbl.textAlignment = .center
        MovieTitleLbl.textColor = .link
        
        // Fecha de lanzamiento
        MovieReleaseDateLbl.font = .Futura(size: 16)
        MovieReleaseDateLbl.numberOfLines = 0
        MovieReleaseDateLbl.textAlignment = .center
        MovieReleaseDateLbl.textColor = .link
        
        // Valoracion de la pelicula
        MovieRateLbl.font = .Futura(size: 16)
        MovieRateLbl.numberOfLines = 0
        MovieRateLbl.textAlignment = .left
        MovieRateLbl.textColor = .link
        
        // Descripcion
        MovieOverviewLbl.font = .Futura(size: 14)
        MovieOverviewLbl.numberOfLines = 0
        MovieOverviewLbl.textAlignment = .left
        MovieOverviewLbl.textColor = .black
        
    }

}
