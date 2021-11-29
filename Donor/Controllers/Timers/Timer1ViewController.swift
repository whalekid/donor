//
//  Timer1ViewController.swift
//  Donor
//
//  Created by кит on 09/03/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import UIKit
import EventKit
import Firebase
class Timer1ViewController: UIViewController, TimerProtocol {
    
    var firebaseService = FirebaseService()
    @IBOutlet weak var WhiteView: DrawOnView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBAction func DeleteDonationPressed(_ sender: Any) {
        deleteDonation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareVC()
    }
    
    private func prepareVC() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        WhiteView.layer.cornerRadius = 6
        WhiteView.x1 = 30
        WhiteView.y1 = 201
        WhiteView.x2 = 316
        WhiteView.y2 = 201
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        DateLabel.text = formatter.string(from: UserSettings.userModel.date!)
        placeLabel.text = UserSettings.userModel.place
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
