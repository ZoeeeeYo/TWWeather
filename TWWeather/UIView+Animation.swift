//
//  UIView+Animation.swift
//  TWWeather
//
//  Created by Zoe on 16/06/2016.
//  Copyright © 2016 Tingting Wen. All rights reserved.
//

import UIKit

extension UIView {
    
    func scaleAnimation(fromValue: Double, toValue: Double, duration: Double) -> UIView{
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = fromValue
        scaleAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        scaleAnimation.toValue = toValue
        scaleAnimation.duration = duration
        scaleAnimation.repeatCount = 0
        scaleAnimation.autoreverses = true;
        scaleAnimation.removedOnCompletion = true;
        scaleAnimation.fillMode = kCAFillModeForwards;
        self.layer.addAnimation(scaleAnimation, forKey: "Float")
        return self
    }
}
