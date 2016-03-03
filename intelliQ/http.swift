//
//  http.swift
//  NoiseToOpportunity
//
//  Created by Markus Petrykowski on 02.05.15.
//  Copyright (c) 2015 Markus Petrykowski. All rights reserved.
//

import Foundation

class Http {
    
    static var session:NSURLSession = NSURLSession.sharedSession()
    static var username:String = "markus@sap.com"
    static var password:String = "markus123"
    
    static func login(callback: () -> Void){
        Http.post("https://explorer.n2o.social/api/login", params: ["username": username, "password": password]) { (result) -> Void in callback() }
    }
    
    static func get(url:String, params:[String:Any] = [:], callback: (NSData) -> Void) -> Void {
//        println("Perform GET Request for url \(url) with Params \(params)")
        func convertDictToString(dict: [String:Any]) -> String{
            var result = ""
            for (key, value) in dict {
                if let _ = value as? [ [String:String]] {
                    //value is simple dict Array
                }else if let _ = value as? [ [String:Any]]{
                    //value is complex dict array
                }else if let _ = value as? [String:Any]{
                    //value is complex dictionary
                }else if let _ = value as? [String: String]{
                    //value is simple dictionary
                }else if NSJSONSerialization.isArray(value as? AnyObject){
                    var firstItem = true
                    if result.isEmpty {
                        result += "\(key)="
                    }else{
                        result += "&\(key)="
                    }
                    for elem in value as! [String]{
                        if firstItem {
                            result += "\(elem)"
                            firstItem = false
                        }else {
                            result += ",\(elem)"
                        }
                    }
                }else{
                    if result.isEmpty {
                        result += "\(key)=\(value)"
                    }else{
                        result += "&\(key)=\(value)"
                    }
                }
            }
            return result
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(url)?\(convertDictToString(params))")!)
        request.HTTPMethod = "GET"
        
        print("GET: \(url)?\(convertDictToString(params))")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
//            var result = NSString(data: data, encoding: NSASCIIStringEncoding)! as String
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 401 {
                    Http.login({ () -> Void in Http.get(url, params: params, callback: callback) })
                }else {
                    callback(data!)
                }
            }
        }
        task.resume()
    }

    static func post(url:String, params:[String:Any] = [:], callback: (NSData) -> Void) -> Void {
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = NSJSONSerialization.JSONObjectToData(params)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
//            var result = NSString(data: data, encoding: NSASCIIStringEncoding)! as String
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 401 {
                    Http.login { () -> Void in Http.post(url, params: params, callback: callback) }
                }else{
                    callback(data!)
                }
            }
        }
        task.resume()
    }
    
    static func put(url:String, params:[String:Any] = [:], callback: (String) -> Void) -> Void {
        print("")
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        request.HTTPMethod = "PUT"
        request.HTTPBody = NSJSONSerialization.JSONObjectToData(params)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        print("PUT: \(url)")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            let result = NSString(data: data!, encoding: NSASCIIStringEncoding)! as String
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 401 {
                    Http.login { () -> Void in Http.put(url, params: params, callback: callback) }
                }else{
                    callback(result)
                }
            }
        }
        task.resume()
    }
    
    static func delete(url:String, params:[String:Any] = [:], callback: (String) -> Void) -> Void {
        
        
        var err: NSError?
        
        func convertDictToString(dict: [String:Any]) -> String{
            var result = ""
            for (key, value) in dict {
                if let _ = value as? [ [String:String]] {
                    //value is simple dict Array
                }else if let _ = value as? [ [String:Any]]{
                    //value is complex dict array
                }else if let _ = value as? [String:Any]{
                    //value is complex dictionary
                }else if let _ = value as? [String: String]{
                    //value is simple dictionary
                }else if NSJSONSerialization.isArray(value as? AnyObject){
                    var firstItem = true
                    if result.isEmpty {
                        result += "\(key)="
                    }else{
                        result += "&\(key)="
                    }
                    for elem in value as! [String]{
                        if firstItem {
                            result += "\(elem)"
                            firstItem = false
                        }else {
                            result += ",\(elem)"
                        }
                    }
                }else{
                    if result.isEmpty {
                        result += "\(key)=\(value)"
                    }else{
                        result += "&\(key)=\(value)"
                    }
                }
            }
            return result
        }

        let request = NSMutableURLRequest(URL: NSURL(string: "\(url)?\(convertDictToString(params))")!)
        
        request.HTTPMethod = "DELETE"
        
        print("DELETE: \(url)")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            let result = NSString(data: data!, encoding: NSASCIIStringEncoding)! as String
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 401 {
                    Http.login { () -> Void in Http.put(url, params: params, callback: callback) }
                }else{
                    callback(result)
                }
            }
        }
        task.resume()
    }
}

extension NSJSONSerialization{

    static func JSONObjectToData(dict:[String:Any]) -> NSData?{
        let jsonString = dictToString(dict)
        
        return (jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    static func dictToString(dict: [String:Any]) -> String{
        var result = "{"
            for (key, value) in dict {
                if NSJSONSerialization.isArray(value as? AnyObject) {
                    if result == "{" {
                        result += "\"\(key)\":" + arrayToString(value as? AnyObject)
                    }else {
                        result += ",\"\(key)\":" + arrayToString(value as? AnyObject)
                    }
                } else if NSJSONSerialization.isDict(value as? AnyObject){
                    if result == "{" {
                        result += "\"\(key)\":" + NSJSONSerialization.unknownDictToString(value as? AnyObject)
                    }else{
                        result += ",\"\(key)\":" + NSJSONSerialization.unknownDictToString(value as? AnyObject)
                    }
                }else{
                    if result == "{" {
                        result += "\"\(key)\":\"\(value)\" "
                    }else{
                        result += ",\"\(key)\":\"\(value)\""
                    }
                }
            }
        
        return "\(result) }"
    }
    
    static func dictIntToString(dict: [String:Int]) -> String {
        var result = "{"
        for (key, value) in dict {
            if result == "{" {
                result += "\"\(key)\":\(value) "
            }else{
                result += ",\"\(key)\":\(value)"
            }
            
        }
        return result + "}"
    }
    
    static func dictDoubleToString(dict: [String:Double]) -> String {
        var result = "{"
        for (key, value) in dict {
            if result == "{" {
                result += "\"\(key)\":\(value) "
            }else{
                result += ",\"\(key)\":\(value)"
            }
            
        }
        return result + "}"
    }
    
    static func dictToString(dict: [String:String]) -> String {
        var result = "{"
        for (key, value) in dict {
            if result == "{" {
                result += "\"\(key)\":\"\(value)\" "
            }else{
                result += ",\"\(key)\":\"\(value)\""
            }
            
        }
        return result + "}"
    }

    static func isDict(obj: AnyObject?) -> Bool {
        if let _ = obj as? [String:AnyObject] {
            return true
        } else {
            return false
        }
    }
    
    static func unknownDictToString(obj: AnyObject?) -> String{
        if let o = obj as? [String:String] {
            return NSJSONSerialization.dictToString(o as [String:String])
        } else if let o = obj as? [String:Int] {
            return NSJSONSerialization.dictIntToString(o as [String:Int])
        } else if let o = obj as? [String:Double] {
            return NSJSONSerialization.dictDoubleToString(o as [String:Double])
        }else if let o = obj as? [String:AnyObject] {
            return NSJSONSerialization.dictToString(o as [String:Any])
        } else if let o = obj as? [String:Any] {
            return NSJSONSerialization.dictToString(o as [String:Any])
        } else {
            return "{}"
        }
    }
    
    static func isArray(obj: AnyObject?) -> Bool {
        if let _ = obj as? [AnyObject]{ return true } else
            if let _ = obj as? [String]{ return true } else
                if let _ = obj as? [Int]{ return true } else
                    if let _ = obj as? [Double]{ return true } else
                    if let _ = obj as? [Any]{ return true } else
                        if let _ = obj as? [ [String:AnyObject] ]{ return true } else
                            if let _ = obj as? [ [String:Any] ]{ return true } else
                                if let _ = obj as? [ [String:String] ]{ return true } else
                                    if let _ = obj as? [ [String:Int] ]{ return true } else
                                        if let _ = obj as? [ [String:Double] ]{ return true } else
                                            if let _ = obj as? [ [AnyObject] ]{ return true } else
                                                if let _ = obj as? [ [Any] ]{ return true } else
                                                    if let _ = obj as? [ [Int] ]{ return true } else
                                                        if let _ = obj as? [ [Double] ]{ return true } else
                                                            if let _ = obj as? [ [String] ]{ return true } else
                                                            {return false}
    }
    
    static func arrayToString(obj: AnyObject?) -> String {
        var result = "["
//        if let o = obj as? [AnyObject]{
//            for ob in o {
//                if result == "[" {
//                    result += "\(ob)"
//                }else {
//                    result += ",\(ob)"
//                }
//            }
//        } else
                if let o = obj as? [Int]{
                    for ob in o {
                        if result == "[" {
                            result += "\(ob)"
                        }else {
                            result += ",\(ob)"
                        }
                    }
                } else
                    if let o = obj as? [Double]{
                        for ob in o {
                            if result == "[" {
                                result += "\(ob)"
                            }else {
                                result += ",\(ob)"
                            }
                        }
                    } else if let o = obj as? [String]{
                            for ob in o {
                                if result == "[" {
                                    result += "\"\(ob)\""
                                }else {
                                    result += ",\"\(ob)\""
                                }
                            }
                        }
                        if let o = obj as? [Any]{
                            for ob in o {
                                if result == "[" {
                                    result += "\(ob)"
                                }else {
                                    result += ",\(ob)"
                                }
                            }
                        } else
                                    if let o = obj as? [ [String:String] ]{
                                        for ob in o {
                                            if result == "[" {
                                                result += NSJSONSerialization.dictToString(ob)
                                            }else {
                                                result += "," + NSJSONSerialization.dictToString(ob)
                                            }
                                        }
                                    } else
                                        if let o = obj as? [ [String:Int] ]{
                                            for ob in o {
                                                if result == "[" {
                                                    result += NSJSONSerialization.dictIntToString(ob)
                                                }else {
                                                    result += "," + NSJSONSerialization.dictIntToString(ob)
                                                }
                                            }
                                        } else
                                            if let o = obj as? [ [String:Double] ]{
                                                for ob in o {
                                                    if result == "[" {
                                                        result += NSJSONSerialization.dictDoubleToString(ob)
                                                    }else {
                                                        result += "," + NSJSONSerialization.dictDoubleToString(ob)
                                                    }
                                                }
                                            } else
                                                if let o = obj as? [ [String:AnyObject] ]{
                                                    for ob in o {
                                                        if result == "[" {
                                                            result += NSJSONSerialization.dictToString(ob as [String:Any])
                                                        }else {
                                                            result += "," + NSJSONSerialization.dictToString(ob as [String:Any])
                                                        }
                                                    }
                                                } else
                                                    if let o = obj as? [ [String:Any] ]{
                                                        for ob in o {
                                                            if result == "[" {
                                                                result += NSJSONSerialization.dictToString(ob as [String:Any])
                                                            }else {
                                                                result += "," + NSJSONSerialization.dictToString(ob as [String:Any])
                                                            }
                                                        }
                                                    } else
                                                if let o = obj as? [ [AnyObject] ]{
                                                    for ob in o {
                                                        if result == "[" {
                                                            result += NSJSONSerialization.arrayToString(ob as AnyObject)
                                                        }else {
                                                            result += "," + NSJSONSerialization.arrayToString(ob as AnyObject)
                                                        }
                                                    }
                                                } else
                                                    if let o = obj as? [ [Any] ]{
                                                        for ob in o {
                                                            if result == "[" {
                                                                result += NSJSONSerialization.arrayToString(ob as? AnyObject)
                                                            }else {
                                                                result += "," + NSJSONSerialization.arrayToString(ob as? AnyObject)
                                                            }
                                                        }
                                                    } else
                                                        if let o = obj as? [ [Int] ]{
                                                            for ob in o {
                                                                if result == "[" {
                                                                    result += NSJSONSerialization.arrayToString(ob as AnyObject)
                                                                }else {
                                                                    result += "," + NSJSONSerialization.arrayToString(ob as AnyObject)
                                                                }
                                                            }
                                                        } else
                                                            if let o = obj as? [ [Double] ]{
                                                                for ob in o {
                                                                    if result == "[" {
                                                                        result += NSJSONSerialization.arrayToString(ob as AnyObject)
                                                                    }else {
                                                                        result += "," + NSJSONSerialization.arrayToString(ob as AnyObject)
                                                                    }
                                                                }
                                                            } else
                                                                if let o = obj as? [ [String] ]{
                                                                    for ob in o {
                                                                        if result == "[" {
                                                                            result += NSJSONSerialization.arrayToString(ob as AnyObject)
                                                                        }else {
                                                                            result += "," + NSJSONSerialization.arrayToString(ob as AnyObject)
                                                                        }
                                                                    }
                                                                }
        
        return result + "]"
    }
    
}

