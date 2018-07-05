//
//  TweetViewController.swift
//  Todo List
//
//  Created by Admin on 05/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreData

class TweetViewController: MainViewController {
    
   override func didFinishedAdding(_ todoTask: ToDoTask) {
        super.didFinishedAdding(todoTask)
        updateDatabase(with: todoTask)
    }
    
    private func updateDatabase(with todoTask: ToDoTask){
        container?.performBackgroundTask{ [weak self] context in
        _ = Todo.createTodoTask(with: todoTask, in: context)
            try? context.save()
            self?.printDB()
        }
    }
    
    private func printDB(){
        if let context = container?.viewContext{
            context.perform {
                if let todoCount = try? context.count(for: Todo.fetchRequest()){
                    print("\(todoCount) in list")
                }
            }
        }
    }
}
