//
//  DataDownloader.swift
//  CloudAPI
//
//  Created by Partha Gudivada on 11/1/15.
//  Copyright © 2015 Partha. All rights reserved.
//

import UIKit

typealias DataDownloaderCompletion = (data: NSData?, response: NSURLResponse?, error: NSError?) -> ()



class DataDownloader: NSObject,  NSURLSessionDataDelegate  {
   
    let config: NSURLSessionConfiguration? = {
        
        let cfg = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let appId = "Your appId"
        let appToken = "Your App Token"
        
        let userNamePasswordString = "\(appId)\(appToken)"
        guard let userNamePasswordData = userNamePasswordString.dataUsingEncoding(NSUTF8StringEncoding) else { return nil }
        let base64EncodedCredential = userNamePasswordData.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn)
        let authHeader = "Basic \(base64EncodedCredential)"
        cfg.HTTPAdditionalHeaders = ["Accept" : "application/json", "Authorization" : authHeader]
        return cfg
    }()
    
    lazy var session: NSURLSession? = {
        let queue = NSOperationQueue.mainQueue()
        guard let config = self.config else { return nil }
        return NSURLSession(configuration: config, delegate: self, delegateQueue: queue)
    }()
    
    func download(s: String, completionHandler ch: DataDownloaderCompletion) -> NSURLSessionTask?  {
      
        let url = NSURL(string: s)!
        let req = NSMutableURLRequest(URL: url)
      
        guard let task = self.session?.dataTaskWithRequest(req, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            ch(data: data ,response: response, error: error)
        }) else { return nil }
   
        task.resume()
        return task
    }
    
    func cancelAllTasks() {
        self.session?.invalidateAndCancel()
    }
}

