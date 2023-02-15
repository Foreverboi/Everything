//
//  ShowIDViewController.swift
//  Everything
//
//  Created by Fuxin Bi on 6/2/2023.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import RealmSwift
import Alamofire

class ShowIDViewController: UIViewController {
    
    let currentBrightness = UIScreen.main.brightness
    let markerFeltThin = UIFont(name: "MarkerFelt-Thin", size: K.defaultFontSize)!
    let storage = Storage.storage()
    var talk5Manager = Talk5Manager()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        picView.layer.cornerRadius = picView.frame.height / 2.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIScreen.main.brightness = currentBrightness
    }
    
    let cardBackView : UIView = {
        let cardBackView = UIView()
        cardBackView.frame = UIScreen.main.bounds
        cardBackView.backgroundColor = K.BrandColors.talk5
        cardBackView.layer.borderWidth = 2
        cardBackView.layer.borderColor = UIColor.gray.cgColor
        cardBackView.layer.cornerRadius = 30
        cardBackView.layer.shadowRadius = 5
        cardBackView.layer.shadowColor = UIColor.black.cgColor
        cardBackView.layer.shadowOpacity = 0.5
        cardBackView.layer.shadowOffset = .zero
        cardBackView.layer.masksToBounds = false
        return cardBackView
    }()
    
    lazy var appBackPic : UIImage = {
        let appBackPic = UIImage(named: "talk5_logo-edited.svg")!
        return appBackPic
    }()

    lazy var appBackView : UIImageView = {
        let appBackView = UIImageView()
        return appBackView
    }()
    
    let cardView : UIView = {
        let cardView = UIView()
        cardView.frame = UIScreen.main.bounds
        cardView.backgroundColor = .white
        cardView.layer.borderWidth = 2
        cardView.layer.borderColor = UIColor.gray.cgColor
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowRadius = 5
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = .zero
        cardView.layer.masksToBounds = false
        return cardView
    }()
    
    lazy var appPic : UIImage = {
        let appPic = UIImage(named: "talk5_logo-color.svg")!
        return appPic
    }()
    
    lazy var appView : UIImageView = {
        let appView = UIImageView()
        return appView
    }()
    
    lazy var phoneLabel : UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.layer.backgroundColor = view.backgroundColor?.cgColor
        phoneLabel.layer.borderColor = UIColor.black.cgColor
        phoneLabel.text = "Ph: 1300 00 MAIN"
        phoneLabel.font = UIFont.systemFont(ofSize: (14.0))
        phoneLabel.textAlignment = .center
        return phoneLabel
    }()
    
    lazy var picView :UIImageView = {
        let picView = UIImageView()
        picView.layer.backgroundColor = K.BrandColors.lightYellow.cgColor
        picView.clipsToBounds = true
        return picView
    }()
    
    lazy var nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.layer.backgroundColor = view.backgroundColor?.cgColor
        nameLabel.text = ""
        nameLabel.font = UIFont(name: "GillSans-Bold", size: (20.0))!
        nameLabel.textAlignment = .center
        return nameLabel
    }()
    
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.layer.backgroundColor = view.backgroundColor?.cgColor
        titleLabel.text = "Project Director"
        titleLabel.font = UIFont.systemFont(ofSize: (16.0))
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    lazy var qrView : UIImageView = {
        let qrView = UIImageView()
        qrView.layer.backgroundColor = K.BrandColors.lightYellow.cgColor
        return qrView
    }()
    
    let ppi: Double = {
        switch Ppi.get() {
        case .success(let ppi):
            return ppi
        case .unknown(let bestGuessPpi, let error):
            // A bestGuessPpi value is provided but may be incorrect
            // Treat as a non-fatal error -- e.g. log to your backend and/or display a message
            return bestGuessPpi
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        UIScreen.main.brightness = 0.8
        let scale : Double = UIScreen.main.nativeScale
        let ratio: Double = ppi / scale
        let cardViewHeight = K.IDCardHeight * ratio
        let cardViewWidth = K.IDCardWidth * ratio
        talk5Manager.delegate = self
        
        setupCardBackView(height: cardViewHeight, width: cardViewWidth)
        setupAppBackView()
        setupcardView(height: cardViewHeight, width: cardViewWidth)
        setupAppView(height: cardViewHeight)
        setupPhoneView(height: cardViewHeight)
        setupPicView(height: cardViewHeight)
        setupNameView(height: cardViewHeight)
        setupTitleView(height: cardViewHeight)
        setupQRView(height: cardViewHeight)
        
        talk5Manager.fetchTalk5()
        
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0) {
                self.cardView.alpha = 0
                self.cardBackView.alpha = 1
                self.cardView.transform3D = CATransform3DRotate(self.cardView.layer.transform, CGFloat.pi, 0, 0.5, 0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.cardBackView.transform3D = CATransform3DRotate(self.cardBackView.layer.transform, CGFloat.pi, 0, 0.5, 0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.cardView.transform3D = CATransform3DRotate(self.cardView.layer.transform, CGFloat.pi, 0, 0.5, 0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0) {
                self.cardBackView.alpha = 0
                self.cardView.alpha = 1
            }
        }
        
    }
    
    func setupCardBackView(height: Double, width: Double){
        view.addSubview(cardBackView)
        cardBackView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
    }
    
    func setupAppBackView() {
        cardBackView.addSubview(appBackView)
        appBackView.image = appBackPic
        appBackView.snp.makeConstraints { (make) -> Void in
            make.centerX.centerY.equalTo(cardBackView)
            make.height.equalTo(cardBackView.snp.width).multipliedBy(0.8)
            make.width.equalTo(cardBackView.snp.width).multipliedBy(0.8)
        }
    }
    
    func setupcardView(height: Double, width: Double){
        view.addSubview(cardView)
        cardView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
    }
    
    func setupAppView(height: Double) {
        cardView.addSubview(appView)
        appView.image = appPic
        appView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(cardView)
            make.top.equalTo(cardView.snp.top).offset((height) * 0.05)
            make.height.equalTo(cardView.snp.height).multipliedBy(0.13)
            make.width.equalTo(cardView.snp.height).multipliedBy(0.26)
        }
    }
    
    func setupPhoneView(height: Double) {
        cardView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(cardView)
            make.top.equalTo(appView.snp.bottom).offset((height) * 0.02)
            make.height.equalTo(cardView.snp.height).multipliedBy(0.025)
            make.trailing.lessThanOrEqualToSuperview().inset(2)
        }
    }
    
    
    func setupPicView(height: Double) {
        cardView.addSubview(picView)
        if Auth.auth().currentUser != nil {
            let imageName = ("profilePic/"+(Auth.auth().currentUser?.uid)!)
            let imageReference = Storage.storage().reference().child(imageName)
            imageReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
              if let error = error {
                  print(error.localizedDescription)
              } else {
                  self.picView.image = UIImage(data: data!)
              }
            }
        } else {
            picView.image = UIImage(systemName: "figure.wave.circle")
        }
        
        picView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(cardView)
            make.top.equalTo(phoneLabel.snp.bottom).offset((height) * 0.06)
            make.height.width.equalTo(cardView.snp.height).multipliedBy(0.28)
        }
    }
    
    
    func setupNameView(height: Double) {
        cardView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(cardView)
            make.top.equalTo(picView.snp.bottom).offset((height) * 0.06)
            make.height.equalTo(cardView.snp.height).multipliedBy(0.035)
            make.trailing.lessThanOrEqualToSuperview().inset(2)
        }
    }
    
    func setupTitleView(height: Double) {
        cardView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(cardView)
            make.top.equalTo(nameLabel.snp.bottom).offset((height) * 0.02)
            make.height.equalTo(cardView.snp.height).multipliedBy(0.03)
            make.trailing.lessThanOrEqualToSuperview().inset(2)
        }
    }
    
    func setupQRView(height: Double) {
        cardView.addSubview(qrView)
        qrView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(cardView)
            make.top.equalTo(titleLabel.snp.bottom).offset((height) * 0.05)
            make.height.width.equalTo(cardView.snp.height).multipliedBy(0.18)
        }
    }
}

extension ShowIDViewController: Talk5ManagerDelegate {
    
    func didUpdateTalk5(_ talk5Manager: Talk5Manager, talk5: Talk5Model) {
        DispatchQueue.main.async {
            self.nameLabel.text = talk5.fullName
            self.qrView.image = talk5.qrcode
        }
    }
    
    func didFailWithError(error: Error) {
        print("Talk5ManagerDelegate Failed")
        print(error)
    }
    
}
