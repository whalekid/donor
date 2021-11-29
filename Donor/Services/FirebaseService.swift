//
//  FirebaseService.swift
//  Donor
//
//  Created by кит on 22/11/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseService {
    
    private let usersRef = Firestore.firestore().collection("users")
    
    func fetchProfileNetworkData(completion: @escaping (String,String?,String,String,String)->()) {
        guard let uid = UserSettings.uid else {return}
        usersRef.whereField("uid", isEqualTo: uid) .getDocuments() { (querySnapshot, err) in
            var name = ""
            var date: String?
            var count = ""
            var blood = ""
            var rhesus = ""
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    name = document.data()["name"] as! String
                    guard let donationRef = document.data()["donation"] as? [[String : Any]]
                        else {break}
                    count = String(donationRef.count)
                    blood = document.data()["bloodType"] as! String
                    rhesus = document.data()["rhesus"] as! String
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy HH:mm"
                    if let temp = donationRef.first(where: {
                        let tempDate = $0["data"] as! Timestamp?
                        let RequestedDate = tempDate!.dateValue()
                        return RequestedDate > Date()
                    })
                    {
                        let tempDate = temp["data"] as! Timestamp?
                        let RequestedDate = tempDate!.dateValue()
                        date = formatter.string(from: RequestedDate)
                    }
                    completion(name,date,count,blood,rhesus)
                }
            }
        }
    }
    
    func fetchDonations( completion: @escaping ( [Donation])->() ) {
        var donationArray = [Donation]()
        guard let uid = UserSettings.uid else {return}
        usersRef.whereField("uid", isEqualTo: uid).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    guard  let donationRef = document.data()["donation"] as? [[String : Any]]
                        else {break}
                    for number in 0..<(donationRef.count)
                    {
                        let tempDate = donationRef[number]["data"] as! Timestamp?
                        let RequestedDate = tempDate!.dateValue()
                        donationArray.append(.init(name: document.data()["name"] as? String, date: RequestedDate, place: donationRef[number]["place"] as? String))
                    }
                }
            }
            completion(donationArray)
        }
    }
    
    func downloadAvatar(completion: @escaping (Data, String)->()) {
        guard let uid = UserSettings.uid else {return}
        usersRef.whereField("uid", isEqualTo: uid) .getDocuments() {
            (querySnapshot, err) in
            var urlString = ""
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    guard let url = document.data()["avatarURL"] as? String
                        else { return }
                    urlString = url
                }
                let ref = Storage.storage().reference(forURL: urlString)
                let megaByte = Int64(1 * 1024 * 1024)
                ref.getData(maxSize:megaByte) { (data,error) in
                    guard let imageData = data else { return }
                    completion(imageData,urlString)
                }
            }
        }
    }
    
    func uploadImage(currentUID: String, photo: UIImage, completion: @escaping (Result<URL,Error>) -> Void) {
        let ref = Storage.storage().reference().child("avatars").child(currentUID)
        guard let ImageData = photo.jpegData(compressionQuality: 0.4) else {return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        ref.putData(ImageData, metadata: metaData) { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            ref.downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
    }
    
    func updateData(name: String?, rhesus: String?, blood: String?, photo: UIImage, completion: @escaping (String)->()) {
        let userRef = usersRef.document(UserSettings.uid)
        userRef.updateData([
            "name": name ??  "-",
            "rhesus": rhesus ?? "-",
            "bloodType": blood ?? "-"
        ])
        self.uploadImage(currentUID: UserSettings.uid, photo: photo) { (result) in
            switch result {
            case .success(let url):
                userRef.updateData([
                    "avatarURL": url.absoluteString
                ])
             completion(url.absoluteString)
            case .failure(let err): print("\(err.localizedDescription)")
            }
        }
    }
    
    func setAuthData(result: AuthDataResult, name: String, surname: String, completion: @escaping (FirebaseAuthService.AuthResult) -> ()) {
        usersRef.document(result.user.uid).setData([
            "name": name,
            "surname": surname,
            "uid": result.user.uid
        ]) { (error) in
            if error != nil {
                completion(.failure(AuthError.serverError))
            }
            completion(.success)
        }
        UserSettings.uid = result.user.uid
        UserSettings.userName = String(name + surname )
    }
    
    func updateDonation(place: String, date: Date) {
                   let userRef = usersRef.document(UserSettings.uid)
                   let dict = [ "place" : place, "data" : date ] as [String : Any]
                    userRef.updateData([
                     "donation": FieldValue.arrayUnion([dict])
                     ])
    }
    
    func updateDocumentFromTimerVC() {
        let userRef = usersRef.document(UserSettings.uid)
        userRef.getDocument { (documentSnapshot, err) in
            let donationRef = documentSnapshot?.data()!["donation"] as! [[String : Any]]
            for number in 0..<(donationRef.count)
            {
                let tempDate = donationRef[number]["data"] as! Timestamp?
                let RequestedDate = tempDate!.dateValue()
                let dat = UserSettings.userModel?.date
                let place = donationRef[number]["place"] as! String
                if ( (RequestedDate == dat) && (place == UserSettings.userModel.place) )
                {
                    print("Document successfully deleted")
                    _ = userRef.updateData ([
                        "donation": FieldValue.arrayRemove([donationRef[number]])
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                    // удаление производить в данном блоке
                    UserSettings.removeUserDonation()
                    break
                }
            }
        }
    }
    
    func loadDonation(){
           var tempName = " "
           var tempPlace = " "
           var tempDate = Date()
           _ = usersRef.whereField("uid", isEqualTo: UserSettings.uid!) .getDocuments() { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   for document in querySnapshot!.documents {
                       UserSettings.userName =  document.data()["name"] as? String
                       guard let donationRef = document.data()["donation"] as? [[String : Any]]
                           else {break}
                       for number in 0..<(donationRef.count)
                       {
                           let timeStampDate = donationRef[number]["data"] as! Timestamp?
                           let RequestedDate = timeStampDate!.dateValue()
                           
                           if tempDate.compare(RequestedDate) == .orderedAscending {
                               tempDate = RequestedDate
                               tempPlace = donationRef[number]["place"] as! String
                               tempName =  document.data()["name"] as! String
                           }
                           else {print ("No donations found ")}
                       }
                   }
                   if tempName != " " {
                       let newDonation = Donation (name:  tempName , date: tempDate, place: tempPlace)
                       UserSettings.userModel = newDonation
                       UserDefaults.standard.synchronize()
                   }
               }
           }
       }
    
}

