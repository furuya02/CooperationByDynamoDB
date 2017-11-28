//
//  SecretViewController.swift
//  CooperationByDynamoDB
//
//  Created by SIN on 2017/11/28.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import UIKit
import AWSCognito
import AWSDynamoDB

class SecretViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    
    let expired = 5.0
    var secretKey = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 以下の行は、別ファイルで定義され、GitHubでは公開されておりません。
        //let poolId = "us-east-1:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        
        let region =  AWSRegionType.USEast1

        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: region, identityPoolId: poolId)
        let dynamoDbConfiguration = AWSServiceConfiguration(region: region, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = dynamoDbConfiguration
    }
    

    @IBAction func tapOkButton(_ sender: Any) {
        
        let pin = pinTextField.text!
        let name = userTextField.text!
        saveDb(name: name, pin: pin)
        
        let alert: UIAlertController = UIAlertController(title: "送信しました", message: "暗証番号は、OKボタンを押してから\(expired)秒間有効です。", preferredStyle:  UIAlertControllerStyle.alert)
        present(alert, animated: true, completion:{
            DispatchQueue.main.asyncAfter(deadline: .now() + self.expired, execute: {
                alert.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    func saveDb(name: String, pin: String) {
        let dbItem = DbItem()
        dbItem?.SecretKey = secretKey
        dbItem?.Name = name
        dbItem?.Pin = pin
        dbItem?.Ttl = NSNumber(integerLiteral: Int(NSDate().timeIntervalSince1970 + expired))
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDBObjectMapper.save(dbItem!).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else {
                print("Success")
            }
            return nil
        })
    }
    
}
