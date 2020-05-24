//
//  WithSegControlTableViewCell.swift
//  IG-Statistic
//
//  Created by и on 05.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

class WithSegControlTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var label: UILabel!
    weak var delegate: changeThemeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(with title: String) {
        label.text = title
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            ThemeManager.applyTheme(theme: .light)
        case 1:
            ThemeManager.applyTheme(theme: .dark)
        default:
            print("No action")
        }
        delegate?.redrawView()
    }
    
    func setupView() {
        segmentControl.setTitle("Light", forSegmentAt: 0)
        segmentControl.setTitle("Dark", forSegmentAt: 1)
        segmentControl.tintColor = .red
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().titleTextColor]
        let titleSelectedTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().lightCoral]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(titleSelectedTextAttributes, for: .selected)
        segmentControl.backgroundColor = ThemeManager.currentTheme().segmentControlBackColor
        selectionStyle =  .none
        self.icon.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.label.textColor = ThemeManager.currentTheme().titleTextColor
        
        switch ThemeManager.currentTheme() {
        case .light:
            segmentControl.selectedSegmentIndex = 0
        default:
            segmentControl.selectedSegmentIndex = 1
        }
    }
}

protocol changeThemeDelegate: AnyObject {
    func redrawView()
}
