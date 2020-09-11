//
//  PhoneAuthentication.swift
//  VirtualLine User
//
//  Created by Benedikt Langer on 10.09.20.
//  Copyright © 2020 Benedikt. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class PhoneAuthentication{
    
    public static var instance = PhoneAuthentication()
    private let keyForVerificationID = "AuthVerificatonID"
    var verificationID = ""
    var isMFAEnabled = true
    
    private init(){}
    
    func verifyPhoneNumber(phoneNumber: String){
        
        
        Auth.auth().languageCode = "de"
        let staticPhoneNr = "+4367681420786"
        PhoneAuthProvider.provider().verifyPhoneNumber(staticPhoneNr, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print("Unable to get Verification: \(error)")
            }else {
                guard let verificationID = verificationID else { return }
                self.verificationID = verificationID
                UserDefaults.standard.set(verificationID, forKey: self.keyForVerificationID)
            }
        }
    }
    
    func verifyWithOTP(verificationCode: String) {
        
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "Some default text"
        }
        
        if verificationID == "" {
            verificationID = UserDefaults.standard.string(forKey: keyForVerificationID) ?? ""
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            let authError = error as NSError
            if (self.isMFAEnabled && authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
              // The user is a multi-factor user. Second factor challenge is required.
              let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
              var displayNameString = ""
              for tmpFactorInfo in (resolver.hints) {
                displayNameString += tmpFactorInfo.displayName ?? ""
                displayNameString += " "
              }
//              self.showTextInputPrompt(withMessage: "Select factor to sign in\n\(displayNameString)", completionBlock: { userPressedOK, displayName in
//                var selectedHint: PhoneMultiFactorInfo?
//                for tmpFactorInfo in resolver.hints {
//                  if (displayName == tmpFactorInfo.displayName) {
//                    selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
//                  }
//                }
//                PhoneAuthProvider.provider().verifyPhoneNumber(with: selectedHint!, uiDelegate: nil, multiFactorSession: resolver.session) { verificationID, error in
//                  if error != nil {
//                    print("Multi factor start sign in failed. Error: \(error.debugDescription)")
//                  } else {
//                    self.showTextInputPrompt(withMessage: "Verification code for \(selectedHint?.displayName ?? "")", completionBlock: { userPressedOK, verificationCode in
//                      let credential: PhoneAuthCredential? = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verificationCode!)
//                      let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator.assertion(with: credential!)
//                      resolver.resolveSignIn(with: assertion!) { authResult, error in
//                        if error != nil {
//                          print("Multi factor finanlize sign in failed. Error: \(error.debugDescription)")
//                        } else {
//                          self.navigationController?.popViewController(animated: true)
//                        }
//                      }
//                    })
//                  }
//                }
//              })
            } else {
                print(error.localizedDescription)
//              self.showMessagePrompt(error.localizedDescription)
              return
            }
            // ...
            return
          }
          // User is signed in
          // ...
        }
    }
    
//    func showTextInputPrompt(withMessage message: String,
//                               completionBlock: @escaping ((Bool, String?) -> Void)) {
//        let prompt = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
//          completionBlock(false, nil)
//        }
//        weak var weakPrompt = prompt
//        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
//          guard let text = weakPrompt?.textFields?.first?.text else { return }
//          completionBlock(true, text)
//        }
//        prompt.addTextField(configurationHandler: nil)
//        prompt.addAction(cancelAction)
//        prompt.addAction(okAction)
//        present(prompt, animated: true, completion: nil)
//      }
    
    
//    func showMessagePrompt(_ message: String) {
//        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(okAction)
//        present(alert, animated: false, completion: nil)
//      }
}
