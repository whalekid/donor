//
//  TestViewController.swift
//  Donor
//
//  Created by кит on 01/03/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import UIKit
//import RevealingSplashView


class TestViewController: UIViewController {
    
    @IBOutlet weak var NameVIew: UITextField!
    
    @IBOutlet weak var WhiteView: UIView!
    
    //Общее сост здоровья
    
    @IBOutlet weak var chronicYes: cornerButton!
    @IBOutlet weak var chronicNo: cornerButton!
    
    @IBOutlet weak var tyazhYes: cornerButton!
    @IBOutlet weak var tyazhNo: cornerButton!
    
    @IBOutlet weak var zubYes: cornerButton!
    @IBOutlet weak var zubNo: cornerButton!
    
    @IBOutlet weak var vaccineYes: cornerButton!
    @IBOutlet weak var vaccineNo: cornerButton!
    
  
    @IBOutlet weak var bloodDonationYes: cornerButton!
    @IBOutlet weak var bloodDonationNo: cornerButton!
    
    //last 6-12 months
    
    @IBOutlet weak var injectYes: cornerButton!
    @IBOutlet weak var injectNo: cornerButton!
    
    @IBOutlet weak var hirurgYes: cornerButton!
    @IBOutlet weak var hirurgNo: cornerButton!
    
    @IBOutlet weak var perelivYes: cornerButton!
    @IBOutlet weak var perelivNo: cornerButton!
    
    @IBOutlet weak var tatuYes: cornerButton!
    @IBOutlet weak var tatuNo: cornerButton!
    
    @IBOutlet weak var AidsYes: cornerButton!
    @IBOutlet weak var AidsNo: cornerButton!
    
    //Были ли у вас когда-нибудь
    @IBOutlet weak var obmorokYes: cornerButton!
    @IBOutlet weak var obmorokNo: cornerButton!
    
    @IBOutlet weak var heartYes: cornerButton!
    @IBOutlet weak var heartNo: cornerButton!
    
    @IBOutlet weak var VeneraYes: cornerButton!
    @IBOutlet weak var VeneraNo: cornerButton!
    
    @IBOutlet weak var invalidYes: cornerButton!
    @IBOutlet weak var invalidNo: cornerButton!
    
    @IBOutlet weak var neuroYes: cornerButton!
    @IBOutlet weak var neuroNo: cornerButton!
    
    @IBOutlet weak var otkazvrachYes: cornerButton!
    @IBOutlet weak var otkazvrachNo: cornerButton!
    
    @IBOutlet weak var africYes: cornerButton!
    @IBOutlet weak var africNo: cornerButton!
    
    //для женщин
    
    @IBOutlet weak var pregnantYes: cornerButton!
    @IBOutlet weak var pregnantNo: cornerButton!
    @IBOutlet weak var DateWOMAN: UITextField!
    private let datePicker = UIDatePicker()
    private var finalWomanDate: Date? = nil
    private var YesButtons: [cornerButton] = []
    private var NoButtons: [cornerButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareVC()
        initialButtons()
        prepareWomanCheckbox()
    }
    
    @IBAction func AnswerBtnClicked(_ sender: Any) {
       fetchAnswer()
     }
    
    private func prepareVC() {
        NameVIew?.text = UserSettings.userName ?? "Введите ваше имя"
        WhiteView.layer.cornerRadius = 6
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone))
            self.view.addGestureRecognizer(tapGesture)
    }
    
    private func initialButtons() {
        // единственный ответ на вопрос
        YesButtons = [ chronicYes,tyazhYes,zubYes,vaccineYes,injectYes,hirurgYes,perelivYes,tatuYes,AidsYes,obmorokYes,heartYes,VeneraYes,invalidYes,neuroYes,otkazvrachYes,africYes,pregnantYes, bloodDonationYes]
        NoButtons = [ chronicNo,tyazhNo,zubNo,vaccineNo,injectNo,hirurgNo,perelivNo,tatuNo,AidsNo,obmorokNo,heartNo,VeneraNo,invalidNo,neuroNo,otkazvrachNo,africNo,pregnantNo, bloodDonationNo]
        
        for (i, value) in YesButtons.enumerated() {
            value.indexP = i
            YesButtons[i].addTarget(self, action: #selector(onlyYesBtn(Btn:)), for: .touchUpInside)
        }
        
        for (i, value) in NoButtons.enumerated() {
            value.indexP = i
            NoButtons[i].addTarget(self, action: #selector(onlyNoBtn(Btn:)), for: .touchUpInside)
        }
    }
    
    private func fetchAnswer() {
        var FalseSum = 0
        var TrueSum = 0
        var yesButtons =  YesButtons
        let yesButtonTapped = yesButtons.map{ $0.isChecked }
        yesButtons.append(contentsOf: NoButtons)
        let allButtonsTapped = yesButtons.map { $0.isChecked }
        
        for (_,value) in allButtonsTapped.enumerated() {
            if value == false {  FalseSum += 1 }
            else {TrueSum += 1}
        }
        
        if (TrueSum < 17)  || ((TrueSum == 17)  && ((pregnantNo.isChecked) || (pregnantYes.isChecked)) ) {
            let alert = UIAlertController(title: "Анкета не заполнена", message: "Пожалуйста, ответьте на вопросы анкеты", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil
            ))
            self.present(alert, animated: true, completion: nil)
        }
        else if (yesButtonTapped.contains(true))
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "NegativeRespondViewController")
            navigationController?.pushViewController(vc!, animated: true)
        }
        else {
            UserSettings.userName  = NameVIew.text
            let vc = storyboard?.instantiateViewController(withIdentifier: "PositiveRespondViewController") as? PositiveRespondViewController
            vc?.womanDate = finalWomanDate
            navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    private func getDateFromDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        DateWOMAN.text = formatter.string(from: datePicker.date)
        finalWomanDate = datePicker.date
    }
    
    private func prepareWomanCheckbox() {
        DateWOMAN.inputView = datePicker
        datePicker.datePickerMode = .date
        let minDate = Calendar.current.date(byAdding: .year, value: -1,  to: Date())
        datePicker.minimumDate = minDate
        datePicker.maximumDate = Date()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace,doneBtn], animated: true)
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
        DateWOMAN.inputAccessoryView = toolbar
        datePicker.addTarget(self, action: #selector(dataChanged), for: .valueChanged)
    }
    
    private func womanCheck(date: Date) -> Bool{
        if Calendar.current.dateComponents([.day], from: date, to: Date()).day! <= 3
        {return false}
        else {return true}
    }
    
    @objc private func dataChanged () {
        getDateFromDatePicker()
    }
       
    @objc private func doneAction (){
        view.endEditing(true)
        finalWomanDate = datePicker.date
    }
    
    @objc private func tapGestureDone() {
        view.endEditing(true)
    }
    
    @objc private func onlyYesBtn (Btn: cornerButton) {
        for (i, value) in NoButtons.enumerated() {
            value.indexP = i
            if Btn.indexP == value.indexP{
                   if Btn.isChecked && value.isChecked {
                       value.isChecked = false
                   }}}}
    
    @objc private func onlyNoBtn (Btn: cornerButton) {
       for (i, value) in YesButtons.enumerated() {
           value.indexP = i
           if Btn.indexP == value.indexP{
                  if Btn.isChecked && value.isChecked {
                      value.isChecked = false
                  }}}}
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
