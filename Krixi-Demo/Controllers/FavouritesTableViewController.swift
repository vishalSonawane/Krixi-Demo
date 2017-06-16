//
//  FavouritesTableViewController.swift
//  Krixi-Demo
//
//  Created by Vishal Sonawane on 16/06/17.
//  Copyright © 2017 Vishal Sonawane. All rights reserved.
//

import UIKit
import Floaty

class FavouritesTableViewController: UITableViewController {

    var imagesDataSource = [Images]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //register cell
        tableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoritesTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        Floaty.global.hide()
    }
    override func viewWillDisappear(_ animated: Bool) {
        Floaty.global.show()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return imagesDataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
       let imageData = imagesDataSource[indexPath.row].imageValue as Data?
        cell.pantShirtImageView.image  = UIImage(data: imageData!)
        
        cell.shareClickHandler = {(aCell) in
            self.shareImage(image: (aCell?.pantShirtImageView.image)!)
        }
        return cell
    }
 
    func shareImage(image:UIImage)  {
        
        // set up activity view controller
        let imageToShare = [ image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        activityViewController.excludedActivityTypes = nil
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190.0
    }
}
