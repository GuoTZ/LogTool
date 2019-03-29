//
//  LogMessage.h
//  LogStatistical
//
//  Created by RM on 2018/6/23.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+date.h"

/**
 打印信息
直接用该方法打印日志只会在控制台输出、不会在APP内部统计
 @param format 格式化字符串
 @param ... 多个值
 @return 返回字符串 时间:类:对象:所在文件:行数:方法:内容:
 */
#define LogMsg(format, ...) ({\
    printf("———————————————开始打印———————————————");\
    const char *date = [[NSDate currenttDate] UTF8String]; \
    const char *file = [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]; \
    int line = __LINE__; \
    const char  *menthod = __PRETTY_FUNCTION__; \
    const char  *formatStr = [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String]; \
    printf("\n时间:\n\t%s\n类:\n\t对象:%p\n\t所在文件:%s\n\t行数:%d\n方法: \n\t%s\n内容:\n\t%s",date, self, file, line, menthod, formatStr); \
    printf("\n———————————————打印结束———————————————\n");\
    printf("\n");\
    NSString *dataStr = [NSString stringWithUTF8String:date];\
    NSString *fileStr = [NSString stringWithUTF8String:file];\
    NSString *menthodStr = [NSString stringWithUTF8String:menthod];\
    NSString *formatStrStr = [NSString stringWithUTF8String:formatStr];\
    [NSString stringWithFormat:@"\n时间:\n\t%@\n类:\n\t对象:%p\n\t所在文件:%@\n\t行数:%d\n方法: \n\t%@\n内容:\n\t%@",dataStr, self, fileStr, line, menthodStr, formatStrStr];\
})

/**
 打印错误日志信息

 @param format 格式化字符串
 @param ... 多个值
 @return 返回值
 */
#define LogError(format, ...) {\
    NSLog(@"\n这是一个错误error");\
    [LogMessage printError:LogMsg(format)];\
}
/**
 打印警告日志信息
 
 @param format 格式化字符串
 @param ... 多个值
 @return 返回值
 */
#define LogWarning(format, ...) {\
NSLog(@"\n这是一个警告日志信息Warning");\
    [LogMessage printWarning:LogMsg(format)];\
}
/**
 打印info日志信息
 
 @param format 格式化字符串
 @param ... 多个值
 @return 返回值
 */
#define LogInfo(format, ...) {\
NSLog(@"\n这是一个info日志信息");\
    [LogMessage printInfo:LogMsg(format)];\
}
/**
 打印网络请求日志信息
 
 @param format 格式化字符串
 @param ... 多个值
 @return 返回值
 */
#define LogHttp(format, ...) {\
NSLog(@"\n这是一个网络请求日志信息");\
    [LogMessage printHttp:LogMsg(format)];\
}
/**
 打印其他日志信息
 
 @param format 格式化字符串
 @param ... 多个值
 @return 返回值
 */
#define LogOther(format, ...) {\
NSLog(@"\n这是一个其他信息Other");\
    [LogMessage printOther:LogMsg(format)];\
}

// 日志类型
typedef enum LogMessageType{
    LogMessageError =  0,
    LogMessageInfo = 1,
    LogMessageWarning = 2,
    LogMessageHttp = 3,
    LogMessageOther = 4,
}LogMessageType;


@interface LogMessage : NSObject
+ (void)printError:(NSString *)msg;
+ (void)printHttp:(NSString *)msg;
+ (void)printInfo:(NSString *)msg;
+ (void)printOther:(NSString *)msg;
+ (void)printWarning:(NSString *)msg;
@end


