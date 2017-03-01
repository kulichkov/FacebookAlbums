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

    var user: User!
    private var nextPage: String?
    @IBOutlet weak var tableView: UITableView!

    @IBAction func exit(_ sender: UIButton) {
        //let loginManager = FBSDKLoginManager()

        //self.dismiss(animated: true, completion: nil)
    }

    private func fetchAlbums(page: String?) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        FacebookAPI.shared.getMyAlbums { result in
            self.albums = result
//            for eachAlbum in self.albums! {
//                FacebookAPI.shared.getSmallImage(imageID: eachAlbum.id!) { image in
//                    self.images.updateValue(image, forKey: eachPhoto.id!)
//                    self.tableView.reloadData()
//                }
//            }
            self.tableView.reloadData()

        }
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

            /*
            let id = user.albums[indexPath.row].id
            if let image = images["\(id!)"].thumb {
                albumCell.iconImageView.image = image
                albumCell.activityIndicator.stopAnimating()
            } else {
                albumCell.iconImageView.image = UIImage(named: Constants.imageNoPhoto)
                albumCell.activityIndicator.startAnimating()
            }
            */

            return albumCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let id = user.albums[indexPath.row].id
        //performSegue(withIdentifier: "Show Photos", sender: id)
    }

/*

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Show Photos":
                if let destination = segue.destination as? PhotosViewController {
                    destination.albumID = sender as! String
                }
            default:
                break
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
*/
 

}

