//
//  UIButtonExctension.swift
//  Calculator
//
//  Created by Михаил Железовский on 13.02.2022.
//

import UIKit

extension UIButton {
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.3
        pulse.fromValue = 0.95
        pulse.toValue = 1
        pulse.autoreverses = false
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 0.5
        
        layer.add(pulse, forKey: nil)
    }
    
}
