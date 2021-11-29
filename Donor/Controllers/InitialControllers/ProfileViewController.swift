//
//  ProfileViewController.swift
//  Donor
//
//  Created by кит on 12/03/2020.
//  Copyright © 2020 kitaev. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var WhiteView: DrawOnView!
    @IBOutlet weak var SaveChangesButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var rhesusTextField: UITextField!
    @IBOutlet weak var bloodTypeTextField: UITextField!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DonationCountLabel: UILabel!
    @IBOutlet weak var profilePick: RoundedImageView!
 
    private var firebaseService = FirebaseService()
    private var currentTextField = UITextField()
    private var pickerView = UIPickerView()
    
    private let bloodTypes = ["A(I)", "A(II)", "A(III)", "A(IV)"]
    private let rhesusTypes = ["Rh +", "Rh -"]
    private var urlString: String = ""
    
    /** UIImagePicker для камеры */
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }()
    
    /** UIImagePicker для галереи */
    lazy var libraryPicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareProfileVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        profilePick.image = Avatar.shared.image
        checkDate()
    }
    
    @IBAction func changeAvatarPressed(_ sender: Any) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        actionSheetController.addAction(cancelAction)
        let cameraAction = UIAlertAction(title: "Камера", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetController.addAction(cameraAction)
        let galleryAction = UIAlertAction(title: "Галерея", style: .default) { action -> Void in
            self.present(self.libraryPicker, animated: true, completion: nil)
        }
        actionSheetController.addAction(galleryAction)
        present(actionSheetController, animated: true, completion: nil)
    }

    @IBAction func ChangeProfileInfo(_ sender: Any) {
        rhesusTextField.isUserInteractionEnabled = true
        bloodTypeTextField.isUserInteractionEnabled = true
        nameTextField.isUserInteractionEnabled = true
        SaveChangesButton.isEnabled = true
    }
    
    @IBAction func SaveChanges(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Сохранение изменений", message: "Вы уверены?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { (action: UIAlertAction!) in
        
            let newBlood = BloodRhesus(rhesus: self.rhesusTextField.text ?? "-", bloodType: self.bloodTypeTextField.text ?? "-")
            UserSettings.userBlood = newBlood
            UserSettings.userName = self.nameTextField.text
            UserDefaults.standard.synchronize()
            self.firebaseService.updateData(name:self.nameTextField.text, rhesus:self.rhesusTextField.text, blood: self.bloodTypeTextField.text, photo: self.profilePick.image! ){ (result) in
                self.urlString = result
            }
            
            self.rhesusTextField.isUserInteractionEnabled = false
            self.bloodTypeTextField.isUserInteractionEnabled = false
            self.nameTextField.isUserInteractionEnabled = false
            self.SaveChangesButton.isEnabled = false
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { [weak self] (action: UIAlertAction!) in
            self!.nameTextField.text =  UserSettings.userName
            self!.rhesusTextField.text = UserSettings.userBlood.rhesus
            self!.bloodTypeTextField.text = UserSettings.userBlood.bloodType
            self!.rhesusTextField.isUserInteractionEnabled = false
            self!.bloodTypeTextField.isUserInteractionEnabled = false
            self!.nameTextField.isUserInteractionEnabled = false
            self!.SaveChangesButton.isEnabled = false
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    private func fetchProfileData() {
        firebaseService.fetchProfileNetworkData { [weak self] (name,date,count,blood,rhesus) in
            DispatchQueue.main.async {
                self!.nameTextField.text = name
                self!.countLabel.text = count
                if let currentDate = date {
                    self!.DateLabel.text = currentDate
                }
                if  ((self!.bloodTypeTextField?.text == "-") && (self!.rhesusTextField?.text == "-") )
                {
                    self!.bloodTypeTextField?.text = blood
                    self!.rhesusTextField?.text = rhesus
                }
                else { print("no rhesus changed") }
            }
        }
        firebaseService.downloadAvatar { [weak self](imageData,url) in
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                Avatar.shared.image = image
                self?.profilePick.image = image
                self?.urlString = url
            }
        }
    }
    
    private func prepareProfileVC () {
        bloodTypeTextField?.text = UserSettings.userBlood?.bloodType ?? "-"
        rhesusTextField?.text = UserSettings.userBlood?.rhesus ?? "-"
        nameTextField?.text = UserSettings.userName ?? " "
        countLabel.isUserInteractionEnabled = true
        fetchProfileData()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelPressed))
        countLabel.addGestureRecognizer(gestureRecognizer)
        DateLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone))
        self.view.addGestureRecognizer(tapGesture)
        rhesusTextField.isUserInteractionEnabled = false
        bloodTypeTextField.isUserInteractionEnabled = false
        nameTextField.isUserInteractionEnabled = false
        UserDefaults.standard.synchronize()
    }
    
    @objc private func tapGestureDone() {
        view.endEditing(true)
    }
    
    @objc private func labelPressed(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "DonationTableVC")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    private func uploadImage(currentUID: String, photo: UIImage, completion: @escaping (Result<URL,Error>) -> Void) {
        firebaseService.uploadImage(currentUID: currentUID, photo: photo) { (result) in
            completion(result)
        }
    }
    
    private func saveBlood () {
        let newBlood = BloodRhesus(rhesus: rhesusTextField.text ?? "-", bloodType: bloodTypeTextField.text ?? "-")
        UserSettings.userBlood = newBlood
        UserDefaults.standard.synchronize()
    }
    
    private func checkDate() {
        guard let dat = UserSettings.userModel?.date
            else {return}
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        DateLabel.text = formatter.string(from: dat)
    }
    
}

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == bloodTypeTextField {
            return bloodTypes.count}
        else if currentTextField == rhesusTextField {
            return rhesusTypes.count}
        else {return 0}
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == bloodTypeTextField {
            return bloodTypes[row]}
        else if currentTextField == rhesusTextField {
            return rhesusTypes[row]}
        else {return ""}
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == bloodTypeTextField {
            bloodTypeTextField.text = bloodTypes[row]
            self.view.endEditing(true)
        }
        else if currentTextField == rhesusTextField {
            rhesusTextField.text = rhesusTypes[row]
            self.view.endEditing(true)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        currentTextField = textField
        if currentTextField == bloodTypeTextField {
            bloodTypeTextField.inputView = pickerView}
        else if currentTextField == rhesusTextField {
            rhesusTextField.inputView = pickerView}
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            dismiss(animated: true, completion: {
                let lightImage = image.resizeImage(targetSize: CGSize(width: 400.0, height: 400.0))
                Avatar.shared.image = lightImage
                self.profilePick.image = lightImage
            })
        }
    }
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
