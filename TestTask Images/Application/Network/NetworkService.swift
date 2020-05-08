//
//  NetworkServiceAlamofire.swift
//  TestTask Images
//
//  Created by Максим Окунеев on 5/1/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import Alamofire

protocol AlertNetworkProtocol: AnyObject {
    func alertNetwork()
}

class NetworkService {
    
    weak var delegate: AlertNetworkProtocol?
    private let workWithImage = WorkWithImage()
    
    func fetchListOfImages(completion: @escaping ( [ListOfImages])->()) {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=1&limit=20") else { return }
        AF.request(url, method: .get).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                var jsonData = [ListOfImages]()
                jsonData = ListOfImages.getArray(from: value)!
                completion(jsonData)
            case .failure(let error):
                print(error)
                self.delegate?.alertNetwork()
            }
        }
    }
    
    func fetchImageWithResize(imageUrl: String, completion: @escaping(_ image: UIImage) -> ()) {
        guard let url = URL(string: imageUrl) else { return }
        AF.request(url).responseData { (responceData)  in
            switch responceData.result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                let resizeImage = self.workWithImage.resize(image)
                completion(resizeImage)
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.delegate?.alertNetwork()
                    let image = #imageLiteral(resourceName: "noImage")
                    completion(image)
                }
            }
        }
    }
    
    func fetchImage(imageUrl: String, completion: @escaping(_ image: UIImage) -> ()) {
        guard let url = URL(string: imageUrl) else { return }
        AF.request(url).responseData { (responceData)  in
            switch responceData.result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                completion(image)
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.delegate?.alertNetwork()
                    let image = #imageLiteral(resourceName: "noImage")
                    completion(image)
                }
            }
        }
    }
}
