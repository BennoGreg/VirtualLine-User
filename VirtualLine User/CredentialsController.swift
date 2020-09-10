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
    
    public static let shared = CredentialsController()
    
    private init() {}
    
}
