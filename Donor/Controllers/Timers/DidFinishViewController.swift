//
//  DidFinishViewController.swift
//  Donor
//
//  Created by кит on 09/04/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import UIKit
import EventKit
class DidFinishViewController: UIViewController {

    @IBOutlet weak var ReccBtn: UIView!
    
    @IBAction func DidReccBtnPressed(_ sender: Any) {
       tabBarController?.selectedIndex = 1
    }
    
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        super.viewDidLoad()
        ReccBtn.layer.cornerRadius = 12
        UserSettings.hasCongratulated = true
        setCalendarEvents()
    }
    
    private func setCalendarEvents() {
        let eventStore = EKEventStore()
        if let date = UserSettings.userModel?.date  {
            let predic = eventStore.predicateForEvents(withStart: date, end: date.addingTimeInterval(60 * 60), calendars: nil)
            let eV = eventStore.events(matching: predic) as [EKEvent]?
            if eV != nil {
                for i in eV! {
                    do{
                        (try eventStore.remove(i, span: EKSpan.thisEvent, commit: true))
                    }
                    catch let error {
                        print ("Calendar Event Error: \(error)")
                    }
                }
            }
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
