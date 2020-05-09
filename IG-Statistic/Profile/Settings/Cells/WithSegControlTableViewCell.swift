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
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(with title: String) {
        label.text = title
    }
    
    @IBAction func changessegment(_ sender: Any) {

    }
    
    func setupView() {
        segmentControl.setTitle("Light", forSegmentAt: 0)
        segmentControl.setTitle("Dark", forSegmentAt: 1)
        selectionStyle = .none
        self.icon.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.label.textColor = ThemeManager.currentTheme().titleTextColor
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().selectedSegmentColor]
        //self.segmentControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        ///self.segmentControl.tintColor = .red
        
        //self.segmentControl.selectedSegmentTintColor = .red
        //self.segmentControl.setTitleTextAttributes(       , for: )
        //self.segmentControl.selectedSegmentTintColor = ThemeManager.currentTheme().selectedSegmentColor
      //  self.segmentControl.backgroundColor = ThemeManager.currentTheme().secondaryColor
    }
}
