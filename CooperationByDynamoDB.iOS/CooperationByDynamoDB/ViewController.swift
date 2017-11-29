//
//  ViewController.swift
//  CooperationByDynamoDB
//
//  Created by SIN on 2017/11/28.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var secretKeyTextField: UITextField!

    let userDefaults = UserDefaults.standard
    let key = "SecretKey"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let secretKey = userDefaults.string(forKey: key) {
            secretKeyTextField.text = secretKey
        }
    }
    
    @IBAction func tapOkButton(_ sender: Any) {
        if secretKeyTextField.text == "" {
            let alert: UIAlertController = UIAlertController(title: nil, message: "シークレット・キーが入力されていません", preferredStyle:  UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        secretKeyTextField.resignFirstResponder()
        performSegue(withIdentifier: "gotoSecretViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cv = segue.destination as? SecretViewController {
            let secretKey = secretKeyTextField.text!
            cv.secretKey = secretKey
            userDefaults.set(secretKey, forKey: key)
        }
    }
}

