//
//  SQLiteManager.m
//  LogStatistical
//
//  Created by RM on 2018/6/23.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import "SQLiteToolManager.h"
#import "LogMessage.h"
#import "SQLiteModel.h"
#import "FMDB.h"
@interface SQLiteToolManager ()
@property (nonatomic, strong)FMDatabase *db;
@end
@implementation SQLiteToolManager
static SQLiteToolManager* _instance = nil;

+(instancetype) shareInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[SQLiteToolManager alloc] init];
        [_instance openDB:@"myLog.sqlite"];
    }) ;
    
    return _instance ;
}

/**
 创建数据表

 @return 是否成功
 */
- (BOOL)createTableDB {
    NSString *sql = @"\
    CREATE TABLE IF NOT EXISTS logMsg(\
                                      id INTEGER PRIMARY KEY AUTOINCREMENT,\
                                      type INTEGER,\
                                      msg TEXT,\
                                      time DATETIME\
                                      );";
    return [self.db executeUpdate:sql];
}

/**
 打开、创建数据库

 @param name 数据库名称
 */
- (void)openDB:(NSString *)name {
    NSString *path = [NSString stringWithFormat:@"%@/%@",[self documentDir],name];
    _db = [[FMDatabase alloc]initWithPath:path];
    if (!_db.open) {// open()特点: 如果数据库文件不存在就创建一个新的, 如果存在就直接打开
        LogMsg(@"打开数据库失败");
        return;
    } else {
        LogMsg(@"打开数据库成功");
    }
    if (![self createTableDB]) {
        LogMsg(@"创建数据库失败");
        return;
    } else {
        LogMsg(@"创建数据库成功");
    }
    
}

/**
 新增数据

 @param msg 内容
 @param type 类型
 @return 是否成功
 */
- (BOOL)insert:(NSString *)msg type:(LogMessageType )type {
    NSDate *date = [[NSDate alloc]init];
    NSString* sql = @"\
    INSERT INTO logMsg\
    (\
     type,\
     msg,\
     time\
     )\
    VALUES\
    (?,?,?);\
    ";
    NSInteger typeIndex = 0;
    switch (type) {
        case LogMessageError:
            typeIndex = 0;
            break;
        case LogMessageInfo:
            typeIndex = 1;
            break;
        case LogMessageWarning:
            typeIndex = 2;
            break;
        case LogMessageHttp:
            typeIndex = 3;
            break;
        case LogMessageOther:
            typeIndex = 4;
            break;
    }
    BOOL isSc = [self.db executeUpdate:sql withArgumentsInArray:@[[NSNumber numberWithUnsignedInteger:typeIndex],msg,date]];
    if (isSc) {
        LogMsg(@"新增数据成功");
    } else {
        LogMsg(@"新增数据失败");
    }
    return isSc;
}


- (NSString *)documentDir {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}



/**
 查询日志按照时间排序

 @param indexPage 第几页
 @return 数组
 */
- (NSArray<SQLiteModel *> *)select:(NSInteger)indexPage {
    NSInteger page = indexPage <= 1 ? 0 : (indexPage - 1) * 20;
    NSString * sql2 = @"SELECT * FROM logMsg ORDER BY time DESC LIMIT ?,20;";
    FMResultSet *result = [self.db executeQuery:sql2 withArgumentsInArray:@[[NSNumber numberWithInteger:page]]];
    NSMutableArray<SQLiteModel *> *array = [NSMutableArray array];
    while (result.next) {
        SQLiteModel *model = [[SQLiteModel alloc]init];
        model.msg = [result stringForColumn:@"msg"];
        model.type = [result intForColumn:@"type"];
        model.time = [[result dateForColumn:@"time"] string];
        [array addObject:model];
    }
    return array;
}


/**
 查询日志

 @param indexPage 第几页
 @param type 类型
 @return 返回
 */
- (NSArray<SQLiteModel *> *)select:(NSInteger)indexPage type:(LogMessageType)type {
    NSInteger page = indexPage <= 1 ? 0 : (indexPage - 1) * 20;
    NSString * sql2 = @"SELECT * FROM logMsg where type = ? ORDER BY time DESC LIMIT ?,20;";
    FMResultSet *result = [self.db executeQuery:sql2 withArgumentsInArray:@[[NSNumber numberWithInteger:type],[NSNumber numberWithInteger:page]]];
    NSMutableArray<SQLiteModel *> *array = [NSMutableArray array];
    while (result.next) {
        SQLiteModel *model = [[SQLiteModel alloc]init];
        model.msg = [result stringForColumn:@"msg"];
        model.type = [result intForColumn:@"type"];
        model.time = [[result dateForColumn:@"time"] string];
        [array addObject:model];
    }
    return array;
}




/**
 查询关键字日志
 
 @param indexPage 第几页
 @param key 关键字
 @return 返回
 */
- (NSArray<SQLiteModel *> *)select:(NSInteger)indexPage keyWord:(NSString *)key {
    NSInteger page = indexPage <= 1 ? 0 : (indexPage - 1) * 20;
    NSString * sql2 = @"SELECT * FROM logMsg where msg like ? ORDER BY time DESC LIMIT ?,20;";
    FMResultSet *result = [self.db executeQuery:sql2 withArgumentsInArray:@[[NSString stringWithFormat:@"%@%@\%@",@"%",key,@"%"],[NSNumber numberWithInteger:page]]];
    NSMutableArray<SQLiteModel *> *array = [NSMutableArray array];
    while (result.next) {
        SQLiteModel *model = [[SQLiteModel alloc]init];
        model.msg = [result stringForColumn:@"msg"];
        model.type = [result intForColumn:@"type"];
        model.time = [[result dateForColumn:@"time"] string];
        [array addObject:model];
    }
    return array;
}















@end
