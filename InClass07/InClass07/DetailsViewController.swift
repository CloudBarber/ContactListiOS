//
//  DetailsViewController.swift
//  InClass07
//
//  Created by Evans, Jonathan on 4/29/19.
//  Copyright © 2019 Evans, Jonathan. All rights reserved.
//

import UIKit
import Alamofire

class DetailsViewController: UIViewController {
    
    
    @IBOutlet weak var NameLabel: UILabel!
    
    
    @IBOutlet weak var EmailLabel: UILabel!
    
    
    @IBOutlet weak var PhoneNumberLabel: UILabel!
    
    
    @IBOutlet weak var PhoneTypeLabel: UILabel!
    
    var user: User?
    var idArray = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onRecieveNotification(notification:)), name: NSNotification.Name("PassContact"), object: nil)

        // Do any additional setup after loading the view.
        
        NameLabel.text = user!.name
        EmailLabel.text = user!.email
        PhoneNumberLabel.text = user!.phoneNumber
        PhoneTypeLabel.text = user!.phoneLocation
        print("We are printing the user in the Details View")
        print(user!.id!)
        print(user!.name!)
        
    }
    
    @objc func onRecieveNotification(notification: Notification){
        user = (notification.object as! User)
        viewDidLoad()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToEdit"{
            
            
            let destinationVC = segue.destination as! EditViewController
            
            destinationVC.user = user
            destinationVC.idArray = idArray
        }
    }
    
    //really the edit button I'm not changing it now
    @IBAction func SubmitButton(_ sender: Any) {
       
    }
   
    @IBAction func myEditUnwindFunction(unwindSegue: UIStoryboardSegue){
        print("Unwind Segue Called")
         user!.name = NameLabel.text
         user!.email = EmailLabel.text
         user!.phoneNumber = PhoneNumberLabel.text
         user!.phoneLocation = PhoneTypeLabel.text
        NotificationCenter.default.post(name: NSNotification.Name("PassContact"), object: user)
    }
    
    @IBAction func DeleteButton(_ sender: Any) {
        let parameter = ["id": user!.id]
        AF.request("http://ec2-18-234-222-229.compute-1.amazonaws.com/contact/delete", method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseString{ (response) in
            
            if response.result.isSuccess{
                NotificationCenter.default.post(name: NSNotification.Name("DeleteContact"), object: self.user)
                print("success connected to delete")
                //print(response.result.value!)
                self.dismiss(animated: true, completion: nil)
                
                
            }
                
                
            else {
                print ("error")
            }
            
        }
    }
    

}
