//
//  TestViewController.swift
//  Everything
//
//  Created by Fuxin Bi on 24/1/23.
//

import UIKit
import SnapKit
import Firebase
import RealmSwift

class TestViewController: UIViewController {
    
    lazy var picture = UIImage(named: "profilePic1.jpeg")
    lazy var picView = UIImageView()
    lazy var saveButton = UIButton()
    lazy var getButton = UIButton()
    let saveButtonCenterX: Int = 100
    let saveButtonCenterY: Int = 700
    let getButtonCenterX: Int = 300
    let getButtonCenterY: Int = 700
    let markerFeltThin = UIFont(name: "MarkerFelt-Thin", size: K.defaultFontSize)!
    lazy var profileImagePhoto = UIImageView()
    lazy var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        print("Realm location : ", Realm.Configuration.defaultConfiguration.fileURL ?? "")
        
        setupPicView()

        
        self.view.addSubview(saveButton)
        saveButton.layer.backgroundColor = K.BrandColors.pink.cgColor
        saveButton.setTitle("Upload", for: .normal)
        saveButton.setTitleColor(.systemGray6, for: .normal)
        saveButton.titleLabel?.font = markerFeltThin
        saveButton.layer.masksToBounds = true
        saveButton.layer.cornerRadius = K.defaultCornorRadius
        
        saveButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.buttonHeight)
            make.width.equalTo(K.buttonWidth)
            make.centerX.equalTo(saveButtonCenterX)
            make.centerY.equalTo(saveButtonCenterY)
        }
        
        
        self.view.addSubview(getButton)
        getButton.layer.backgroundColor = K.BrandColors.pink.cgColor
        getButton.setTitle("Get", for: .normal)
        getButton.setTitleColor(.systemGray6, for: .normal)
        getButton.titleLabel?.font = markerFeltThin
        getButton.layer.masksToBounds = true
        getButton.layer.cornerRadius = K.defaultCornorRadius
        
        getButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.buttonHeight)
            make.width.equalTo(K.buttonWidth)
            make.centerX.equalTo(getButtonCenterX)
            make.centerY.equalTo(getButtonCenterY)
        }
        getButton.addTarget(self, action: #selector(getPressed), for: .touchUpInside)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImagePhoto.isUserInteractionEnabled = true
        profileImagePhoto.addGestureRecognizer(imageTap)
        profileImagePhoto.layer.cornerRadius = profileImagePhoto.bounds.height / 2
        profileImagePhoto.clipsToBounds = true
        saveButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)


               imagePicker = UIImagePickerController()
               imagePicker.allowsEditing = false
               imagePicker.sourceType = .photoLibrary
               imagePicker.delegate = self
        
        //saveButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        
    }
    
    func setupPicView() {
        self.view.addSubview(picView)
        picView.layer.backgroundColor = K.BrandColors.lightYellow.cgColor
        picView.layer.borderWidth = 1
        picView.layer.masksToBounds = false
        picView.layer.borderColor = UIColor.black.cgColor
        picView.layer.cornerRadius = K.picViewCornorRadius
        picView.clipsToBounds = true
        //picView.image = picture
        picView.image = UIImage(systemName: "figure.wave.circle")
        
        picView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.picViewHeight)
            make.width.equalTo(K.picViewWidth)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(K.picViewCenterY)
        }
    }
    
    @objc func openImagePicker(_ sender:Any) {
            //Open Image Picker
            self.present(imagePicker, animated: true, completion: nil)
        }
    
    /*
    @objc private func savePressed() {
        _ = navigationController?.popViewController(animated: true)
    }
    */
    
    @objc private func getPressed() {
        do {
            let readData = try Data(contentsOf: URL(fileURLWithPath: "\(self.documentDirectory())/profilePic"))
            self.picView.image = UIImage(data: readData)
            print("ProfileRealm profile picture got")
        } catch let error as NSError {
          print(error.localizedDescription)
        }
    }
    
    
}

extension TestViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //self.picView.image = pickedImage
            picker.dismiss(animated: true, completion: nil)
            crop()
            
            
            let data = pickedImage.pngData()!
            do {
                let profileURL = "\(self.documentDirectory())/profilePic"
                try data.write(to: URL(fileURLWithPath: profileURL), options: .atomic)
                if let userID = Auth.auth().currentUser?.uid{
                    let realm = try Realm()
                    let profile = ProfileRealm(_id: userID, email: Auth.auth().currentUser?.email, profilePic: profileURL )
                    try realm.write {
                        realm.add(profile, update: .modified)
                        print("ProfileRealm added")
                    }
                }
               
              
            } catch let error as NSError {
              print(error.localizedDescription)
            }
            
            
            
            
        } 
            picker.dismiss(animated: true, completion: nil)
        
    }
    
    func crop() {
        let sampleView = UIView(frame: UIScreen.main.bounds)
        let maskLayer = CALayer()
        maskLayer.frame = sampleView.bounds
        let circleLayer = CAShapeLayer()
        //assume the circle's radius is 100
        circleLayer.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 200, height: 200))
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.black.cgColor
        circleLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.addSublayer(circleLayer)

        sampleView.layer.mask = maskLayer
    }
    
    func documentDirectory() -> String {
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
    .userDomainMask, true)
        return documentDirectory[0]
    }
}
