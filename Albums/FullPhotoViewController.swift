//
//  FullPhotoViewController.swift
//  Albums
//
//  Created by Mikhail Kulichkov on 02/03/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import UIKit

class FullPhotoViewController: UIViewController {
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    var photo: FBPhoto!
    private var image: UIImage! {
        didSet {
            imageView.image = image
            imageView.sizeToFit()
            updateMinZoomScaleForSize(size: view.bounds.size)
            updateConstraintsForSize(size: view.bounds.size)
        }
    }

    override func viewDidLoad() {
        scrollView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false;
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLocationButton()
        setImage()
    }

    func setLocationButton() {
        if let location = photo.location {
            locationButton.setTitle(location.name, for: .normal)
        } else {
            locationButton.isHidden = true
            locationView.isHidden = true
        }
    }

    func setImage() {
        if let savedImage = ImagesRepo.shared.image(id: photo.id) {
            imageView.image = savedImage
        } else {
            indicator.startAnimating()
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                FacebookAPI.shared.getImage(imageID: self.photo.id, full:true) { fetchedImage in
                    ImagesRepo.shared.updateImage(image: fetchedImage, id: self.photo.id)
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                        self.image = fetchedImage
                    }
                }
            }
        }
    }
}

extension FullPhotoViewController: UIScrollViewDelegate {

    func updateMinZoomScaleForSize(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale
    }

    func updateConstraintsForSize(size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        view.layoutIfNeeded()
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(size: view.bounds.size)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMinZoomScaleForSize(size: view.bounds.size)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.segueShowPlace:
                if let destination = segue.destination as? PlaceViewController
                {
                    let latitude = photo.location?.latitude
                    let longitude = photo.location?.longitude
                    let mapURL = "https://www.google.com/maps?q=loc:\(latitude!),\(longitude!)"
                    destination.placeURL = URL(string: mapURL)
                }
            default:
                break
            }
        }
    }
}
