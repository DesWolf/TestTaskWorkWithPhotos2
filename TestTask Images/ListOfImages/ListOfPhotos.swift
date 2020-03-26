//
//  ListOfImages.swift
//  TestTask Images
//
//  Created by Максим Окунеев on 3/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import Foundation

struct ListOfPhotos: Decodable {
    
    let id: String?
    let author: String?
    let width: Int?
    let height: Int?
    let url: String?
    let downloadUrl: String?
    


//    enum CodingKeys: String, CodingKey {
//
//      case id = "id"
//      case author = "author"
//      case width = "width"
//      case height = "height"
//      case url = "url"
//      case downloadUrl = "download_url"
//    }
}
