//
//  Extensions.swift
//  Krixi-Demo
//
//  Created by Vishal Sonawane on 16/06/17.
//  Copyright © 2017 Vishal Sonawane. All rights reserved.
//

import UIKit

    //MARK: Corner Radius , Shaddow in StoryBoard
    extension UIView {
        
        @IBInspectable var shadow: Bool {
            get {
                return layer.shadowOpacity > 0.0
            }
            set {
                if newValue == true {
                    self.addShadow()
                }
            }
        }
        
        @IBInspectable var cornerRadius: CGFloat {
            get {
                return self.layer.cornerRadius
            }
            set {
                self.layer.cornerRadius = newValue
                
                // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
                if shadow == false {
                    self.layer.masksToBounds = true
                }
            }
        }
        
        
        func addShadow(_ shadowColor: CGColor = UIColor.black.cgColor,
                       shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                       shadowOpacity: Float = 0.4,
                       shadowRadius: CGFloat = 3.0) {
            layer.shadowColor = shadowColor
            layer.shadowOffset = shadowOffset
            layer.shadowOpacity = shadowOpacity
            layer.shadowRadius = shadowRadius
        }
    }
