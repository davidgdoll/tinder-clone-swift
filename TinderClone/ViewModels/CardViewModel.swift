//
//  CardViewModel.swift
//  TinderClone
//
//  Created by David Doll on 09/05/19.
//  Copyright © 2019 David Doll. All rights reserved.
//

import UIKit

class CardViewModel {
    var images: [String]
    var attributedString: NSMutableAttributedString
    var textAlignment: NSTextAlignment
    
    var imageIndexObserver: ((UIImage?, Int) -> Void)?

    var imageIndex = 0 {
        didSet {
            let imageName = images[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(image, imageIndex)
        }
    }
    
    init(user: User) {
        images = user.imageNames
        textAlignment = .left
        attributedString = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedString.append(NSMutableAttributedString(string: "  \(user.age)\n\(user.profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
    }
    
    init(advertiser: Advertiser) {
        images = [advertiser.posterPhotoName]
        textAlignment = .center
        attributedString = NSMutableAttributedString(string: advertiser.title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedString.append(NSMutableAttributedString(string: "\n\(advertiser.brandName)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
    }
}

extension CardViewModel {
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, images.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}
