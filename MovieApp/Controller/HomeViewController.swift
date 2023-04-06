//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Miguel Angel Bric Ulloa on 28/03/23.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
    
    // enum con los proveedores de registro en la aplicacion
enum ProviderType: String {
    case basic
    case google
    case facebook
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
    private let cellSizeWitdh = UIScreen.main.bounds.width / 2
    
    var movies = [MovieDataModel]()
    

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
        MovieCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        

        saveUserCredentials()
        setUpSegmentedControl()
        setUpLabels()
        setUpButtons()
        
        
        NetworkingProvider.shared.getMovies { results in
            self.movies = results.movies
            DispatchQueue.main.async {
                self.MovieCollectionView.reloadData()
            }
        }
        
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
            
        case .facebook:
            LoginManager().logOut()
            firebaseLogOut()

        }
        navigationController?.popViewController(animated: true)
    }
    
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         
        let cell = MovieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCollectionViewCell

        
        cell?.MovieTitleLbl.text = movies[indexPath.row].title
        cell?.MovieOverviewLbl.text = movies[indexPath.row].overview
        cell?.MovieReleaseDateLbl.text = movies[indexPath.row].releaseDate
        cell?.MovieRateLbl.text = String(movies[indexPath.row].score ?? 0.0)
        
        let baseUrl = "https://image.tmdb.org/t/p/original/"
        let completUrl = baseUrl + (movies[indexPath.row].image ?? "noImage")
        cell?.MovieImg.downloaded(from: completUrl, contentMode: .scaleAspectFill)
         
        return cell!

    }
    
    // tamaño de la celda
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellSizeWitdh, height: 430)
        
    }
}
