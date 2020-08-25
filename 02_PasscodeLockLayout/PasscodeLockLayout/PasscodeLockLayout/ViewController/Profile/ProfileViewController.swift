//
//  ProfileViewController.swift
//  PasscodeLockLayout
//
//  Created by 酒井文也 on 2020/08/15.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Property

    private let passcodeModel = PasscodeModel()

    // MARK: - @IBOutlet

    @IBOutlet weak private var passcodeSwitch: UISwitch!
    @IBOutlet weak private var editPasscodeButton: UIButton!
    @IBOutlet weak private var openSettingButton: UIButton!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("プロフィール・設定")
        removeBackButtonText()
        setupPasscodeSwitch()
        setupOpenSettingButton()
        setupEditPasscodeButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showTabBarItems()
        setCurrentPasscodeStatus()
    }

    // MARK: - Private Function

    //
    @objc private func passcodeSwitchChanged() {
        if passcodeModel.existsHashedPasscode() {
            showAlertWith(title: "パスコードを無効にします", message: "以前に設定したパスコードは削除されますがよろしいですか?",
                okActionHandler: {
                    PasscodeModel().deleteHashedPasscode()
                    self.setCurrentPasscodeStatus()
                },
                cancelActionHandler: {
                    self.setCurrentPasscodeStatus()
                }
            )
        } else {
            let vc = getPasscodeViewController(targetInputPasscodeType: .inputForCreate)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    //
    @objc private func openSettingButtonAction() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    //
    @objc private func editPasscodeButtonAction() {
        let vc = getPasscodeViewController(targetInputPasscodeType: .inputForUpdate)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //
    private func setCurrentPasscodeStatus() {
        let isPasscodeExist = PasscodeModel().existsHashedPasscode()
        passcodeSwitch.isOn = isPasscodeExist
        editPasscodeButton.superview?.isHidden = !isPasscodeExist
    }

    //
    private func getPasscodeViewController(targetInputPasscodeType: InputPasscodeType) -> PasscodeViewController {

        // 遷移先のViewControllerに関する設定をする
        let passcodeViewController = UIStoryboard(name: "Passcode", bundle: nil).instantiateInitialViewController() as! PasscodeViewController
        passcodeViewController.setTargetInputPasscodeType(targetInputPasscodeType)
        passcodeViewController.setTargetPresenter(nil)
        return passcodeViewController
    }

    //
    private func setupPasscodeSwitch() {
        passcodeSwitch.addTarget(self, action: #selector(self.passcodeSwitchChanged), for: .touchUpInside)
    }

    //
    private func setupOpenSettingButton() {
        openSettingButton.addTarget(self, action: #selector(self.openSettingButtonAction), for: .touchUpInside)
    }

    //
    private func setupEditPasscodeButton() {
        editPasscodeButton.addTarget(self, action: #selector(self.editPasscodeButtonAction), for: .touchUpInside)
    }

    //
    private func showTabBarItems() {
        if let tabBarVC = self.tabBarController {
            tabBarVC.tabBar.isHidden = false
        }
    }

    //
    private func showAlertWith(title: String? = nil, message: String, okActionHandler: @escaping () -> Void = {}, cancelActionHandler: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default) { _ in
            okActionHandler()
        }
        let cancelAction = UIAlertAction(title: "いいえ", style: .cancel) { _ in
            cancelActionHandler()
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
