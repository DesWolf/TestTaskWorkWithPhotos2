//
//  NetworkService.swift
//  TestTask Images
//
//  Created by Максим Окунеев on 3/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

struct NetworkService {
    
    // MARK: Network
    static func fetchListOfPhotos(completion: @escaping ([ListOfPhotos]) -> ()) {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=1&limit=20") else { return }
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonData = try decoder.decode([ListOfPhotos].self, from: data)
                    completion(jsonData)
                } catch let error {
                    print ("Error serialization JSON", error)
                    completion([])
                }
            } else {
                DispatchQueue.main.async {
                    networkAlert()
                }
            }
        }.resume()
    }
    
    static func fetchPhoto(imageUrl: String, completion: @escaping (UIImage) -> Void) -> Request {
        return AF.request(imageUrl, method: .get).responseImage { response in
            switch response.result {
            case .success(let image):
                completion(image)
            case .failure(let error):
                print(error)
                networkAlert()
                completion(#imageLiteral(resourceName: "noImage"))
            }
        }
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
