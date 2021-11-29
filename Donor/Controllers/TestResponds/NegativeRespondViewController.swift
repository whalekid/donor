//
//  NegativeRespondViewController.swift
//  Donor
//
//  Created by кит on 07/03/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import UIKit

class NegativeRespondViewController: UIViewController {

    @IBOutlet weak var AnketaOneMoreView: UIView!
    @IBOutlet weak var WhiteView: DrawOnView!
    @IBOutlet weak var ReccomendView: UIView!
    
    @IBAction func AnketaOneMoreBtnPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TestViewController")
        navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func ReccBtnPressed(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareVC()
    }
 
    private func prepareVC() {
        WhiteView.layer.cornerRadius = 6
        AnketaOneMoreView.layer.cornerRadius = 12
        ReccomendView.layer.cornerRadius = 12
        WhiteView.x1 = 52
        WhiteView.y1 = 300
        WhiteView.x2 = 284
        WhiteView.y2 = 300
        WhiteView.x3 = 52
        WhiteView.y3 = 526
        WhiteView.x4 = 284
        WhiteView.y4 = 526
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
