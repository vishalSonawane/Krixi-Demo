//
//  Utils.swift
//  Krixi-Demo
//
//  Created by Vishal Sonawane on 14/06/17.
//  Copyright © 2017 Vishal Sonawane. All rights reserved.
//

import UIKit
import TSMessages

class Utils {

    
  static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func showSucess(_ message:String){
        TSMessage.showNotification(withTitle: message, type: .success)
    }
    static func showError(_ message:String){
        TSMessage.showNotification(withTitle: message, type: .error)
    }
    static func showError(_ message:String, viewController:UIViewController){
        TSMessage.showNotification(in: viewController, title: message, subtitle: "", type: .error)
    }
}
