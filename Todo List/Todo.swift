//
//  Todo.swift
//  TodoList
//
//  Created by Admin on 05/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreData

class Todo: NSManagedObject {

    class func createTodoTask(with todoTask: ToDoTask, in context: NSManagedObjectContext) -> Todo {
        
        
        let todo = Todo(context: context)
        todo.active = true
        todo.title = todoTask.title
        todo.detail = todoTask.detail
        todo.location = todoTask.location
        todo.date = todoTask.date.convertToDate()
        
        return todo
    }
}
