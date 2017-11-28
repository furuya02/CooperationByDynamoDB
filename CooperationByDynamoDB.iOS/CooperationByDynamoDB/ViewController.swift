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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapOkButton(_ sender: Any) {
        if secretKeyTextField.text == "" {
            let alert: UIAlertController = UIAlertController(title: nil, message: "シークレット・キーが入力されていません", preferredStyle:  UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        performSegue(withIdentifier: "gotoSecretViewController", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cv = segue.destination as? SecretViewController {
            cv.secretKey = secretKeyTextField.text!
        }
    }
}

