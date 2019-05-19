//
//  RegistrationController.swift
//  TinderClone
//
//  Created by David Doll on 12/05/19.
//  Copyright © 2019 David Doll. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationController: UIViewController {
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.widthAnchor.constraint(equalToConstant: 275).isActive = true
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter full name"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8169022799, green: 0.09829682857, blue: 0.3345560133, alpha: 1)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
        button.isEnabled = false
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(handleReegister), for: .touchUpInside)
        return button
    }()
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            fullNameTextField,
            emailTextField,
            passwordTextField,
            registerButton
            ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        verticalStackView
        ])
    
    let gradientLayer = CAGradientLayer()
    let registrationViewModel = RegistrationViewModel()
    let registeringHUD = JGProgressHUD(style: .dark)
    
    @objc fileprivate func handleSelectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc fileprivate func handleReegister() {
        handleTapDismiss()
        registrationViewModel.performRegistration { [weak self] error in
            guard let error = error else { return }
            self?.showHudWithError(error: error)
        }
    }
    
    fileprivate func showHudWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = error.localizedDescription
        hud.indicatorView?.frame = .zero
        hud.indicatorView?.isHidden = true
        hud.show(in: view)
        hud.dismiss(afterDelay: 4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        setupRegistrationViewModelObserver()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.isFormValid.bind { [unowned self] isFormValid in
            guard let isFormValid = isFormValid else { return }
            self.registerButton.isEnabled = isFormValid
            if isFormValid {
                self.registerButton.setTitleColor(.white, for: .normal)
            } else {
                self.registerButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
            }
        }
        
        registrationViewModel.image.bind { [unowned self] image in
            self.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationViewModel.isRegistering.bind { [unowned self] isRegistering in
            guard let isRegistering = isRegistering else { return }
            if isRegistering {
                self.registeringHUD.textLabel.text = "Registering"
                self.registeringHUD.show(in: self.view)
            } else {
                self.registeringHUD.dismiss()
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
        } else {
            overallStackView.axis = .vertical
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        view.endEditing(true)
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardHide(notification: Notification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = overallStackView.frame.minY
        let difference = keyboardFrame.height - bottomSpace
        view.transform = CGAffineTransform(translationX: 0, y: -difference - 10)
    }
    
    fileprivate func setupLayout() {
        overallStackView.spacing = 8
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.9862408042, green: 0.3834023476, blue: 0.3692134917, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.892090857, green: 0.1048654541, blue: 0.4604073763, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == fullNameTextField {
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.image.value = image
        picker.dismiss(animated: true)
    }
}
