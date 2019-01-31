//
//  JMSegmentView.swift
//  news
//
//  Created by zhouweijie on 2018/12/21.
//  Copyright © 2018 malei. All rights reserved.
//

import UIKit

let JMSegmentViewReUsedID = "JMSegmentViewReUsedID"

@objcMembers class JMSegmentView: UIView {

    var titles = [String]()
    var itemSpace: CGFloat = 24.0
    var buttonInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    var buttonFrame = [CGRect]()
    var titleColor: DKColorPicker = DKColorPickerWithColors(UIColor.hex(hexValue: 0x333333), UIColor.hex(hexValue: 0x868687))
    var selectedTitleColor: DKColorPicker = DKColorPickerWithColors(UIColor.hex(hexValue: 0xF12B15), UIColor.hex(hexValue: 0xC22514))
    var titleFont = UIFont.jm_regularFont(ofSize: 18)
    var selectedTitleFont = UIFont.jm_mediumFont(ofSize: 18)
    var selectedIndex: Int!
    var indicatorSize: CGSize = CGSize(width: 20, height: 2)
//    var previousSelectedIndex: Int?
    var indicatorTopSpace: CGFloat = 0.0
    
    var willSelectItem: ((IndexPath) -> Void)?
    var didSelectItem: ((IndexPath) -> Void)?
    
    lazy var titlesButtons: [UIButton] = {
        var array = [UIButton]()
        for title:String in titles {
            let button = UIButton.init()
            button.dk_setTitleColorPicker(titleColor, for: UIControl.State.normal)
            button.dk_setTitleColorPicker(selectedTitleColor, for: UIControl.State.selected)
            button.titleLabel?.font = titleFont
            button.setTitle(title, for: UIControl.State.normal)
            button.isUserInteractionEnabled = false
            button.contentHorizontalAlignment = .center
            array.append(button)
        }
        array[self.selectedIndex].isSelected = true
        return array
    }()
    
    lazy var indicatorView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.dk_backgroundColorPicker = selectedTitleColor
        imageView.layer.cornerRadius = indicatorSize.height/2.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    convenience init(titles: [String]) {
       self.init(titles: titles, selectedIndex: 0)
    }
    
    init(titles: [String], selectedIndex: Int) {
        super.init(frame: CGRect.zero)
        self.titles = titles
        self.selectedIndex = selectedIndex
        var selfWidth: CGFloat = 0
        var buttonWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        for titleButton in self.titlesButtons {
            let intrinsicSize = titleButton.intrinsicContentSize
            buttonWidth = intrinsicSize.width + buttonInset.left + buttonInset.right
            self.buttonFrame.append(CGRect(origin: CGPoint(x: selfWidth, y: 0), size: CGSize(width: buttonWidth, height: intrinsicSize.height)))
            selfWidth += buttonWidth
            if titleButton != self.titlesButtons.last {
                selfWidth += itemSpace
            }
            maxHeight = maxHeight > intrinsicSize.height ? maxHeight : intrinsicSize.height
        }
        self.frame = CGRect(x: 0, y: 0, width: selfWidth, height: maxHeight+indicatorTopSpace+indicatorSize.height)
        self.addSubview(collectionView)
        collectionView.frame = self.bounds
        self.addSubview(indicatorView)
        let x: CGFloat = (self.buttonFrame[selectedIndex].width - indicatorSize.width)/2.0 + self.buttonFrame[selectedIndex].minX
        let y: CGFloat = titlesButtons[selectedIndex].intrinsicContentSize.height + indicatorTopSpace
        indicatorView.frame = CGRect(origin: CGPoint(x: x, y: y), size: indicatorSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- collectionView
    lazy var collectionView: UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = itemSpace
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: JMSegmentViewReUsedID)
        return collectionView
    }()
    
}

extension JMSegmentView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titlesButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JMSegmentViewReUsedID, for: indexPath)
        let button = self.titlesButtons[indexPath.row]
        cell.addSubview(button)
        let size = self.buttonFrame[indexPath.row].size
        button.frame = CGRect(origin: CGPoint.zero, size: size)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.buttonFrame[indexPath.row].size
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.setSelctedState(indexPath: indexPath)
        if self.didSelectItem != nil {
            self.didSelectItem!(indexPath)
        }
    }
    
    func setSelctedState(indexPath: IndexPath) {
        let priviousButton = self.titlesButtons[self.selectedIndex]
        let currentButton = self.titlesButtons[indexPath.row]
        priviousButton.isSelected = false
        priviousButton.titleLabel?.font = titleFont
        currentButton.isSelected = true
        currentButton.titleLabel?.font = selectedTitleFont
        self.selectedIndex = indexPath.row
        let newX = currentButton.convert(currentButton.frame, to: self).minX + (currentButton.frame.width - indicatorSize.width)/2.0
        var newFrame = self.indicatorView.frame
        newFrame.origin.x = newX
        UIView.animate(withDuration: 0.3) {
            self.indicatorView.frame = newFrame
        }
    }
}
