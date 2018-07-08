//
//  ToDoTask.swift
//  Todo List
//
//  Created by Admin on 02/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct ToDoTask {
    var title: String
    var detail: String
    var location: String
    var date: String
    
    init(title: String,detail: String,location: String,date: String) {
        self.title = title
        self.detail = detail
        self.location = location
        self.date = date
    }
    
}

extension String {
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd , hh:mm:ss"
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func correctDateFormatt() -> Bool {
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd , hh:mm:ss"
            let _ = dateFormatter.date(from: self)
            return true
        } catch {
            return false
        }
    }
}

extension Date {
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd , hh:mm:ss"
        let date = dateFormatter.string(from: self)
        return date
    }
}
