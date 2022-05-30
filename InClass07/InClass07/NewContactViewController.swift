//
//  NewContactViewController.swift
//  InClass07
//
//  Created by Evans, Jonathan on 4/29/19.
//  Copyright © 2019 Evans, Jonathan. All rights reserved.
//

import UIKit
import Alamofire

class NewContactViewController: UIViewController {
    
    
    @IBOutlet weak var NameTextField: UITextField!
    
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    
    @IBOutlet weak var PhoneNumberTextField: UITextField!
    
    
    @IBOutlet weak var PhoneTypeSegmentedControlOutlet: UISegmentedControl!
    
    var phoneType = "Cell"
    
    var idArray = [Int]()
    var id = 0
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        while(idArray.contains(id) == true){
            id += 1
        }
        
        idArray.append(id)
    }
    

   
    @IBAction func SubmitButton(_ sender: Any) {
        if NameTextField.text == ""{
            let wrongTypeAlert = UIAlertController(title: "Format Error", message: "You Must Enter Text In Every Field", preferredStyle: .alert)
            
            wrongTypeAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                //print("The \"OK\" alert occured.")
            }))
            
            self.present(wrongTypeAlert, animated: true, completion: nil)
        }
            
        else if EmailTextField.text == ""{
            let wrongTypeAlert = UIAlertController(title: "Format Error", message: "You Must Enter Text In Every Field", preferredStyle: .alert)
            
            wrongTypeAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                //print("The \"OK\" alert occured.")
            }))
            
            self.present(wrongTypeAlert, animated: true, completion: nil)
        }
            
        else if PhoneNumberTextField.text == ""{
            let wrongTypeAlert = UIAlertController(title: "Format Error", message: "You Must Enter Text In Every Field", preferredStyle: .alert)
            
            wrongTypeAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                //print("The \"OK\" alert occured.")
            }))
            
            self.present(wrongTypeAlert, animated: true, completion: nil)
        }
            
        else{
            
            
        
        let parameters = [
                          "name": NameTextField.text!,
                          "email": EmailTextField.text!,
                          "phone": PhoneNumberTextField.text!,
                          "type": phoneType]
            user?.id = id
            user?.name = NameTextField.text!
            user?.email = EmailTextField.text!
            user?.phoneNumber = PhoneNumberTextField.text!
            user?.phoneLocation = phoneType
        NotificationCenter.default.post(name: NSNotification.Name("AddContact"), object: user)
        
        
       AF.request("http://ec2-18-234-222-229.compute-1.amazonaws.com/contact/create", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseString{ (response) in
            
            if response.result.isSuccess{
                
                print("success connected to create")
                //print(response.result.value!)
                
                print("We hit here after saying dismiss")
            }
            else {
                print ("error")
            }
        }
        
        }
    }
    
    
    
    @IBAction func SegmentedControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            phoneType = "CELL"
        }
        
        else if sender.selectedSegmentIndex == 1{
            phoneType = "HOME"
        }
        
        else if sender.selectedSegmentIndex == 2{
            phoneType = "OFFICE"
        }
    }
    
    

}
