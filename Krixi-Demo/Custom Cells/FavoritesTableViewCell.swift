//
//  FavoritesTableViewCell.swift
//  Krixi-Demo
//
//  Created by Vishal Sonawane on 16/06/17.
//  Copyright © 2017 Vishal Sonawane. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    typealias ShareClickHandler = (_ aCell:FavoritesTableViewCell?) -> (Void)
    var shareClickHandler:ShareClickHandler? = nil
    @IBOutlet weak var pantShirtImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func didTapShareButton(_ sender: Any) {
        if shareClickHandler != nil {
            shareClickHandler!(self)
        }
        
    }
    
}
