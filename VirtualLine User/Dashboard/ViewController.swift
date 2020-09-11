//
//  ViewController.swift
//  VirtualLine User
//
//  Created by Benedikt Langer on 04.05.20.
//  Copyright © 2020 Benedikt. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    var selectedQueue: Queue?

    
 
    @IBOutlet weak var queueCollectionView: UICollectionView!
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.parent?.title = "Virtual Line"
       navigationItem.largeTitleDisplayMode = .always
       self.navigationController?.navigationBar.prefersLargeTitles = true
     
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]


        
        setUpFirebase()
   
        getAllQueues()
    }
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    func getAllQueues() {
        
        let db = Firestore.firestore()
        let docRef = db.collection("queue")

        docRef.addSnapshotListener { [weak self] snapshot, error in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                if let documents = snapshot?.documents {
                    var queues = [Queue]()
                    for document in documents {
                        do {
                            if let queue = try document.data(as: Queue.self) {
                                queues.append(queue)
                            }
                        } catch let error as NSError {
                            print("error: \(error)")
                        }
                    }
                    self?.updateViewWithQueues(queues: queues)
                }
            }
            
        }
    }
   
    func updateViewWithQueues(queues: [Queue])  {
        
        QueuesData.shared.allQueues = queues
        queueCollectionView?.reloadData()
        
        
    }
    
     // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        if indexPath.section == 0 && QueuesData.shared.currentQueues != nil {
            
            if let currentQueue = QueuesData.shared.currentQueues?[indexPath.row]{
             
                
            selectedQueue = currentQueue
            performSegue(withIdentifier: Segues.queueDetailsSegue, sender: nil)
            }
            
        }else if indexPath.section == 1 {
            selectedQueue = QueuesData.shared.allQueues[indexPath.row]
            performSegue(withIdentifier: Segues.companyDetailSegue, sender: nil)
        }
        
      }

      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.queueDetailsSegue {
              let vc = segue.destination as! CompanyViewController // TODO: Details vs
              let detailsVC = vc.self
              detailsVC.currentCompanyQueue = selectedQueue
        }else if segue.identifier == Segues.companyDetailSegue {
            let vc = segue.destination as! CompanyViewController
            let detailsVC = vc.self
            detailsVC.currentCompanyQueue = selectedQueue
        }
      }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
           return 2
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return QueuesData.shared.currentQueues?.count ?? 0
        }else {
            return QueuesData.shared.allQueues.count
        }
    }
    
  
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        
        if indexPath.section == 0 && QueuesData.shared.currentQueues != nil {

            let cell: QueueCell = collectionView.dequeueReusableCell(withReuseIdentifier: "queueCell", for: indexPath) as! QueueCell
            cell.update(queueName: QueuesData.shared.currentQueues![indexPath.row].name, queueTime: QueuesData.shared.currentQueues![indexPath.row].timePerCustomer * QueuesData.shared.currentQueues![indexPath.row].queueCount, queueLength: QueuesData.shared.currentQueues![indexPath.row].queueCount)
           
            updateCellLayout(cell: cell)
             return cell

        }else  {
            
            let cell: CompanyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "companyCell", for: indexPath) as! CompanyCell
            cell.update(companyName: QueuesData.shared.allQueues[indexPath.row].name)
             updateCellLayout(cell: cell)
            return cell
        
        }
    }
    
    // Section Header View
       func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
           let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "QueueSectionHeader", for: indexPath) as! QueueSectionHeader
        
        
        if indexPath.section == 0 && QueuesData.shared.currentQueues != nil {
            
        sectionHeaderView.update(sectionName: "Aktuelle Warteschlange")
        }
//        else if indexPath.section == 0 && QueuesData.shared.currentQueues == nil {
//
//        sectionHeaderView.update(sectionName: "")
//
//        }
        else if indexPath.section == 1 {
            
        sectionHeaderView.update(sectionName: "Warteschlangen in der Nähe")
            
        }
        
           return sectionHeaderView
       }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 && QueuesData.shared.currentQueues == nil {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 && QueuesData.shared.currentQueues == nil {
            return CGSize(width: 0, height: 0)
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 65)
        }
    }
    
    
    func updateCellLayout(cell: UICollectionViewCell){
       
        cell.layer.cornerRadius = 10
       // cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
       
      
//       cell.layer.shadowColor = UIColor.gray.cgColor
//       cell.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
//       cell.layer.shadowRadius = 1.0
//       cell.layer.shadowOpacity = 1.0
//       cell.layer.masksToBounds = false
    }
    
    


}

// Extension to adjust Cell size according to section
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if (indexPath.section == 0){
            if QueuesData.shared.currentQueues != nil {
                return CGSize(width: 180, height: 180)
            } else {
                return CGSize(width: 0, height: 0)
            }
        } else {
            return CGSize(width: 110, height: 110)

        }
    
}
}

