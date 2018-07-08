//
//  ContactsViewController.swift
//  Todo List
//
//  Created by Admin on 05/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func saveContacts(_ sender: UIBarButtonItem) {
        delegate?.finishedAddingContacts(selectedContacts)
        self.dismiss(animated: true)
    }
    weak var delegate: TodoTaskContactsDelegate?
    
    var todo: Todo?
    
    private var contactList: [Contacts] {
        get {
            if todo == nil {
                return Contacts.fetchContacts()
            }else{
                return todo?.contacts?.allObjects as! [Contacts]
            }
        }
    }
    
    private var selectedContacts = [Contacts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.allowsMultipleSelection = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let currentContact = self.contactList[indexPath.row]
        cell.textLabel?.text = currentContact.firstName
        cell.detailTextLabel?.text = currentContact.phoneNumber
        if self.selectedContacts.contains(currentContact) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
        
    }
}

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedContact = self.contactList[indexPath.row]
        if self.selectedContacts.contains(selectedContact) {
            guard let index = self.selectedContacts.index(of: selectedContact) else {
                return
            }
            self.selectedContacts.remove(at: index)
        } else {
            self.selectedContacts.append(selectedContact)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

protocol TodoTaskContactsDelegate: class {
    func finishedAddingContacts(_ contacts: [Contacts]) -> Void
}
