//
//  AuthViewPresenter.swift
//  IG-Statistic
//
//  Created by и on 07.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import Foundation
import FacebookLogin

protocol AuthViewProtocol: AnyObject {
    func setUpView()
    func performSeg(withIdentifier id: String, sender: Any)
}

protocol AuthPresenterProtocol: AnyObject {
    func getCredentials() -> Credentials?
    func isAccessTokenExisting() -> Bool
    func setCredentialsIfAccessTokenExists()
    func setFBtoken()
    func setUserPages()
    func setPageIBA()
    func instUserIDLoaded()
}

final class AuthPresenter: AuthPresenterProtocol {
    weak var view: AuthViewProtocol?
    private var authService: AuthService!
    
    private var credentials: Credentials? {
        didSet {
            if credentials?.pageID == nil {
                setUserPages()
            } else if credentials?.instUserID == nil {
                setPageIBA()
            } else if credentials?.instUserID != nil {
                instUserIDLoaded()
            }
        }
    }
    
    init(view: AuthViewProtocol) {
        authService = AuthService()
        self.view = view
    }

    func getCredentials() -> Credentials? {
        return credentials
    }
    
    func isAccessTokenExisting() -> Bool {
        guard let _ = AccessToken.current else {
            return false
        }
        return true
    }
    
    func setCredentialsIfAccessTokenExists() {
        if let _ = AccessToken.current {
            setFBtoken()
        }
    }
    
    func setFBtoken() {
        guard let fbToken = AccessToken.current?.tokenString else {
            return
        }
        credentials = Credentials(fbToken)
    }
    
    func setUserPages() {
        authService.getUserPages(credentials!) { result in
            switch result {
            case let .success(credentials):
                self.credentials = credentials
            case let .failure(error):
                print (error)
            }
        }
    }

    func setPageIBA() {
        authService.getPagesInstagramBusinessAccount(self.credentials!) { result in
            switch result {
            case let .success(credentials):
                self.credentials = credentials
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func instUserIDLoaded() {
        DispatchQueue.main.sync {
            self.view?.performSeg(withIdentifier: "authToTabBar", sender: self)
        }
    }
}
