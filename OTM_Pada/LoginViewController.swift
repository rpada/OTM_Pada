//
//  ViewController.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/2/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Spinner: UIActivityIndicatorView!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Email.delegate = self
        Password.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Spinner.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {

          super.viewWillDisappear(animated)
          unsubscribeFromKeyboardNotifications()
          // from Udacity iOS Development course, Lesson 4 section 12
      }
    // from https://stackoverflow.com/questions/24195310/how-to-add-an-action-to-a-uialertview-button-using-swift-ios
    
    // stack overflow said to use DispatchQueue: https://stackoverflow.com/questions/58087536/modifications-to-the-layout-engine-must-not-be-performed-from-a-background-thr
        
    func showAlertAction(title: String, message: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                print("Action")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
        
    func handleRequestTokenResponse(success: Bool, error: Error?){
        if success {
            print(UdacityClient.Auth.tokenRequest)
            DispatchQueue.main.async{
            UdacityClient.login(email: self.Email.text ?? "", password: self.Password.text ?? "", completion: self.handleLoginRequest(success:error:))
        }
        }
    }
        
        //MARK:- Handling requests & responses
        func handleLoginRequest(success: Bool, error: Error?) {
            if success {
                DispatchQueue.main.async { [self] in
                print(UdacityClient.Auth.tokenRequest)
                performSegue(withIdentifier: "Submit", sender: nil)
                    self.Spinner.startAnimating()
                }
            } else {
                showAlertAction(title:"Error", message: "Incorrect email or password. Please try again.") // error message if your info is wrong
                DispatchQueue.main.async {
                self.Spinner.stopAnimating()
                }
            }
        }
        // login function
    @IBAction func Submit(_ sender: Any) {
        UdacityClient.login(email: self.Email.text!, password: self.Password.text!, completion: // grabbing fields from the client
            self.handleLoginRequest(success:error:)) // use handleLoginRequest function
    }
    
        // from Udacity iOS Development course, Lesson 4 section 12
         func subscribeToKeyboardNotifications() {
             NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
             NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
         }
         // from Udacity iOS Development course, Lesson 4 section 12
         func unsubscribeFromKeyboardNotifications() {
             NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
             NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
         }
         
         // from https://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift/34637353
         // and help from Udacity iOS Development course, Lesson 4 section 13
             @objc func keyboardWillHide(_ notification:Notification){
                 view.frame.origin.y = 0
             }
         // from Udacity iOS Development course, Lesson 4 section 12
         @objc func keyboardWillShow(_ notification:Notification) {
             if Password.isEditing {
                 view.frame.origin.y -= getKeyboardHeight(notification)
             }
         }
         // from Udacity iOS Development course, Lesson 4 section 12
         func getKeyboardHeight(_ notification:Notification) -> CGFloat {
             let userInfo = notification.userInfo
             let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
             return keyboardSize.cgRectValue.height
         }
         

        
}
