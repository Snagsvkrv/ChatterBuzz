//
//  YoTextField.swift
//  yobro
//
//  Created by Atul Manwar on 19/02/15.
//  Copyright (c) 2015 Atul Manwar. All rights reserved.
//

import UIKit

class YoTextField: UITextField {
    func commonInit() {
//        var leftView = UIView(frame: CGRectMake(0, 0, 20, self.frame.size.height))
//        leftView.backgroundColor = UIColor.clearColor()
//        self.leftView = leftView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.backgroundColor = UIColor.whiteColor()
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        self.layer.borderColor = UIColor(red: (192/255.0), green: (192/255.0), blue: (192/255.0), alpha: 1.0).CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
    }
    
//    override func drawPlaceholderInRect(rect: CGRect) {
//        UIColor.darkGrayColor().setFill()
//        super.drawPlaceholderInRect(rect)
//    }
    
//    override func textRectForBounds(bounds: CGRect) -> CGRect {
//        return CGRectInset( bounds, 20, 10)
//    }
//    
//    override func editingRectForBounds(bounds: CGRect) -> CGRect {
//        return CGRectInset( bounds, 20, 10)
//    }
}
