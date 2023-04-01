//
//  SignUpViewController.swift
//  MovieApp
//
//  Created by Miguel Angel Bric Ulloa on 28/03/23.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    // MARK: - Outlets
        // Views
    @IBOutlet weak var SignUpView: UIView!
    @IBOutlet weak var LogoView: UIView!
    @IBOutlet weak var FormView: UIView!
    @IBOutlet weak var UsrView: UIView!
    @IBOutlet weak var PassView: UIView!
    @IBOutlet weak var VerifyPassView: UIView!
    
        // Stack Views
    @IBOutlet weak var SignUpSV: UIStackView!
    @IBOutlet weak var FormSV: UIStackView!
    
        // Labels
    @IBOutlet weak var UsrNameLbl: UILabel!
    @IBOutlet weak var UsrPassLbl: UILabel!
    @IBOutlet weak var VerifyUsrPassLbl: UILabel!
    
        // Images
    @IBOutlet weak var LogoImg: UIImageView!
    @IBOutlet weak var UsrImg: UIImageView!
    @IBOutlet weak var PassImg: UIImageView!
    @IBOutlet weak var VerifyPassImg: UIImageView!
    
        // Buttons
    @IBOutlet weak var SignUpBtn: UIButton!
    
        // Text fields
    @IBOutlet weak var UsrTF: UITextField!
    @IBOutlet weak var PassTF: UITextField!
    @IBOutlet weak var VerifyPassTF: UITextField!
    
    
    // MARK: - View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UsrTF.delegate = self
        PassTF.delegate = self
        VerifyPassTF.delegate = self

        self.title = "Sign Up"
        setUpLabels()
        setUpViews()
        setUpButtons()
        setUpTextFields()
    }

    // MARK: - Method
    
    
    
    private func setUpLabels() {
        AppFontModel(label: UsrNameLbl, text: "Email address or username").applyChanges(textAlignment: .left)
        AppFontModel(label: UsrPassLbl, text: "Password").applyChanges(textAlignment: .left)
        AppFontModel(label: VerifyUsrPassLbl, text: "Verify password").applyChanges(textAlignment: .left)

    }
    
    private func setUpViews() {
        UsrView.layer.borderColor = UIColor.link.cgColor
        UsrView.layer.borderWidth = 1
        UsrView.layer.cornerRadius = 5

        PassView.layer.borderColor = UIColor.link.cgColor
        PassView.layer.borderWidth = 1
        PassView.layer.cornerRadius = 5
        
        VerifyPassView.layer.borderColor = UIColor.link.cgColor
        VerifyPassView.layer.borderWidth = 1
        VerifyPassView.layer.cornerRadius = 5
    }
    
    private func setUpTextFields() {
        UsrTF.placeholder = "Email address or username"
        UsrTF.font = .Futura(size: 17)
        
        PassTF.placeholder = "Password"
        PassTF.font = .Futura(size: 17)
        
        VerifyPassTF.placeholder = "Password"
        VerifyPassTF.font = .Futura(size: 17)
    }
    
        // Metodo para cambiar al siguiente textfield
    private func switchBasedNextTextField(_ textField: UITextField) {
        
        switch textField {
        case self.UsrTF:
            self.PassTF.becomeFirstResponder()
        case self.PassTF:
            self.VerifyPassTF.becomeFirstResponder()
        default:
            self.VerifyPassTF.resignFirstResponder()
        }
        
    }
    
    private func setUpButtons() {
        SignUpBtn.round()
        SignUpBtn.setTitle("Sign Up", for: .normal)
        SignUpBtn.titleLabel?.font = .Futura(size: 17)
        SignUpBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        SignUpBtn.titleLabel?.minimumScaleFactor = 0.5
    }
    
    
    // MARK: - Method Actions
    @IBAction func SignUpBtnAction(_ sender: UIButton) {
        
        if let usrName = UsrTF.text, let verifyPass = VerifyPassTF.text, let usrPass = PassTF.text {
            
            if verifyPass != usrPass {
                // Bloque si no coincide el password con verify password
                
                AlertModel().simpleAlert(vc: self, title: "Error", message: "Password and Verify password doesn't match")
            } else {
                // Bloque de validacion del email y el usario
                
                if usrName == "" && verifyPass == "" && usrPass == "" {
                    AlertModel().simpleAlert(vc: self, title: "Error", message: "Please, fill in all fields")
                } else {
                    if !usrName.isValidEmail(usrName) {
                        // Bloque por si no ingresa un correo invalido
                        
                        AlertModel().simpleAlert(vc: self, title: "Error", message: "Please, enter valid email")
                    } else if !usrPass.isValidPassword(password: usrPass) {
                        // Bloque por si no ingresa un correo invalido
                        
                        AlertModel().simpleAlert(vc: self, title: "Error", message: "Please, enter valid password")
                    } else {
                        // Bloque si se valido correctamente el email y el password
                        
                        Auth.auth().createUser(withEmail: usrName, password: usrPass) {result,error in
                            if let result = result, error == nil {
                                // Bloque si el resultado es distinto de nulo y error es nulo, se registro correctamente el usuario
                                
                                self.navigationController?.pushViewController(HomeViewController(email: result.user.email!, provider: .basic), animated: true)
                            } else {
                                // Bloque si no se hizo el registro correctamente
                                
                                let alertController = UIAlertController(title: "Error", message: "Problem creating user", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "Accept", style: .default))
                                self.present(alertController, animated: true)
                            }
                        }
                        
                    }
                }
                
            }
            
        }
        
    }
    

}

extension SignUpViewController: UITextFieldDelegate {
    
        // Metodo del textfield para detectar cuando el usario presiona el boton Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        
        return true
        
    }

}
