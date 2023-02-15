//
//  HomeViewController.swift
//  Everything
//
//  Created by Fuxin Bi on 23/1/23.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class HomeViewController: UIViewController {
    
    lazy var titleLabel = UILabel()
    lazy var emailLabel = UILabel()
    lazy var logOutButton = UIButton()
    lazy var profileButton = UIButton()
    let logOutButtonCenterY: Int = 635
    let profileButtonCenterY: Int = 720
    let markerFeltThin = UIFont(name: "MarkerFelt-Thin", size: K.defaultFontSize)!
    let baskervilleSemiBoldItalic = UIFont(name: "Baskerville-SemiBoldItalic", size: K.defaultFontSize)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.BrandColors.lightBlue
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = K.BrandColors.lightBlue// colour here

        navigationController?.navigationBar.standardAppearance = appearance
        //navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        var i: Int = 0
        let colorArray: Array = [UIColor.red, UIColor.yellow, UIColor.blue, UIColor.green, UIColor.cyan]
        
        self.view.addSubview(titleLabel)
        titleLabel.layer.backgroundColor = K.BrandColors.yellow.cgColor
        //titleLabel.backgroundColor = .green
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.font = baskervilleSemiBoldItalic
        titleLabel.font = titleLabel.font.withSize(K.titleFontSize)
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = K.defaultCornorRadius
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.titleLabelHeight)
            make.width.equalTo(K.titleLabelWidth)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(K.titleLabelCenterY)
        }
        
        
        
        
        
        self.view.addSubview(emailLabel)
        emailLabel.layer.backgroundColor = K.BrandColors.lightYellow.cgColor
        //emailLabel.backgroundColor = .green
        emailLabel.textAlignment = .center
        emailLabel.numberOfLines = 0
        emailLabel.sizeToFit()
        emailLabel.font = markerFeltThin
        emailLabel.font = emailLabel.font.withSize(K.titleFontSize)
        emailLabel.layer.masksToBounds = true
        emailLabel.layer.cornerRadius = K.defaultCornorRadius
        
        emailLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.titleLabelHeight)
            make.width.equalTo(K.titleLabelWidth)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(K.titleLabelCenterY + 90)
        }
        
        
        titleLabel.text = ""
        emailLabel.text = ""
        var charIndex = 0.0
        var titleText = "Welcome"
        i = 0
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
                self.titleLabel.textColor = colorArray[i]
                if i < 4 {
                    i+=1
                } else {
                    i = 0
                }
            }
            charIndex += 1
        }
        
        if Auth.auth().currentUser != nil {
            titleText = (Auth.auth().currentUser?.email)!
            i = 0
            for letter in titleText {
                Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { (timer) in
                    self.emailLabel.text?.append(letter)
                    self.emailLabel.textColor = colorArray[i]
                    if i < 4 {
                        i+=1
                    } else {
                        i = 0
                    }
                }
                charIndex += 1
            }
        } else {
          // No user is signed in.
          // ...
        }
        
        self.view.addSubview(logOutButton)
        logOutButton.layer.backgroundColor = K.BrandColors.lightPink.cgColor
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.setTitleColor(.systemGray6, for: .normal)
        logOutButton.titleLabel?.font = markerFeltThin
        logOutButton.layer.masksToBounds = true
        logOutButton.layer.cornerRadius = K.defaultCornorRadius
        
        logOutButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.buttonHeight)
            make.width.equalTo(K.buttonWidth)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(logOutButtonCenterY)
        }
        
        
        self.view.addSubview(profileButton)
        profileButton.layer.backgroundColor = K.BrandColors.lightPink.cgColor
        profileButton.setTitle("Profile", for: .normal)
        profileButton.setTitleColor(.systemGray6, for: .normal)
        profileButton.titleLabel?.font = markerFeltThin
        profileButton.layer.masksToBounds = true
        profileButton.layer.cornerRadius = K.defaultCornorRadius
        
        profileButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.buttonHeight)
            make.width.equalTo(K.buttonWidth)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(profileButtonCenterY)
        }
        
        logOutButton.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profilePressed), for: .touchUpInside)
    }
    
    @objc private func logOutPressed() {
        let loadVC = UINavigationController(rootViewController: WelcomeViewController())
        self.view.window?.rootViewController = loadVC
        self.view.window?.makeKeyAndVisible()
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    @objc private func profilePressed() {
        let loadVC = ProfileViewController()
        self.navigationController?.pushViewController(loadVC, animated: true)
        //self.present(loadVC, animated: true, completion: nil)
    }
}
