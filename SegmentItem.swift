//
//  SegmentItem.swift
//  customButton
//
//  Created by zhouweijie on 2019/1/28.
//  Copyright © 2019 zhouweijie. All rights reserved.
//

import UIKit

@objcMembers class SegmentItem: UIView {
    
    private(set) var button: WJButton
    
    var showDefaultIndicator: Bool = true {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    private(set) var indicatorView: UIImageView {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var indicatorPadding = UIEdgeInsets(top: 5, left: 0, bottom: 2, right: 0) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var defaultIndicatorSize: CGSize = CGSize(width: 20, height: 2) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    func getIndicatorSize() -> CGSize {
        if self.indicatorView.image != nil {
            return self.indicatorView.image!.size
        } else {
            return self.defaultIndicatorSize
        }
    }
    
    var isSelected: Bool {
        get {
            return self.button.isSelected
        }
        set {
            self.button.isSelected = newValue
        }
    }
    
    init(button: WJButton, indicator: UIImageView?) {
        self.button = button
        if indicator == nil {
            self.indicatorView = UIImageView.init(frame: .zero)
            self.indicatorView.layer.masksToBounds = true
            self.indicatorView.backgroundColor = UIColor.red
        } else {
            self.indicatorView = indicator!
        }
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonSize = self.button.intrinsicContentSize
        let indicatorSize = self.resetIndicatorSize()
        self.button.frame = CGRect(origin: .zero, size: buttonSize)
        self.indicatorView.frame = CGRect(origin: CGPoint(x: buttonSize.width-indicatorSize.width, y: buttonSize.height+self.indicatorPadding.top), size: indicatorSize)
        self.indicatorView.layer.cornerRadius = indicatorSize.height/2.0
    }
    
    override var intrinsicContentSize: CGSize {
        let buttonSize = self.button.intrinsicContentSize
        let indicatorSize = self.resetIndicatorSize()
        let height = buttonSize.height + self.indicatorPadding.top + indicatorSize.height + self.indicatorPadding.bottom
        return CGSize(width: buttonSize.width, height: height)
    }
    
    private func resetIndicatorSize() -> CGSize {
        let buttonSize = self.button.intrinsicContentSize
        var indicatorSize = self.indicatorView.image == nil ? self.defaultIndicatorSize : self.indicatorView.image!.size
        if indicatorSize.width > buttonSize.width {
            indicatorSize = CGSize(width: buttonSize.width, height: self.defaultIndicatorSize.height)
        }
        return indicatorSize
    }
    
}
