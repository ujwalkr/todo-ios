//
//  Attachment+Extension.swift
//  Todo List
//
//  Created by Admin on 05/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import CoreData

extension Attachments {
    
    static func createEntity(json: JSON, context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext) -> Attachments {
        
        let attachment = Attachments(context: context)
        attachment.fileName = json["fileName"] as? String
        attachment.id = json["id"] as? String ?? UUID().uuidString
        return attachment
    }
    
    static func createEntity(photo: Photo, context: NSManagedObjectContext) -> Attachments {
        let attachment = Attachments(context: context)
        attachment.fileName = photo.fileName
        attachment.id = photo.id
        return attachment
    }
}

extension Attachments {
    
    func toJSON() -> JSON  {
        var json = JSON()
        json["fileName"] = fileName
        json["id"] = id
        return json
    }
}
