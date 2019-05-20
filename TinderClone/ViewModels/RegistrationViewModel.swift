//
//  RegistrationViewModel.swift
//  TinderClone
//
//  Created by David Doll on 14/05/19.
//  Copyright © 2019 David Doll. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RegistrationViewModel {
    
    var fullName: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }

    var isFormValid = Bindable<Bool>()
    var isRegistering = Bindable<Bool>()
    var image = Bindable<UIImage>()
    
    func performRegistration(completion: @escaping (Error?) -> Void) {
        guard let email = email, let password = password else { return }
        isRegistering.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(error)
            }
            self?.saveImageToFirebase(completion: completion)
        }
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> Void) {
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        let imageData = image.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil, completion: { _, error in
            if let error = error {
                completion(error)
                return
            }
            
            ref.downloadURL(completion: { [weak self] url, error in
                if let error = error {
                    completion(error)
                    return
                }
                let imageUrl = url?.absoluteString ?? ""
                self?.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
                self?.isRegistering.value = false
            })
        })
    }
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> Void) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["fullName": fullName ?? "", "uid": uid, "imageUrl1": imageUrl]
        Firestore.firestore().collection("users").document(uid).setData(docData) { error in
            guard error == nil else { completion(error); return }
            completion(nil)
        }
    }
    
    fileprivate func checkFormValidity() {
        let isValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isValid
    }
}
