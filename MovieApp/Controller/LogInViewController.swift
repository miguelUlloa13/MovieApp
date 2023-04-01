//
//  ViewController.swift
//  MovieApp
//
//  Created by Miguel Angel Bric Ulloa on 26/03/23.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

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
    
    // Text Fields
    @IBOutlet weak var UsrNameTF: UITextField!
    @IBOutlet weak var UsrPassTF: UITextField!
    
    // Buttons
    @IBOutlet weak var RecoverPassBtn: UIButton!
    @IBOutlet weak var RememberPassBtn: UIButton!
    @IBOutlet weak var LogInBtn: UIButton!
    @IBOutlet weak var SignUpBtn: UIButton!
    
    // MARK: - Properties

    
    // MARK: - View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "AUTHENTICATION"
        
        UsrNameTF.delegate = self
        UsrPassTF.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        // RememberPassView.isHidden = true
        
        
        setUpLabels()
        setUpViews()
        setUpTextFields()
        setUpButtons()
    }
    
    // MARK: - Methods
    
        // Metodo para personalizar los labels
    private func setUpLabels() {
        AppFontModel(label: LogInLbl, text: "Log In").applyChanges(size: 20 ,textAlignment: .left)
        AppFontModel(label: RememberPassLbl, text: "Stay signed in").applyChanges(textAlignment: .left)
        AppFontModel(label: SignUpLbl, text: "Don't have account?").applyChanges()
        AppFontModel(label: UsrNameLbl, text: "Email address or username").applyChanges(textAlignment: .left)
        AppFontModel(label: UsrPassLbl, text: "Password").applyChanges(textAlignment: .left)
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
    }
    
    // MARK: - Method Actions
        // Action para Logearse en la app
    @IBAction func LogInBtnAction(_ sender: UIButton) {
        if let usrName = UsrNameTF.text, let usrPass = UsrPassTF.text {
            Auth.auth().signIn(withEmail: usrName, password: usrPass) {result,error in
                
                    
                if let result = result, error == nil {
                    // Bloque si el resultado es distinto de nulo y error es nulo, se registro correctamente el usuario
                    self.navigationController?.pushViewController(HomeViewController(email: result.user.email!, provider: .basic), animated: true)
                    self.view.endEditing(true)
                } else {
                    
                    // Bloque si no se hizo el registro correctamente
                    AlertModel().simpleAlert(vc: self, title: "Error", message: "Can't login")
                }
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

