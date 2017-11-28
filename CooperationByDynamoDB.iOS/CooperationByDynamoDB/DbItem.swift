//
//  DbItem.swift
//  CooperationByDynamoDB
//
//  Created by SIN on 2017/11/28.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import AWSDynamoDB

class DbItem : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    @objc var SecretKey : String?
    @objc var Name : String?
    @objc var Pin : String?
    @objc var Ttl: NSNumber = 0 
    
    static func dynamoDBTableName() -> String {
        return "CooperationByDynamoDBTable"
    }
    
    class func hashKeyAttribute() -> String {
        return "SecretKey"
    }
}
