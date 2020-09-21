//
//  CredentialsController.swift
//  VirtualLine User
//
//  Created by Niklas Wagner on 10.09.20.
//  Copyright © 2020 Benedikt. All rights reserved.
//
import Firebase
import Foundation

class CredentialsController {
    
    
    var isLoggedIn = UserDefaultsConfig.isLoggedIn
    var user: User?
    var userFirstName = UserDefaultsConfig.userFirstName
    var userLastName = UserDefaultsConfig.userLastName
    public func updateLogInStatus(loggedIn: Bool) {
        
        isLoggedIn = loggedIn
        UserDefaultsConfig.isLoggedIn = loggedIn
    
        
    }
    public func updateName() {
        
        userFirstName = UserDefaultsConfig.userFirstName
        userLastName = UserDefaultsConfig.userLastName
        
        if let userID = user?.id {
            
            db.collection("user").document(userID).updateData(["name":"\(userFirstName) \(userLastName)"])
           
        }
        
        
    }
    public static let shared = CredentialsController()
    
    private init() {}
}
