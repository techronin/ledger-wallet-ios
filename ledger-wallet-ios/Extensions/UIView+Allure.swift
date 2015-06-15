//
//  UIView+Allure.swift
//  ledger-wallet-ios
//
//  Created by Nicolas Bigot on 12/01/2015.
//  Copyright (c) 2015 Ledger. All rights reserved.
//

import UIKit

private var allureKey = "allure"

extension UIView {
    
    // MARK: - Allure
    
    @IBInspectable var allure: String? {
        get {
            return objc_getAssociatedObject(self, &allureKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &allureKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            ViewStylist.stylizeView(self)
        }
    }
    
    convenience init(allure: String) {
        self.init(frame: CGRectZero)
        self.allure = allure
    }
    
}