//
//  ViewController.swift
//  Todo List
//
//  Created by Admin on 02/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, ToDoCellAddTaskDelegate{
    
    func didFinishedAdding(_ todoTask: ToDoTask) {
        todoTasks += [todoTask]
        tableView.reloadData()
    }
    
    
    var todoTasks = [ToDoTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "To-Do List"
    }

    
    // MARK: - TableView
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTask" {
            if let nc =  segue.destination as? UINavigationController, let topVc = nc.topViewController as? AddTaskViewController{
                topVc.delegate = self
                print("topvs added")
            }
        }else if segue.identifier == "DisplayTask" {
            if let nc =  segue.destination as? UINavigationController, let topVc = nc.topViewController as? AddTaskViewController{
                if let task = sender as? ToDoTask{
                    topVc.todoTaskCreated = task
                     print("task sent")
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todoTasks.count == 0{
            self.tableView.setEmptyMessage("No ToDo tasks\nadded!")
        }else{
            self.tableView.restore()
        }
        return todoTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todocell", for: indexPath)
        if let taskCell = cell  as? ToDoTableViewCell {
        let todoTask = todoTasks[indexPath.row]
        
        taskCell.todoTask = todoTask
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let vw = UILabel()
            vw.text = "Section 1"
            return vw
        }else{
            let vw = UILabel()
            vw.text = "Section 2"
            return vw
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.count > 0 {
             print("prepare segue")
        performSegue(withIdentifier: "DisplayTask", sender: todoTasks[indexPath.row])
        }
    }
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
//    @objc
//    func refresh(notification: Notification) {
//          print(notification.object)
//    }
}
extension UITableView{
    //    MARK: - assign and reset tableView for empty cell
    
    /// set empty message when tableView doesn't have any cell
    func setEmptyMessage(_ message: String){
        let messageLable = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLable.text = message
        messageLable.textColor = .black
        messageLable.numberOfLines = 0
        messageLable.textAlignment = .center
        messageLable.font = UIFont(name: "TrebuchetMS", size: 20)
        messageLable.sizeToFit()
        
        self.backgroundView = messageLable
        self.separatorStyle = .none
    }
    
    func restore(){
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
