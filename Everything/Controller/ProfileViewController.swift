//
//  ProfileViewController.swift
//  Everything
//
//  Created by Fuxin Bi on 24/1/23.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import RealmSwift
import Alamofire

class ProfileViewController: UIViewController {
    
    lazy var picView = UIImageView()
    lazy var profileButton = UIButton()
    lazy var testButton = UIButton()
    
    lazy var profileImagePhoto = UIImageView()
    lazy var imagePicker = UIImagePickerController()
    
    let profileButtonCenterY: Int = 720
    let testButtonCenterY: Int = 500
    let markerFeltThin = UIFont(name: "MarkerFelt-Thin", size: K.defaultFontSize)!
    
    let storage = Storage.storage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.BrandColors.lightBlue
        
        
        setupPicView()
        
        
        self.view.addSubview(profileButton)
        profileButton.layer.backgroundColor = K.BrandColors.lightPink.cgColor
        profileButton.setTitle("Change Profile", for: .normal)
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
        
        //let imageTap = UITapGestureRecognizer(target: self, action: #selector(picPressed))
        //profileImagePhoto.isUserInteractionEnabled = true
        //profileImagePhoto.addGestureRecognizer(imageTap)
        profileImagePhoto.layer.cornerRadius = profileImagePhoto.bounds.height / 2
        //profileImagePhoto.clipsToBounds = true
        
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker(_:)))
        picView.isUserInteractionEnabled = true
        picView.addGestureRecognizer(imageTap)
        //picView.layer.cornerRadius = picView.bounds.height / 2
        //picView.clipsToBounds = true
 

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        
        self.view.addSubview(testButton)
        testButton.layer.backgroundColor = K.BrandColors.pink.cgColor
        testButton.setTitle("Show ID", for: .normal)
        testButton.setTitleColor(.systemGray6, for: .normal)
        testButton.titleLabel?.font = markerFeltThin
        testButton.layer.masksToBounds = true
        testButton.layer.cornerRadius = K.defaultCornorRadius
        
        testButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.buttonHeight)
            make.width.equalTo(K.buttonWidth)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(testButtonCenterY)
        }
        
        testButton.addTarget(self, action: #selector(showIDPressed), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        //profileButton.addTarget(self, action: #selector(profilePressed), for: .touchUpInside)
    }
    
    @objc private func showIDPressed() {
        let loadVC = ShowIDViewController()
        self.navigationController?.pushViewController(loadVC, animated: true)
        
    }
    
    @objc private func picPressed() {
        let loadVC = TestViewController()
        self.navigationController?.pushViewController(loadVC, animated: true)
        
    }
    
    /*
    @objc private func profilePressed() {
        let loadVC = WelcomeViewController()
        self.view.window?.rootViewController = loadVC
        self.view.window?.makeKeyAndVisible()
        
    }*/
    
    @objc func openImagePicker(_ sender:Any) {
            //Open Image Picker
            self.present(imagePicker, animated: true, completion: nil)
        }
    
    
    
    func setupPicView() {
        self.view.addSubview(picView)
        picView.layer.backgroundColor = K.BrandColors.lightYellow.cgColor
        picView.layer.borderWidth = 1
        picView.layer.masksToBounds = false
        picView.layer.borderColor = UIColor.black.cgColor
        picView.layer.cornerRadius = K.picViewCornorRadius
        picView.clipsToBounds = true
        if Auth.auth().currentUser != nil {
            let imageName = ("profilePic/"+(Auth.auth().currentUser?.uid)!)
            let imageReference = Storage.storage().reference().child(imageName)
            imageReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
              if let error = error {
                  print(error.localizedDescription)
              } else {
                // Data for "images/island.jpg" is returned
                  self.picView.image = UIImage(data: data!)
              }
            }
        } else {
            picView.image = UIImage(systemName: "figure.wave.circle")
        }
        
        picView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.picViewHeight)
            make.width.equalTo(K.picViewWidth)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(K.picViewCenterY)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.picView.image = pickedImage
            
            //1. Create an unique name for your image
            if Auth.auth().currentUser != nil {
                let imageName = ("profilePic/"+(Auth.auth().currentUser?.uid)!)
                //let imageName = UUID().uuidString
                let imageReference = Storage.storage().reference().child(imageName)
                
                //2. Compress quality
                if let uploadData = self.picView.image!.jpegData(compressionQuality: 0.5){
                    
                    //3. Save image as .jpeg
                    let metaDataForImage = StorageMetadata()
                    metaDataForImage.contentType = "image/jpeg"
                    
                    //4. Add the data to Firebase Storage
                    imageReference.putData(uploadData, metadata: metaDataForImage) { (meta, err) in
                        if let err = err{
                            print(err.localizedDescription)
                        }
                        else{
                            //5. Retrieving the image URL
                            imageReference.downloadURL { (url, err) in
                                if let err = err{
                                    print(err.localizedDescription)
                                }
                                else{
                                    //6. Print the complete URL as string
                                    let urlString = url?.absoluteString
                                    print(urlString!)
                                }
                            }
                        }
                    }
                }
            }
            
            
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func makeAPICall(){
        //AF.dat
    }
}
