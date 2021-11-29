//
//  TimerProtocol.swift
//  Donor
//
//  Created by кит on 26/10/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import Firebase

enum timers: String {
    case timer0 = "Timer0ViewController"
    case timer1 = "Timer1ViewController"
    case timer2 = "Timer2ViewController"
    case timer = "TimerViewController"
    case unknowned = "unknowned"
}

protocol TimerProtocol: UIViewController {
    func deleteDonation()
    var firebaseService: FirebaseService { get set }
}

extension TimerProtocol {

    func settingsRemove () {
        UserSettings.removeUserDonation()
    }
    
    func updateDocument() {
        firebaseService.updateDocumentFromTimerVC()
    }
    
    func deleteDonation () {
        let refreshAlert = UIAlertController(title: "Удаление записи", message: "Вы уверены?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Удалить", style: .default, handler: { (action: UIAlertAction!) in
            if let identifier = UserSettings.userModel.place {
                let center = UNUserNotificationCenter.current(); center.removePendingNotificationRequests(withIdentifiers:[identifier])
            }
            if let identifierDay = UserSettings.userName {
                let center = UNUserNotificationCenter.current(); center.removePendingNotificationRequests(withIdentifiers:[identifierDay])
            }
            // work with Calendar Events
            let eventStore = EKEventStore()
            let predic = eventStore.predicateForEvents(withStart: UserSettings.userModel.date!, end: UserSettings.userModel.date!.addingTimeInterval(2 * 60), calendars: nil)
            let eV = eventStore.events(matching: predic) as [EKEvent]?
            if eV != nil {
                for i in eV! {
                    do{
                        (try eventStore.remove(i, span: EKSpan.thisEvent, commit: true))
                    }
                    catch let error {
                        print ("Calendar Event Error: \(error)")
                    }
                }}

            self.updateDocument()
            self.navigationController!.popToRootViewController(animated: true)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
}
