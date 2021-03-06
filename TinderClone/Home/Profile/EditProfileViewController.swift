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
    
    
    @IBOutlet weak var editProfileNavBar: UINavigationBar!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var descTextView: UITextView!
    
    @IBOutlet weak var uploadImageButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AESTHETICS
        imageTapGestureHandler()
        ProfilePicDisplay.profileBounds(image: profilePictureImageView)
        descBoxDisplay.descTextViewAppear(textView: descTextView)
        buttonDisplay()
        
        // LOADING
        loadUserInforHandler()
        
        editProfileNavBar.backgroundColor = UIColor.clear
    }
    
    func buttonDisplay () {
        uploadImageButton.layer.cornerRadius = 5
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveProfileHandler()
        dismiss(animated: true, completion: nil)
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
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        guard let gender = genderTextField.text else { return }
        guard let age = ageTextField.text else { return }
        guard let userDesc = descTextView.text else { return }
        guard let name = nameTextField.text else { return }
        
        FirebaseDataHandler.uploadDataToDatabaseWithUID(uid: currentUserUID, values: ["gender" : gender, "age" : age, "userDesc" : userDesc, "name" : name])
        uploadImageHandler()
    }
    
    func loadUserInforHandler() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(currentUserUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                
                if let profilePicURL = dictionary["userImageURL"] as? String {
                    self.profilePictureImageView.loadImageUsingCacheWithURLString(urlString: profilePicURL)
                }
                
                if
                    let gender = dictionary["gender"] as? String,
                    let age = dictionary["age"] as? String,
                    let name = dictionary["name"] as? String,
                    let desc = dictionary["userDesc"] as? String {
                    
                    self.genderTextField.text = gender
                    self.ageTextField.text = age
                    self.descTextView.text = desc
                    self.nameTextField.text = name
                }
            }
        }, withCancel: nil)
    }
    
}

// MARK : Handling all funcstions relating to profile images
extension EditProfileViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imageTapGestureHandler () {
        profilePictureImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(enableImagePickerHandler)))
        profilePictureImageView.isUserInteractionEnabled = true
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
            profilePictureImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func uploadImageHandler() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        guard let proImage = profilePictureImageView.image else { return }
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
                    FirebaseDataHandler.uploadDataToDatabaseWithUID(uid: currentUserUID, values: values)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
