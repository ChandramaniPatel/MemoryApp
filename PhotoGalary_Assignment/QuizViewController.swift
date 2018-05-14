//
//  QuizViewController.swift
//  PhotoGalary_Assignment
//
//  Created by sumo on 13/05/18.
//  Copyright © 2018 sumo. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var qiuzViewContainer: UIView!
    @IBOutlet weak var playNowButton: UIButton!

    var count : Float = 0.0
    var selectedTimerTime : Float = 0.0
    var timer : Timer?
    var feedViewController = FeedViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        count = selectedTimerTime
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         feedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
         feedViewController.fireTimerDelegate = self
         feedViewController.view.frame = qiuzViewContainer.bounds;
         qiuzViewContainer.addSubview(feedViewController.view)
         self.addChildViewController(feedViewController)
        // createTimer()
    }
    
    
    func createTimer() {
        
        countDownLabel.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(QuizViewController.update), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(QuizViewController.timerObserverMethodForbackground), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(QuizViewController.timerObserverMethodForForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    
    @objc func update() {
        if(count > 0) {
            count =  count - 1
            countDownLabel.text = String(count)
            if count == 0 {
                countDownLabel.isHidden = true
                flipBackAllImages()
            }
        } else {
            self.timer?.invalidate()
            countDownLabel.text = String(0)
            countDownLabel.isHidden = true
            flipBackAllImages()
        }
    }
    @IBAction func playNowAction(_ sender: Any) {
        presentRandomImage()
    }
    
    func flipBackAllImages(){
        feedViewController.isTimerOn = false
        feedViewController.collectionView?.reloadData()
    }
    
    func presentRandomImage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       let randomImageViewController = storyboard.instantiateViewController(withIdentifier: "RandomImageViewController") as! RandomImageViewController
        randomImageViewController.randomImageDelegate = self
        randomImageViewController.photos = feedViewController.photos
        self.present(randomImageViewController, animated: true, completion: nil)
     }
    @objc func timerObserverMethodForbackground() {
        self.timer?.invalidate()
    }
    
    @objc func timerObserverMethodForForeground() {
        createTimer()
    }
}
extension QuizViewController : RandomImageProtocol {
    func flipBackImage(at index: Int,attemptCount : Int) {
        self.playNowButton.setTitle("Next", for: UIControlState.normal)
        feedViewController.reloadImage(at: index)
        if attemptCount == 9 {
            self.playNowButton.setTitle("Start Now", for: UIControlState.normal)
            self.playNowButton.isHidden = true
            quizFinished()
        }
    }
    
    func quizFinished() {
        RandomImageViewController.alreadyPickedData = []
        let message =  "You have finished the quiz"
        let alert = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Try new quiz", style: .cancel, handler: { (action:UIAlertAction) in
            self.feedViewController.fetchPhotoFeed()
            self.playNowButton.isHidden = false
            self.feedViewController.isTimerOn = false
            //self.timer?.invalidate()
            //self.createTimer()
         })
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

extension QuizViewController : FeedViewTimerProtocol {
    func fireTimer() {
       count = selectedTimerTime
       self.timer?.invalidate()
       createTimer()
    }
    
}
