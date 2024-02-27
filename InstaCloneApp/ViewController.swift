//
//  ViewController.swift
//  InstaCloneApp
//
//  Created by Ali serkan Boyracı  on 10.10.2022.
//

import UIKit
import FirebaseAuth // we must write this

class ViewController: UIViewController {

    @IBOutlet var emailText: UITextField!
    
    @IBOutlet var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" { //150
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in // we use firebase func. here
                if error != nil {
                    self.makeAlert(titleInput: "Error!!!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "ERROR!!!", messageInput: "Username/Password is empty!")
            
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" { //149
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { [self] (authdata, error) in // to creaate a user
                
                if error != nil {
                    self.makeAlert(titleInput: "Error!!!", messageInput: error?.localizedDescription ?? "Error") // to use firebase error message we use localizeddescription
                    
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
                
            }
            
        } else {
            makeAlert(titleInput: "Error!!", messageInput: "Username/Password ???")
            
        }
        
        
    }
    
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

