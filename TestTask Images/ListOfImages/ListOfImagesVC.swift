//
//  ViewController.swift
//  TestTask Images
//
//  Created by Максим Окунеев on 3/24/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class ListOfImagesVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var listOfImages = [ListOfImages]()
//    let memoryCapacity = 500 * 1024 * 1024
//    let diskCapacity = 500 * 1024 * 1024
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "diskPath")
//        URLCache.shared = urlCache
        fetchListOfPhotos()
        
    }
    
    @IBAction func updateListOfImages(_ sender: Any) {
        fetchListOfPhotos()
    }
    
    @objc func deleteAction(tapGesture:UILongPressGestureRecognizer){
        switch tapGesture.state {
        case .ended:
            listOfImages.remove(at: tapGesture.view!.tag)
            tableView.deleteRows(at: [IndexPath(item: tapGesture.view!.tag, section: 0)], with: .fade)
            tableView.reloadData()
        default:
            break
        }
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
        
        let longPressGesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(deleteAction(tapGesture:)))
        longPressGesture.delegate = self
        longPressGesture.minimumPressDuration = 1
        cell.isUserInteractionEnabled = true
        cell.tag = indexPath.row
        cell.addGestureRecognizer(longPressGesture)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            self.listOfImages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

extension ListOfImages {
    func deleteAlert()  {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

