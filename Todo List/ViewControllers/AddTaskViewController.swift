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
    var flowLayout: UICollectionViewFlowLayout {
        return self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    
    var todo: Todo?
    
    let datePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    var contacts =  [Contacts]()
    var imageViewSelectedForImage: UIImageView?
    private var photos: [Photo] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    public var maximumAttachment: Int = 10
    
    
    //    MARK: - Outlets and Actions
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDetail: UITextView!
    @IBOutlet weak var taskLocation: UITextField!
    @IBOutlet weak var taskDate: UITextField!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contactsButton: UIButton!
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        let taskTitleString = taskTitle.text!
        let taskDetailString = taskDetail.text!
        let taskLocationString = taskLocation.text!
        let taskDateString = taskDate.text!
        
        let todoTask = ToDoTask(title: taskTitleString, detail: taskDetailString, location: taskLocationString, date: taskDateString)
        
        let checkOk = checkAllFieldsForEmptyOrError(todo: todoTask)
        if checkOk {
            updateDatabase(with: todoTask)
            presentingViewController?.dismiss(animated: true)
        }
    }
    
    private func updateDatabase(with todoTask: ToDoTask){
        container?.performBackgroundTask{[unowned self] context in
            let todo = Todo.createTodoTask(with: todoTask, in: context)
            do {
                for contact in (self.contacts) {
                    let objectId = contact.objectID
                    guard let mutableContact = context.object(with: objectId) as? Contacts  else {
                        continue
                    }
                    todo.addToContacts(mutableContact)
                }
                
                for photo in self.photos {
                    let attachment = Attachments.createEntity(photo: photo, context: context)
                    todo.addToAttachements(attachment)
                }
                
                
                try context.save()
                print("todo task saved")
            } catch {
                print("todo task eror\(error.localizedDescription)")
            }
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
        imagePicker.delegate = self
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
    
    
    
    private func updateViews() {
        if taskTitle != nil , taskDetail != nil , taskLocation != nil {
            taskTitle.text = todo?.title ?? ""
            taskDetail.text = todo?.detail ?? ""
            taskLocation.text = todo?.location ?? ""
            taskDate.text = todo?.date?.convertToString() ?? ""
            
            if let attachments = todo?.attachements?.allObjects as? [Attachments] {
                var photosArray = [Photo]()
                for attachment in attachments {
                    let photo = Photo(id: attachment.id!, fileName: attachment.fileName!)
                    photosArray.append(photo)
                }
                photos.append(contentsOf: photosArray) // += photosArray
            }
            if todo != nil{
                changeLayoutFeatureIfTaskIsAlreadyPresent()
            }
        }
    }
    
    private func checkAllFieldsForEmptyOrError(todo: ToDoTask) -> Bool {
        if todo.title.isEmpty {
            showAlert(title: "Title Empty", message: "Please enter the title it cannot be empty!")
            return false
        }else if todo.detail.isEmpty {
            showAlert(title: "Detail Empty", message: "Please enter details about the todo!")
            return false
        }else if todo.location.isEmpty {
            showAlert(title: "Location Empty", message: "Please enter location!")
            return false
        }else if todo.date.isEmpty || !todo.date.correctDateFormatt(){
            showAlert(title: "Date and Time Error", message: "Either the date field is empty or the date formatt is compromized!")
            return false
        }
        
        return true
    }
    
    private func showAlert(title: String,message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
            switch action.style {
            case .default:
                alert.dismiss(animated: true, completion: nil)
            case .cancel:
                alert.dismiss(animated: true, completion: nil)
            case .destructive:
                alert.dismiss(animated: true, completion: nil)
            }
        }))
        present(alert,animated: true,completion: nil)
        
        
    }
    
    private func changeLayoutFeatureIfTaskIsAlreadyPresent(){
        taskTitle.isUserInteractionEnabled = false
        taskDetail.isUserInteractionEnabled = false
        taskLocation.isUserInteractionEnabled = false
        taskDate.isUserInteractionEnabled = false
        
        saveButton.isEnabled = false
        saveButton.tintColor = .clear
        
        contactsButton.setTitle("View Contacts", for: .normal)
        
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
    
    
    // MARK: - segue to contactScreen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selcetContacts" {
            if let nc = segue.destination as? UINavigationController, let cvc = nc.topViewController as? ContactsViewController {
                cvc.delegate = self
                cvc.todo = self.todo
            }
        }
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


extension AddTaskViewController: UICollectionViewDataSource {
    //    MARK: - Collection view data source extension
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.photos.count != self.maximumAttachment else {
            return self.photos.count
        }
        return self.photos.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attachment", for: indexPath) as! AttachmentCollectionViewCell
        
        if self.photos.count == 0 || indexPath.row == self.photos.count {
            
            cell.attachmentType = .add
            
        } else {
            cell.attachmentType = .image
            let photo = self.photos[indexPath.row]
            cell.photo = photo
            
        }
        
        //        if self.photos.count != 0, indexPath.row > 0 {
        //
        //            if self.photos.count == self.maximumAttachment {
        //                cell.photo = self.photos[indexPath.row - 1]
        //            } else {
        //                let previousPath = IndexPath(row: (indexPath.row - 1), section: indexPath.section)
        //                let previousCell = collectionView.cellForItem(at: previousPath) as! AttachmentCollectionViewCell
        //                previousCell.photo = photos[indexPath.row - 1]
        //            }
        //
        //
        //        }
        
        return cell
    }
}

extension AddTaskViewController: UICollectionViewDelegate {
    //    MARK: - Collection view deligate extension
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let imageCell = cell as? AttachmentCollectionViewCell
        imageViewSelectedForImage = (imageCell?.attachmentImage)!
        print("Item in collection view cell selected \(indexPath.row)")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension AddTaskViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("image selected \(pickedImage)")
            let id = UUID().uuidString
            self.saveImageInDocument(image: pickedImage, fileName: id)
            let photo = Photo(id: id,fileName: id)
            self.photos.append(photo)
        }
    }
    
    private func saveImageInDocument(image: UIImage, fileName: String, withExtension fileExtension: String = ".png") {
        let formattedFileName = fileName + fileExtension
        let imageData = UIImagePNGRepresentation(image)
        var documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        documentURL.appendPathComponent(formattedFileName)
        do {
            try imageData?.write(to: documentURL)
            print("write to storage success")
        } catch {
            print("write error \(error.localizedDescription)")
        }
    }
}

extension AddTaskViewController: TodoTaskContactsDelegate {
    func finishedAddingContacts(_ contacts: [Contacts]) {
        self.contacts = contacts
    }
}

extension AddTaskViewController: UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let spacing = self.flowLayout.minimumInteritemSpacing
         let width = (collectionView.frame.size.width / 4) - spacing
        let size = CGSize(width: width, height: width)
        return size
    }
}


struct Photo {
    let id: String
    var imageUrl: URL {
        get {
            let formattedFileName = self.fileName + ".png"
            var documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
            documentURL.appendPathComponent(formattedFileName)
            return documentURL
        }
    }
    var fileName: String
}
