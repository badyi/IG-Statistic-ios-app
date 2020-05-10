//
//  AuthViewController.swift
//  IG-Statistic
//
//  Created by Бадый Шагаалан on 21.03.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit
import FacebookLogin
import ResourceNetworking

final class AuthViewController: UIViewController {
    private var presenter: AuthPresenter!
    private var loginButton : FBLoginButton = FBLoginButton(permissions: [ .publicProfile, .email, .userFriends, "instagram_basic", "pages_show_list", "instagram_manage_insights", "instagram_manage_comments"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AuthPresenter(view: self)
        setUpView()
        loginButton.delegate = self
        if presenter.isAccessTokenExisting() {
            if presenter.doesDefaultUserPageExist() {
                presenter.useDefaultUserPage(flag: true)
            }
            presenter.setCredentialsIfAccessTokenExists()
        }
    }
}

extension AuthViewController: AuthViewProtocol {
    func smtWrongAlert(reason: String) {
        let alert = UIAlertController(title: "Error", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert,animated: true, completion: nil)
        loginButton.isHidden = false
        LoginManager().logOut()
    }
    
    func selected(alertAction: UIAlertAction) {
        self.presenter.setPageId(pageName: alertAction.title!)
    }
    
    func selectPage(pages: [String: String]) {
        let pageMenu = UIAlertController(title: nil, message: "Choose page", preferredStyle: .actionSheet)
        for i in pages {
            let action = UIAlertAction(title: i.value, style: .default, handler: selected)
            action.setValue(ThemeManager.currentTheme().titleTextColor, forKey: "titleTextColor")
            pageMenu.addAction(action)
        }
        self.present(pageMenu, animated: true, completion: nil)
    }

    func setUpView() {
        let label = UILabel()
        label.text = "IG-Statistic"
        label.textAlignment = .center
        
        label.textColor = ThemeManager.currentTheme().titleTextColor
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        //loginButton.center =  view.center
        if presenter.isAccessTokenExisting()  == true {
            loginButton.isHidden = true
        }
        
        view.addSubview(label)
        view.addSubview(loginButton)
    
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        label.font = label.font.withSize(100)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 10).isActive = true
        loginButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0).isActive = true
        loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
    }
    
    func performSeg(withIdentifier id: String, sender: Any) {
        self.performSegue(withIdentifier: "authToTabBar", sender: self)
    }
}

extension AuthViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        UserDefaults.standard.removeObject(forKey: "userPageIsExisting")
        UserDefaults.standard.removeObject(forKey: "pageID")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "authToTabBar" else { return }
        guard let destination = segue.destination as? BaseUITabBarViewController else { return }
        destination.credentials = presenter.getCredentials()
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        presenter.setFBtoken()
    }
}
