//
//  RandomImageViewController.swift
//  PhotoGalary_Assignment
//
//  Created by sumo on 13/05/18.
//  Copyright © 2018 sumo. All rights reserved.
//

import UIKit

protocol RandomImageProtocol {
    func flipBackImage(at index : Int,attemptCount : Int)
}
class RandomImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationPicker: UIPickerView!
    var randomImageDelegate : RandomImageProtocol?
    var selectedIndex : Int = 0
    var randomNumber : Int = 0
    var photos: [Photo]?
    
    var pickerData : [Int] = []
   static var alreadyPickedData : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationPicker.delegate = self
        locationPicker.dataSource = self
        
        
        createPickerDataSource(count : (photos?.count)!)
    }
    
    func createPickerDataSource(count : Int) {
        pickerData = Array(0...8)
        self.presentImageRandomly()
    }
    
    func presentImageRandomly() {
        
        print("alreadyPickedData \(RandomImageViewController.alreadyPickedData)")
        if !(RandomImageViewController.alreadyPickedData.count == 9) {
            
            randomNumber = Int(arc4random_uniform(9))
            print("randomNumber \(randomNumber)")
            if RandomImageViewController.alreadyPickedData.contains(randomNumber) {
                presentImageRandomly()
            } else {
                RandomImageViewController.alreadyPickedData.append(randomNumber)
                let photoUrl = photos![randomNumber].photoUrl
                setImageToImageView(photoUrl: photoUrl)
            }
        }
    }
    
    func setImageToImageView(photoUrl: URL) {
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
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func verifyAnswerButtonActon(_ sender: Any) {
        if selectedIndex == randomNumber {
            self.dismiss(animated: true, completion: nil)
            randomImageDelegate?.flipBackImage(at: selectedIndex, attemptCount: RandomImageViewController.alreadyPickedData.count)
        } else {
            triggerAlert(message : "Incorrect answer!Please try again.")
       }
    }
    
    func triggerAlert(message : String){
        let alert = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

extension RandomImageViewController : UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ("\(pickerData[row])")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.selectedIndex = pickerData[row]
    }
}
