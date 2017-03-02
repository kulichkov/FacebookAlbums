//
//  AlbumsTableViewController.swift
//  Albums
//
//  Created by Mikhail Kulichkov on 26/02/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class AlbumsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var footer: UIView!
    
    var user: FBUser!
    private var isLoading = false
    private var nextPage: String? {
        didSet {
            tableView.reloadData()
        }
    }
    @IBOutlet weak var tableView: UITableView!

    @IBAction func exit(_ sender: UIButton) {
        //let loginManager = FBSDKLoginManager()

        //self.dismiss(animated: true, completion: nil)
    }

    private func fetchAlbums() {
        FacebookAPI.shared.fetchAlbums(pageCursor: nextPage) { (fetchedAlbums, nextPage) in
            if self.nextPage == nil {
                self.user.albums = fetchedAlbums
            } else {
                self.user.albums.append(contentsOf: fetchedAlbums)
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
        fetchAlbums()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.albums.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let albumCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellForAlbumId, for: indexPath) as? AlbumTableViewCell {
            albumCell.titleLabel.text = user.albums[indexPath.row].name
            let id = user.albums[indexPath.row].coverId
            if let image = ImagesRepo.shared.thumb(id: id) {
                albumCell.iconImageView.image = image
                albumCell.activityIndicator.stopAnimating()
            } else {
                albumCell.iconImageView.image = UIImage(named: Constants.imageNoPhoto)
                albumCell.activityIndicator.startAnimating()
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                    FacebookAPI.shared.getImage(imageID: id, full: false) { image in
                        ImagesRepo.shared.updateThumb(image: image, id: id)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            return albumCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.segueShowPhotos, sender: indexPath.row)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endOfTable = (scrollView.contentOffset.y >= (CGFloat(user.albums.count * 80) - scrollView.frame.size.height))

        if (nextPage != nil && endOfTable && !isLoading && !scrollView.isDragging && !scrollView.isDecelerating)
        {
            footer.isHidden = false
            fetchAlbums()
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.segueShowPhotos:
                if let destination = segue.destination as? PhotosTableViewController
                {
                    destination.user = user
                    destination.albumIndex = sender as! Int
                }
            default:
                break
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

