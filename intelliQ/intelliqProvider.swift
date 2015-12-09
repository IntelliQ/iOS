//
//  QProvider.swift
//  intelliQ
//
//  Created by Markus Petrykowski on 13.06.15.
//  Copyright (c) 2015 Markus Petrykowski. All rights reserved.
//

import Foundation


class QueueProvider{
    
    private var domain = "http://intelliq.me/api"
    
    func getNearbyQueues(callback: ([BusinessQueue]) -> Void){
        Http.get("\(domain)/queue/nearby/", params: ["longitude": 13.131216, "latitude": 52.393326, "distance": 5000]) {
            (result) -> Void in
            let _: NSError?
            
            var queueList:[BusinessQueue] = []
            do{
                if let json = try NSJSONSerialization.JSONObjectWithData(result, options: .MutableLeaves) as? [String:AnyObject] {
                    if let queues = json["content"] as? [ [String:AnyObject] ]{
                        for queue in queues  {
                            let queueEntry = BusinessQueue()
                                
                            queueEntry.name = (queue["name"] as! String)
                            queueEntry.businessKeyId = (queue["businessKeyId"] as! Int)
                            queueEntry.isVisible = Bool.init(queue["visibility"] as! Int)
                            queueEntry.imageId = (queue["photoImageKeyId"] as! Int)
                            queueEntry.waitingPeople = (queue["waitingPeople"] as! Int)
                            queueEntry.country = (queue["country"] as! String)
                            queueEntry.city = (queue["city"] as! String)
                            queueEntry.country = (queue["postalCode"] as! String)
                            queueEntry.street = (queue["street"] as! String)
                            queueEntry.streetNumber = (queue["number"] as! String)
                            queueEntry.avgWaitingTime = (queue["averageWaitingTime"] as! Int)
                            
                            if queueEntry.isVisible! {
                                print("added item to queue")
                                queueList.append(queueEntry)
                            }
                            
                        }
                    }
    
                }
            }catch{
                //Catch error here
            }
            
            callback(queueList)
            
        }
    }
    
    func getNearbyBusinesses(callback: ([Business]) -> Void){
        Http.get("\(domain)/queue/nearby/", params: ["longitude": 13.131216, "latitude": 52.393326, "distance": 5000, "includeBusinesses": true]) {
            (result) -> Void in
            let _: NSError?
            
            var businessList:[Business] = []
            do{
                if let json = try NSJSONSerialization.JSONObjectWithData(result, options: .MutableLeaves) as? [String:AnyObject] {
                    if let businesses = json["content"] as? [ [String:AnyObject] ]{
                        
                        for business in businesses {
                            
                            let businessEntry = Business()
                            
                            businessEntry.name = business["name"] as! String
//                            businessEntry.email = business["email"] as! String
                            businessEntry.logoImageKey = business["logoImageKeyId"] as! Int
                            
                            if let queues = business["queues"] as? [ [String: AnyObject] ]{
                                
                                for queue in queues {
                                    let queueEntry = BusinessQueue()
                                    
                                    queueEntry.name = (queue["name"] as! String)
                                    queueEntry.businessKeyId = (queue["businessKeyId"] as! Int)
                                    queueEntry.isVisible = Bool.init(queue["visibility"] as! Int)
                                    queueEntry.imageId = (queue["photoImageKeyId"] as! Int)
                                    queueEntry.waitingPeople = (queue["waitingPeople"] as! Int)
                                    queueEntry.country = (queue["country"] as! String)
                                    queueEntry.city = (queue["city"] as! String)
                                    queueEntry.country = (queue["postalCode"] as! String)
                                    queueEntry.street = (queue["street"] as! String)
                                    queueEntry.streetNumber = (queue["number"] as! String)
                                    queueEntry.avgWaitingTime = (queue["averageWaitingTime"] as! Int)
                                    
                                    if queueEntry.isVisible! {
                                        businessEntry.queues.append(queueEntry)
                                    }
                                    
                                }

                                
                            }
                            
                            businessList.append(businessEntry)
                            
                        }
                        
                    }
                    
                }
            }catch{
                //Catch error here
            }
            
            callback(businessList)
            
        }
    }
}

