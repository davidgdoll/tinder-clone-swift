//
//  CardViewModel.swift
//  TinderClone
//
//  Created by David Doll on 09/05/19.
//  Copyright © 2019 David Doll. All rights reserved.
//

import UIKit

enum CardType {
    case advertiser, user
}

protocol CardViewModelProtocol {
    var images: [String] {get}
    var attributedString: NSMutableAttributedString {get}
    var textAlignment: NSTextAlignment {get}
}

extension User: CardViewModelProtocol {
    
    var images: [String] {
        return imageNames
    }
    
    var attributedString: NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attrString.append(NSMutableAttributedString(string: "  \(age)\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        return attrString
    }
    
    var textAlignment: NSTextAlignment {
        return .left
    }
}

extension Advertiser: CardViewModelProtocol {
    
    var images: [String] {
        return [posterPhotoName]
    }
    
    var attributedString: NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attrString.append(NSMutableAttributedString(string: "\n\(brandName)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        return attrString
    }
    
    var textAlignment: NSTextAlignment {
        return .center
    }
}
