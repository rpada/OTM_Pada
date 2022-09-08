//
//  AddViewController.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/7/22.
//

import Foundation
import UIKit
import CoreLocation

class AddViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var Location: UITextField!
    @IBOutlet weak var Website: UITextField!
    @IBOutlet weak var Submit: UIButton!
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
  
    
}
