//
//  ILDynamicCollectionViewCell.swift
//  ILDynamicCollectionViewController
//
//  Created by Igar Liubavetskiy on 2017-07-30.
//  Copyright © 2017 Igar Liubavetskiy. All rights reserved.
//

import UIKit

class ILDynamicCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "ILDynamicCollectionViewCell"
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.containerView.backgroundColor = nil
    }

}
