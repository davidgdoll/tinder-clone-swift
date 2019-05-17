//
//  RegistrationViewModel.swift
//  TinderClone
//
//  Created by David Doll on 14/05/19.
//  Copyright © 2019 David Doll. All rights reserved.
//

import Foundation

class RegistrationViewModel {
    
    var fullName: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }

    var isFormValid: ((Bool) -> Void)?
    
    fileprivate func checkFormValidity() {
        let isValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValid?(isValid)
    }
}
