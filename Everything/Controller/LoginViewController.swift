//
//  LoginViewController.swift
//  Everything
//
//  Created by Fuxin Bi on 18/1/23.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    lazy var loginButton = UIButton()
    let loginButtonCenterY: Int = 635
    let markerFeltThin = UIFont(name: "MarkerFelt-Thin", size: K.defaultFontSize)!
    let savoyeLetPlain = UIFont(name: "SavoyeLetPlain", size: K.defaultFontSize)!
    
    
    lazy var emailField : UITextField = {
        let field = UITextField()
        field.text = "1@1.com"
        //field.text = "Email"
        field.isUserInteractionEnabled = true
       // field.insetsLayoutMarginsFromSafeArea = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return field
    }()
    
    lazy var passwordField : UITextField = {
        let field = UITextField()
        field.text = "123456"
        //field.text = "Password"
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
        //emailField.textAlignment = .center
        emailField.textAlignment = .natural
        emailField.font = markerFeltThin
        emailField.layer.masksToBounds = true
        emailField.layer.cornerRadius = K.defaultCornorRadius - 10
        
        //emailField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        //emailField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
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
        passwordField.layer.cornerRadius = K.defaultCornorRadius - 10
        
        passwordField.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.buttonHeight)
            make.width.equalTo(K.buttonWidth)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(240)
        }
        
        
        self.view.addSubview(loginButton)
        loginButton.layer.backgroundColor = K.BrandColors.lightPink.cgColor
        loginButton.setTitle("Sign In", for: .normal)
        loginButton.setTitleColor(.systemGray6, for: .normal)
        loginButton.titleLabel?.font = markerFeltThin
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = K.defaultCornorRadius
        
        loginButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.buttonHeight)
            make.width.equalTo(K.buttonWidth)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(loginButtonCenterY)
        }
        
        loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
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
    
    @objc private func loginPressed() {
       
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    let home = TabBarViewController()
                    home.selectedIndex = 0
                    self.view.window?.rootViewController = home
                    //let loadVC = UINavigationController(rootViewController: HomeViewController())
                    //self.view.window?.rootViewController = loadVC
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
}

