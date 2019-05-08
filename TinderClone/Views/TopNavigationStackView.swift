//
//  TopNavigationStackView.swift
//  TinderClone
//
//  Created by David Doll on 07/05/19.
//  Copyright © 2019 David Doll. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    let settingButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImage = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fireImage.contentMode = .scaleAspectFit
        settingButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingButton, fireImage, messageButton].forEach { v in
            addArrangedSubview(v)
        }
        
        distribution = .equalSpacing
        heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
