//
//  ViewController.swift
//  TinderClone
//
//  Created by David Doll on 07/05/19.
//  Copyright © 2019 David Doll. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    var cardViewModels: [CardViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupFirestoreUserCards()
        topStackView.settingButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        fetchUsersFromFirestore()
    }
    
    fileprivate func fetchUsersFromFirestore() {
        Firestore.firestore().collection("users").getDocuments { [weak self] (snapShot, error) in
            guard error == nil else { return }
            snapShot?.documents.forEach { document in
                let userDictionary = document.data()
                let user = User(dictionary: userDictionary)
                self?.cardViewModels.append(CardViewModel(user: user))
            }
            self?.setupFirestoreUserCards()
        }
    }
    
    @objc func handleSettings() {
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
    }
    
    fileprivate func setupFirestoreUserCards() {
        cardViewModels.forEach { viewModel in
            let cardView = CardView(frame: .zero)
            cardView.viewModel = viewModel
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardsDeckView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                leading: view.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: view.trailingAnchor)
    }
}

