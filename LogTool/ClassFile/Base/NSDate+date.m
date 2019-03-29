//
//  NSDate+date.m
//  LogStatistical
//
//  Created by RM on 2018/6/23.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import "NSDate+date.h"

@implementation NSDate (date)
+ (NSString *)currenttDate {
    //获得系统时间
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}
- (NSString *)string {
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * locationString = [dateformatter stringFromDate:self];
    return locationString;
}
@end
