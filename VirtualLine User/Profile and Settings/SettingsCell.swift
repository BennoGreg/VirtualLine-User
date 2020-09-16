//
//  SettingsCell.swift
//  VirtualLine User
//
//  Created by Niklas Wagner on 24.05.20.
//  Copyright © 2020 Benedikt. All rights reserved.
//

 import UIKit
import Firebase
import FirebaseFirestore
import UserNotifications
import FirebaseAuth
import FirebaseMessaging
import FirebaseCore

 class SettingsCell: UITableViewCell {
     
     // MARK: - Properties
    
    var sectionType: SectionType? {
        didSet{
            guard let sectionType = sectionType else {return}
            
            switchControl.isHidden = !sectionType.containsSwitch

            textLabel?.text = sectionType.description
        }
    }
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()

        if UserDefaultsConfig.notifcationsEnabled {
            switchControl.isOn = true
        }else {
            switchControl.isOn = false
        }
        //switchControl.onTintColor = UIColor(displayP3Red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        switchControl.translatesAutoresizingMaskIntoConstraints = false;
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        return switchControl
    }()
     
     // MARK: - Init
     
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
        //addSubview(switchControl)
        accessoryView = switchControl
        if let view = accessoryView {
            addSubview(view)
        }
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
     }
    
  
     
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    // MARK: - Selectors
    
    @objc func handleSwitchAction(sender: UISwitch){
        
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
     //   if let tokenData = Messaging.messaging().apnsToken {
        var token = ""
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let result = result {
                
                token = result.token
                print(token)
                       if sender.isOn {
                           UserDefaultsConfig.notifcationsEnabled = true
                           if let userID = user?.uid {
                               db.collection("user").document(userID).updateData(["deviceToken": token, "pushEnabled": true])
                           }
                           print("Turned on")
                       }else{
                            UserDefaultsConfig.notifcationsEnabled = false
                           if let userID = user?.uid {
                             db.collection("user").document(userID).updateData(["deviceToken": "", "pushEnabled": false])
                           }
                           print("Turned off")
                       }
                
            }
        }
           
     //   }
        
        
    }
     
 }

