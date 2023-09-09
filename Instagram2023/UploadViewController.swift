//
//  UploadViewController.swift
//  Instagram2023
//
//  Created by Berat Tugay İnce on 7.09.2023.
//

import UIKit
import FirebaseStorage
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRicognizer = UITapGestureRecognizer(target: self, action: #selector(choosenImage))
        imageView.addGestureRecognizer(gestureRicognizer)
    }
    
    @objc func choosenImage() {
        let pickerControler = UIImagePickerController()
        pickerControler.delegate = self
        pickerControler.sourceType = .photoLibrary
        present(pickerControler, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func UploadClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        guard let data = imageView?.image?.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        let uuid = UUID().uuidString
        let imageReferance = mediaFolder.child("\(uuid).jpg")
        
        imageReferance.putData(data, metadata: nil) { (metadata, error) in
            
            guard error == nil else {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                return
            }
            
            imageReferance.downloadURL { url, error in
                guard error == nil else {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    return
                }
                
                let firestorePots = ["imageUrl" : url?.absoluteString ?? "",
                                     "postedBy" : Auth.auth().currentUser?.email ?? "" ,
                                     "postComment" : self.commentText.text ?? "" ,
                                     "date" : FieldValue.serverTimestamp(),
                                     "likes" : 0  ] as? [String : Any]
                Firestore.firestore()
                    .collection("post")
                    .addDocument(data: firestorePots ?? [:], completion: { (error) in
                        guard error == nil else {
                            self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                            return
                        }
                        self.imageView.image = UIImage(named: "select.jpg")
                        self.commentText.text = ""
                        self.tabBarController?.selectedIndex = 0
                })
            }
        }
    }
}



