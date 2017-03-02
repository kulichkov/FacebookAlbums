//
//  PhotosTableViewController.swift
//  Albums
//
//  Created by Mikhail Kulichkov on 27/02/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class PhotosTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footer: UIView!
    
    var currentAlbum: FBAlbum!
    private var isLoading = false
    private var nextPage: String? {
        didSet {
            tableView.reloadData()
        }
    }
    private func fetchPhotos() {
        FacebookAPI.shared.fetchPhotos(albumId: currentAlbum.id, pageCursor: nextPage) { (fetchedPhotos, nextPage) in
            if self.nextPage == nil {
                self.currentAlbum.photos = fetchedPhotos
            } else {
                self.currentAlbum.photos.append(contentsOf: fetchedPhotos)
            }
            self.nextPage = nextPage
        }
    }


//    private func getPhotos() {
//        isLoading = true
//        FacebookAPI.shared.getPhotos(albumID: albumID, pageCursor: nextPage) { (photos, nextPage) in
//            self.photos.append(contentsOf: photos)
//            for eachPhoto in photos {
//                FacebookAPI.shared.getSmallImage(imageID: eachPhoto.id!) { image in
//                    self.images.updateValue(image, forKey: eachPhoto.id!)
//                    self.tableView.reloadData()
//                }
//            }
//            self.nextPage = nextPage
//            self.tableView.reloadData()
//            self.isLoading = false
//            self.footer.isHidden = true
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchPhotos()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endOfTable = (scrollView.contentOffset.y >= (CGFloat(currentAlbum.photos.count * 120) - scrollView.frame.size.height))

        if (nextPage != nil && endOfTable && !isLoading && !scrollView.isDragging && !scrollView.isDecelerating)
        {
            footer.isHidden = false
            fetchPhotos()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  currentAlbum.photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        if let photoCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellForPhotoId, for: indexPath) as? PhotoTableViewCell {
            photoCell.titleLabel.text = currentAlbum.photos[indexPath.row].name
            if let createdTime = currentAlbum.photos[indexPath.row].created {
                photoCell.createdLabel.text = "Created: " + dateFormatter.string(from: createdTime)
            }
            
            let imageId = currentAlbum.photos[indexPath.row].id
            if let image = ImagesRepo.shared.thumb(id: imageId) {
                photoCell.activityIndicator.stopAnimating()
                photoCell.photo.image = image
            } else {
                photoCell.photo.image = UIImage(named: Constants.imageNoPhoto)
                photoCell.activityIndicator.startAnimating()
                FacebookAPI.shared.getImage(imageID: imageId, maxHeight: 200, maxWidth: 200) { image in
                    ImagesRepo.shared.updateThumb(image: image, id: imageId)
                    self.tableView.reloadData()

                }
            }
            return photoCell
        }
        return UITableViewCell()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
