//
//  RegisterViewController.swift
//  Everything
//
//  Created by Fuxin Bi on 18/1/23.
//

import UIKit
import SnapKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    lazy var regisButton = UIButton()
    let regisButtonCenterY: Int = 635
    let markerFeltThin = UIFont(name: "MarkerFelt-Thin", size: K.defaultFontSize)!
    let savoyeLetPlain = UIFont(name: "SavoyeLetPlain", size: K.defaultFontSize)!
    
    
    lazy var emailField : UITextField = {
        let field = UITextField()
    
        field.text = "Email"
        field.isUserInteractionEnabled = true
       // field.insetsLayoutMarginsFromSafeArea = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return field
    }()
    
    lazy var passwordField : UITextField = {
        let field = UITextField()
    
        field.text = "Password"
        field.isUserInteractionEnabled = true
       // field.insetsLayoutMarginsFromSafeArea = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return field
    }()
    
    /*
    lazy var backgroundImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "textfield")
       // field.insetsLayoutMarginsFromSafeArea = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImage)
        view.backgroundColor = K.BrandColors.yellow
        backgroundImage.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(18.0)
            make.centerY.centerX.equalToSuperview()
            make.height.equalTo(177)
        }
        */
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.BrandColors.yellow
        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = K.BrandColors.lightPink // colour here

        navigationController?.navigationBar.standardAppearance = appearance
        //navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
        
        view.addSubview(emailField)
        emailField.delegate = self
        emailField.layer.backgroundColor = K.BrandColors.lightBlue.cgColor
        emailField.textAlignment = .center
        emailField.font = markerFeltThin
        emailField.layer.masksToBounds = true
        emailField.layer.cornerRadius = K.defaultCornorRadius
        
        emailField.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.buttonHeight)
            make.width.equalTo(K.buttonWidth)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(180)
        }
        
        
        
        
        view.addSubview(passwordField)
        passwordField.delegate = self
        passwordField.layer.backgroundColor = K.BrandColors.lightBlue.cgColor
        passwordField.textAlignment = .center
        passwordField.font = markerFeltThin
        passwordField.layer.masksToBounds = true
        passwordField.layer.cornerRadius = K.defaultCornorRadius
        
        passwordField.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.buttonHeight)
            make.width.equalTo(K.buttonWidth)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(240)
        }
        
        
        
        
        self.view.addSubview(regisButton)
        regisButton.layer.backgroundColor = K.BrandColors.lightPink.cgColor
        regisButton.setTitle("Sign Up", for: .normal)
        regisButton.setTitleColor(.systemGray6, for: .normal)
        regisButton.titleLabel?.font = markerFeltThin
        regisButton.layer.masksToBounds = true
        regisButton.layer.cornerRadius = K.defaultCornorRadius
        
        regisButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.buttonHeight)
            make.width.equalTo(K.buttonWidth)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(regisButtonCenterY)
        }
        
        regisButton.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text?.removeAll()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == emailField && textField.text == "") {
           textField.text = "Enter Email"
        }
        else if (textField == passwordField && textField.text == "") {
            textField.text = "Enter Password"
        }
    }
    
    @objc private func registerPressed() {
       
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    //Navigate to the ChatViewController
                    //self.performSegue(withIdentifier: K.registerSegue, sender: self)
                    
                    //let loadVC = HomeViewController()
                    //self.view.window?.rootViewController = loadVC
                    //self.view.window?.makeKeyAndVisible()

                    //self.navigationController?.pushViewController(loadVC, animated: true)
                    
                    let home = TabBarViewController()
                    home.selectedIndex = 0
                    self.view.window?.rootViewController = home
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
}

