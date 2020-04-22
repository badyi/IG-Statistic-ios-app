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
    func selectPage(pages:[String: String])
    func smtWrongAlert(reason: String)
}

protocol AuthPresenterProtocol: AnyObject {
    func getCredentials() -> Credentials?
    func isAccessTokenExisting() -> Bool
    func setCredentialsIfAccessTokenExists()
    func setFBtoken()
    func setUserPages()
    func setPageIBA()
    func instUserIDLoaded()
    func setToUserDefaultsPageID(_ pageID: String)
    func doesDefaultUserPageExist() -> Bool
    func setDefaultUserPage()
    func useDefaultUserPage(flag: Bool)
}

final class AuthPresenter: AuthPresenterProtocol {
    
    weak var view: AuthViewProtocol?
    private var authService: AuthService!
    var pages: [String: String] = [:]
    var useDefaultPageID = false
    private var credentials: Credentials? {
        didSet {
            if credentials?.fbUserId == nil {
                setFBID()
            } else if credentials?.pageID == nil {
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
    
    func useDefaultUserPage(flag: Bool) {
        useDefaultPageID = flag
    }
    
    func doesDefaultUserPageExist() -> Bool {
        let status = UserDefaults.standard.bool(forKey: "userPageIsExisting")
        guard let _ = UserDefaults.standard.string(forKey: "pageID") else {
            return false
        }
        return status
    }
    
    func setDefaultUserPage() {
        let pageID = UserDefaults.standard.string(forKey: "pageID")
        let cred = credentials
        cred?.pageID = pageID
        credentials = cred
    }
    
    func setUserPages() {
        if useDefaultPageID == true {
            setDefaultUserPage()
            return
        }
        authService.getUserPages(credentials!) { result in
            switch result {
            case let .success(pages):
                self.pages = pages
                DispatchQueue.main.async {
                    self.view?.selectPage(pages: pages)
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.view?.smtWrongAlert(reason: "cant get user pages")
                }
                print (error)
            }
        }
    }
    
    func setFBID() {
        authService.getFBID_(credentials!) { result in
            switch result {
            case let .success(id):
                let cred = self.credentials
                cred?.fbUserId = id.id
                self.credentials = cred
            case let .failure(error):
                print (error)
            }
        }
    }
    
    func setPageId(pageName: String){
        let cred = credentials
        for i in pages {
            if i.value == pageName {
                cred?.pageID = i.key
                setToUserDefaultsPageID((cred?.pageID)!)
            }
        }
        if cred?.pageID == nil {
            view?.smtWrongAlert(reason: "cant set page id")
        }
        credentials = cred
    }

    func setPageIBA() {
        authService.getPagesInstagramBusinessAccount(self.credentials!) { result in
            switch result {
            case let .success(credentials):
                self.credentials = credentials
            case let .failure(error):
                DispatchQueue.main.async {
                    self.view?.smtWrongAlert(reason: "cant get instagram business account")
                }
                print(error)
            }
        }
    }
    
    func instUserIDLoaded() {
        DispatchQueue.main.sync {
            self.view?.performSeg(withIdentifier: "authToTabBar", sender: self)
        }
    }
    
    func setToUserDefaultsPageID(_ pageID: String) {
        UserDefaults.standard.set(true, forKey: "userPageIsExisting")
        UserDefaults.standard.set(pageID, forKey: "pageID")
    }
}
