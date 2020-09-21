//
//  User.swift
//  VirtualLine User
//
//  Created by Niklas Wagner on 12.09.20.
//  Copyright © 2020 Benedikt. All rights reserved.
//
import FirebaseFirestoreSwift
import Firebase

struct User: Codable, Identifiable {
 
    @DocumentID var id: String?
    let name: String?
    let queueID: DocumentReference?
    let numberInQueue: Int?
    let customerQueueID: Int?
}
