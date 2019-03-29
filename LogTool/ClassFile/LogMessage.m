//
//  LogMessage.m
//  LogStatistical
//
//  Created by RM on 2018/6/23.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import "LogMessage.h"
#import "SQLiteToolManager.h"
@implementation LogMessage

+ (void)printHttp:(NSString *)msg{
    [[SQLiteToolManager shareInstance] insert:msg type:LogMessageHttp];
}

+ (void)printInfo:(NSString *)msg{
    [[SQLiteToolManager shareInstance] insert:msg type:LogMessageInfo];
}

+ (void)printOther:(NSString *)msg{
    [[SQLiteToolManager shareInstance] insert:msg type:LogMessageOther];
}

+ (void)printWarning:(NSString *)msg{
    [[SQLiteToolManager shareInstance] insert:msg type:LogMessageWarning];
}

+ (void)printError:(NSString *)msg{
    [[SQLiteToolManager shareInstance] insert:msg type:LogMessageError];
}

@end
