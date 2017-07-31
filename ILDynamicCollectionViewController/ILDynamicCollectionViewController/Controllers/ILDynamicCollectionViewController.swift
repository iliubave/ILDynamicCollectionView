//
//  ILDynamicCollectionViewController.swift
//  ILDynamicCollectionViewController
//
//  Created by Igar Liubavetskiy on 2017-08-25.
//  Copyright © 2017 Igar Liubavetskiy. All rights reserved.
//

import UIKit

class ILDynamicCollectionViewController: UICollectionViewController {

	let imagesCache = NSCache<AnyObject, AnyObject>()
	var dynamicItems: [ILDynamicItem] = []
	var currentPage = 1
    var isFetchingNextPage = true
    
    // customizables
    var portraitNumberOfColumns = 3
    var landscapeNumberOfColumns = 5
    
    private func prepareDemoContent() {
        for _ in 0...500 {
            let item = ILDynamicItem()
            
            // demo size ranges
            let width = CGFloat(Int.random(from: 50, to: 200))
            let height = CGFloat(Int.random(from: 50, to: 200))
            
            item.contentSize = CGSize(width: width, height: height)
            
            self.dynamicItems.append(item)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareDemoContent()

		if let layout = self.collectionView?.collectionViewLayout as? ILDynamicLayout {
			layout.delegate = self
		}
        
        let nib = UINib(nibName: "ILDynamicCollectionViewCell", bundle: nil)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: ILDynamicCollectionViewCell.reuseIdentifier)
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
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ILDynamicCollectionViewCell.reuseIdentifier, for: indexPath) as! ILDynamicCollectionViewCell

        cell.containerView.backgroundColor = UIColor.random()
        
		return cell
	}

	// willDisplay cannot be used due to some inconsistencies
	// reaching very last indexPath.item could result in having an empty column
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		var offset: CGFloat = 0
		var sizeLength: CGFloat = 0
		if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
			offset = scrollView.contentOffset.x
			sizeLength = scrollView.contentSize.width - scrollView.frame.size.width
		} else {
			offset = scrollView.contentOffset.y
			sizeLength = scrollView.contentSize.height - scrollView.frame.size.height
		}
        
        
        // TODO: pagination logic
        if offset >= sizeLength && !self.isFetchingNextPage {
            
        }
	}
}

extension ILDynamicCollectionViewController : ILDynamicLayoutLayoutDelegate {
	func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, with width: CGFloat) -> CGFloat {

		let item = self.dynamicItems[indexPath.item]
        let size = item.contentSize
        
		if let width = size?.width, let height = size?.height {
			let aspectRatio = width / height

			if aspectRatio >= 0 {
				return CGFloat(width / aspectRatio)
			} else {
				return CGFloat(width * aspectRatio)
			}
		}

		return 0.0
	}
}
