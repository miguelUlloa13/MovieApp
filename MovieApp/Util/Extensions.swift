//
//  Extensions.swift
//  MovieApp
//
//  Created by Miguel Angel Bric Ulloa on 27/03/23.
//

import Foundation
import UIKit

    // MARK: - Extension UIFont
extension UIFont {

        // Metodo para usar la fuente "Futura"
    static func Futura(size: CGFloat) -> UIFont? {
        return UIFont(name: "Futura", size: size) ?? .systemFont(ofSize: 17)
    }

}


// MARK: - Extension UIButton

extension UIButton {

    // Method to round Buttons
    func round() {
        self.layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }

    // Method to apply animation bounce
    func bounce(){
        UIView.animate(withDuration: 0.1, animations: { self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (completion) in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }

    }

}

// MARK: - Extension String
extension String {
    
    // Metodo para validar un email
    func isValidEmail(_ email: String) -> Bool {
        let usrName = "[A-Z0-9a-z._%+-]"    // Exprecion regular del nombre de usuario
        let provider = "[A-Za-z0-9.-]"      // Exprecion regular del proveedor del correo
        let domain = "[A-Za-z]"             // Tipo de dominio
        let emailRegEx = usrName + "+@" + provider + "+\\." +  domain + "{2,64}"    // Exprecion regular completa
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailPred.evaluate(with: email)
        return result
    }

    // Metodo para validar el password
        // Longitud de 6 a 16 caracteres
        // Permite ingresar el alfabeto
        // Es necesario un caracter especial
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#+!%*?&])[A-Za-z\\d$@$#!+%*?&]{6,16}"
        
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let result = passwordPred.evaluate(with: password)
        return result
    }

}

