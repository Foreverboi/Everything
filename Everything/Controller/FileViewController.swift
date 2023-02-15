//
//  FileViewController.swift
//  Everything
//
//  Created by Fuxin Bi on 31/1/23.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class FileViewController: UIViewController {
    
    lazy var picView = UIImageView()
    lazy var saveButton = UIButton()
    let saveButtonCenterY: Int = 700
    let markerFeltThin = UIFont(name: "MarkerFelt-Thin", size: K.defaultFontSize)!
    lazy var profileImagePhoto = UIImageView()
    lazy var imagePicker = UIImagePickerController()
    
    lazy var tableView = UITableView()
    lazy var messageTextfield = UITextField()
    
    
   // private let storage = Storage.storage().reference()
    
    let db = Firestore.firestore()
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        tableView.dataSource = self
        //title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
        
        setupPicView()
        
        
        self.view.addSubview(saveButton)
        saveButton.layer.backgroundColor = K.BrandColors.pink.cgColor
        saveButton.setTitle("Try it out", for: .normal)
        saveButton.setTitleColor(.systemGray6, for: .normal)
        saveButton.titleLabel?.font = markerFeltThin
        saveButton.layer.masksToBounds = true
        saveButton.layer.cornerRadius = K.defaultCornorRadius
        
        saveButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.buttonHeight)
            make.width.equalTo(K.buttonWidth)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(saveButtonCenterY)
        }
        
    
        
    }
    
    func setupPicView() {
        self.view.addSubview(picView)
        picView.layer.backgroundColor = K.BrandColors.lightYellow.cgColor
        picView.layer.borderWidth = 1
        picView.layer.masksToBounds = false
        picView.layer.borderColor = UIColor.black.cgColor
        picView.layer.cornerRadius = K.picViewCornorRadius
        picView.clipsToBounds = true
        picView.image = UIImage(systemName: "figure.wave.circle")
        
        picView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(K.picViewHeight)
            make.width.equalTo(K.picViewWidth)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(K.picViewCenterY)
        }
    }
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                   self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @objc func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    
                    DispatchQueue.main.async {
                         self.messageTextfield.text = ""
                    }
                }
            }
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
    
}


    


extension FileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        //This is a message from the current user.
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = K.BrandColors.lightYellow
            cell.label.textColor = K.BrandColors.pink
        }
        //This is a message from another sender.
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = K.BrandColors.yellow
            cell.label.textColor = K.BrandColors.lightPink
        }
        
      
      
        return cell
    }
}

