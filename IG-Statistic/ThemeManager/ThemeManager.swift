//
//   ThemeManager.swift
//  IG-Statistic
//
//  Created by и on 30.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

enum Theme: Int {
    case light, dark

    var mainColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return .black
        }
    }

    var barStyle: UIBarStyle {
        switch self {
        case .light:
            return .default
        case .dark:
            return .black
        }
    }

    var navigationBackgroundImage: UIImage? {
        return self == .light ? UIImage(named: "navBackground") : nil
    }

    var tabBarBackgroundImage: UIImage? {
        return self == .light ? UIImage(named: "tabBarBackground") : nil
    }

    var backgroundColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return .black
        }
    }

    var secondaryColor: UIColor {
        switch self {
        case .light:
            return .systemBlue
        case .dark:
            return .systemBlue
        }
    }
    
    var titleTextColor: UIColor {
        switch self {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
    
    var reverseTitleTextColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return .black
        }
    }
    
    var borderColor: UIColor {
        return .darkGray
    }
    
    var buttonColor: UIColor {
        switch self {
        case .light:
            return .black
        default:
            return .white
        }
    }
    var buttonSelectedColor: UIColor {
        return .systemBlue
    }
    
    var tableViewCellSelectedColor: UIColor {
        return .lightGray
    }
    
    var tintColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return .black
        }
    }
    
    var menuBarHighlightColor: UIColor {
        switch self {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
    
    var menuBarTintColor: UIColor {
        return .lightGray
    }
    
    var subtitleTextColor: UIColor {
        switch self {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
    
    var selectedSegmentColor: UIColor {
        switch self {
        case .light:
            return .systemBlue
        case .dark:
            return .lightGray
        }
    }
    
    var barsColor: UIColor {
        return .systemBlue
    }
    
    var collectionCellBorderColor: UIColor {
        return .lightGray
    }
    
    var lightCoral: UIColor {
        return UIColor(hexString:"F08080")
    }
    
    var systemBlue: UIColor {
        return UIColor.systemBlue
    }
    
    var segmentControlBackColor: UIColor {
        switch self {
        case .light:
            return .lightGray
        default:
            return .darkGray
        }
    }
}

let SelectedThemeKey = "SelectedTheme"

class ThemeManager {
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .dark
        }
    }

    static func applyTheme(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()

        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor

        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().setBackgroundImage(theme.navigationBackgroundImage, for: .default)
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")

        UITabBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().backgroundImage = theme.tabBarBackgroundImage

        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
        let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
    }
}
