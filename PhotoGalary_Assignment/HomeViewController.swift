//
//  HomeViewController.swift
//  PhotoGalary_Assignment
//
//  Created by sumo on 13/05/18.
//  Copyright © 2018 sumo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var timeSlider: UISlider!
    var timeChoosenInSeconds : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeSlider.isContinuous = false
    }
    @IBAction func proceedToPlay(_ sender: Any) {
     showAlert()
    }
 
    @IBAction func sliderAction(_ sender: Any) {
       timeChoosenInSeconds = Float(round(timeSlider.value))
        print("time \(timeChoosenInSeconds)")
    }
    
    func showAlert() {
        let message = "You have \(timeChoosenInSeconds) second to memorise the location of images"
        let alert = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
        let loginAction = UIAlertAction.init(title: "Proceed to play", style: .default, handler: { (action:UIAlertAction) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let quizViewController = storyboard.instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
            quizViewController.selectedTimerTime = self.timeChoosenInSeconds
            self.navigationController?.pushViewController(quizViewController, animated: true)
        })
        let cancelAction = UIAlertAction.init(title: "Reset time", style: .cancel, handler: nil)
        alert.addAction(loginAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}







