//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Miguel Angel Bric Ulloa on 28/03/23.
//

import UIKit
import FirebaseAuth
    
    // enum con los proveedores de registro en la aplicacion
enum Provider: String {
    case basic
}

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
        // Views
    @IBOutlet weak var HomeView: UIView!
    @IBOutlet weak var WelcomeView: UIView!
    @IBOutlet weak var MovieView: UIView!
    
        // Stack View
    @IBOutlet weak var HomeSV: UIStackView!
    @IBOutlet weak var WelcomeSV: UIStackView!
    
        // Labels
    @IBOutlet weak var WelcomeLbl: UILabel!
    @IBOutlet weak var ProviderLbl: UILabel!
    
        // Segmented Control
    @IBOutlet weak var MovieSC: UISegmentedControl!
    
        // Button
    @IBOutlet weak var CloseSessionBtn: UIButton!
    
    // MARK: - Properties
    private let email: String
    private let provider: Provider
    
    // MARK: - Properties
    lazy var rowsToDisplay = ChaletOne  // Indicador del pabellon a desplegar
    
    let SegmControlValues = ["Popular", "Top Rated", "New Releases"]
    let ChaletOne = ["Empresa 1 Chalet 1", "Empresa 2 Chalet 1", "Empresa 3 Chalet 1"]
    
    init(email: String, provider: Provider) {
        self.email = email
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "HOME"

        setUpSegmentedControl()
        setUpLabels()
        setUpButtons()
    }


    // MARK: - Methods
    private func setUpLabels(){
        AppFontModel(label: WelcomeLbl, text: "Welcome \(email)").applyChanges()
        AppFontModel(label: ProviderLbl, text: "Account type: \(provider.rawValue)").applyChanges()
    }
    
    private func setUpButtons(){
        CloseSessionBtn.round()
        CloseSessionBtn.setTitle("Log Out", for: .normal)
        CloseSessionBtn.titleLabel?.font = .Futura(size: 17)
        CloseSessionBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        CloseSessionBtn.titleLabel?.minimumScaleFactor = 0.5
    }
    
    private func setUpSegmentedControl() {
        
        MovieSC.removeAllSegments()
        
        for (index, value) in SegmControlValues.enumerated() {
            
            MovieSC.insertSegment(withTitle: value, at: index, animated: true)
            
        }
        // MovieSC.selectedSegmentTintColor = .link
    }
    
    // MARK: - Method Actions

    @IBAction func CloseSessionBtnAction(_ sender: UIButton) {
        switch provider {
            
        case .basic:
            
            do {
                try Auth.auth().signOut()
                navigationController?.popViewController(animated: true)
            } catch {
                // Ocurred an Error
            }
            
        }
    }
    
}
