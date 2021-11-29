//
//  StartViewController.swift
//  Donor
//
//  Created by кит on 08/03/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

class StartViewController: UIViewController,DonationDateCalculatorProtocol {

    @IBOutlet weak var AnketaBtn: UIView!
    @IBOutlet weak var WhiteView: DrawOnView!
    private let firebaseService = FirebaseService()
    
    @IBAction func AnketaBtnPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TestViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        let storyBoard = UIStoryboard(name: "Auth", bundle: nil)
        let authNC = storyBoard.instantiateViewController(withIdentifier: "authNC") as! UINavigationController
        authNC.dismiss(animated: false, completion: nil)
        self.tabBarController?.navigationItem.hidesBackButton = true
        if UserSettings.hasViewedWalkthrough != false {
            print ("UserSettings.hasViewWalkthouth is \(String(describing: UserSettings.hasViewedWalkthrough))")
        }
        else {
            _ = Timer.scheduledTimer(timeInterval: 1.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
            UserSettings.hasViewedWalkthrough = true
            UserDefaults.standard.synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDonation()
        InitialDonationCheck()
        WhiteViewPrepare()
    }
    
    private func InitialDonationCheck() {
        if (UserSettings.userModel != nil) && (UserSettings.userModel.place != "") {
            setNotifications()
            initialExpiredDonation()
            guard let date = UserSettings.userModel.date else {
                return
            }
            calculateDonationDate(date: date)
        }
        else if (UserSettings.userModel != nil) && (UserSettings.userModel.place == "")  {
            let vc = storyboard?.instantiateViewController(withIdentifier: "PositiveRespondViewController") as? PositiveRespondViewController
            vc!.navigationItem.setHidesBackButton(true, animated: true)
            navigationController?.pushViewController(vc!, animated: true)
        }
        else {
            print("Donation doesn't exist")
        }
    }
    
    private func WhiteViewPrepare() {
        WhiteView.layer.cornerRadius = 6
        AnketaBtn.layer.cornerRadius = 12
        WhiteView.x1 = 52
        WhiteView.y1 = 242
        WhiteView.x2 = 284
        WhiteView.y2 = 242
        WhiteView.x3 = 52
        WhiteView.y3 = 436
        WhiteView.x4 = 284
        WhiteView.y4 = 436
    }
    
    private func loadDonation(){
        if UserSettings.uid != nil {
        firebaseService.loadDonation()
        }
    }
    
    private func setNotifications() {
        guard let DonationDate = UserSettings.userModel.date else {return }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = formatter.string(from: DonationDate)
        let message = "\(UserSettings.userName ?? "Напоминаем"), сегодня у вас запись в \(time) !"
        let content = UNMutableNotificationContent()
        content.body = message
        content.sound = UNNotificationSound.default
        var dateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: UserSettings.userModel.date! )
        dateComponents.hour! -= 2
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        if let identifier = UserSettings.userModel.place {
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil) }
        
        guard let DonationDateDay = UserSettings.userModel.date else {return }
        let formatterDay = DateFormatter()
        formatterDay.dateFormat = "HH:mm"
        let timeDay = formatterDay.string(from: DonationDateDay)
        let messageDay = "\(UserSettings.userName ?? "Напоминаем"), завтра у вас запись в \(timeDay) !"
        let contentDay = UNMutableNotificationContent()
        contentDay.body = messageDay
        contentDay.sound = UNNotificationSound.default
        var dateComponentsDay = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: UserSettings.userModel.date! )
        dateComponentsDay.day! -= 1
        let triggerDay = UNCalendarNotificationTrigger(dateMatching: dateComponentsDay, repeats: true)
        if let identifierDay = UserSettings.userName {
            let requestDay = UNNotificationRequest(identifier: identifierDay, content: contentDay, trigger: triggerDay)
            let centerDay = UNUserNotificationCenter.current()
            centerDay.add(requestDay, withCompletionHandler: nil) }
    }
    
    @objc private func timerAction(){
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
                present(walkthroughViewController, animated: true, completion: nil)
            }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
