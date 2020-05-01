//
//  AlertService.swift
//  TestTask Images
//
//  Created by Максим Окунеев on 5/1/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit
import Foundation

extension UIAlertController {
    class func alert(title:String, msg:String, target: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
        (result: UIAlertAction) -> Void in
        })
        target.present(alert, animated: true, completion: nil)
    }
}
