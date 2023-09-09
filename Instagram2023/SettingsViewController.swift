//
//  SettingsViewController.swift
//  Instagram2023
//
//  Created by Berat Tugay İnce on 7.09.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

  
    @IBAction func logoutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toFirstViewController", sender: nil)
        }catch {
            print("Error")
        }
        
        
    }
    
    
}
