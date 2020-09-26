//
//  Data.swift
//  VirtualLine User
//
//  Created by Niklas Wagner on 16.05.20.
//  Copyright © 2020 Benedikt. All rights reserved.
//

import UIKit

class QueuesData {
    
    var allQueues: [Queue] = [
        .init(name: "", queueCount: 20, timePerCustomer: 20)
     ]
     
     var currentQueues: [Queue]?
    
   public static let shared = QueuesData()
    
    private init(){}
    
    
    
}



