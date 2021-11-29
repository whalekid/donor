//
//  DonationDateCalculatorProtocol.swift
//  Donor
//
//  Created by кит on 23/11/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import Foundation
import UIKit
import EventKit

protocol DonationDateCalculatorProtocol: UIViewController {
}
extension DonationDateCalculatorProtocol {
     
    private func DonationDateCheck(date: Date) -> timers{
        if Calendar.current.dateComponents([.day], from: Date(), to: date ).day! < 1
        {return timers.timer0}
        else if Calendar.current.dateComponents([.day], from: Date(), to: date).day! == 1
        {return timers.timer1}
        else if Calendar.current.dateComponents([.day], from: Date(), to: date).day! == 2
        {return timers.timer2}
        else if Calendar.current.dateComponents([.day], from: Date(), to: date).day! >= 3
        {return timers.timer}
        else {return timers.unknowned}
    }
    
    func initialExpiredDonation() {
        if (UserSettings.userModel.date! < Date()) {
            if  (UserSettings.hasCongratulated == false) {
                print ("Дата записи истекла")
                if let identifier = UserSettings.userModel.place {
                    let center = UNUserNotificationCenter.current(); center.removePendingNotificationRequests(withIdentifiers:[identifier])
                }
                if let identifierDay = UserSettings.userName {
                    let center = UNUserNotificationCenter.current(); center.removePendingNotificationRequests(withIdentifiers:[identifierDay])
                }
                UserSettings.removeUserDonation()
                let vc = storyboard?.instantiateViewController(withIdentifier: "DidFinishViewController") as? DidFinishViewController
                navigationController?.pushViewController(vc!, animated: true)
            }
            else {
                print("Donation is expired and user was already congratulated")
            }
        }
    }
    
    func calculateDonationDate(date: Date) {
        let someTimer = DonationDateCheck(date: date)
        UserSettings.hasCongratulated = false
        switch someTimer {
        case .timer:
            let vc = storyboard?.instantiateViewController(withIdentifier: "\(someTimer.rawValue)") as? TimerViewController
            GetCalendarAccess(date: date)
            navigationController?.pushViewController(vc!, animated: true)
            
        case .timer0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "\(someTimer.rawValue)") as? Timer0ViewController
            print ("Raw value: \(someTimer.rawValue)")
            GetCalendarAccess(date: date)
             print ("PUSH")
            navigationController?.pushViewController(vc!, animated: true)
            
        case .timer1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "\(someTimer.rawValue)") as? Timer1ViewController
            GetCalendarAccess(date: date)
            navigationController?.pushViewController(vc!, animated: true)
            
        case .timer2:
            let vc = storyboard?.instantiateViewController(withIdentifier: "\(someTimer.rawValue)") as? Timer2ViewController
            GetCalendarAccess(date: date)
            navigationController?.pushViewController(vc!, animated: true)
            
        case .unknowned:
            print("unknowed timer")
        }
    }
    
    private func GetCalendarAccess(date: Date) {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            insertEvent(store: eventStore, date: date)
        case .denied:
            print("Access denied")
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion:
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if granted {
                        self!.insertEvent(store: eventStore, date: date)
                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Case default")
        }
    }
    
    private func insertEvent(store: EKEventStore,date: Date) {
        let event:EKEvent = EKEvent(eventStore: store)
        let startDate = date
        let endDate = startDate.addingTimeInterval(2 * 60)
        event.title = "Запись на сдачу крови"
        event.startDate = startDate
        event.endDate = endDate
        event.notes = "\(UserSettings.userModel.place ?? "")"
        event.calendar = store.defaultCalendarForNewEvents
        do {
            try store.save(event, span: .thisEvent)
        } catch let error as NSError {
            print("failed to save event with error : \(error)")
        }
        print("Saved Event")
    }
    
}
