//
//  RegistrationViewModel.swift
//  TinderClone
//
//  Created by David Doll on 14/05/19.
//  Copyright © 2019 David Doll. All rights reserved.
//

import Foundation
import UIKit

class RegistrationViewModel {
    
    var fullName: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }

    var isFormValid = Bindable<Bool>()
    var image = Bindable<UIImage>()
    
    fileprivate func checkFormValidity() {
        let isValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isValid
    }
}
