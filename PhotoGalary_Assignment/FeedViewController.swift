
//
//  FeedViewController.swift
//  PhotoGalary_Assignment
//
//  Created by sumo on 09/05/18.
//  Copyright © 2018 sumo. All rights reserved.
//


import UIKit

protocol FeedViewTimerProtocol  {
    
    func fireTimer()
}

class FeedViewController: UICollectionViewController {
    
    var  fireTimerDelegate : FeedViewTimerProtocol?
    var photos: [Photo]?
    var currentMessage = "Loading photos..."
    let cellIdentifier = "photoCell"
    let messageCellIdentifier = "messageCell"
    var isTimerOn = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Photos"
        fetchPhotoFeed()
    }
    
    func fetchPhotoFeed() {
        Photo.getAllFeedPhotos { [weak self] (photos, error) in
            guard error == nil else {
                if let error = error as? PhotoServiceError {
                    self?.currentMessage = error.rawValue
                } else if let error = error {
                    self?.currentMessage = error.localizedDescription
                } else {
                    self?.currentMessage = "Sorry, there was an error."
                }
                self?.photos = nil
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
                return
            }
            self?.photos = photos
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
                // fire timer from here
                if (self!.fireTimerDelegate != nil) {
                    self?.fireTimerDelegate?.fireTimer()
                    self?.isTimerOn = true
                }
            }
        }
    }
    
    func reloadImage(at index : Int) {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = collectionView!.cellForItem(at: indexPath) as! PhotoCell
        cell.flipBackPhoto(photoUrl: photos![index].photoUrl)
    }
    // MARK: - UICollectionView delegate/data source
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photos = photos else { return 1 }
        return  9 //photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell
        if isTimerOn {
            if let photos = photos, photos.count > 0 {
                let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! PhotoCell
                photoCell.photo = photos[indexPath.item]
                cell = photoCell
            } else {
                let messageCell = collectionView.dequeueReusableCell(withReuseIdentifier: messageCellIdentifier, for: indexPath as IndexPath) as! MessageCell
                messageCell.messageLabel.text = currentMessage
                cell = messageCell
            }
        } else {
            let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! PhotoCell
            photoCell.flipPhoto(with: "MEDIUM-CARD")
            cell = photoCell
        }
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isTimerOn {
            guard (photos?[indexPath.item]) != nil else { return }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let photoViewController = storyboard.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
            photoViewController.photos = self.photos
            photoViewController.selectedIndexPath = indexPath
            self.navigationController?.pushViewController(photoViewController, animated: true)
        }
    }
}
