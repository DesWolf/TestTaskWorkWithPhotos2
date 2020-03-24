//
//  PhotoVC.swift
//  TestTask Images
//
//  Created by Максим Окунеев on 3/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController {

 
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoActivityIndicator: UIActivityIndicatorView!
    
    var currentPhotoUrl = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoActivityIndicator.isHidden = true
        photoActivityIndicator.hidesWhenStopped = true
        
        fetchPhoto(imageUrl: currentPhotoUrl)
    }
}

extension PhotoVC {
    
    private func fetchPhoto(imageUrl: String) {
        photoActivityIndicator.isHidden = false
        photoActivityIndicator.startAnimating()
        
        NetworkService.fetchPhoto(imageUrl: imageUrl) {(image) in
            DispatchQueue.main.async {
                if self.currentPhotoUrl == imageUrl {
                    self.photoImageView.image = image
                    self.photoActivityIndicator.stopAnimating()
                }
            }
        }
    }
}
