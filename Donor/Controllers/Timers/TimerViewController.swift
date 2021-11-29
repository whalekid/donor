//
//  TimerViewController.swift
//  Donor
//
//  Created by кит on 08/03/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import UIKit
import EventKit
import Firebase
class TimerViewController: UIViewController, TimerProtocol {
    
    var firebaseService = FirebaseService()
    @IBOutlet weak var WhiteView: DrawOnView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBAction func DeleteDonation(_ sender: Any) {
     deleteDonation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Name.text = UserSettings.userName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareVC()
    }
    
    private func prepareVC() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        WhiteView.layer.cornerRadius = 6
        WhiteView.x1 = 30
        WhiteView.y1 = 211
        WhiteView.x2 = 316
        WhiteView.y2 = 211
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM HH:mm"
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
