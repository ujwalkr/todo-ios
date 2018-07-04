//
//  ToDoTableViewCell.swift
//  Todo List
//
//  Created by Admin on 03/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var location: UILabel!
    
    var todoTask: ToDoTask? {
        didSet {
            title.text = self.todoTask?.title
            date.text = self.todoTask?.date
            location.text = self.todoTask?.location
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
