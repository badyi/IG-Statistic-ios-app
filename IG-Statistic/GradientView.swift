//
//  GradientView.swift
//  IG-Statistic
//
//  Created by и on 14.04.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var beginColor : UIColor = UIColor.clear //(hexString: "#FFB6C1")
    @IBInspectable var endColor : UIColor = UIColor.clear //white
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context?.addRect(rect)
        context?.clip()
        let colors : [CGColor] = [beginColor.cgColor, endColor.cgColor]
        var locations : [CGFloat] = [0, 1]
        let grad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: &locations)
        let startPoint = CGPoint(x: rect.midX, y: rect.maxY)
        let endPoint = CGPoint(x: rect.midX, y: rect.minY)
        context?.drawLinearGradient(grad!, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
    }
}
