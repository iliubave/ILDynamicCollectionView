//
//  ILDynamicCollectionViewCell.swift
//  ILDynamicCollectionView
//
//  Created by Igar Liubavetskiy on 2017-08-25.
//  Copyright © 2017 Igar Liubavetskiy. All rights reserved.
//

import UIKit

class ILDynamicCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var photoImageView: UIImageView!

	override func prepareForReuse() {
		super.prepareForReuse()

		photoImageView.image = nil
	}
}
