//
//  Bindable.swift
//  TinderClone
//
//  Created by David Doll on 16/05/19.
//  Copyright © 2019 David Doll. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
