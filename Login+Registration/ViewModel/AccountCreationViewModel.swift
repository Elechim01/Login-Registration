//
//  AccountCreationViewModel.swift
//  Dating App
//
//  Created by Michele on 26/12/20.
//

import SwiftUI
import Firebase
import CoreLocation

//Getting User Locaton..

class AccountCreationViewModel: NSObject,ObservableObject,CLLocationManagerDelegate {
//    User Details
    @Published var name = ""
    @Published var bio = ""
    @Published var age = ""
    @Published var location = ""
//    loggin details ...
    @Published var phNumber = ""
    @Published var code = ""
//    reference for View Cahnging
//    ie Login to Register to Image Upload
    
//    images..
    @Published var images = Array(repeating: Data(count: 0), count: 4)
    @Published var picker = false
    
    @Published var pageNumber = 0
// alert View
    @Published var alert = false
    @Published var alertMsg = ""
//    Loading Screen
    @Published var isLoading = false
//    OTP CRedentials..
    @Published var CODE = ""
//    Status
    @AppStorage("log_Status") var status = false
    
    func login(){
//        getting OTP
//        disabilito app verification
//        undo it while testing with live phone 
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        isLoading.toggle()
        PhoneAuthProvider.provider().verifyPhoneNumber("+"+code+phNumber, uiDelegate: nil){(CODE,err)in
            self.isLoading.toggle()
            if err != nil{
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            self.CODE = CODE!
//            alert TextFields
            let alertView = UIAlertController(title: "Verification", message: "Enter OTP Code", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            let ok = UIAlertAction(title: "OK", style: .default){(_) in
                if let otp = alertView.textFields![0].text{
                    let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.CODE, verificationCode: otp)
                    self.isLoading.toggle()
                    Auth.auth().signIn(with: credential){(res,err) in
                        self.isLoading.toggle()
                        if err != nil{
                            self.alertMsg = err!.localizedDescription
                            self.alert.toggle()
                            return
                        }
//                        Go tu registration
                        withAnimation{
                            self.pageNumber = 1 
                        }
                        
                    }
                }
            }
            alertView.addTextField{(txt) in
                txt.placeholder = "123456"
            }
            alertView.addAction(cancel)
            alertView.addAction(ok)
//            Presentitng
            UIApplication.shared.windows.first?.rootViewController?.present(alertView, animated: true, completion: nil)
        }
    }
    func signUP(){
        let storage = Storage.storage().reference()
        let ref = storage.child("profile_Pics").child(Auth.auth().currentUser!.uid)
//        images urls
        var urls : [String] = []
        for index in images.indices{
            self.isLoading.toggle()
            ref.child("img\(index)").putData(images[index],metadata: nil){(_,err) in
                self.isLoading.toggle()
                if err != nil {
                    self.alertMsg = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                ref.child("img\(index)").downloadURL(completion: {(url,_)in
                    guard let imageUrl = url else {return}
                    urls.append("\(imageUrl)")
//                    controllo che non ci siano altri url
                    if urls.count == self.images.count{
//                        update databse
                        self.registerUsers(urls: urls)
                    }
                })
                
            }
        }
    }
    func registerUsers(urls : [String]){
        let db = Firestore.firestore()
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "userName" : self.name,
            "bio" : self.bio,
            "location" : self.location,
            "age": self.age,
            "imageUrls" : urls
            
        ]){(err) in
            if err != nil{
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
//            successo
            self.isLoading.toggle()
            self.status = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let last = locations.last!
        
        CLGeocoder().reverseGeocodeLocation(last) {(places,_) in
            guard let placeMarks = places else{return}
            self.location = (placeMarks.first?.name ?? "")+"," + (placeMarks.first?.locality ?? "")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        Do something
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
}
