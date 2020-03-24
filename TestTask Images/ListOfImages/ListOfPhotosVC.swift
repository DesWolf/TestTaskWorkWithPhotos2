//
//  ViewController.swift
//  TestTask Images
//
//  Created by Максим Окунеев on 3/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class ListOfPhotosVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var listOfPhotos = [ListOfPhotos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.rowHeight = 87
    }
    
    @IBAction func updateListOfPhotos(_ sender: Any) {
     
    }
}

// MARK: Network
extension ListOfPhotosVC {
    private func fetchListOfPhotos() {
        NetworkService.fetchListOfImages { (jsonData) in
            self.listOfPhotos = jsonData
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: Navigation
extension ListOfPhotosVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailPhoto" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let photo = listOfPhotos[indexPath.row]
            let photosVC = segue.destination as! PhotoVC
            photosVC.currentPhotoUrl = photo.download_url ?? ""
        }
    }
}

// MARK: TableViewDataSource
extension ListOfPhotosVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfPhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfPhotosCell", for: indexPath) as! ListOfPhotosCell
        let photo = listOfPhotos[indexPath.row]
        cell.configere(with: photo)
        return cell
    }
}
