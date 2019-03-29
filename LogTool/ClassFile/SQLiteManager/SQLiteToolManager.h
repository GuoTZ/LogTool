//
//  SQLiteManager.h
//  LogStatistical
//
//  Created by RM on 2018/6/23.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogMessage.h"
@class SQLiteModel;
@interface SQLiteToolManager : NSObject
+(instancetype) shareInstance ;
/**
 新增数据
 
 @param msg 内容
 @param type 类型
 @return 是否成功
 */
- (BOOL)insert:(NSString *)msg type:(LogMessageType)type;
/**
 查询日志按照时间排序
 
 @param indexPage 第几页
 @return 数组
 */
- (NSArray<SQLiteModel *> *)select:(NSInteger)indexPage ;
/**
 查询日志
 
 @param indexPage 第几页
 @param type 类型
 @return 返回
 */
- (NSArray<SQLiteModel *> *)select:(NSInteger)indexPage type:(LogMessageType)type ;
/**
 查询关键字日志
 
 @param indexPage 第几页
 @param key 关键字
 @return 返回
 */
- (NSArray<SQLiteModel *> *)select:(NSInteger)indexPage keyWord:(NSString *)key;
@end
