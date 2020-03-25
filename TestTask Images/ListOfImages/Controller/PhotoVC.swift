//
//  VCViewController.swift
//  TestTask Images
//
//  Created by Максим Окунеев on 3/25/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var photoScrollView: UIScrollView!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoActivityIndicator: UIActivityIndicatorView!
    
    var currentPhotoUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoActivityIndicator.isHidden = true
        photoActivityIndicator.hidesWhenStopped = true

        fetchPhoto(imageUrl: currentPhotoUrl)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
}

extension PhotoVC {
    
    private func fetchPhoto(imageUrl: String) {
        photoActivityIndicator.isHidden = false
        photoActivityIndicator.startAnimating()
        
        _ = NetworkService.fetchPhoto(imageUrl: imageUrl) {(image) in
           
            DispatchQueue.main.async {
                
                if self.currentPhotoUrl == imageUrl {
                    self.photoImageView.image = image
                    self.photoActivityIndicator.stopAnimating()
                }
            }
        }
    }
}
