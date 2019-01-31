//
//  MyCollectionAPI.swift
//  news
//
//  Created by zhouweijie on 2018/12/20.
//  Copyright © 2018 malei. All rights reserved.
//

import UIKit

@objcMembers class MyCollectionAPI: JMRequest2018 {
   
    private var page: UInt
    
    init(page: UInt) {
        self.page = page
        super.init()
    }
    
    override func baseUrl() -> String {
        return httpsPapiUrl
    }
    
    override func requestUrl() -> String {
        return "app/collect/listsnew"
    }
    
    override func requestArgument() -> Any? {
        return ["page":page]
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return YTKRequestMethod.GET
    }
}
