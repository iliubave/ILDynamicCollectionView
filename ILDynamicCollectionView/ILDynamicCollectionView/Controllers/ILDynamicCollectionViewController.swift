//
//  ILDynamicCollectionViewController.swift
//  ILDynamicCollectionView
//
//  Created by Igar Liubavetskiy on 2017-08-25.
//  Copyright © 2017 Igar Liubavetskiy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PXPhotoCollectionViewCellIdentifier"

class ILDynamicCollectionViewController: UICollectionViewController {

	let imagesCache = NSCache<AnyObject, AnyObject>()
	var dynamicItems: [ILDynamicItem] = []
	var currentPage = 1
    var isFetchingNextPage = true
    var portraitNumberOfColumns = 3
    var landscapeNumberOfColumns = 3

	var sourceIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

		if let layout = self.collectionView?.collectionViewLayout as? ILDynamicLayout {
			layout.delegate = self
		}
    }

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)

		if let layout = self.collectionView?.collectionViewLayout as? ILDynamicLayout {
			layout.numberOfColumns = (size.width < size.height) ? portraitNumberOfColumns : landscapeNumberOfColumns

			layout.invalidateLayout()
		}
	}
}

extension ILDynamicCollectionViewController {

	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.dynamicItems.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ILDynamicCollectionViewCell

		let item = self.dynamicItems[indexPath.item]

		return cell
	}

	// willDisplay couldn't be used due to some inconsistencies
	// with the way cells were getting layed out 
	// (reaching very last indexPath.item could result in having an empty column)
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		var offset:CGFloat = 0
		var sizeLength:CGFloat = 0
		if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
			offset = scrollView.contentOffset.x
			sizeLength = scrollView.contentSize.width - scrollView.frame.size.width
		} else {
			offset = scrollView.contentOffset.y
			sizeLength = scrollView.contentSize.height - scrollView.frame.size.height
		}
	}
}

extension ILDynamicCollectionViewController : ILDynamicLayoutLayoutDelegate {
	func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, with width: CGFloat) -> CGFloat {

		let item = self.dynamicItems[indexPath.item]
//		if let photoWidth = photo.width, let photoHeight = photo.height {
//			let aspectRatio = photoWidth / photoHeight
//
//			if aspectRatio >= 0 {
//				return CGFloat(width / aspectRatio)
//			} else {
//				return CGFloat(width * aspectRatio)
//			}
//		}

		return 0.0
	}
}
