//
//  PhoneLoginViewController.swift
//  VirtualLine User
//
//  Created by Niklas Wagner on 10.09.20.
//  Copyright © 2020 Benedikt. All rights reserved.
//

import UIKit

class PhoneLoginViewController: ViewController {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var confirmNumberButton: UIButton!
    @IBOutlet weak var verificationCodeLabel: UILabel!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    @IBOutlet weak var confirmVerificationButton: UIButton!
    
    let viewModel = PhoneLoginViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.parent?.title = "Login"
         navigationItem.largeTitleDisplayMode = .always
         self.navigationController?.navigationBar.prefersLargeTitles = true
        verificationCodeLabel.isHidden = true
        verificationCodeTextField.isHidden = true
        confirmVerificationButton.isHidden = true
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    @IBAction func confirmNumberButtonPressed(_ sender: UIButton) {
        
        guard let number = phoneNumberTextField.text else {return}
        
        if Validation.isValidPhoneNumber(text: number) {
            
            viewModel.sendVerificationCodeTo(phoneNumber: number)
            
            verificationCodeLabel.isHidden = false
            verificationCodeTextField.isHidden = false
            confirmVerificationButton.isHidden = false
        }
    }
    @IBAction func confirmVerificationButtonClicked(_ sender: UIButton) {
        
        guard let code = verificationCodeTextField.text else {return}
        if viewModel.checkVerificationCode(code: code) {
            
            
            CredentialsController.shared.updateLogInStatus(loggedIn: true)
           
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            
            
        }
        
    }
}
