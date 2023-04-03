//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Miguel Angel Bric Ulloa on 28/03/23.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
    
    // enum con los proveedores de registro en la aplicacion
enum ProviderType: String {
    case basic
    case google
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
    
        //Collection View
    @IBOutlet weak var MovieCollectionView: UICollectionView!
    
    // MARK: - Properties
    private let email: String
    private let provider: ProviderType
    private let defaults = UserDefaults.standard // Singleton de user default
    
    lazy var rowsToDisplay = ChaletOne  // Indicador del pabellon a desplegar
    
    let SegmControlValues = ["Popular", "Top Rated", "New Releases"]
    let ChaletOne = ["Empresa 1 Chalet 1", "Empresa 2 Chalet 1", "Empresa 3 Chalet 1"]
    
    init(email: String, provider: ProviderType) {
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
        self.navigationItem.setHidesBackButton(true, animated: false)   // Metodo para esconder el back button del nav bar
        
        // Delegados del collection view
        MovieCollectionView.delegate = self
        MovieCollectionView.dataSource = self
        MovieCollectionView.register(UINib(nibName: "StaticExhibitionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StaticExhibitionCell")
        

        saveUserCredentials()
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
    
        // Guardar datos del usuario
    func saveUserCredentials() {
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "provider")
        defaults.synchronize()
    }
    
    func deleteUserCredentials() {
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
    }
    
    private func firebaseLogOut() {
        do {
            try Auth.auth().signOut()
            
        } catch {
            // Ocurrio un error
        }
    }
    
    
    // MARK: - Method Actions
        // Metodo para cerrar sesion
    @IBAction func CloseSessionBtnAction(_ sender: UIButton) {
        
        deleteUserCredentials()
        switch provider {
            
        case .basic:
            firebaseLogOut()
                
        case .google:   // El logout de email y google es el mismo
            GIDSignIn.sharedInstance.signOut()

            
        }
        navigationController?.popViewController(animated: true)
    }
    
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         
         let cell = MovieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCollectionViewCell
         /*
         cell?.StaticExhibitionCVCellImage.image = UIImage(named: Block1ArrayImgs[indexPath.row])
         cell?.StaticExhibitionCVCellTitleLbl.text =  NombreAvion[indexPath.row]
         cell?.StaticExhibitionCVCellDescriptionLbl.text =  DescripcionAvion
         */
         let bgColorView = UIView()
         
         bgColorView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
         cell?.selectedBackgroundView = bgColorView
         
         cell?.layer.cornerRadius = 20
         
         return cell!

    }
    
    
}
