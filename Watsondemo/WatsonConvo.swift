//
//  WatsonConvo.swift
//  amex
//
//  Created by dennis noto on 8/9/16.
//  Copyright © 2016 Etay Luz. All rights reserved.
//

import Foundation
import Alamofire

var context = ""
var cvalue1 = "Susan G Komen"
var cvalue2 = "Red Cross"
var cvalue3 = "Thrivent Builds"

@objc class WatsonConvo : NSObject {
    var save_context = ""
    var answer = ""
  
    func sendToConvo(input: String, chatViewController:Chat) {
        
    let url = "http://Node-Workflow-Hub.mybluemix.net/mobileV2-1"
    
        let requestParameters =  ["input" : input, "workspace_id" : "1d311c0b-0ad2-4b17-9253-dede37ef3e51", "fname" : "Mary", "lname" : "Smith", "nname" : "Mary", "cvalue1" : cvalue1, "cvalue2" : cvalue2, "cvalue3" : cvalue3, "context" : context ]
    
    print (requestParameters)
    
    Alamofire.request(.POST, url, parameters:requestParameters).responseJSON {
        response in
        switch response.result {
            
        case .Success(let JSON): print("Success with JSON: \(JSON)")
        
        do {
            self.answer = (JSON["text"] as? String)!
            context = (JSON["context"] as? String)!
            print(self.answer)
            print(context)
            chatViewController.addWatsonChat(self.answer, waiting: false);
          
            }
        case .Failure(let error): print("Request failed with error: \(error)")
            
        }}

    print(self.answer)
    }
    
}