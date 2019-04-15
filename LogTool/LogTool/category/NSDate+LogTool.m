//
//  NSDate+LogTool.m
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "NSDate+LogTool.h"

@implementation NSDate (LogTool)
+ (NSString *)currenttDate_logtool {
    //获得系统时间
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}
- (NSString *)string_logtool {
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * locationString = [dateformatter stringFromDate:self];
    return locationString;
}
@end
