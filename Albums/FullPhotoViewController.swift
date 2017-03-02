//
//  FullPhotoViewController.swift
//  Albums
//
//  Created by Mikhail Kulichkov on 02/03/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import UIKit

class FullPhotoViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.3
            scrollView.maximumZoomScale = 1.0
        }
    }
    var photo: FBPhoto!
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedImage = ImagesRepo.shared.image(id: photo.id) {
            image = savedImage
        } else {
            indicator.startAnimating()
            FacebookAPI.shared.getImage(imageID: photo.id, full:true) { fetchedImage in
                self.indicator.stopAnimating()
                self.image = fetchedImage
                ImagesRepo.shared.updateImage(image: fetchedImage, id: self.photo.id)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let location = photo.location {
            locationButton.setTitle(location.name, for: .normal)
        } else {
            locationButton.isHidden = true
        }
    }

}
