//
//  ServerCommunication.swift
//  VirtualLine User
//
//  Created by Niklas Wagner on 02.06.20.
//  Copyright © 2020 Benedikt. All rights reserved.
//

import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFunctions
import Foundation

var db: Firestore!
var ref: DocumentReference?
var functions = Functions.functions(region: "europe-west1")
var userID: String = ""

func setUpFirebase() {
    let settings = FirestoreSettings()

    Firestore.firestore().settings = settings
    // [END setup]
    db = Firestore.firestore()
}

func userEnqueue(queueID: String, userID: String, completion: @escaping () -> Void) {
    let dataDict: [String: Any] = ["id": queueID, "reference": userID]

    functions.httpsCallable("putReference").call(dataDict) { result, error in
        if let error = error as NSError? {
            completion()
            if error.domain == FunctionsErrorDomain {
                let code = FunctionsErrorCode(rawValue: error.code)
                let message = error.localizedDescription
                let details = error.userInfo[FunctionsErrorDetailsKey]
                print(message, details)
                
            }
            
            // ...
        } else if let result = result {
            print("RESULT: \(result.data)")
            completion()
        }
    }
}

func userDequeue(queueID: String, userID: String) {
    guard let userPosition = CredentialsController.shared.user?.numberInQueue else { return }
    let dataDict: [String: Any] = ["id": queueID, "reference": userID, "position": userPosition]

    functions.httpsCallable("deleteReference").call(dataDict) { _, error in
        if let error = error as NSError? {
            if error.domain == FunctionsErrorDomain {
                let code = FunctionsErrorCode(rawValue: error.code)
                let message = error.localizedDescription
                let details = error.userInfo[FunctionsErrorDetailsKey]
                print(message, details)
               
            }
            // ...
        }
    }
}
