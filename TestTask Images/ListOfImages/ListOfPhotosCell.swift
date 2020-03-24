//
//  ListOfImagesCell.swift
//  TestTask Images
//
//  Created by Максим Окунеев on 3/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class ListOfPhotosCell: UITableViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var autorLabel: UILabel!
    @IBOutlet var photoSizeLabel: UILabel!
    
    var currentImageUrl = ""
    
    func configere( with photo: ListOfPhotos) {
        
        photoActivityIndicator.isHidden = true
        photoActivityIndicator.hidesWhenStopped = true
        
        self.autorLabel.text = photo.author
        self.photoSizeLabel.text = "w: \(photo.width ?? 0) h: \(photo.height ?? 0)"
        
        self.fetchPhoto(imageUrl: photo.download_url ?? "")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}

// MARK: Network
extension ListOfPhotosCell {
    
    private func fetchPhoto(imageUrl: String) {
        photoActivityIndicator.isHidden = false
        photoActivityIndicator.startAnimating()
        
        NetworkService.fetchPhoto(imageUrl: imageUrl) { (image) in
            DispatchQueue.main.async {
                if self.currentImageUrl == imageUrl {
                    self.photoImageView.image = image
                    self.photoActivityIndicator.stopAnimating()
                }
            }
        }
    }
}

