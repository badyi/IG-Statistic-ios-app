//
//  SettingsViewController.swift
//  IG-Statistic
//
//  Created by и on 14.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit
import FacebookLogin

final class SettingsViewController: UITableViewController {
    
    private var presenter: SettingsPresenter!
    
    private let settingsCellwithLabelID = "labelCellID"
    private let withSegControlCellID = "SCCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupView()
        setupTableView()
        presenter = SettingsPresenter(delegat: self)
    }
    
    @IBAction func changePageTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "userPageIsExisting")
        UserDefaults.standard.removeObject(forKey: "pageID")
        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginPage
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController")
        LoginManager().logOut()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginPage
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.settingsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch presenter.type(at: indexPath) {
        case .changePage, .logout:
            let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellwithLabelID, for: indexPath) as! SettingsTableViewCell
            cell.config(with: presenter.name(at: indexPath.row))
            return cell
        case .changeTheme:
            let cell = tableView.dequeueReusableCell(withIdentifier: withSegControlCellID, for: indexPath) as! WithSegControlTableViewCell
            cell.config(with: presenter.name(at: indexPath.row))
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellwithLabelID, for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.action(at: indexPath)
    }
}

extension SettingsViewController {
    func setupView() {
        //changePageButton.setTitleColor(ThemeManager.currentTheme().titleTextColor, for: .normal)
        //logOutButton.setTitleColor(ThemeManager.currentTheme().titleTextColor, for: .normal)
        let titleColor = ThemeManager.currentTheme().titleTextColor
        let textAttributes = [NSAttributedString.Key.foregroundColor:titleColor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.tintColor = titleColor
    }
    
    func setupTableView() {
        tableView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: settingsCellwithLabelID)
        tableView.register(UINib(nibName: "WithSegControlTableViewCell", bundle: nil), forCellReuseIdentifier: withSegControlCellID)
    }
}

extension SettingsViewController: SettingsDelegate {
    func presentAlert(_ alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentAuthVC() {
        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginPage
    }

}
