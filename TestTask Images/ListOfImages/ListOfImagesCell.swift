//
//  ListOfImagesCell.swift
//  TestTask Images
//
//  Created by Максим Окунеев on 3/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

@objc protocol DeleteCellProtocol: AnyObject {
    @objc func deleteAction(tapGesture:UILongPressGestureRecognizer)
}

class ListOfImagesCell: UITableViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var autorLabel: UILabel!
    @IBOutlet var photoSizeLabel: UILabel!
    
    var currentPhotoUrl = ""
    var imageCache = NSCache<AnyObject, AnyObject>()
    weak var delegate: DeleteCellProtocol?
    
    func configere(with photo: ListOfImages) {
        photoActivityIndicator.isHidden = true
        photoActivityIndicator.hidesWhenStopped = true
        
        self.autorLabel.text = photo.author
        self.photoSizeLabel.text = "w: \(photo.width ?? 0) h: \(photo.height ?? 0)"
        self.currentPhotoUrl = photo.downloadUrl ?? ""
        
        if let cacheImage = imageCache.object(forKey: currentPhotoUrl as AnyObject) as? UIImage {
            self.photoImageView.image = cacheImage
            return
        } else {
            fetchPhoto(imageUrl: currentPhotoUrl)
        }
        
        let longPressGesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(ListOfImagesVC.deleteAction(tapGesture:)))
        longPressGesture.delegate = self
        self.isUserInteractionEnabled = true
        
        //        self.tag = indexPath.row
        self.addGestureRecognizer(longPressGesture)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}

// MARK: Network
extension ListOfImagesCell {
    
    private func fetchPhoto(imageUrl: String) {
        self.photoActivityIndicator.isHidden = false
        self.photoActivityIndicator.startAnimating()
        
        _ = NetworkService.fetchImageWithResize(imageUrl: self.currentPhotoUrl) { (image) in
            if self.currentPhotoUrl == imageUrl {
                self.photoImageView.image =  image
                self.imageCache.setObject(image, forKey: self.currentPhotoUrl as AnyObject)
                self.photoActivityIndicator.stopAnimating()
            }
        }
    }
}
