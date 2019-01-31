//
//  JMDataFlowDateTableViewCell.swift
//  news
//
//  Created by zhouweijie on 2018/12/24.
//  Copyright © 2018 malei. All rights reserved.
//

import UIKit

let JMDataFlowDateTableViewCellReUsedId = "JMDataFlowDateTableViewCellReUsedId"

@objcMembers class JMDataFlowDateTableViewCell: MGSwipeTableCell {
    
    private var subTitleWidthConstriant: NSLayoutConstraint!
    private var titleWidthConstriant: NSLayoutConstraint!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: JMDataFlowDateTableViewCellReUsedId)
        self.dk_backgroundColorPicker = DKColorPickerWithColors(UIColor.hex(hexValue: 0xF3F3F3), UIColor.hex(hexValue: 0x36363A))
        self.selectionStyle = .none
//        self.separatorInset = UIEdgeInsets(top: 0, left: CGFloat.greatestFiniteMagnitude, bottom: 0, right: 0)
        self.contentView.addSubview(self.title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 9).isActive = true
        title.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15).isActive = true
        title.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -9).isActive = true
        self.titleWidthConstriant = title.widthAnchor.constraint(equalToConstant: title.intrinsicContentSize.width)
        self.titleWidthConstriant!.isActive = true
        self.contentView.addSubview(self.subTitle)
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.topAnchor.constraint(greaterThanOrEqualTo: self.contentView.topAnchor, constant: 9).isActive = true
        subTitle.leftAnchor.constraint(equalTo: self.title.rightAnchor, constant: 16).isActive = true
        subTitle.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -9).isActive = true
        self.subTitleWidthConstriant = subTitle.widthAnchor.constraint(equalToConstant: subTitle.intrinsicContentSize.width)
        self.subTitleWidthConstriant!.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var title: UILabel = {
        let label = UILabel.init()
        label.dk_textColorPicker = DKColorPickerWithColors(UIColor.hex(hexValue: 0x333333), UIColor.hex(hexValue: 0x868687))
        label.font = UIFont.jm_regularFont(ofSize: 15)
        return label
    }()
    
    private var subTitle: UILabel = {
        let label = UILabel.init()
        label.dk_textColorPicker = DKColorPickerWithColors(UIColor.hex(hexValue: 0x999999), UIColor.hex(hexValue: 0x767676))
        label.font = UIFont.jm_regularFont(ofSize: 15)
        return label
    }()
    
    func updateCellWithDataFlowModel(model: JMDataFlowModel) -> Void {
        guard let dateModel: JMDataFlowDateModel = model.dateModel else {return}
        let titleString = dateModel.date_format
        self.title.text = String(titleString ?? "")
        self.subTitle.text = String(dateModel.msg ?? "")
        self.titleWidthConstriant.constant = self.title.intrinsicContentSize.width
        self.subTitleWidthConstriant.constant = self.subTitle.intrinsicContentSize.width
    }
    
}
