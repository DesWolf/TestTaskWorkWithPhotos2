//
//  ViewController.swift
//  TestTask Images
//
//  Created by Максим Окунеев on 3/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class ListOfImagesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var listOfImages = [ListOfImages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchListOfPhotos()
    }
    
    @IBAction func updateListOfImages(_ sender: Any) {
        fetchListOfPhotos()
    }
}

// MARK: Network
extension ListOfImagesVC {
    private func fetchListOfPhotos() {
        NetworkService.fetchListOfImages { (jsonData) in
            self.listOfImages = jsonData
            self.tableView.reloadData()
            self.tableView.tableFooterView = UIView()
        }
    }
}

// MARK: Navigation
extension ListOfImagesVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailPhoto" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let photo = listOfImages[indexPath.row]
            let photosVC = segue.destination as! PhotoVC
            photosVC.currentPhotoUrl = photo.downloadUrl ?? ""
        }
    }
}

// MARK: TableViewDataSource & TableViewDelegate
extension ListOfImagesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListOfImagesCell
        let photo = listOfImages[indexPath.row]
        cell.configere(with: photo)
        cell.delegate = self
        cell.tag = indexPath.row
       
        return cell
    }
}
// MARK: DeleteCellAction
extension ListOfImagesVC: UIGestureRecognizerDelegate, DeleteCellProtocol {
   
    @objc func deleteAction(holdGesture:UILongPressGestureRecognizer){
        switch holdGesture.state {
        case .ended:
            listOfImages.remove(at: holdGesture.view!.tag)
            tableView.deleteRows(at: [IndexPath(item: holdGesture.view!.tag, section: 0)], with: .fade)
            tableView.reloadData()
        default:
            break
        }
    }
}
