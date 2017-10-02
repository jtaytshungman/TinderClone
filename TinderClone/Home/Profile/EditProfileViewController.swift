//
//  EditProfileViewController.swift
//  TinderClone
//
//  Created by Jeremy Tay on 02/10/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageTapGestureHandler()
        profilePicDisplay()
        descTextViewAppear()
        
    }
    
    func loadProfileImageHandler(urlString : String) {
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveProfileHandler()
    }
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        uploadImageHandler()
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        cancelHandler()
    }
    
}

extension EditProfileViewController {

    func cancelHandler () {
        let cancelAlert = UIAlertController(title: "Cancel Message", message: "Your information will be gone if you didn't save. Are you sure you want to cancel?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        cancelAlert.addAction(cancel)
        cancelAlert.addAction(confirm)
        present(cancelAlert, animated: true, completion: nil)
    }
    
    func saveProfileHandler() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let gender = genderTextField.text else { return }
        guard let age = ageTextField.text else { return }
        guard let userDesc = descTextView.text else { return }
        
        FirebaseDataHandler.uploadDataToDatabaseWithUID(uid: uid, values: ["gender" : gender, "age" : age, "userDesc" : userDesc])
        
    }
    
}

// MARK : Handling all funcstions relating to profile images
extension EditProfileViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imageTapGestureHandler () {
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(enableImagePickerHandler)))
        profileImage.isUserInteractionEnabled = true
    }
    
    func enableImagePickerHandler() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker : UIImage?
        
        // edited image
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        // original image
        } else if let oriImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = oriImage
        }
        // Selected Image
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func uploadImageHandler() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let proImage = profileImage.image else { return }
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("UserProfileImage").child("\(imageName).jpg")
        
        if let uploadData = UIImageJPEGRepresentation(proImage, 0.1) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                    let values = ["userImageURL" : profileImageURL]
                    FirebaseDataHandler.uploadDataToDatabaseWithUID(uid: uid, values: values)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension EditProfileViewController {
    func profilePicDisplay () {
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.borderWidth = CGFloat(3.0)
        self.profileImage.layer.borderColor = UIColor.white.cgColor
    }
    func descTextViewAppear () {
        self.descTextView.layer.cornerRadius = self.descTextView.frame.size.width / 10
    }
}
