//
//  CompanyViewController.swift
//  VirtualLine User
//
//  Created by Niklas Wagner on 22.05.20.
//  Copyright © 2020 Benedikt. All rights reserved.
//

import FirebaseAuth
import UIKit

class CompanyViewController: UIViewController {
    @IBOutlet var ticketView: UIView!

    @IBOutlet weak var customerWaitingTimeTitleLabel: UILabel!
    @IBOutlet weak var customerQueueIDTitleLabel: UILabel!
    @IBOutlet weak var customerPositionTitleLabel: UILabel!
    @IBOutlet var queueLengthLabel: UILabel!
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var waitingTimeLabel: UILabel!
    var currentCompanyQueue: Queue?
    @IBOutlet var queueUpButton: UIButton!
    var queuedUp = false
    @IBOutlet var queueInfoLabel: UILabel!
    var buttonPostition = ButtonPosition.up

    @IBOutlet weak var customerWaitingTimeLabel: UILabel!
    @IBOutlet weak var customerPositionLabel: UILabel!
    @IBOutlet weak var customerQueueIDLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
       
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // corner radius

        
        customerPositionLabel.isHidden = true
        customerWaitingTimeLabel.isHidden = true
        customerQueueIDLabel.isHidden = true
        customerPositionTitleLabel.isHidden = true
        customerWaitingTimeTitleLabel.isHidden = true
        customerQueueIDTitleLabel.isHidden = true
        ticketView.layer.cornerRadius = 10
        companyNameLabel.text = currentCompanyQueue?.name
        if let queueCount = currentCompanyQueue?.queueCount, let timePerCustomer = currentCompanyQueue?.timePerCustomer {
            waitingTimeLabel.text = String(queueCount * timePerCustomer)
            queueLengthLabel.text = String(queueCount)
        }

        queueUpButton.backgroundColor = UIColor(named: "virtualLineColor")
        queueUpButton.layoutIfNeeded()
        queueUpButton.layer.cornerRadius = queueUpButton.frame.height / 2
        queueInfoLabel.text = ""
          queueUpButton.isEnabled = true
          queueUpButton.titleLabel?.font = .systemFont(ofSize: 16)

        if Auth.auth().currentUser == nil {
                   
            queueUpButton.setTitle("Bitte einloggen um anzustellen.", for: .disabled)
            queueUpButton.isEnabled = false
            queueUpButton.titleLabel?.font = .systemFont(ofSize: 12)

            }
               
        updateMask()
        evaluateButtonPostition()
     
    }

    public func evaluateButtonPostition() {
        if CredentialsController.shared.user?.queueID != nil &&
            CredentialsController.shared.user?.queueID?.documentID == currentCompanyQueue?.id {
            
            updateEnqueuedValuesUI()
                                    
            UIView.animate(withDuration: 0, animations: {
                self.queueUpButton.center.y = self.queueUpButton.center.y + 100
              
            }) { _ in

//                if let layer = self.queueUpButton.layer.sublayers?.first {
//                    layer.removeFromSuperlayer()
//                }
                self.queueUpButton.applyGradient(colors: [CompanyViewController.UIColorFromRGB(0xCC0000).cgColor, CompanyViewController.UIColorFromRGB(0x990000).cgColor])
                self.queueUpButton.setTitle("Warteschlange verlassen", for: .normal)
                
            }
        }
    }
    
    func updateEnqueuedValuesUI() {
        buttonPostition = .down
        queuedUp = true
        customerPositionLabel.isHidden = false
        customerWaitingTimeLabel.isHidden = false
        customerQueueIDLabel.isHidden = false
        customerPositionLabel.textColor = .lightGray
        customerWaitingTimeLabel.textColor = .lightGray
        customerQueueIDLabel.textColor = .lightGray
        
        customerPositionTitleLabel.isHidden = false
        customerWaitingTimeTitleLabel.isHidden = false
        customerQueueIDTitleLabel.isHidden = false
        customerPositionTitleLabel.textColor = .lightGray
        customerWaitingTimeTitleLabel.textColor = .lightGray
        customerQueueIDTitleLabel.textColor = .lightGray
        
        if let queueCount = currentCompanyQueue?.queueCount, let timePerCustomer = currentCompanyQueue?.timePerCustomer {
            waitingTimeLabel.text = String(queueCount * timePerCustomer)
            queueLengthLabel.text = String(queueCount)
        }
        
        if let customerQueueID = CredentialsController.shared.user?.customerQueueID, let timePerCustomer =  QueuesData.shared.currentQueues?.first?.timePerCustomer, let customerPosititon = CredentialsController.shared.user?.numberInQueue {
            
            let waitingTime = timePerCustomer*(customerPosititon-1)
            customerQueueIDLabel.text = "\(customerQueueID)"
            customerWaitingTimeLabel.text = "\(waitingTime) min"
            customerPositionLabel.text = String(customerPosititon)
            
        }

    }

    @IBAction func queueButtonPressed(_ sender: UIButton) {
        if !UserDefaultsConfig.notifcationsEnabled {
            presentNotificationAlert()

        } else {
            if let id = currentCompanyQueue?.id, let userID = Auth.auth().currentUser?.uid {
                if queuedUp {
                    handleDequeue(queueId: id, userID: userID)

                } else {
                    
                    if buttonPostition == .up && CredentialsController.shared.user?.queueID != nil {
                        presentAlreadyQueuedUpAlert()
                    } else {
                        handleQueueUp(queueId: id, userID: userID)
                        
                    }
                }
            }
        }
    }
    func presentAlreadyQueuedUpAlert() {
        
        let alert = UIAlertController(title: "Anstellen nicht möglich.", message: "Sie befinden sich derzeit schon in einer Warteschlange.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
        }))
        present(alert, animated: true, completion: nil)
        
    }

    func presentNotificationAlert() {
        let alert = UIAlertController(title: "Benachrichtigugen einschalten.", message: "Bitte aktivieren Sie die Benachrichtigungen in den Einstellungen um sich bei einer Warteschlange anstellen zu können", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
        }))
        present(alert, animated: true, completion: nil)
    }

    func handleQueueUp(queueId: String, userID: String) {
        userEnqueue(queueID: queueId, userID: userID) {
            self.updateEnqueuedValuesUI()
        }

        queuedUp.toggle()
        // add queue to current queue
        if let curQueue = currentCompanyQueue {
            if QueuesData.shared.currentQueues == nil {
                QueuesData.shared.currentQueues = [Queue]()
                QueuesData.shared.currentQueues?.append(curQueue)
            } else {
                QueuesData.shared.currentQueues?.append(curQueue)
            }
        }
        self.updateEnqueuedValuesUI()

        UIView.animate(withDuration: 0.8, animations: {
           
           
        }) { _ in

            self.queueUpButton.center.y = self.queueUpButton.center.y + 100
//            if let layer = self.queueUpButton.layer.sublayers?.first {
//                layer.removeFromSuperlayer()
//            }
            self.queueUpButton.applyGradient(colors: [CompanyViewController.UIColorFromRGB(0xCC0000).cgColor, CompanyViewController.UIColorFromRGB(0x990000).cgColor])
            self.queueUpButton.setTitle("Warteschlange verlassen", for: .normal)

        }
        self.updateEnqueuedValuesUI()

    }

    func handleDequeue(queueId: String, userID: String) {
         
       
        
        let alert = UIAlertController(title: "Warteschlange verlassen", message: "Möchten Sie wirklich die Warteschlange verlassen?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ja", style: UIAlertAction.Style.default, handler: { _ in

            self.customerPositionLabel.isHidden = true
            self.customerWaitingTimeLabel.isHidden = true
            self.customerQueueIDLabel.isHidden = true
            self.customerPositionTitleLabel.isHidden = true
            self.customerWaitingTimeTitleLabel.isHidden = true
            self.customerQueueIDTitleLabel.isHidden = true
            
            userDequeue(queueID: queueId, userID: userID)
            self.buttonPostition = .up
          
            
            UIView.animate(withDuration: 0.8, animations: {
                self.queueUpButton.center.y = self.queueUpButton.center.y - 100
            }) { _ in

                if let layer = self.queueUpButton.layer.sublayers?.first { // The first sublayer of
                    layer.removeFromSuperlayer()
                }
                self.queueUpButton.backgroundColor = UIColor(named: "virtualLineColor")
                self.queueUpButton.layoutIfNeeded()
                self.queueUpButton.layer.cornerRadius = self.queueUpButton.frame.height / 2
                self.queueUpButton.setTitle("Jetzt anstellen", for: .normal)
                self.queueInfoLabel.text = ""
            }
            self.queuedUp.toggle()

        }))
        alert.addAction(UIAlertAction(title: "Abbrechen", style: UIAlertAction.Style.cancel, handler: { _ in
        }))

        present(alert, animated: true, completion: nil)
    }

    private func updateMask() {
        let leftCenter = CGPoint(x: ticketView.bounds.minX, y: ticketView.bounds.midY - 60)
        let rightCenter = CGPoint(x: ticketView.bounds.maxX, y: ticketView.bounds.midY - 60)

        let path = UIBezierPath(rect: ticketView.bounds)
        let path2 = UIBezierPath(rect: ticketView.bounds)

        path.addArc(withCenter: leftCenter, radius: 20, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        path2.addArc(withCenter: rightCenter, radius: 20, startAngle: 0, endAngle: 2 * .pi, clockwise: true)

        path.append(UIBezierPath(rect: ticketView.bounds))
        path.append(path2)

        let mask = CAShapeLayer()
        mask.fillRule = .evenOdd
        mask.path = path.cgPath

        ticketView.layer.mask = mask

        let layer = CAShapeLayer()
        let path3 = UIBezierPath()
        path3.move(to: CGPoint(x: ticketView.bounds.minX, y: ticketView.bounds.midY - 60))
        path3.addLine(to: CGPoint(x: ticketView.bounds.maxX, y: ticketView.bounds.midY - 60))

        layer.path = path3.cgPath
        layer.lineWidth = 5
        layer.strokeColor = UIColor.lightGray.cgColor // Set Dashed line Color
        layer.lineDashPattern = [7, 7] // Here you set line length
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        ticketView.layer.addSublayer(layer)
    }

    private func updateMaskTry1() {
        let path = UIBezierPath()
        path.move(to: ticketView.bounds.origin)
        let center = CGPoint(x: ticketView.bounds.minX, y: ticketView.bounds.midY)
        path.addArc(withCenter: center, radius: 20, startAngle: .pi, endAngle: 0, clockwise: false)
        path.addLine(to: CGPoint(x: ticketView.bounds.maxX, y: ticketView.bounds.minY))
        path.addLine(to: CGPoint(x: ticketView.bounds.maxX, y: ticketView.bounds.maxY))
        path.addLine(to: CGPoint(x: ticketView.bounds.minX, y: ticketView.bounds.maxY))
        path.close()

        let mask = CAShapeLayer()
        mask.path = path.cgPath

        ticketView.layer.mask = mask
    }

    /*
     func applySemiCircleEffect(givenView: UIView){
         let shapeLayer = CAShapeLayer(layer: givenView.layer)
         shapeLayer.path = self.pathSemiCirclesPathForView(givenView: givenView).cgPath
         shapeLayer.frame = givenView.bounds
         shapeLayer.masksToBounds = true
         shapeLayer.shadowOpacity = 1
         shapeLayer.shadowColor = UIColor.black.cgColor
         shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
         shapeLayer.shadowRadius = 3

         givenView.layer.mask = shapeLayer
     }

     func pathSemiCirclesPathForView(givenView: UIView, ciclesRadius:CGFloat = 10, circlesDistance : CGFloat = 2) ->UIBezierPath
     {
         let width = givenView.frame.size.width
         let height = givenView.frame.size.height

         let semiCircleWidth = CGFloat(ciclesRadius*2)

         let semiCirclesPath = UIBezierPath()
         semiCirclesPath.move(to: CGPoint(x:0, y:0))

         var x = CGFloat(0)
         var i = 0
         while x < width {
             x = (semiCircleWidth) * CGFloat(i) + (circlesDistance * CGFloat(i))
             let pivotPoint = CGPoint(x: x + semiCircleWidth/2, y: height)
             semiCirclesPath.addArc(withCenter: pivotPoint, radius: ciclesRadius, startAngle: -180 * .pi / 180.0, endAngle: 0 * .pi / 180.0, clockwise: true)
             semiCirclesPath.addLine(to: CGPoint(x: semiCirclesPath.currentPoint.x + circlesDistance, y: height))
             i += 1
         }

         semiCirclesPath.addLine(to: CGPoint(x:width,y: 0))

         i = 0
         while x > 0 {
             x = width - (semiCircleWidth) * CGFloat(i) - (circlesDistance * CGFloat(i))
             let pivotPoint = CGPoint(x: x - semiCircleWidth/2, y: 0)
             semiCirclesPath.addArc(withCenter: pivotPoint, radius: ciclesRadius, startAngle: 0 * .pi / 180.0, endAngle: -180 * .pi / 180.0, clockwise: true)
             semiCirclesPath.addLine(to: CGPoint(x: semiCirclesPath.currentPoint.x - circlesDistance, y: 0))
             i += 1
         }

         semiCirclesPath.close()
         return semiCirclesPath
     }
     */

    static func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
        return UIColor(red: (CGFloat)((rgbValue & 0xFF0000) >> 16) / 255.0, green: (CGFloat)((rgbValue & 0x00FF00) >> 8) / 255.0, blue: (CGFloat)(rgbValue & 0x0000FF) / 255.0, alpha: 1.0)
    }
}

extension UIButton {
    func applyGradient(colors: [CGColor]) {
        backgroundColor = nil
        layoutIfNeeded()
        layer.cornerRadius = frame.height / 2

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = frame.height / 2

        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.masksToBounds = false
        layer.insertSublayer(gradientLayer, at: 0)
        contentVerticalAlignment = .center
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        titleLabel?.textColor = UIColor.white
    }
}

public enum ButtonPosition {
    case up
    case down
}
