//
//  AddTaskViewController.swift
//  Todo List
//
//  Created by Admin on 02/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate{
    
    weak var delegate: ToDoCellAddTaskDelegate?
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    
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
        
        let todoTask = ToDoTask(title: taskTitleString, detail: taskDetailString, location: taskLocationString, date: taskDateString)
        updateDatabase(with: todoTask)
        
//        delegate?.didFinishedAdding(ToDoTask(title: taskTitleString, detail: taskDetailString, location: taskLocationString, date: taskDateString))
        presentingViewController?.dismiss(animated: true)
        //     NotificationCenter.default.post(name: NSNotification.Name.init("didFinishedAdding"), object: "")
    }
    
    private func updateDatabase(with todoTask: ToDoTask){
        container?.performBackgroundTask{ context in
            _ = Todo.createTodoTask(with: todoTask, in: context)
            try? context.save()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        updateViews()
        self.navigationItem.title = "Add To-Do"
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        taskDate.inputView = datePicker
        taskDate.inputAccessoryView = UIToolbar().ToolbarPicker(select: #selector(dismissPicker))
        
        datePicker.addTarget(self, action: #selector(datePicKChanged(_:)), for: UIControlEvents.valueChanged)
    }


//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let nextTag = textField.tag + 1
//
//        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
//            nextResponder.becomeFirstResponder()
//        } else {
//            textField.resignFirstResponder()
//        }
//
//        return true
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == taskTitle {
            textField.resignFirstResponder()
            taskDetail.becomeFirstResponder()
        }else if textField == taskLocation {
            textField.resignFirstResponder()
            taskDate.becomeFirstResponder()
        }else if textField == taskDate {
            textField.resignFirstResponder()
        }
        return true
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
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
}

protocol ToDoCellAddTaskDelegate: class {
    func didFinishedAdding(_ todoTask: ToDoTask) -> Void
}

extension UIToolbar {
    func ToolbarPicker(select: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = .black
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: select)
        toolbar.setItems([doneBtn], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
}
