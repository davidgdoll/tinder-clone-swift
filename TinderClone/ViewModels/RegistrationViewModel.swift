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
    
    func performRegistration(onError: @escaping (Error?) -> Void) {
        guard let email = email, let password = password else { return }
        isRegistering.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                onError(error)
            }
            
            let fileName = UUID().uuidString
            let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
            let imageData = self?.image.value?.jpegData(compressionQuality: 0.75) ?? Data()
            ref.putData(imageData, metadata: nil, completion: { _, error in
                if let error = error {
                    onError(error)
                    return
                }
                
                ref.downloadURL(completion: { url, error in
                    if let error = error {
                        onError(error)
                        return
                    }
                    self?.isRegistering.value = false
                })
            })
        }
    }
    
    fileprivate func checkFormValidity() {
        let isValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isValid
    }
}
