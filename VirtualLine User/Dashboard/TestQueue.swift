//
//  Queue.swift
//  VirtualLine User
//
//  Created by Niklas Wagner on 16.05.20.
//  Copyright © 2020 Benedikt. All rights reserved.
//

import UIKit
import FirebaseFirestoreSwift

struct TestQueue{
    
    let name: String
    var waitingTime: Int
    var queueLength: Int
    
}

struct Queue: Codable, Identifiable {
    
    @DocumentID var id: String?
    let name: String
    let queueCount: Int
    let timePerCustomer: Int
}
