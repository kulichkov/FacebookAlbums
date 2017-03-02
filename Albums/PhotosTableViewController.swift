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

    var user: FBUser!
    var albumIndex: Int!
    private var isLoading = false
    private var nextPage: String? {
        didSet {
            tableView.reloadData()
        }
    }
    private func fetchPhotos() {
        FacebookAPI.shared.fetchPhotos(albumId: user.albums[self.albumIndex].id, pageCursor: nextPage) { (fetchedPhotos, nextPage) in
            if self.nextPage == nil {
                self.user.albums[self.albumIndex].photos = fetchedPhotos
            } else {
                self.user.albums[self.albumIndex].photos.append(contentsOf: fetchedPhotos)
            }
            self.user.saveToFile()
            self.footer.isHidden = true
            self.nextPage = nextPage
        }
    }

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
        let endOfTable = (scrollView.contentOffset.y >= (CGFloat(user.albums[self.albumIndex].photos.count * 120) - scrollView.frame.size.height))

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
        return  user.albums[self.albumIndex].photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        if let photoCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellForPhotoId, for: indexPath) as? PhotoTableViewCell {
            photoCell.titleLabel.text = user.albums[self.albumIndex].photos[indexPath.row].name
            if let createdTime = user.albums[self.albumIndex].photos[indexPath.row].created {
                photoCell.createdLabel.text = "Created: " + dateFormatter.string(from: createdTime)
            }
            let imageId = user.albums[self.albumIndex].photos[indexPath.row].id
            if let image = ImagesRepo.shared.thumb(id: imageId) {
                photoCell.activityIndicator.stopAnimating()
                photoCell.photo.image = image
            } else {
                photoCell.photo.image = UIImage(named: Constants.imageNoPhoto)
                photoCell.activityIndicator.startAnimating()
                FacebookAPI.shared.getImage(imageID: imageId, full:false) { image in
                    ImagesRepo.shared.updateThumb(image: image, id: imageId)
                    self.tableView.reloadData()
                }
            }
            return photoCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = user.albums[self.albumIndex].photos[indexPath.row]
        performSegue(withIdentifier: Constants.segueShowFullPhoto, sender: photo)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.segueShowFullPhoto:
                if let destination = segue.destination as? FullPhotoViewController
                {
                    destination.photo = sender as? FBPhoto
                }
            default:
                break
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
