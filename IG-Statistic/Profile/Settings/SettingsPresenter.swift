//
//  SettingsPresenter.swift
//  IG-Statistic
//
//  Created by и on 05.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit
import FacebookLogin

protocol SettingsDelegate: AnyObject {
    func presentAuthVC()
    func presentAlert(_ alert: UIAlertController)
}

protocol SettingsPresenterProtocol {
    func logout()
    func changePage()
    func changeTheme()
    func settingsCount() -> Int
    func getSettingNames() -> [String]
    func type(at indexPath: IndexPath) -> settingsType
    func name(at index: Int) -> String
    func action(at indexPath: IndexPath)
    func actionAlert(type: settingsType)
    func changePageAction(alertAction: UIAlertAction)
    func logoutAction(alertAction: UIAlertAction)
}

enum settingsType {
    case changePage,changeTheme,logout, none
}

final class SettingsPresenter: SettingsPresenterProtocol {
    weak private var delegate: SettingsDelegate?
    private let settingNames = ["Theme", "Change fb page", "Logout"]
    
    init (delegat: SettingsDelegate) {
        self.delegate = delegat
    }
    
    func changePage() {
        UserDefaults.standard.removeObject(forKey: "userPageIsExisting")
        UserDefaults.standard.removeObject(forKey: "pageID")
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.presentAuthVC()
        }
    }
    
    func changeTheme() {
        
    }
    
    func logout() {
        LoginManager().logOut()
        UserDefaults.standard.removeObject(forKey: "userPageIsExisting")
        UserDefaults.standard.removeObject(forKey: "pageID")
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.presentAuthVC()
        }
    }
    
    func settingsCount() -> Int {
        settingNames.count
    }
    
    func getSettingNames() -> [String] {
        settingNames
    }
    
    func type(at indexPath: IndexPath) -> settingsType {
        switch indexPath.row {
        case 0:
            return .changeTheme
        case 1:
            return .changePage
        case 2:
            return .logout
        default:
            return .none
        }
    }
    
    func name(at index: Int) -> String {
        settingNames[index]
    }
    
    func action(at indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            changeTheme()
        case 1:
            actionAlert(type: .changePage)
        case 2:
            actionAlert(type: .logout)
        default:
            print("no action at index")
        }
    }
    
    func actionAlert(type: settingsType) {
        switch type {
        case .changePage:
            let alert = UIAlertController(title: "Change page?", message: "You can choose other page", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Change", style: .default, handler: changePageAction))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: changePageAction))
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.presentAlert(alert)
            }
        case .logout:
            let alert = UIAlertController(title: "Log out?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: logoutAction))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: logoutAction))
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.presentAlert(alert)
            }
        default:
            break
        }
    }
    
    func changePageAction(alertAction: UIAlertAction) {
        switch alertAction.title {
        case "Change":
            changePage()
        default:
            #warning("unselected cell")
        }
    }
    
    func logoutAction(alertAction: UIAlertAction) {
        switch alertAction.title {
        case "Log out":
            logout()
        default:
            #warning("unselected cell")
        }
    }
}
