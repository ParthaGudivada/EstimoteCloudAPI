//
//  DataViewController.swift
//  CloudAPI
//
//  Created by Partha Gudivada on 11/1/15.
//  Copyright © 2015 Partha. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    var task: NSURLSessionTask?
    var dataDownloader: DataDownloader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataDownloader = DataDownloader()
        
        task = self.dataDownloader.download(EstimoteCloudURI.aboutBeacons) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> () in
            
            if let error = error {
                print("error in retrieving becons associated with your account : \(error.localizedDescription)")
            } else {
                guard let data = data else { return }
                guard let outputString = String(data: data, encoding: NSUTF8StringEncoding) else { return }
                print("\(outputString)")
            }
        }
    }
    
    deinit {
        self.dataDownloader.cancelAllTasks()
    }
        


}
