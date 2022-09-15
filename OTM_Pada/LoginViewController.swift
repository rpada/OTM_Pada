//
//  ViewController.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/2/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Email.delegate = self
        Password.delegate = self
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
// from https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/3283ae8e-5dd5-483b-9c49-2faac7c53276/concepts/126b0978-f775-480a-bac0-68a1396aa81a
    // https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/3283ae8e-5dd5-483b-9c49-2faac7c53276/concepts/6acdc289-de30-4f0e-b408-626668c70629
    func handleRequestTokenResponse(success: Bool, error: Error?){
        if success {
            DispatchQueue.main.async{
            UdacityClient.login(email: self.Email.text ?? "", password: self.Password.text ?? "", completion: self.handleLoginRequest(success:error:))
                print(UdacityClient.Auth.tokenRequest)
        }
        }
    }
       // from https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/3283ae8e-5dd5-483b-9c49-2faac7c53276/concepts/126b0978-f775-480a-bac0-68a1396aa81a
        func handleLoginRequest(success: Bool, error: Error?) {
            if success {
                grabInfo()
                DispatchQueue.main.async { [self] in
                performSegue(withIdentifier: "Submit", sender: nil)
                }
            } else {
                showAlertAction(title:"Error", message: error!.localizedDescription) // error message if your info is wrong
            }
        }

    func grabInfo(){
        UdacityClient.grabUserInfo(completion: { (success, error) in
            if success {
                print("Success")
            } else {
                print("Failure!")
            }
        })
    }
    // from https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/3283ae8e-5dd5-483b-9c49-2faac7c53276/concepts/126b0978-f775-480a-bac0-68a1396aa81a
        // login function
    @IBAction func Submit(_ sender: Any) {
        UdacityClient.login(email: self.Email.text!, password: self.Password.text!, completion: // grabbing fields
            self.handleLoginRequest(success:error:))
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
