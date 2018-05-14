//
//  PhotoCell.swift
//  PhotoGalary_Assignment
//
//  Created by sumo on 09/05/18.
//  Copyright © 2018 sumo. All rights reserved.
//


import UIKit

class PhotoCell: UICollectionViewCell {
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var progressView: UIProgressView!
  
  var imageTask: URLSessionDownloadTask?

  var photo: Photo? {
    didSet {
      imageTask?.cancel()
      guard let photoUrl = photo?.photoUrl else {
        self.photoImageView.image = UIImage(named: "Downloading")
        return
      }
        imageTask = NetworkClient.sharedInstance.getImageInBackground(url: photoUrl,
        downloadProgressBlock: { [weak self] (progress) in
          if (progress > 0 && progress < 1) {
            self?.progressView.progress = progress
            self?.progressView.isHidden = false
          } else {
            self?.progressView.isHidden = true
          }
        }, completion: { [weak self] (image, error) in
          guard error == nil else {
            self?.photoImageView.image = UIImage(named: "Broken")
            return
          }
          self?.photoImageView.image = image
        })
    }
  }
    func flipPhoto(with imageName : String)  {
        self.photoImageView.image = UIImage(named: imageName)
        //self.photoImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
    func flipBackPhoto(photoUrl : URL){
        setImageToCell(photoUrl: photoUrl)
    }

  override func prepareForReuse() {
    super.prepareForReuse()
    photo = nil
  }
    
    func setImageToCell(photoUrl: URL) {
        downloadImage(url: photoUrl)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                self.photoImageView.image = UIImage(data: data)
               // self.photoImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
            }
        }
    }
}
