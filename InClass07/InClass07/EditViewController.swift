//
//  EditViewController.swift
//  InClass07
//
//  Created by Evans, Jonathan on 4/29/19.
//  Copyright © 2019 Evans, Jonathan. All rights reserved.
//

import UIKit
import Alamofire

class EditViewController: UIViewController {
    
    
    @IBOutlet weak var NameTextField: UITextField!
    
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PhoneNumberTextField: UITextField!
    
    
    @IBOutlet weak var PhoneTypeSegmentedControl: UISegmentedControl!
    
    var user: User?
    var idArray = [Int]()
    var phoneType: String?
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneType = user!.phoneLocation
        print()
        print()
        print("We are in the Edit View")
        print(user!.id!)
        print(user!.name!)
        print()
        print()
        print()
        id = user!.id!
        print(id)
        // Do any additional setup after loading the view.
        
        NameTextField.text = user!.name
        EmailTextField.text = user!.email
        PhoneNumberTextField.text = user!.phoneNumber
        
        if (user!.phoneLocation == "Cell" || user!.phoneLocation == "CELL"){
            PhoneTypeSegmentedControl.selectedSegmentIndex = 0
        }
        
        else if (user!.phoneLocation == "Home" || user!.phoneLocation == "HOME"){
            PhoneTypeSegmentedControl.selectedSegmentIndex = 1
        }
        
        else if (user!.phoneLocation == "Work" || user!.phoneLocation == "WORK"){
            PhoneTypeSegmentedControl.selectedSegmentIndex = 2
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
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindEdit"{
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.user = user
        }
    }
    

    @IBAction func SubmitButton(_ sender: Any) {
        
        //pass parameters
        print("Pressed submit to update user with id: \(user!.id!)")
        let name = NameTextField.text!
        let email = EmailTextField.text!
        let phone = PhoneNumberTextField.text!
        print("Printing the id number being passed to parameters: \(String(describing: id))")
        let parameters = ["id": id!,
            "name": name,
            "email": email,
            "phone": phone,
            "type": phoneType!] as [String : Any]
        
        
        user!.name = NameTextField.text!
        user!.email = EmailTextField.text!
        user!.phoneNumber = PhoneNumberTextField.text!
        user!.phoneLocation = phoneType
        NotificationCenter.default.post(name: NSNotification.Name("PassContact"), object: user)
        
        
        AF.request("http://ec2-18-234-222-229.compute-1.amazonaws.com/contact/update", method: .post, parameters: parameters as Parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseString{ (response) in
            
            if response.result.isSuccess{
               
                print("success connected to update")
                print(response.result.value!)
                
                
                
            }
                
                
            else {
                print ("error")
            }
            
        }
    }
    
}
