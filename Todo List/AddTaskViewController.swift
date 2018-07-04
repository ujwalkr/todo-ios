//
//  AddTaskViewController.swift
//  Todo List
//
//  Created by Admin on 02/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    weak var delegate: ToDoCellAddTaskDelegate?
    
    var todoTaskCreated: ToDoTask?
    
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDetail: UITextView!
    @IBOutlet weak var taskLocation: UITextField!
    @IBOutlet weak var taskDate: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
   
    @IBAction func cancel(_ sender: UIBarButtonItem) {
       presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
         let taskTitleString = taskTitle.text!
         let taskDetailString = taskDetail.text!
         let taskLocationString = taskLocation.text!
        let taskDateString = taskDate.text!
        
        
        delegate?.didFinishedAdding(ToDoTask(title: taskTitleString, detail: taskDetailString, location: taskLocationString, date: taskDateString))
        presentingViewController?.dismiss(animated: true)
        //     NotificationCenter.default.post(name: NSNotification.Name.init("didFinishedAdding"), object: "")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        updateViews()
        self.navigationItem.title = "Add To-Do"
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        taskDate.inputView = datePicker
        
        datePicker.addTarget(self, action: #selector(datePicKChanged(_:)), for: UIControlEvents.valueChanged)
    }

   
    func updateViews() {
        if taskTitle != nil , taskDetail != nil , taskLocation != nil {
        taskTitle.text = todoTaskCreated?.title ?? ""
        taskDetail.text = todoTaskCreated?.detail ?? ""
        taskLocation.text = todoTaskCreated?.location ?? ""
        taskDate.text = todoTaskCreated?.date ?? ""
              if todoTaskCreated != nil{
            changeLayoutFeatureIfTaskIsAlreadyPresent()
            }
        }
    }
    
    func changeLayoutFeatureIfTaskIsAlreadyPresent(){
        taskTitle.isUserInteractionEnabled = false
        taskDetail.isUserInteractionEnabled = false
        taskLocation.isUserInteractionEnabled = false
        taskDate.isUserInteractionEnabled = false
        
        saveButton.isEnabled = false
        saveButton.tintColor = .clear
    }
    
    @objc func datePicKChanged(_ datePicker: UIDatePicker){
        
        let dateFormatter = DateFormatter()
      //  dateFormatter.dateStyle = .long
     //   dateFormatter.timeStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd , hh:mm:ss"
        let string  = dateFormatter.string(from: datePicker.date)
        
        taskDate.text = string
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

protocol ToDoCellAddTaskDelegate: class {
    func didFinishedAdding(_ todoTask: ToDoTask) -> Void
}
