//
//  NSString+JM.h
//  news
//
//  Created by zhouwei on 2018/7/12.
//  Copyright © 2018年 malei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JM)

// 播放时间
- (NSString *)jm_playTime;

// 播放量转化
- (NSString *)jm_convertPlayCount;

@end

@interface NSString (MyMessage)// “我的消息”页面用到的分类
/**
 省略用户名(超过五个字截取并在末尾添加省略号)

 @param userName 要截取的用户名
 @return 返回处理好的用户名
 */
+ (NSString *)jm_TruncateUserNameWithEllipsis:(NSString *)userName maxLength:(NSInteger)maxLength;


/**
 生成富文本用户名

 @param userName 用户名
 @param isGuest 是否是嘉宾，如果是嘉宾需要带有嘉宾标识
 @return 处理好的富文本用户名
 */
+ (NSAttributedString *)combineUserName:(NSString *)userName isGuest:(BOOL)isGuest;


@end
