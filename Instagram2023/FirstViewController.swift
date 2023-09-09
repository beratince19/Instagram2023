//
//  ViewController.swift
//  Instagram2023
//
//  Created by Berat Tugay İnce on 6.09.2023.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextField! {
        didSet {
            self.nameText.autocorrectionType = .no
        }
    }
    
    @IBOutlet weak var passwordText: UITextField!
    
    private let imageViewBackground: UIImageView = {
        let view = UIImageView(image: UIImage(named: "instagram"))
        view.contentMode = .bottom
        view.alpha = 0.7
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.insertSubview(imageViewBackground, at: 0)
        
    }
    
    

    @IBAction func sıgnInClicked(_ sender: Any) {
        guard let name = nameText.text , let password = passwordText.text else {
            self.makeAlert(titleInput: "Error", messageInput: "name and password null")
            return
        }
        
        Auth.auth().signIn(withEmail: name, password: password){ (authdata, error) in
            guard error == nil else {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                return
            }
            self.performSegue(withIdentifier: "toFeedVC", sender: nil)
        }
    }
    
    @IBAction func sıgnUpClicked(_ sender: Any) {
        if nameText.text != nil && passwordText.text != nil {
            Auth.auth().signIn(withEmail: nameText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                } else {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
            }
        }
        else {
            self.performSegue(withIdentifier: "toFeedVC", sender: nil)
        }
        
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
}

