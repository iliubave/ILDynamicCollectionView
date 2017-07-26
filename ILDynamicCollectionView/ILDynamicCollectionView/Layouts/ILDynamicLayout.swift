//
//  ILDynamicLayout.swift
//  ILDynamicCollectionView
//
//  Created by Igar Liubavetskiy on 2017-08-25.
//  Copyright © 2017 Igar Liubavetskiy. All rights reserved.
//

import UIKit

protocol ILDynamicLayoutLayoutDelegate {

	// get a height for the photo
	// keeping its aspect ratio and given a column width (in this case item's width)
	func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath,
	                    with width:CGFloat) -> CGFloat
}

class ILDynamicLayoutAttributes: UICollectionViewLayoutAttributes {

	var height: CGFloat = 0.0

	override func copy(with zone: NSZone? = nil) -> Any {
		let copy = super.copy(with: zone) as! ILDynamicLayoutAttributes
		copy.height = height
		return copy
	}

	override func isEqual(_ object: Any?) -> Bool {
		if let attributes = object as? ILDynamicLayoutAttributes {
			if(attributes.height == height) {
				return super.isEqual(object)
			}
		}
		return false
	}
}

class ILDynamicLayout: UICollectionViewLayout {

	var delegate: ILDynamicLayoutLayoutDelegate!

	var numberOfColumns = 2
	var targetIndexPath: IndexPath?

	var attributesCache: [IndexPath: ILDynamicLayoutAttributes] = [:]

	// Custom width and height properties
	var contentHeight: CGFloat  = 0.0
	var contentWidth: CGFloat {
		return collectionView!.bounds.width
	}

	// Cell placement properties
	var column = 0
	var yOffsets: [CGFloat] = []
	var xOffsets: [CGFloat] = []

	override var collectionViewContentSize: CGSize {
		let maxHeight = yOffsets.max()!
		let maxWidth = contentWidth

		return CGSize(width: maxWidth, height: maxHeight)
	}

	override class var layoutAttributesClass: AnyClass {
		return ILDynamicLayoutAttributes.self
	}

	override func prepare() {

		// Reset the properties once the device orientation changes
		if self.numberOfColumns != xOffsets.count {
			self.refreshOffsets()
		}

		// only calculate in case of the initial launch
		// after that the batch updates would trigger layoutAttributesForItem(at indexPath:) in order to
		// generate new attributes for new items
		if attributesCache.isEmpty {

			let columnWidth = contentWidth / CGFloat(numberOfColumns)

			// if it's the inital layout process
			if yOffsets.isEmpty && xOffsets.isEmpty {

				// setup initial x and y offsets
				for column in 0 ..< numberOfColumns {
					xOffsets.append(CGFloat(column) * columnWidth)
					yOffsets.append(0)
				}
			}

			// this loops through all the items in the first section, as this particular
			// layout has only one section
			for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
				let indexPath = IndexPath(item: item, section: 0)
				let attributes = self.prepareAttributes(forElementAtIndexPath: indexPath)
				attributesCache[indexPath as IndexPath] = attributes as! ILDynamicLayoutAttributes?
			}
		}
	}

	// calculate the attributes for the newly added items
	// used when a new page of photos is being addded to the collectionview
	// since layoutAttributesForElements doesn't get triggered
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		guard let cachedAttributes = attributesCache[indexPath] else {
			let attributes = prepareAttributes(forElementAtIndexPath: indexPath)
			attributesCache[indexPath as IndexPath] = attributes as! ILDynamicLayoutAttributes?
			return attributes
		}

		return cachedAttributes
	}

	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var cachedAttributes = [UICollectionViewLayoutAttributes]()
		for (_, attributes) in attributesCache {
			if attributes.frame.intersects(rect) {
				cachedAttributes.append(attributes)
			}
		}
		return cachedAttributes
	}

	private func refreshOffsets() {
		xOffsets.removeAll()
		yOffsets.removeAll()
		column = 0
		attributesCache.removeAll()
	}
}

extension ILDynamicLayout {
	func prepareAttributes(forElementAtIndexPath indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		let columnWidth = (contentWidth) / CGFloat(numberOfColumns)

		// calculate the frame for the cell
		let width = columnWidth
		let height = delegate.collectionView(collectionView: collectionView!, heightForPhotoAtIndexPath: indexPath as NSIndexPath, with: width)

		// setup the frame for the item with respect to the x,y offsets and padding
		let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: width, height: height)

		// This creates an instance of PinterestLayoutAttributes
		let attributes = ILDynamicLayoutAttributes(forCellWith: indexPath as IndexPath)
		attributes.height = height
		attributes.frame = frame

		// increment the content height with respect to the newly added item
		contentHeight = max(contentHeight, frame.origin.y + frame.size.height)

		// increent the yOffset for the next item
		yOffsets[column] = yOffsets[column] + height

		// calculate the column for the next item
		// will be used for calcualting the xOffset
		if column == numberOfColumns - 1 {
			column = 0
		} else {
			column += 1
		}

		return attributes
	}

}

