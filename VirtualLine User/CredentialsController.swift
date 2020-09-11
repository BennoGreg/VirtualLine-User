//
//  CredentialsController.swift
//  VirtualLine User
//
//  Created by Niklas Wagner on 10.09.20.
//  Copyright © 2020 Benedikt. All rights reserved.
//

import Foundation

class CredentialsController {
    
    
    var isLoggedIn = UserDefaultsConfig.isLoggedIn
    public func updateLogInStatus(loggedIn: Bool) {
        
        isLoggedIn = loggedIn
        UserDefaultsConfig.isLoggedIn = loggedIn
        
    }
    public static let shared = CredentialsController()
    
    private init() {}
    
}
