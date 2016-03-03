//
//  QProvider.swift
//  intelliQ
//
//  Created by Markus Petrykowski on 13.06.15.
//  Copyright (c) 2015 Markus Petrykowski. All rights reserved.
//

import Foundation


class QProvider{
    
    private var domain = "https://intelliq.herokuapp.com"
    
    func getCompanies(callback: ([Company]) -> Void){
        Http.get("\(domain)/api/companies", params: [:]) {
            (result) -> Void in
            var err: NSError?
            
            var companies:[Company] = []
            if let json = NSJSONSerialization.JSONObjectWithData(result, options: .MutableLeaves, error: &err) as? [String:AnyObject] {
                if let companyResult = json["companies"] as? [ [String:AnyObject] ]{
                    for company in companyResult  {
                        var newCompany:Company = Company()
                        
                        newCompany.id = company["id"] as! String
                        newCompany.name = company["name"] as! String
                        if let logoUrl = company["logo__c"] as? String{
                            newCompany.logo = logoUrl
                        }
                        if let waitingPersons = company["waiting"] as? Int{
                            newCompany.waiting = String(waitingPersons)
                        }
                        newCompany.avgWaitingTime = company["waitingtime__c"] as! Int
                        
                        companies.append(newCompany)
                    }
                }
                
            }
            
            callback(companies)
            
        }
    }
    
    func enqueMe(name:String, company:String, callback: (String) -> Void){
        Http.post("\(domain)/api/qitems", params: ["name": name, "company": company]){
            (result) -> Void in
            var err: NSError?
            
            if let json = NSJSONSerialization.JSONObjectWithData(result, options: .MutableLeaves, error: &err) as? [String:AnyObject] {
                if let newId = json["qItemId"] as? String {
                    callback(newId)
                }
            }else{
                callback("")
            }
            
        }
    }
    
    func checkStatus(qItemId:String, companyId:String, callback: ([String:String]) -> Void){
        Http.get("\(domain)/api/qitems", params: ["companyId": companyId]){
            result -> Void in
            
            var err: NSError?,
            status:[String:String] = [:]
            var json = NSJSONSerialization.JSONObjectWithData(result, options: .MutableLeaves, error: &err) as? [String:AnyObject]
            if let personsArray = json!["qItems"] {
                if let persons = personsArray as?  [ [String:AnyObject] ] {
                    //                status["peopleAhead"] = json["ahead"] as! String
                    //                status["timeLeft"]  = json["timeLeft"] as! String
                    
                    var position = -1,
                    state    = ""
                    for person in persons{
                        if person["id"] as! String == qItemId {
                            position = (person["position__c"] as! String).toInt()!
                            
                        }
                    }
                    
                    var personAhead = 0
                    for person in persons{
                        if (person["position__c"] as! String).toInt() < position {
                            personAhead++
                        }
                    }
                    
                    
                    status["peopleAhead"] = String(personAhead)
                    status["ticketId"] = String(position)
                    status["companyId"] = companyId
                    if position == -1{
                        status["state"] = "ready"
                    }
                    
                    callback(status)
                }else{
                    callback(status)
                }
            }
        }
    }
    
    func cancelWaiting(qItemId:String){
        Http.post("\(domain)/api/qitem/cancel", params: ["id": qItemId]){
            result -> Void in
            
        }
    }
    
}