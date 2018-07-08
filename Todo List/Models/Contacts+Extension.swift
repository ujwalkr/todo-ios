//
//  Contacts+Extension.swift
//  Todo List
//
//  Created by Admin on 05/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import CoreData
import Contacts

typealias JSON = [String: Any]


extension Contacts {
    
    static func createEntity(json: JSON, context: NSManagedObjectContext) -> Contacts {
        
        let contact = Contacts(context: context)
        contact.firstName = json["firstName"] as? String
        contact.lastName = json["lastName"] as? String
        contact.phoneNumber = json["phoneNumber"] as? String
        contact.id = json["id"] as? String ?? UUID().uuidString
        return contact
    }
    
    static func createEntity(contact: Contacts, context: NSManagedObjectContext) -> Contacts{
        let cont = Contacts(context: context)
        cont.firstName = contact.firstName
        cont.lastName = contact.lastName
        cont.phoneNumber = contact.phoneNumber
        cont.id = contact.id
        return contact
    }
    
    static func createEntity(phoneContact: CNContact, context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext) -> Contacts {
        
        let contact = Contacts(context: context)
        contact.firstName = phoneContact.givenName
        contact.lastName = phoneContact.familyName
        contact.phoneNumber = phoneContact.formattedPhoneNumber?.first
        contact.id = phoneContact.identifier
        return contact
    }
}

// MARK: - Payload Methods

extension Contacts {
    
    func toJSON() -> JSON  {
        var json = JSON()
        json["firstName"] = firstName
        json["lastName"] = lastName
        json["phoneNumber"] = phoneNumber
        json["id"] = id
        return json
    }
}


extension Contacts {
    
    static func fetchContacts() -> [Contacts] {
        
        let fetchRequest: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        do {
            let contacts = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            return contacts
        } catch  {
            print("unable to fecth conatcts \(error.localizedDescription)")
            return []
        }
        
        
    }
}
