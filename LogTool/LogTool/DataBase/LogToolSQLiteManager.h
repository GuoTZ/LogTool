//
//  LogToolSQLiteManager.h
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LogToolMessageModel;
@interface LogToolSQLiteManager : NSObject
+(instancetype) shareInstance;
/**
 新增数据
 
 @param msg 内容
 */
- (void)insert:(LogToolMessageModel *)msg ;





/**
 查询日志按照时间排序
 
 @param indexPage 第几页
 @return 数组
 */
- (NSArray<LogToolMessageModel *> *)select:(NSInteger)indexPage type:(NSInteger)type;

/**
 查询关键字日志
 
 @param indexPage 第几页
 @param key 关键字
 @return 返回
 */
- (NSArray<LogToolMessageModel *> *)select:(NSInteger)indexPage keyWord:(NSString *)key type:(NSInteger)type;

/**
 查询文件列表
 @return 返回
 */
- (NSArray<LogToolMessageModel *> *)selectFileNames;
/**
 查询文件
 
 @param indexPage 第几页
 @return 数组
 */
- (NSArray<LogToolMessageModel *> *)selectFileNames:(NSInteger)indexPage fileName:(NSString *)fileName;
/**
删除
 */
- (BOOL)deleteType:(NSInteger)type;
- (BOOL)deleteId:(NSInteger)Id;
@end

NS_ASSUME_NONNULL_END
