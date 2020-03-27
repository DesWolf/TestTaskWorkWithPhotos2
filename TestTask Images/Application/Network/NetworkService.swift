//
//  NetworkService.swift
//  TestTask Images
//
//  Created by Максим Окунеев on 3/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

struct NetworkService {
    
    // MARK: Network
    static func fetchListOfImages(completion: @escaping ([ListOfImages]) -> ()) {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=1&limit=20") else { return }
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonData = try decoder.decode([ListOfImages].self, from: data)
                    DispatchQueue.main.async {
                        completion(jsonData)
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        print ("Error serialization JSON", error)
                        completion([])
                    }
                }
            } else {
                DispatchQueue.main.async {
                    networkAlert()
                }
            }
        }.resume()
    }
    
    static func fetchImageWithResize(imageUrl: String, completion: @escaping (UIImage) -> ()){
        guard let imageUrl = URL(string: imageUrl) else { return }
        let session = URLSession.shared
        session.dataTask(with: imageUrl) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                let resizeImage = WorkWithImage.resize(image)
                DispatchQueue.main.async {
                    completion(resizeImage)
                }
            } else {
                DispatchQueue.main.async {
                    networkAlert()
                    let image = #imageLiteral(resourceName: "noImage")
                    completion(image)
                }
            }
        }.resume()
    }
    
    static func fetchImage(imageUrl: String, completion: @escaping (UIImage) -> ()){
        guard let imageUrl = URL(string: imageUrl) else { return }
        let session = URLSession.shared
        session.dataTask(with: imageUrl) { (data, response, error) in
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    networkAlert()
                    let image = #imageLiteral(resourceName: "noImage")
                    completion(image)
                }
            }
        }.resume()
    }
    
    // MARK: Network Alert
    static func networkAlert() {
        let alertController = UIAlertController(title: "Error", message: "Network is unavaliable! Please try again later!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
