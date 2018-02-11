//
//  MainViewController.swift
//  Bitmoji
//
//  Created by Jake on 2/10/18.
//  Copyright © 2018 Jake. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Subviews
    var textField: UITextField!
    var doneButton: UIButton!
    var imageView: UIImageView!
    var alertController: UIAlertController!
    
    // MARK: - Properties
    var username: String = "brian_hans"

    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestureRecognizer()
        setupTextField()
        setupDoneButton()
        setupImageView()
        setupAlertController()
        requestBitmoji()
    }

    // MARK: - Setups
    func setupTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func setupTextField() {
        let frame = CGRect(x: 0, y: 20, width: view.bounds.width, height: 50)
        textField = UITextField(frame: frame)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .purple
        textField.delegate = self
        view.addSubview(textField)
        
        
    }
    
    func setupDoneButton() {
        let frame = CGRect(x: 0, y: 70, width: view.bounds.width, height: 50)
        doneButton = UIButton(frame: frame)
        doneButton.setTitle("Get Bitmoji", for: .normal)
        doneButton.setTitleColor(.red, for: .normal)
        doneButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(doneButton)
    }
    
    func setupImageView() {
        let frame = CGRect(x: 0, y: view.bounds.height / 8, width: view.bounds.width, height: view.bounds.height)
        imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }
    
    func setupAlertController() {
        alertController = UIAlertController(title: "Username does not exist or they do not have a Bitmoji", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try again!", style: .default, handler: nil))
    }
    
    // MARK: - Helpers
    @objc func buttonTapped() {
        doneButton.isEnabled = false
        username = textField.text ?? ""
        requestBitmoji()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    func requestBitmoji() {
        let url = URL(string: "https://feelinsonice-hrd.appspot.com/web/deeplink/snapcode?username=\(username)&type=SVG")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            guard let data = data else { return }
            
            let svg = String(data: data, encoding: .utf8)!
            
            
            guard let startIndex = svg.endIndex(of: "data:image/png;base64,") else {
                DispatchQueue.main.async {
                    self.present(self.alertController, animated: true, completion: nil)
                    self.doneButton.isEnabled = true
                }
                return
            }
            
            
            let newString = svg[startIndex..<svg.endIndex]
            
            guard let newEndIndex = newString.index(of: "\"") else {
                DispatchQueue.main.async {
                    self.present(self.alertController, animated: true, completion: nil)
                    self.doneButton.isEnabled = true
                }
                return
            }
            
            let base64 = newString[newString.startIndex..<newEndIndex]
            
            
            guard let imageData = Data(base64Encoded: String(base64)) else {
                DispatchQueue.main.async {
                    self.present(self.alertController, animated: true, completion: nil)
                    self.doneButton.isEnabled = true
                }
                return
            }
            
            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.imageView.image = image!
                self.doneButton.isEnabled = true
            }
        }
        
        task.resume()
    }

}

// MARK: - Text Field Delegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        buttonTapped()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}


// MARK: - String Extension
extension String {
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
