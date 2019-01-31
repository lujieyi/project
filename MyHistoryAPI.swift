//
//  MyHistoryAPI.swift
//  news
//
//  Created by zhouweijie on 2018/12/25.
//  Copyright © 2018 malei. All rights reserved.
//

import UIKit

@objcMembers class MyHistoryAPI: JMRequest2018 {
    
    private var page: UInt
    private var lastTime: String
    
    init(page: UInt, lastTime: String) {
        self.page = page
        self.lastTime = lastTime
        super.init()
    }
    
    override func baseUrl() -> String {
        return httpsPapiUrl
    }
    
    override func requestUrl() -> String {
        return "app/user/readhistory"
    }
    
    override func requestArgument() -> Any? {
        return ["page":page, "lastTime":lastTime]
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return YTKRequestMethod.GET
    }
    
}
