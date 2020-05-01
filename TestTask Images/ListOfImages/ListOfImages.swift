//
//  ListOfImages2.swift
//  TestTask Images
//
//  Created by Максим Окунеев on 5/1/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

struct ListOfImages: Decodable {
    
    let id: String?
    let author: String?
    let width: Int?
    let height: Int?
    let url: String?
    let downloadUrl: String?
    
    init?(json: [String: Any]) {
        
        let id = json["id"] as? String
        let author = json["author"] as? String
        let width = json["width"] as? Int
        let height = json["height"] as? Int
        let url = json["url"] as? String
        let downloadUrl = json["download_url"] as? String
        
        self.id = id
        self.author = author
        self.width = width
        self.height = height
        self.url = url
        self.downloadUrl = downloadUrl
    }
    
    static func getArray(from jsonArray: Any) -> [ListOfImages]? {
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        return jsonArray.compactMap { ListOfImages(json: $0) }
    }
}
