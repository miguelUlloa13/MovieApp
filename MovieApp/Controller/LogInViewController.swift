//
//  ViewController.swift
//  MovieApp
//
//  Created by Miguel Angel Bric Ulloa on 26/03/23.
//

import UIKit
import FirebaseCore
import FirebaseAnalytics
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit    // Anteriormente FacebookLogin

class LogInViewController: UIViewController {
    
    // MARK: - Outlets
    
    // Views
    @IBOutlet weak var logInView: UIView!
    @IBOutlet weak var LogInImgView: UIView!
    @IBOutlet weak var FormView: UIView!
    @IBOutlet weak var UsrNameView: UIView!
    @IBOutlet weak var UsrPassView: UIView!
    @IBOutlet weak var RememberPassView: UIView!
    @IBOutlet weak var SignUpView: UIView!
    @IBOutlet weak var OrView: UIView!
    @IBOutlet weak var LeftGrayLineView: UIView!
    @IBOutlet weak var RightGrayLineView: UIView!
    
    // Stack View
    @IBOutlet weak var LogInSV: UIStackView!
    @IBOutlet weak var FormSV: UIStackView!
    
    // Images
    @IBOutlet weak var LogoImg: UIImageView!
    @IBOutlet weak var UsrImg: UIImageView!
    @IBOutlet weak var PassImg: UIImageView!
    
    // Labels
    @IBOutlet weak var LogInLbl: UILabel!
    @IBOutlet weak var RememberPassLbl: UILabel!
    @IBOutlet weak var SignUpLbl: UILabel!
    @IBOutlet weak var UsrNameLbl: UILabel!
    @IBOutlet weak var UsrPassLbl: UILabel!
    @IBOutlet weak var OrLbl: UILabel!
    
    // Text Fields
    @IBOutlet weak var UsrNameTF: UITextField!
    @IBOutlet weak var UsrPassTF: UITextField!
    
    // Buttons
    @IBOutlet weak var RecoverPassBtn: UIButton!
    @IBOutlet weak var RememberPassBtn: UIButton!
    @IBOutlet weak var LogInBtn: UIButton!
    @IBOutlet weak var SignUpBtn: UIButton!
    @IBOutlet weak var SignUpGoogleBtn: UIButton!
    // @IBOutlet weak var SignUpFacebookBtn: UIButton!
    @IBOutlet weak var SignUpFacebookBtn: FBLoginButton!
    
    
    // MARK: - Properties

    
    // MARK: - View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "AUTHENTICATION"
        
        UsrNameTF.delegate = self
        UsrPassTF.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        // Comprobar la session del usuario autenticado
        checkUserSession()
        
        // Personalizacion de views
        setUpLabels()
        setUpViews()
        setUpTextFields()
        setUpButtons()

 
        NetworkingProvider.shared.getMovies { results in
            print(results.movies.count)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FormView.isHidden = false
    }
    
    // MARK: - Methods
    
        // Metodo para personalizar los labels
    private func setUpLabels() {
        AppFontModel(label: LogInLbl, text: "Log In").applyChanges(size: 20 ,textAlignment: .left)
        AppFontModel(label: RememberPassLbl, text: "Stay signed in").applyChanges(textAlignment: .left)
        AppFontModel(label: SignUpLbl, text: "Don't have an account yet?").applyChanges()
        AppFontModel(label: UsrNameLbl, text: "Email address or username").applyChanges(textAlignment: .left)
        AppFontModel(label: UsrPassLbl, text: "Password").applyChanges(textAlignment: .left)
        AppFontModel(label: OrLbl, text: "Or").applyChanges(textColor: .darkGray)
    }
    
        // Metodo para personalizar los views
    private func setUpViews() {
        UsrNameView.layer.borderColor = UIColor.link.cgColor
        UsrNameView.layer.borderWidth = 1
        UsrNameView.layer.cornerRadius = 5

        UsrPassView.layer.cornerRadius = 5
    }
    
        // Metodo para personalizar los text fields
    private func setUpTextFields() {
        UsrNameTF.placeholder = "Email address or username"
        UsrNameTF.font = .Futura(size: 17)
        
        UsrPassTF.placeholder = "Password"
        UsrPassTF.font = .Futura(size: 17)
    }
    
        // Metodo para cambiar al siguiente textfield
    private func switchBasedNextTextField(_ textField: UITextField) {
        
        switch textField {
        case self.UsrNameTF:
            self.UsrPassTF.becomeFirstResponder()
        default:
            self.UsrPassTF.resignFirstResponder()
        }
        
    }
    
        // Metodo para personalizar los botones
    private func setUpButtons() {
        RememberPassBtn.setTitle("Remember me", for: .normal)
        RememberPassBtn.titleLabel?.font = .Futura(size: 17)
        RememberPassBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        RememberPassBtn.titleLabel?.minimumScaleFactor = 0.5
        
        RecoverPassBtn.setTitle("Forgot password?", for: .normal)
        RecoverPassBtn.titleLabel?.font = .Futura(size: 17)
        RecoverPassBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        RecoverPassBtn.titleLabel?.minimumScaleFactor = 0.5
        
        LogInBtn.round()
        LogInBtn.setTitle("Log In", for: .normal)
        LogInBtn.titleLabel?.font = .Futura(size: 17)
        LogInBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        LogInBtn.titleLabel?.minimumScaleFactor = 0.5
        
        SignUpBtn.setTitle("Sign Up", for: .normal)
        SignUpBtn.titleLabel?.font = .Futura(size: 17)
        SignUpBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        SignUpBtn.titleLabel?.minimumScaleFactor = 0.5
        
        SignUpGoogleBtn.setTitle("Log in using Google", for: .normal)
        SignUpGoogleBtn.titleLabel?.font = .Futura(size: 17)
        SignUpGoogleBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        SignUpGoogleBtn.titleLabel?.minimumScaleFactor = 0.5
        SignUpGoogleBtn.layer.borderWidth = 1
        SignUpGoogleBtn.layer.borderColor = UIColor.black.cgColor
        SignUpGoogleBtn.round()
        
        SignUpFacebookBtn.setTitle("Log in using Facebook", for: .normal)
        SignUpFacebookBtn.titleLabel?.font = .Futura(size: 17)
        SignUpFacebookBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        SignUpFacebookBtn.titleLabel?.minimumScaleFactor = 0.5
        SignUpFacebookBtn.layer.borderWidth = 1
        SignUpFacebookBtn.layer.borderColor = UIColor.link.cgColor
        SignUpFacebookBtn.round()
        
    }
    
    // Pasar al view controller Home
    
    private func showHome(result: AuthDataResult?, error: Error?, provider: ProviderType) {
        
        if let result = result, error == nil {
            // Bloque si el resultado es distinto de nulo y error es nulo, se registro correctamente el usuario
            self.navigationController?.pushViewController(HomeViewController(email: result.user.email!, provider: provider), animated: true)
            self.view.endEditing(true)
        } else {
            
            // Bloque si no se hizo el registro correctamente
            AlertModel().simpleAlert(vc: self, title: "Error", message: "Se ha producido un error de autenticacion de usuario mediante \(provider.rawValue)")
        }
        
    }
    
    // Comprobar la sesion del usuario autenticado
    func checkUserSession() {
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String, let provider = defaults.value(forKey: "provider") as? String {
            FormView.isHidden = true
            navigationController?.pushViewController(HomeViewController.init(email: email, provider: ProviderType.init(rawValue: provider)!), animated: true)
        }
    }
    
    // Log in y Sign up con google
    func signInGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
              print("User cancelled login")
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            fatalError("Error")
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) {result,error in
                self.showHome(result: result, error: error, provider: .google)
            }
            
        }
    }
    
    // MARK: - Method Actions
        // Action para Logearse en la app
    @IBAction func LogInBtnAction(_ sender: UIButton) {
        if let usrName = UsrNameTF.text, let usrPass = UsrPassTF.text {
            
                // Metodo para registrar el email y la contraseña en firebase
            Auth.auth().signIn(withEmail: usrName, password: usrPass) {result,error in
                self.showHome(result: result, error: error, provider: .basic)
            }
        }
    }
    
    @IBAction func SignUpWithGoogleBtnAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signOut()
        signInGoogle()
    }
    
 
    @IBAction func SignUpWithFacebookBtnAction(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: ["email"], from: self) { result, error in
            if let error = error {
                print("Error login with Facebook\(error.localizedDescription)")
            }
            
            // Check for cancel
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }

            let token = result.token?.tokenString
            let credential = FacebookAuthProvider.credential(withAccessToken: token ?? "Empty Token")
            Auth.auth().signIn(with: credential) {result,error in
                self.showHome(result: result, error: error, provider: .facebook)
                
            }
        }
        
    }
    
    
    
    
        // Metodo para esconder el Keyboard cuando se toca fuera de este
    @objc private func hideKeyboard() {
        self.view.endEditing(true)  // Cierra forzadamente el keyboard, no importa cual especificamente
        // UsrPassTF.endEditing(true)   // Es posible esta opcion pero hace falta agregar todos los textfield, menos eficiente
    }
    
        // Metodo para pasar al view controller Sign Up
    @IBAction func SignUpBtnAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
}


    // MARK: - UITextFieldDelegate
extension LogInViewController: UITextFieldDelegate {
    
        // Metodo del textfield para detectar cuando el usario presiona el boton Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        
        return true
        
    }

}


