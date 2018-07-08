//
//  AttachmentCollectionViewCell.swift
//  Todo List
//
//  Created by Admin on 06/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class AttachmentCollectionViewCell: UICollectionViewCell {
    
    enum AttachmentType {
        case add
        case image
    }
    
    @IBOutlet weak var attachmentImage: UIImageView!
    
    public var photo: Photo? {
        didSet {
            self.updateUI()
        }
    }
    var attachmentType: AttachmentType = .add {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI() {
        
        switch attachmentType {
        case .add:
            self.attachmentImage.image = #imageLiteral(resourceName: "plus")
        case .image:
            if let url = photo?.imageUrl {
                print("image URL: \(url.absoluteString)")
                displayImageFromUrl(url: url)
                //            self.attachmentImage.image = photo?.image
            }
        }
    }
    
    private func displayImageFromUrl(url: URL) {
        if let image = UIImage(contentsOfFile: url.path) {
            self.attachmentImage.image = image
            print("read from storage success")
        }else{
            print("failed to get image from url")
        }
    }
}
