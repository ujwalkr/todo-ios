//
//  ProfileViewController.swift
//  Todo List
//
//  Created by Admin on 08/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

enum ProfileSection: Int {
    case personaInfo
    case professionalInfo
    
    var sectionTitle: String {
        switch self {
        case .personaInfo:
            return "Personal Details"
        case .professionalInfo:
            return "Professional Details"
        }
    }
    
    static let allCases: [ProfileSection] = [.professionalInfo, .personaInfo]
    
}

enum TextFieldTag : Int {
    case firstName = 1
    case lastName = 2
    case email = 3
    case number = 4
    
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func doneAdding(_ sender: UIBarButtonItem) {
        for personalInfo in personalInfos {
            print(personalInfo.fieldText ?? "personal info not set")
        }
        
        for professionalInfo in professionalInfos {
            print(professionalInfo.fieldText ?? "professional info not set")
        }
        presentingViewController?.dismiss(animated: true) ?? self.dismiss(animated: true, completion: nil)
    }
    let cellIdentifier = String(describing: FormTableViewCell.self)
    
    var personalInfos = [ProfileInfo]()
    var professionalInfos = [ProfileInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        
        self.tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        createProfileInfo()
    }
    
    private func createProfileInfo() {
        let profileFirstName = ProfileInfo(fieldHint: "FirstName", fieldText: "", tag: TextFieldTag.firstName.rawValue)
        let profileLastName = ProfileInfo(fieldHint: "LastName", fieldText: "", tag: TextFieldTag.lastName.rawValue)
        let profileEmail = ProfileInfo(fieldHint: "Email", fieldText: "", tag: TextFieldTag.email.rawValue)
        let profileNumber = ProfileInfo(fieldHint: "Number", fieldText: "", tag: TextFieldTag.number.rawValue)
        
        self.personalInfos += [profileFirstName,profileLastName]
        self.professionalInfos += [profileEmail,profileNumber]
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProfileSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = ProfileSection(rawValue: section)!
        switch currentSection {
        case .personaInfo:
            return 2
        case .professionalInfo:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let formCell = cell as? FormTableViewCell {
            let currentSection = ProfileSection(rawValue: indexPath.section)!
            
            switch currentSection {
            case .personaInfo:
                formCell.personalInfo = personalInfos[indexPath.row]
//                formCell.formText.placeholder = personalInfos[indexPath.row].fieldHint
            case .professionalInfo:
                formCell.professionalInfo = professionalInfos[indexPath.row]
//                formCell.formText.placeholder = professionalInfos[indexPath.row].fieldHint
            }
        }
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currentSection = ProfileSection(rawValue: section)
        return currentSection?.sectionTitle
    }
}

extension ProfileViewController: UITextFieldDelegate {
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let tag = textField.tag
//        switch tag {
//        case TextFieldTag.firstName.rawValue:
//            personalInfos[0].fieldText = textField.text ?? ""
//        case TextFieldTag.lastName.rawValue:
//            personalInfos[1].fieldText = textField.text ?? ""
//        case TextFieldTag.email.rawValue:
//            professionalInfos[0].fieldText = textField.text ?? ""
//        case TextFieldTag.number.rawValue:
//            if let size = textField.text, size.count >= 10 {
//                textField.isEnabled = false
//            }else{
//                textField.isEnabled = true
//            }
//            personalInfos[0].fieldText = textField.text ?? ""
//        default:
//            print("nn")
//        }
//
//    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        <#code#>
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
//        let tag = textField.tag
//        switch tag {
//        case TextFieldTag.firstName.rawValue:
//            personalInfos[0].fieldText = textField.text ?? ""
//        case TextFieldTag.lastName.rawValue:
//            personalInfos[1].fieldText = textField.text ?? ""
//        case TextFieldTag.email.rawValue:
//            professionalInfos[0].fieldText = textField.text ?? ""
//        case TextFieldTag.number.rawValue:
//            if let size = textField.text, size.count >= 10 {
//                textField.isEnabled = false
//            }else{
//                textField.isEnabled = true
//            }
//            personalInfos[0].fieldText = textField.text ?? ""
//        default:
//            print("nn")
//        }
//    }
}

class ProfileInfo {
    var fieldHint: String?
    var fieldText: String?
    var tag: Int?
    
    init(fieldHint: String, fieldText: String, tag: Int) {
        self.fieldHint = fieldHint
        self.fieldText = fieldText
        self.tag = tag
    }
}
