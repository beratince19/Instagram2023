//
//  FeedViewController.swift
//  Instagram2023
//
//  Created by Berat Tugay İnce on 7.09.2023.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userEmailArray = [String]()
    var likeArray = [Int]()
    var commentArray = [String]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFirebase()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as? FeedCell
        cell?.userEmailLabel.text = userEmailArray[indexPath.row]
        cell?.likeLabel.text = String(likeArray[indexPath.row])
        cell?.commentLabel.text = commentArray[indexPath.row]
        cell?.userImageView.loadImage(fromUrl: userImageArray[indexPath.row])
       /* cell?.backgroundColor = ((indexPath.row % 2) != 0) ? UIColor.gray : UIColor.white
        */
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    func getDataFirebase() {
        
       
        Firestore.firestore().collection("post").addSnapshotListener { (snapshot, error) in
            guard error == nil else {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                return
            }
            
            guard let snapShot = snapshot, snapShot.isEmpty == false else {
                return
            }
            
            self.userEmailArray.removeAll()
            self.commentArray.removeAll()
            self.likeArray.removeAll()
            self.userImageArray.removeAll()
            
            for document in snapshot!.documents {
                let documentID = document.documentID
                print(documentID)
                
                if let postedBy = document.get("postedBy") as? String {
                    self.userEmailArray.append(postedBy)
                }
                
                if let postComment = document.get("postComment") as? String {
                    self.commentArray.append(postComment)
                }
                
                if let likes = document.get("likes") as? Int {
                    self.likeArray.append(likes)
                }
                
                if let imageUrl = document.get("imageUrl") as? String {
                    self.userImageArray.append(imageUrl)
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

import Kingfisher

extension UIImageView {

    func loadImage(fromUrl url: String?) {
        guard let url = URL(string: url ?? "") else { return }
        KF.url(url).set(to: self)
    }
}
