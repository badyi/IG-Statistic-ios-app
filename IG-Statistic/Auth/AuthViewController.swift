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
        presenter.setCredentialsIfAccessTokenExists()
    }
}

extension AuthViewController: AuthViewProtocol {
    func setUpView() {
        loginButton.center = view.center
        if presenter.isAccessTokenExisting()  == true {
            loginButton.isHidden = true
        }
        view.addSubview(loginButton)
    }
    
    func performSeg(withIdentifier id: String, sender: Any) {
        self.performSegue(withIdentifier: "authToTabBar", sender: self)
    }
}

extension AuthViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
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
