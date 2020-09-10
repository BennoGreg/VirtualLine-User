//
//  PhoneLoginViewController.swift
//  VirtualLine User
//
//  Created by Niklas Wagner on 10.09.20.
//  Copyright © 2020 Benedikt. All rights reserved.
//

import Foundation

class PhoneLoginViewController: ViewController {
    
    let viewModel = PhoneLoginViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        
        parent?.title = "Login"
        
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
}
