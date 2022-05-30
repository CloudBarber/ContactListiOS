//
//  ContactsListViewController.swift
//  InClass07
//
//  Created by Evans, Jonathan on 4/29/19.
//  Copyright © 2019 Evans, Jonathan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ContactsListViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var contactsArray = [User]()
    
    var user: User?
    var idArray = [Int]()
    var thisindexPath: Int?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(onRecieveNotification(notification:)), name: NSNotification.Name("AddContact"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onRecieveDeleteNotification(notification:)), name: NSNotification.Name("DeleteContact"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onRecievePassNotification(notification:)), name: NSNotification.Name("PassContact"), object: nil)
        
        let cellNib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "CustomCell")
        
        AF.request("http://ec2-18-234-222-229.compute-1.amazonaws.com/contacts").responseString{ (response) in
            
            if response.result.isSuccess{
                print("success contacts was called")
                if let string = response.result.value {
                    self.contactsArray.removeAll()
                    let lines = string.split(separator: "\n")
                    for line in lines{
                        let thisUser = User()
                        
                        let items = line.split(separator: ",")
                        let ids = Int(items[0])
                        let names = String(items[1])
                        let emails = String(items[2])
                        let phoneNumbers = String(items[3])
                        let phoneTypes = String(items[4])
                        print("We are printing the users in the Contacts list View")
                        print(ids!)
                        print(names)
                        thisUser.id = ids
                        thisUser.name = names
                        thisUser.email = emails
                        thisUser.phoneNumber = phoneNumbers
                        thisUser.phoneLocation = phoneTypes
                        self.contactsArray.append(thisUser)
                        self.idArray.append(ids!)
                    
                       
                    }
                    
                    self.tableView.reloadData()
                    print("here")
                    print("contacts array has in viewDidLoad \(self.contactsArray.count)")
                }
                
            }
               
            else {
                print ("error")
            }
            
            
        }
        
        
        
        
        
        
        
       
    }
    
   
    
    @IBAction func myUnwindFunction(unwindSegue: UIStoryboardSegue){
        print("Unwind Segue Called")
       
            
        }
    
    
    @IBAction func DeleteButton(_ sender: Any) {
       
      
    }
    
    @objc func onRecieveNotification(notification: Notification){
        
        viewDidLoad()
    }
    
    @objc func onRecieveDeleteNotification(notification: Notification){
       
        contactsArray.remove(at: thisindexPath!)
        tableView.reloadData()
    }
    
    @objc func onRecievePassNotification(notification: Notification){
        user = (notification.object as! User)
        viewDidLoad()
        tableView.reloadData()
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any? ) {
        print("prepare for segue called !!")
        
        if segue.identifier == "ToDetails"{
            print("going to the details page")
            let indexPath = self.tableView.indexPathForSelectedRow
            let destinationVC = segue.destination as! DetailsViewController
            var thisUser = User()
            thisUser = contactsArray[indexPath!.row]
            destinationVC.user = thisUser
            destinationVC.idArray = idArray
        }
        
        if segue.identifier == "ToNewContact"{
            let destinationVC = segue.destination as! NewContactViewController
            destinationVC.idArray = idArray
        }
    }
    
    
    
    

}

extension ContactsListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contactsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        //let nameLabel = cell.viewWithTag(100) as! UILabel
        //let emailLabel = cell.viewWithTag(200) as! UILabel
        //let phoneNumberLabel = cell.viewWithTag(300) as! UILabel
        //let phoneTypeLabel = cell.viewWithTag(400) as! UILabel
        
       
        
        cell.delegate = self
        
        //nameLabel.text = contactsArray[indexPath.row].name
        //emailLabel.text = contactsArray[indexPath.row].email
        //phoneNumberLabel.text = contactsArray[indexPath.row].phoneNumber
        //phoneTypeLabel.text = contactsArray[indexPath.row].phoneLocation
        
        cell.NameLabel.text = contactsArray[indexPath.row].name
        cell.EmailLabel.text = contactsArray[indexPath.row].email
        cell.PhoneNumberLabel.text = contactsArray[indexPath.row].phoneNumber
        cell.PhoneTypeLabel.text = contactsArray[indexPath.row].phoneLocation
        
        return cell
    }
    
    
}


extension ContactsListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ToDetails", sender: self)
        thisindexPath = indexPath.row
        
    }
}


extension ContactsListViewController: CustomTVCellDelegate{
    func DeleteClicked(cell: UITableViewCell) {
       
       print("Delete button registered")
        let indexPath = self.tableView.indexPath(for: cell)
        thisindexPath = indexPath!.row
        //print("Delete button registered at \(indexPath?.row)")
        let parameter = ["id": contactsArray[indexPath!.row].id]
        AF.request("http://ec2-18-234-222-229.compute-1.amazonaws.com/contact/delete", method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseString{ (response) in
            
            if response.result.isSuccess{
                NotificationCenter.default.post(name: NSNotification.Name("DeleteContact"), object: self.user)
                print("success connected to create")
                //print(response.result.value!)
                
                
                
            }
                
                
            else {
                print ("error")
            }
            
        }
        
    }
    
    
}
