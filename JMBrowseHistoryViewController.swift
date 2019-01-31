//
//  JMBrowseHistoryViewController.swift
//  news
//
//  Created by zhouweijie on 2018/12/24.
//  Copyright © 2018 malei. All rights reserved.
//

import UIKit

class JMBrowseHistoryViewController: JMCollectionAndHistoryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editButton.isHidden = true
    }
    
    override func getAPI() -> (requst: JMRequest2018, isHistory: Bool) {
        return (MyHistoryAPI.init(page: self.currentPage, lastTime: self.lastTime ?? "0"), true)
    }
    
    override func getLogoType() -> LogoType {
        return LogoType.history
    }
    
    override func loadLocalData() {
        
    }
    
    override func getViewDidAppearBlock() {
        if self.viewDidApparBlock != nil {
            self.viewDidApparBlock!(1)
        }
    }
    
}
