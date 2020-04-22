//
//  InfoViewController.swift
//  IG-Statistic
//
//  Created by и on 16.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    var cred: Credentials?
    
    private let tableview: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let cellID = "infoCell"
    private let headerID = "headerID"
    private var presenter: InfoPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter = InfoPresenter(credentials: cred!, view: self)
        presenter?.getMainProfileInfo()
    }
}

extension InfoViewController: InfoViewProtocol {
    func reloadItem(at index: Int) {
        let indexPath = [IndexPath(row: index, section: 0)]
        self.tableview.reloadRows(at: indexPath, with: .automatic)
    }
    
    func imageDidLoaded(_ image: UIImage) {
        reloadData()
    }

    func setInfo(with credentials: Credentials) {
        presenter = InfoPresenter(credentials: credentials, view: self)
        presenter?.getMainProfileInfo()
    }
    
    func reloadData() {
        self.tableview.reloadData()
    }
}

extension InfoViewController {
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.allowsSelection = false
        tableview.tableFooterView = UIView()
        tableview.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        let nib = UINib(nibName: "InfoHeaderView", bundle: nil)
        tableview.register(nib, forHeaderFooterViewReuseIdentifier: headerID)
        
        view.addSubview(tableview)
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
}

extension InfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = presenter?.infoCount() else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! InfoTableViewCell
        cell.config(with: (presenter?.getInfoName(at: indexPath.row))!, presenter?.getInfo(at: indexPath.row))
        return cell
    }
}

extension InfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(175)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(175)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableview.dequeueReusableHeaderFooterView(withIdentifier: headerID) as! InfoHeaderView
        if let nick = presenter?.getNickname() {
            header.setNickname(with: nick)
        }
        
        if let image = presenter?.getImage() {
            header.setImage(with: image)
        }
        
        return header
    }
}