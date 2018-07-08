//
//  ViewController.swift
//  Todo List
//
//  Created by Admin on 02/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class MainViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate, ToDoCellAddTaskDelegate{
    
    
    //    ToDoCellAddTaskDelegate
        func didFinishedAdding(_ todoTask: ToDoTask) {
            //todoTasks += [todoTask]
            
            tableView.reloadData()
            updateUI()
        }
    
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
        didSet{
            updateUI()
        }
    }
    
    var fetchedResultController: NSFetchedResultsController<Todo>?
    
    func updateUI(){
       if let context = container?.viewContext {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title",ascending: true)]
        request.predicate = NSPredicate(format: "active == %@", NSNumber(value: true))
        
        fetchedResultController = NSFetchedResultsController<Todo>(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        try? fetchedResultController?.performFetch()
        tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "To-Do List"
      //  fetchedResultController?.delegate = self
        self.updateUI()
       
    }
    
    
    // MARK: - TableView
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            fetchedResultController?.delegate = nil
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
                if let todo = sender as? Todo {
//                    let todoTask = ToDoTask(title: todo.title!, detail: todo.detail!, location: todo.location!, date: todo.date!.convertToString())
                    topVc.todo = todo
                    print("task sent")
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController?.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultController?.sections, sections.count > 0{
            return sections[section].numberOfObjects
        }else {
            self.tableView.setEmptyMessage("No ToDo tasks\nadded!")
            return 0
        }
        
        //        if todoTasks.count == 0{
        //            self.tableView.setEmptyMessage("No ToDo tasks\nadded!")
        //        }else{
        //            self.tableView.restore()
        //        }
        //        return todoTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todocell", for: indexPath)
        if let taskCell = cell  as? ToDoTableViewCell {
            
            if let todo = fetchedResultController?.object(at: indexPath) {
                //        let todoTask = todoTasks[indexPath.row]
                let todoTask = ToDoTask(title: todo.title!, detail: todo.detail!, location: todo.location!, date: todo.date!.convertToString())
                taskCell.todoTask = todoTask
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let vw = UILabel()
            vw.text = "Section 0"
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
            performSegue(withIdentifier: "DisplayTask", sender: fetchedResultController?.object(at: indexPath))
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    //    MARK: - NSFetchResultController
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type{
        case .insert: tableView.insertSections([sectionIndex], with: .fade)
        case .delete: tableView.deleteSections([sectionIndex], with: .fade)
        default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [indexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension MainViewController {
    
    @IBAction func profileButtonAction(sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        self.present(profileViewController, animated: true, completion: nil)
        
        
    }
}

extension UITableView {
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

