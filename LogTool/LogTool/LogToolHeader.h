//
//  LogToolHeader.h
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#ifndef LogToolHeader_h
#define LogToolHeader_h
#import "LogToolExceptionHandler.h"
#import "UIImage+LogTool.h"
#import "UIColor+LogTool.h"
#import "LogToolMessageModel.h"
#import "LogToolPrintMsgModel.h"
#import "LogToolStatistical.h"
// 主题颜色
#define LogTool_Color_Tin_COLOR  [UIColor logtool_colorWithHexString:@"#4fa036"]
// 文字颜色
#define LogTool_Color_Label_TITLECOLOR  [UIColor logtool_colorWithHexString:@"#333333"]
// 导航栏颜色
#define LogTool_Color_FFFFFF_COLOR  [UIColor logtool_colorWithHexString:@"#ffffff"]
// 导航栏颜色
#define LogTool_Color_ViewBackgroundColor_COLOR  [UIColor logtool_colorWithHexString:@"#000000"]


#define Max_Sql_Count 500


#ifdef DEBUG
#define LogToolMsg(format, ...) NSLog(format)
#else
#define LogToolMsg(format, ...)
#endif


/**
 打印信息
 直接用该方法打印日志只会在控制台输出、不会在APP内部统计
 @param format 格式化字符串
 @param ... 多个值
 @return 返回字符串 时间:类:对象:所在文件:行数:方法:内容:
 */
#ifdef DEBUG
#define LogMsg(format, ...) {\
const char *file = [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]; \
int line = __LINE__; \
const char  *menthod = __PRETTY_FUNCTION__; \
const char  *formatStr = [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String];\
[LogToolPrintMsgModel printStrWithfile:file Andline:line menthod:menthod formatStr:formatStr];\
}
#else
#define LogMsg(format, ...)
#endif
/**
 打印错误日志信息
 
 @param format 格式化字符串
 @param ... 多个值
 @return 返回值
 */
#ifdef DEBUG
#define LogError(format, ...) {\
const char *file = [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]; \
int line = __LINE__; \
const char  *menthod = __PRETTY_FUNCTION__; \
const char  *formatStr = [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String];\
[LogToolPrintMsgModel printError:[LogToolPrintMsgModel printStrWithfile:file Andline:line menthod:menthod formatStr:formatStr]];\
}
#else
#define LogError(format, ...)
#endif
/**
 打印警告日志信息
 
 @param format 格式化字符串
 @param ... 多个值
 @return 返回值
 */
#ifdef DEBUG
#define LogWarning(format, ...) {\
const char *file = [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]; \
int line = __LINE__; \
const char  *menthod = __PRETTY_FUNCTION__; \
const char  *formatStr = [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String];\
[LogToolPrintMsgModel printWarning:[LogToolPrintMsgModel printStrWithfile:file Andline:line menthod:menthod formatStr:formatStr]];\
}
#else
#define LogWarning(format, ...)
#endif
/**
 打印info日志信息
 
 @param format 格式化字符串
 @param ... 多个值
 @return 返回值
 */
#ifdef DEBUG
#define LogInfo(format, ...) {\
const char *file = [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]; \
int line = __LINE__; \
const char  *menthod = __PRETTY_FUNCTION__; \
const char  *formatStr = [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String];\
[LogToolPrintMsgModel printInfo:[LogToolPrintMsgModel printStrWithfile:file Andline:line menthod:menthod formatStr:formatStr]];\
}
#else
#define LogInfo(format, ...)
#endif
/**
 打印网络请求日志信息
 
 @param format 格式化字符串
 @param ... 多个值
 @return 返回值
 */
#ifdef DEBUG
#define LogHttp(format, ...) {\
const char *file = [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]; \
int line = __LINE__; \
const char  *menthod = __PRETTY_FUNCTION__; \
const char  *formatStr = [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String];\
[LogToolPrintMsgModel printHttp:[LogToolPrintMsgModel printStrWithfile:file Andline:line menthod:menthod formatStr:formatStr]];\
}
#else
#define LogHttp(format, ...)
#endif
/**
 打印其他日志信息
 
 @param format 格式化字符串
 @param ... 多个值
 @return 返回值
 */
#ifdef DEBUG
#define LogOther(format, ...) {\
const char *file = [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]; \
int line = __LINE__; \
const char  *menthod = __PRETTY_FUNCTION__; \
const char  *formatStr = [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String];\
[LogToolPrintMsgModel printOther:[LogToolPrintMsgModel printStrWithfile:file Andline:line menthod:menthod formatStr:formatStr]];\
}
#else
#define LogOther(format, ...)
#endif


#define LogToolConfig() {\
[[LogToolStatistical shareInstance]showButton];\
[LogToolExceptionHandler catchCrashLogs];\
\
}




#endif /* LogToolHeader_h */
