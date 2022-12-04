//
//  AppealTagCollectionViewCell.swift
//  Task
//
//  Created by trost.jk on 2022/09/18.
//

import UIKit

class AppealTagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var appealTagView: UIView!
    @IBOutlet weak var tagTitle: UILabel!
    
    static let defaultReuseIdentifier = "AppealTagCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        appealTagView.layer.borderWidth = 1
        appealTagView.layer.borderColor = UIColor.Gray03.cgColor
        appealTagView.backgroundColor = .white
    }
    
}


