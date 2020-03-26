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
    
    var currentPhotoUrl = ""
    
    func configere(with photo: ListOfPhotos) {
        
        photoActivityIndicator.isHidden = true
        photoActivityIndicator.hidesWhenStopped = true
        
        self.autorLabel.text = photo.author
        self.photoSizeLabel.text = "w: \(photo.width ?? 0) h: \(photo.height ?? 0)"
        self.currentPhotoUrl = photo.downloadUrl ?? ""
        
        fetchPhoto(imageUrl: currentPhotoUrl)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}

// MARK: Network
extension ListOfPhotosCell {
    
    private func fetchPhoto(imageUrl: String) {
        self.photoActivityIndicator.isHidden = false
        self.photoActivityIndicator.startAnimating()
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            _ = NetworkService.fetchImage(imageUrl: self.currentPhotoUrl) { (image) in
                let resizeImage = WorkWithImage.resize(image)
                print(Thread.current)
                DispatchQueue.main.async {
                    
                    if self.currentPhotoUrl == imageUrl {
                        self.photoImageView.image = resizeImage
                        self.photoActivityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}

