//
//  PositiveRespondViewController.swift
//  Donor
//
//  Created by кит on 10/03/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import UIKit

import Firebase
class PositiveRespondViewController: UIViewController, DonationDateCalculatorProtocol {
     
    var womanDate: Date?
    @IBOutlet weak var DonationConfirmBtn: UIButton!
    
    @IBOutlet weak var YesBtn: cornerButton!
    @IBOutlet weak var NoBtn: cornerButton!
    
    @IBOutlet weak var DateField: UITextField!
    @IBOutlet weak var PlaceField: UITextField!
    
    private let datePicker = UIDatePicker()
    private let firebaseService = FirebaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareVC()
    }
    
    @IBAction func DonationConfirmBtnPressed(_ sender: UIButton) {
           if (NoBtn.isChecked) {
               UserSettings.userModel = Donation(name: UserSettings.userName, date: nil, place: "")
           }
           else if (YesBtn.isChecked) && (DateField.text != "") && (PlaceField.text != "") && ((womanDate == nil) || (isAllowedForWomanHealth(date: womanDate!))) {
               
               UserSettings.userModel = Donation (name: UserSettings.userName,
                                                  date: datePicker.date, place: PlaceField.text ?? "")
               getNotificatiionGrants()
               firebaseService.updateDonation(place: PlaceField.text!, date: datePicker.date)
               calculateDonationDate(date: datePicker.date)
           }
           else if (YesBtn.isChecked) && (DateField.text != "") && (womanDate != nil) && (!isAllowedForWomanHealth(date: womanDate!))
           {
               let alert = UIAlertController(title: "Выберите другой день", message: "Нельзя сдавать кровь в течение 5 дней после менструации", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
           else if (YesBtn.isChecked) && ((DateField.text == "") || (PlaceField.text == "")) {
               let alert = UIAlertController(title: "Завершите запись", message: "Пожалуйста, выберите место и дату донации", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
           else { print ("Some unknowned error from PositiveRespondVC")}
       }
    
    @objc private func dataChanged () {
        getDateFromDatePicker()
    }
    
    @objc private func tapGestureDone() {
        view.endEditing(true)
    }
    
    @objc private func onlyNoBtn (Btn: cornerButton) {
        if Btn.isChecked && YesBtn.isChecked {
            YesBtn.isChecked = false
        }
    }
    
    @objc private func onlyYesBtn (Btn: cornerButton) {
        if Btn.isChecked && NoBtn.isChecked {
            NoBtn.isChecked = false
        }
    }
    
    private func prepareVC() {
        DateField.inputView = datePicker
        datePicker.datePickerMode = .dateAndTime
        let maxDate = Calendar.current.date(byAdding: .year, value: +1,  to: Date())
        datePicker.minimumDate = Date()
        datePicker.maximumDate = maxDate
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
        datePicker.addTarget(self, action: #selector(dataChanged), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone))
        self.view.addGestureRecognizer(tapGesture)
        YesBtn.addTarget(self, action: #selector(onlyYesBtn(Btn:)), for: .touchUpInside)
        NoBtn.addTarget(self, action: #selector(onlyNoBtn(Btn:)), for: .touchUpInside)
    }
     
    private func getDateFromDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        DateField.text = formatter.string(from: datePicker.date)
    }
    
    private func getNotificatiionGrants() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound],
            completionHandler: {(granted, error) in
                if granted {
                    print("Разрешение на отправку уведомлений получено!")
                } else {
                    print("В разрешении на отправку уведомлений отказано.") }
            }
        )
    }
    
    private func isAllowedForWomanHealth(date: Date) -> Bool{
        if Calendar.current.dateComponents([.day], from: date, to: datePicker.date).day! <= 5
            {return false}
        else {return true}
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
