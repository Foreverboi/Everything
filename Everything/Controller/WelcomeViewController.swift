//
//  WelcomeViewController.swift
//  Everything
//
//  Created by Fuxin Bi on 18/1/23.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth

class WelcomeViewController: UIViewController {
    
    lazy var titleLabel = UILabel()
    lazy var regisButton = UIButton()
    lazy var loginButton = UIButton()
    //lazy var titleLabel : UILabel = {
        //let field = UILabel()
    
        //field.text = K.appName
        //field.isUserInteractionEnabled = true
       // field.insetsLayoutMarginsFromSafeArea = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        //return field
    //}()
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
            // This will change the navigation bar background color
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = K.BrandColors.lightPink // colour here
            
            navigationController?.navigationBar.standardAppearance = appearance
            //navigationController?.navigationBar.scrollEdgeAppearance = appearance
            
            var i: Int = 0
            
            let regisButtonCenterY: Int = 600
            let loginButtonCenterY: Int = 670
            
            let colorArray: Array = [UIColor.red, UIColor.yellow, UIColor.blue, UIColor.green, UIColor.cyan]
            
            /*
             let pink = hexStringToUIColor(hex: K.BrandColors.pink)
             let lightPink = hexStringToUIColor(hex: K.BrandColors.lightPink)
             let yellow = hexStringToUIColor(hex: K.BrandColors.yellow)
             let lightYellow = hexStringToUIColor(hex: K.BrandColors.lightYellow)
             */
            
            //let font = UIFont(name: "MarkerFelt-Thin", size: .systemFontSize)!
            let markerFeltThin = UIFont(name: "MarkerFelt-Thin", size: K.defaultFontSize)!
            let baskervilleSemiBoldItalic = UIFont(name: "Baskerville-SemiBoldItalic", size: K.defaultFontSize)!
            
            view.backgroundColor = K.BrandColors.lightPink
            
            /*
             view.addSubview(titleLabel)
             titleLabel.snp.makeConstraints { make in
             make.left.right.equalTo(titleLabel).inset(12.0)
             make.centerY.centerX.equalTo(titleLabel)
             make.height.equalTo(48.0)
             }*/
            
            
            
            // ----------------------------------------------------------------------
            // titleLabel
            // The title as the app name
            // Located at the top of the page
            // ----------------------------------------------------------------------
            self.view.addSubview(titleLabel)
            titleLabel.layer.backgroundColor = K.BrandColors.pink.cgColor
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
            
            titleLabel.text = ""
            var charIndex = 0.0
            let titleText = K.appName
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
            // ----------------------------------------------------------------------
            // ----------------------------------------------------------------------
            
            
            
            // ----------------------------------------------------------------------
            // regisButton
            // A button with "Sign Up" on it which leads to the register page upon tap
            // Located at the bottom of the page
            // ----------------------------------------------------------------------
            self.view.addSubview(regisButton)
            regisButton.layer.backgroundColor = K.BrandColors.yellow.cgColor
            regisButton.setTitle("Register", for: .normal)
            regisButton.setTitleColor(.systemGray6, for: .normal)
            regisButton.titleLabel?.font = markerFeltThin
            regisButton.layer.masksToBounds = true
            regisButton.layer.cornerRadius = K.defaultCornorRadius
            
            regisButton.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(K.buttonHeight)
                make.width.equalTo(K.buttonWidth)
                make.centerX.equalTo(self.view)
                make.centerY.equalTo(regisButtonCenterY)
                //make.center.equalTo(self.view)
            }
            // ----------------------------------------------------------------------
            // ----------------------------------------------------------------------
            
            
            
            // ----------------------------------------------------------------------
            // loginButton
            // A button with "Log In" on it which leads to the login page upon tap
            // Located at the bottom of the page
            // ----------------------------------------------------------------------
            self.view.addSubview(loginButton)
            loginButton.layer.backgroundColor = K.BrandColors.lightYellow.cgColor
            loginButton.setTitle("Log In", for: .normal)
            loginButton.setTitleColor(.systemGray, for: .normal)
            loginButton.titleLabel?.font = markerFeltThin
            loginButton.layer.masksToBounds = true
            loginButton.layer.cornerRadius = K.defaultCornorRadius
            
            loginButton.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(K.buttonHeight)
                make.width.equalTo(K.buttonWidth)
                make.centerX.equalTo(self.view)
                make.centerY.equalTo(loginButtonCenterY)
                //make.center.equalTo(self.view)
            }
            // ----------------------------------------------------------------------
            // ----------------------------------------------------------------------
            
            regisButton.addTarget(self, action: #selector(regisPressed), for: .touchUpInside)
            loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        
    }
    
    @objc private func regisPressed() {
        let loadVC = RegisterViewController()
        // Full screen instead of Segue
        //loadVC.modalPresentationStyle = .fullScreen
        
        //self.navigationController?.pushViewController(loadVC, animated: true)
        
        //let navController = UINavigationController(rootViewController: UIViewController)
        
        self.navigationController?.pushViewController(loadVC, animated: true)
        
        //self.present(loadVC, animated: true, completion: nil)
    }
    
    @objc private func loginPressed() {
        let loadVC = LoginViewController()
        // Full screen instead of Segue
        //loadVC.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(loadVC, animated: true)
        //self.present(loadVC, animated: true, completion: nil)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

