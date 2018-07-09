//
//  FormTableViewCell.swift
//  Todo List
//
//  Created by Admin on 09/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class FormTableViewCell: UITableViewCell {
    
    @IBOutlet weak var formText: UITextField!
    
    var personalInfo: ProfileInfo? {
        didSet{
            formText.tag = (personalInfo?.tag)!
            formText.placeholder = personalInfo?.fieldHint
        }
    }
    var professionalInfo: ProfileInfo? {
        didSet{
            formText.tag = (professionalInfo?.tag)!
            formText.placeholder = professionalInfo?.fieldHint
        }
    }
    
    @IBAction func textChangeInTextField(_ sender: Any) {
        if let textField = sender as? UITextField {
            let tag = textField.tag
            switch tag {
            case TextFieldTag.firstName.rawValue:
                personalInfo?.fieldText = textField.text ?? ""
                print("first name +\(Date().timeIntervalSince1970)")
            case TextFieldTag.lastName.rawValue:
                personalInfo?.fieldText = textField.text ?? ""
                  print("last name +\(Date().timeIntervalSince1970)")
            case TextFieldTag.email.rawValue:
                professionalInfo?.fieldText = textField.text ?? ""
                  print("email +\(Date().timeIntervalSince1970)")
            case TextFieldTag.number.rawValue:
                if let size = textField.text, size.count >= 10 {
                    textField.isEnabled = false
                }else{
                    textField.isEnabled = true
                }
                professionalInfo?.fieldText = textField.text ?? ""
                  print("number +\(Date().timeIntervalSince1970)")
            default:
                print("default ")
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.formText.delegate = self
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension FormTableViewCell : UITextFieldDelegate {
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        let tag = textField.tag
    //        switch tag {
    //        case TextFieldTag.firstName.rawValue:
    //            personalInfo?.fieldText = textField.text ?? ""
    //        case TextFieldTag.lastName.rawValue:
    //            personalInfo?.fieldText = textField.text ?? ""
    //        case TextFieldTag.email.rawValue:
    //            professionalInfo?.fieldText = textField.text ?? ""
    //        case TextFieldTag.number.rawValue:
    //            if let size = textField.text, size.count >= 10 {
    //                textField.isEnabled = false
    //            }else{
    //                textField.isEnabled = true
    //            }
    //            personalInfo?.fieldText = textField.text ?? ""
    //        default:
    //            print("nn")
    //        }
    //    }
    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        let tag = textField.tag
//        switch tag {
//        case TextFieldTag.firstName.rawValue:
//            personalInfo?.fieldText = textField.text ?? ""
//        case TextFieldTag.lastName.rawValue:
//            personalInfo?.fieldText = textField.text ?? ""
//        case TextFieldTag.email.rawValue:
//            professionalInfo?.fieldText = textField.text ?? ""
//        case TextFieldTag.number.rawValue:
//            if let size = textField.text, size.count >= 10 {
//                textField.isEnabled = false
//            }else{
//                textField.isEnabled = true
//            }
//            personalInfo?.fieldText = textField.text ?? ""
//        default:
//            print("nn")
//        }
//    }
    
}
