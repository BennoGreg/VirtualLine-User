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
    
    
//    var isLoggedIn = UserDefaultsConfig.isLoggedIn
    var user: User?
    var phoneNumber = UserDefaultsConfig.userPhoneNumber
    var userFirstName = UserDefaultsConfig.userFirstName
    var userLastName = UserDefaultsConfig.userLastName
//    public func updateLogInStatus(loggedIn: Bool) {
//        
//        isLoggedIn = loggedIn
//        UserDefaultsConfig.isLoggedIn = loggedIn
//    
//        
//    }
    
    public func getFullName() -> String {
        return "\(userFirstName) \(userLastName)"
    }
    
    public func updateUserInfo() {
        
        userFirstName = UserDefaultsConfig.userFirstName
        userLastName = UserDefaultsConfig.userLastName
        phoneNumber = UserDefaultsConfig.userPhoneNumber
        if let userID = Auth.auth().currentUser?.uid {
       
            db.collection("user").document(userID).updateData(["name":"\(userFirstName) \(userLastName)"])
           
        }
        
        
    }
    public static let shared = CredentialsController()
    
    private init() {}
}
