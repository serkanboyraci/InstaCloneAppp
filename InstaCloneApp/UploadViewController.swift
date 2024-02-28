//
//  UploadViewController.swift
//  InstaCloneApp
//
//  Created by Ali serkan Boyracı  on 11.10.2022.
//

import UIKit
import CoreData
import FirebaseStorage
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    
    
    @IBOutlet var commentText: UITextField!
    
    
    @IBOutlet var uploadButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Recognizers
        //close keyboard-cant open again
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        //to enable to user tapped to image
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTapRecognizer)

        // Do any additional setup after loading the view.
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func selectImage() { //to go to the photo gallery
        let picker = UIImagePickerController()
        picker.delegate = self // to use picker functions
        picker.sourceType = .photoLibrary //to take data source
        picker.allowsEditing = true //to edit photo
        present(picker, animated: true)
    }
    
    // after selecting photo, to go back VC
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage //you can select .originalImage or editedImage
        
        //saveButton.isEnabled = true // to save button activated
        self.dismiss(animated: true, completion: nil) // to close selecting window (picker)
    }
    
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        
        let storage = Storage.storage() // to work with FirebaseStorage, you can see all steps alson in this link. https://firebase.google.com/docs/storage/ios/upload-files?hl=en&authuser=0
        let storageReference = storage.reference() // we use this reference as we use this folder.
        
        let mediaFolder = storageReference.child("media") // we reach to media folder which we produce from web. ALso if you do this code, xcode automatically produce this folder. / if you .child("...) you will go one times lower.
        
        // we must change the format of the view, as we have done it artBookApp.
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) { // we decrease the quality
            
            let uuid = UUID().uuidString // uuid to change string, everytime we will get uniqe id strings.
            
            let imageReference = mediaFolder.child("\(uuid).jpg") // before we take only "image.jpg" and, everytime overwrite of it. , we will take jpg format and uuid string name.
            imageReference.putData(data, metadata: nil) { (metaData, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!!!", messageInput: error?.localizedDescription ?? "Errorrr")
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString // means take URL and change it as String
                            
                            //DATABASE, you have to first initialize from firestore database and also you can define key-value pair from there also from xcode.
                            
                            let firestoreDatabase = Firestore.firestore() //similar like Auth.auth() and Storage.storage()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            // we define Post Collection as a Dict // data will be dict string: any
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" :Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!,
                                                 "date" : FieldValue.serverTimestamp(), "likes" : 0 ]
                            // we define a collection from xcode instead of web
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    
                                    
                                }else {
                                    // we have to reset upload page.
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commentText.text = ""
                                    // and go to the feed page
                                    self.tabBarController?.selectedIndex = 0 // means Feed
                                    
                                    
                                }
                                    
                            })
                            
                            
                            
                                
                          
                            
                            
                            
                            
                            
                        }
                    }
                }
            }
            
        }
        
        
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
