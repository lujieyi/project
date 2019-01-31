//
//  NSString+JM.m
//  news
//
//  Created by zhouwei on 2018/7/12.
//  Copyright © 2018年 malei. All rights reserved.
//

#import "NSString+JM.h"
#import "UIFont+JM.h"

@implementation NSString (JM)

- (NSString *)jm_playTime {
    
    NSInteger secCount = [self integerValue];
    NSInteger minuteCount = secCount / 60;
    NSInteger hourCount = minuteCount / 60;
    
    NSString *minuteStr;
    NSString *hourStr;
    if (hourCount > 0) {
        if (hourCount < 10) {
            hourStr = [NSString stringWithFormat:@"0%li", hourCount];
        }
        else {
            hourStr = [NSString stringWithFormat:@"%li", hourCount];
        }
    }
    
    if (minuteCount < 10) {
        minuteStr = [NSString stringWithFormat:@"0%li", minuteCount];
    }
    else {
        
        if (hourCount > 0) {
            minuteCount = minuteCount % 60;
        }
        
        minuteStr = [NSString stringWithFormat:@"%li", minuteCount];
    }
    
    NSString *secStr;
    if ((secCount % 60) < 10) {
        secStr = [NSString stringWithFormat:@"0%li", (secCount % 60)];
    }
    else {
        secStr = [NSString stringWithFormat:@"%li", (secCount % 60)];
    }
    
    NSMutableString *mutableString = [[NSMutableString alloc]init];
    
    if (hourStr) {
        [mutableString appendString:hourStr];
        [mutableString appendString:@":"];
    }
    [mutableString appendString:minuteStr];
    [mutableString appendString:@":"];
    [mutableString appendString:secStr];
    
    return mutableString;
}

- (NSString *)jm_convertPlayCount {
    long long count = self.longLongValue;
    
    float kts = count / 1000.0;
    
    float wts = count / 10000.0;
    
    int roundTs = (int)roundf(kts);
    
    float decimal = (float)roundTs/10 - floor((float)roundTs/10);
    
    if (wts >= 1.0) {
        if (decimal > 0.1) {
            return [NSString stringWithFormat:@"%.1fw",((float)roundTs/10)];
        }
        else {
            return [NSString stringWithFormat:@"%.0fw", (float)roundTs/10];
        }
    }
    else {
        return self;
    }
}

+ (NSString *)jm_TruncateUserNameWithEllipsis:(NSString *)userName maxLength:(NSInteger)maxLength {
    if (userName.length > maxLength) {
        NSString *modifiedstring = [userName substringToIndex:maxLength];
        modifiedstring = [modifiedstring stringByAppendingString:@"..."];
        return modifiedstring;
    }
    else {
        return userName;
    }
}

+ (NSAttributedString *)combineUserName:(NSString *)userName isGuest:(BOOL)isGuest {
    NSMutableAttributedString *mutableAtttributedString = [[NSMutableAttributedString alloc] initWithString:userName ?: @"" attributes:@{
                                                                                                                                  NSForegroundColorAttributeName : SRGBCOLOR_HEX(0x4f71b7),
                                                                                                                                  NSFontAttributeName : [UIFont jm_regularFontOfSize:15]
                                                                                                                                  }];
    if (isGuest) {
        NSTextAttachment *guestAttachment = [[NSTextAttachment alloc] init];
        guestAttachment.image = [UIImage as_imageNamed:@"MyMessage/jiabin"];
        guestAttachment.bounds = CGRectMake(0, -3, [UIImage as_imageNamed:@"MyMessage/jiabin"].size.width, [UIImage as_imageNamed:@"MyMessage/jiabin"].size.height);
        NSAttributedString *guestAttributedString = [NSAttributedString attributedStringWithAttachment:guestAttachment];
        [mutableAtttributedString appendAttributedString:guestAttributedString];
    }
    return mutableAtttributedString;
}

@end
