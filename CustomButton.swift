//
//  CustomButton.swift
//  customButton
//
//  Created by zhouweijie on 2019/1/4.
//  Copyright © 2019 zhouweijie. All rights reserved.
//

import UIKit

@objcMembers class CustomButton: UIButton {
    enum contentAlignMent {
        case horizontal
        case vertical
    }
    
    enum imageAlignMent {
        case beginning
        case end
    }
    
//    enum childsAlignment {
//        case top
//        case center
//        case bottom
//    }
    
    var contentAlignment: contentAlignMent = .horizontal
//    var childsAlignment: childsAlignment = .center
//    var contentSpacing: CGFloat = 0
    var imageAlignment: imageAlignMent = .beginning
//    var padding: UIEdgeInsets = .zero
//    var imageBeginningOffset: CGFloat = 0.0
//    var titleBeginningOffset: CGFloat = 0.0
    
    init(title: String, image: UIImage) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setImage(image, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func setImage(_ image: UIImage?, for state: UIControl.State) {
//        if image == nil {
//            return
//        }
//        super.setImage(image, for: state)
//    }
//
//    override func setTitle(_ title: String?, for state: UIControl.State) {
//        if title == nil {
//            return
//        } else {
//            super.setTitle(title, for: state)
//            self.titleLabel?.attributedText = NSAttributedString(string: title!)
//        }
//    }
    private func getTitleSize() -> CGSize? {
        
        return self.titleLabel?.attributedText?.boundingRect(with: CGSize(width: self.titleLabel?.preferredMaxLayoutWidth ?? CGFloat(UInt8.max), height: CGFloat(UInt8.max)), options: [], context: nil).size
    }
    
    override var intrinsicContentSize: CGSize {
        let imageSize = self.imageView?.image?.size
        let titleSize = self.getTitleSize()
//        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
//        return self.tempIntrinsicContentSize
//        return super.intrinsicContentSize
        if self.contentAlignment == .horizontal {
            let imageWidth = imageSize?.width ?? 0
            let titleWidth = titleSize?.width ?? 0
            let width: CGFloat = self.contentEdgeInsets.left + self.contentEdgeInsets.right + titleWidth + imageWidth
            let height = (imageSize?.height ?? 0) > (titleSize?.height ?? 0) ? (imageSize?.height ?? 0) : (titleSize?.height ?? 0)
            return CGSize(width: width, height: height+self.contentEdgeInsets.top+self.contentEdgeInsets.bottom)
        } else {
            let width = (imageSize?.width ?? 0) > (titleSize?.width ?? 0) ? (imageSize?.width ?? 0) : (titleSize?.width ?? 0)
            let imageHeight = imageSize?.height ?? 0
            let titleHeight = titleSize?.height ?? 0
            let height = self.contentEdgeInsets.top + self.contentEdgeInsets.bottom + titleHeight + imageHeight
            return CGSize(width: width+self.contentEdgeInsets.left+self.contentEdgeInsets.right, height: height)
        }
    }
    
//    override open class var requiresConstraintBasedLayout: Bool {
//        return true
//    }
    
    override func contentRect(forBounds bounds: CGRect) -> CGRect {
        return super.contentRect(forBounds: bounds)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleSize = self.getTitleSize()
        if self.contentAlignment == .horizontal {
            if self.imageAlignment == .beginning {
                return CGRect(origin: CGPoint(x: contentRect.size.width - (titleSize?.width ?? 0) - contentEdgeInsets.right, y: contentEdgeInsets.top), size: titleSize ?? .zero)
            } else {
                return CGRect(origin: CGPoint(x: self.contentEdgeInsets.left, y: self.contentEdgeInsets.top), size: titleSize ?? .zero)
            }
        } else {
            if self.imageAlignment == .beginning {
                return CGRect(origin: CGPoint(x: contentRect.size.height - (titleSize?.height ?? 0) - contentEdgeInsets.bottom, y: contentEdgeInsets.top), size: titleSize ?? .zero)
            } else {
                return CGRect(origin: CGPoint(x: self.contentEdgeInsets.left, y: self.contentEdgeInsets.top), size: titleSize ?? .zero)
            }
        }
        return super.titleRect(forContentRect: contentRect)
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
//        if self.contentAlignment == .horizontal {
//            if self.imageAlignment == .beginning {
//
//            } else {
//
//            }
//        } else {
//
//        }
        return super.imageRect(forContentRect: contentRect)
    }
    
//    private var imageTopConstraint: NSLayoutConstraint?
//    private var imageLeadingConstraint: NSLayoutConstraint?
//    private var imageLeadingConstraint: NSLayoutConstraint?
//    private var imageLeadingConstraint: NSLayoutConstraint?
//    override func updateConstraints() {
//        if let image = self.imageView {
//            if let label = self.titleLabel {
//
//            } else {
//
//            }
//        } else {
//            if let label = self.titleLabel {
//
//            } else {
//
//            }
//        }
//        self.imageView!.translatesAutoresizingMaskIntoConstraints = false
//        self.titleLabel!.translatesAutoresizingMaskIntoConstraints = false
//        if self.contentAlignment == .horizontal {
//            self.imageView!.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: padding.top).isActive = true
//            self.imageView!.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -padding.bottom).isActive = true
//            self.titleLabel!.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: padding.top).isActive = true
//            self.titleLabel!.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -padding.bottom).isActive = true
//            if self.imageAlignment == .beginning {
//                self.imageView!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding.left).isActive = true
//                self.titleLabel!.leadingAnchor.constraint(equalTo: self.imageView!.trailingAnchor, constant: contentSpacing).isActive = true
//                self.titleLabel!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: padding.right).isActive = true
//            } else {
//                self.titleLabel!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding.left).isActive = true
//                self.imageView!.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: contentSpacing).isActive = true
//                self.imageView!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: padding.right).isActive = true
//            }
//        } else {
//            self.imageView!.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: -padding.left).isActive = true
//            self.imageView!.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: padding.right).isActive = true
//            self.titleLabel!.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: -padding.left).isActive = true
//            self.titleLabel!.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: padding.right).isActive = true
//            if self.imageAlignment == .beginning {
//                self.imageView!.topAnchor.constraint(equalTo: self.topAnchor, constant: padding.top).isActive = true
//                self.imageView!.bottomAnchor.constraint(equalTo: self.titleLabel!.topAnchor, constant: contentSpacing).isActive = true
//                self.titleLabel!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: padding.bottom).isActive = true
//            } else {
//                self.titleLabel!.topAnchor.constraint(equalTo: self.topAnchor, constant: padding.top).isActive = true
//                self.titleLabel!.bottomAnchor.constraint(equalTo: self.imageView!.topAnchor, constant: contentSpacing).isActive = true
//                self.imageView!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: padding.bottom).isActive = true
//            }
//        }
//        super.updateConstraints()
//    }
    
//    private func updateContentFrame() {
//        self.imageView!.widthAnchor.constraint(equalToConstant: self.imageView!.intrinsicContentSize.width).isActive = true
//        self.imageView!.heightAnchor.constraint(equalToConstant: self.imageView!.intrinsicContentSize.height).isActive = true
//        self.titleLabel!.widthAnchor.constraint(equalToConstant: self.titleLabel!.intrinsicContentSize.width).isActive = true
//        self.titleLabel!.heightAnchor.constraint(equalToConstant: self.titleLabel!.intrinsicContentSize.height).isActive = true
//    }
    
//    private func setupConstraints() {
//        if self.contentAlignment == .horizontal {
//            self.imageView!.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: -padding.top).isActive = true
//            self.imageView!.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: padding.bottom).isActive = true
//            self.titleLabel!.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: padding.bottom).isActive = true
//            self.titleLabel!.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: -padding.top).isActive = true
//            if self.imageAlignment == .beginning {
//                self.imageView!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding.left).isActive = true
//                self.titleLabel!.leadingAnchor.constraint(equalTo: self.imageView!.trailingAnchor, constant: contentSpacing).isActive = true
//                self.titleLabel!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: padding.right).isActive = true
//            } else {
//                self.titleLabel!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding.left).isActive = true
//                self.imageView!.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: contentSpacing).isActive = true
//                self.imageView!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: padding.right).isActive = true
//            }
//        } else {
//            self.imageView!.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: -padding.left).isActive = true
//            self.imageView!.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: padding.right).isActive = true
//            self.titleLabel!.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: -padding.left).isActive = true
//            self.titleLabel!.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: padding.right).isActive = true
//            if self.imageAlignment == .beginning {
//                self.imageView!.topAnchor.constraint(equalTo: self.topAnchor, constant: padding.top).isActive = true
//                self.imageView!.bottomAnchor.constraint(equalTo: self.titleLabel!.topAnchor, constant: contentSpacing).isActive = true
//                self.titleLabel!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: padding.bottom).isActive = true
//            } else {
//                self.titleLabel!.topAnchor.constraint(equalTo: self.topAnchor, constant: padding.top).isActive = true
//                self.titleLabel!.bottomAnchor.constraint(equalTo: self.imageView!.topAnchor, constant: contentSpacing).isActive = true
//                self.imageView!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: padding.bottom).isActive = true
//            }
//        }
//    }
    
//    private var tempIntrinsicContentSize = CGSize.zero
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if var imageFrame = self.imageView?.frame {
//            let imageIntrinsicSize = self.imageView!.intrinsicContentSize
//            if self.contentAlignment == .horizontal {
//                if self.imageAlignment == .beginning {
//                    if var titleFrame = self.titleLabel?.frame {
//                        let titleIntrinsicContentSize = self.titleLabel!.intrinsicContentSize
//                        let maxHeight = imageIntrinsicSize.height > titleIntrinsicContentSize.height ? imageIntrinsicSize.height : titleIntrinsicContentSize.height
//                        titleFrame.origin = CGPoint(x: imageIntrinsicSize.width + contentSpacing, y: (maxHeight-titleIntrinsicContentSize.height)/2.0 + padding.top)
//                        titleFrame.size = self.titleLabel!.intrinsicContentSize
//                        self.titleLabel!.frame = titleFrame
//
//
//                        imageFrame.origin = CGPoint(x: padding.left, y: (maxHeight - imageIntrinsicSize.height)/2.0 + padding.top)
//                        imageFrame.size = imageIntrinsicSize
//                        self.imageView!.frame = imageFrame
//
//                        tempIntrinsicContentSize = CGSize(width: imageIntrinsicSize.width+contentSpacing+titleIntrinsicContentSize.width, height: maxHeight)
//                    } else {
//
//                    }
//                } else {
//
//                }
//            } else {
//
//            }
//        } else {
//
//        }
//    }
    
}

