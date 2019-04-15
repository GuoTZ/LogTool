//
//  LogToolSQLiteManager.m
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolSQLiteManager.h"
#import "LogToolMessageModel.h"
#import "FMDB.h"
#import "LogToolHeader.h"
@interface LogToolSQLiteManager (){
    dispatch_queue_t _workConcurrentQueue;
    dispatch_queue_t _serialQueue;
    dispatch_semaphore_t _semaphore;
}
@property (nonatomic, strong)FMDatabase *db;
@end

@implementation LogToolSQLiteManager
static LogToolSQLiteManager* _instance = nil;

+(instancetype) shareInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[LogToolSQLiteManager alloc] init];
        [_instance openDB:@"myLog.sqlite"];
        _instance->_workConcurrentQueue = dispatch_queue_create("cccccccc", DISPATCH_QUEUE_CONCURRENT);
        _instance->_serialQueue = dispatch_queue_create("sssssssss",DISPATCH_QUEUE_SERIAL);
       _instance->_semaphore = dispatch_semaphore_create(3);
    }) ;
    
    return _instance ;
}

/**
 创建数据表
 @property (nonatomic,copy  ) NSString *fileStr;
 @property (nonatomic,assign) int lineStr;
 @property (nonatomic,copy  ) NSString *menthodStr;
 @return 是否成功
 */
- (BOOL)createTableDB {
    NSString *sql = @"\
    CREATE TABLE IF NOT EXISTS logMsg(\
    id INTEGER PRIMARY KEY AUTOINCREMENT,\
    type INTEGER,\
    lineStr INTEGER,\
    msg TEXT,\
    file TEXT,\
    menthod TEXT,\
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
 */
- (void)insert:(LogToolMessageModel *)msg {
    
    //使用信号量机制可以实现线程的同步，也可以控制最大并发数
    for (NSInteger i = 0; i < 10; i++) {
        dispatch_async(_instance->_serialQueue, ^{
            dispatch_semaphore_wait(_instance->_semaphore, DISPATCH_TIME_FOREVER);
            dispatch_async(_instance->_workConcurrentQueue, ^{
                NSDate *date = [[NSDate alloc]init];
                NSString* sql = @"\
                INSERT INTO logMsg\
                (\
                type,\
                lineStr,\
                msg,\
                file,\
                menthod,\
                time\
                )\
                VALUES\
                (?,?,?,?,?,?);\
                ";
                NSError *err;
                //加锁
                @synchronized (self) {
                    BOOL isSc = [self.db executeUpdate:sql values:@[@(msg.type),@(msg.line),msg.formatStrStr,msg.fileStr,msg.menthodStr,date] error:&err];
                    if (isSc) {
                        LogMsg(@"新增数据成功");
                    } else {
                        LogMsg(@"新增数据失败----err%@",err);
                    }
                }
                dispatch_semaphore_signal(_instance->_semaphore);});
        });
    }
   
    
}


- (NSString *)documentDir {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}



/**
 查询日志按照时间排序
 
 @param indexPage 第几页
 @return 数组
 */
- (NSArray<LogToolMessageModel *> *)select:(NSInteger)indexPage type:(NSInteger)type{
    NSInteger page = indexPage <= 1 ? 0 : (indexPage - 1) * Max_Sql_Count;
    FMResultSet *result;
    
    NSMutableArray<LogToolMessageModel *> *array = [NSMutableArray array];
    @try {
        if (type<0) {
            NSString * sql2 = @"SELECT * FROM logMsg ORDER BY time DESC LIMIT ?,?;";
            result = [self.db executeQuery:sql2 withArgumentsInArray:@[[NSNumber numberWithInteger:page],@(Max_Sql_Count)]];
        } else {
            NSString * sql = @"SELECT * FROM logMsg where type=? ORDER BY time DESC LIMIT ?,?;";
            result = [self.db executeQuery:sql withArgumentsInArray:@[@(type),[NSNumber numberWithInteger:page],@(Max_Sql_Count)]];
        }
        while (result.next) {
            [array addObject:[self config:result]];
        }
    } @catch (NSException *exception) {
        LogMsg(@" 查询日志按照时间排序%@",exception)
    } @finally {
        
    }
    return array;
}


- (LogToolMessageModel *)config:(FMResultSet *)result{
    LogToolMessageModel *model = [[LogToolMessageModel alloc]init];
    model.formatStrStr = [result stringForColumn:@"msg"];
    model.type = [result intForColumn:@"type"];
    model.line = [result intForColumn:@"lineStr"];
    model.fileStr = [result stringForColumn:@"file"];
    model.menthodStr = [result stringForColumn:@"menthod"];
    model.dataStr = [result dateForColumn:@"time"];
    model.Id = [result dateForColumn:@"id"];
    return model;
}


/**
 查询关键字日志
 
 @param indexPage 第几页
 @param key 关键字
 @return 返回
 */
- (NSArray<LogToolMessageModel *> *)select:(NSInteger)indexPage keyWord:(NSString *)key  type:(NSInteger)type{
    NSInteger page = indexPage <= 1 ? 0 : (indexPage - 1) * Max_Sql_Count;
    FMResultSet *result;
    if (type<0) {
        NSString * sql2 = @"SELECT * FROM logMsg where msg like ? ORDER BY time DESC LIMIT ?,?;";
        result = [self.db executeQuery:sql2 withArgumentsInArray:@[[NSString stringWithFormat:@"%@%@\%@",@"%",key,@"%"],[NSNumber numberWithInteger:page],@(Max_Sql_Count)]];
    } else {
        NSString * sql2 = @"SELECT * FROM logMsg where type=? msg like ? ORDER BY time DESC LIMIT ?,?;";
        result = [self.db executeQuery:sql2 withArgumentsInArray:@[@(type),[NSString stringWithFormat:@"%@%@\%@",@"%",key,@"%"],[NSNumber numberWithInteger:page],@(Max_Sql_Count)]];
    }
    NSMutableArray<LogToolMessageModel *> *array = [NSMutableArray array];
    while (result.next) {
        [array addObject:[self config:result]];
    }
    return array;
}

/**
 查询关键字日志
 */
- (BOOL)deleteType:(NSInteger)type{
    BOOL result;
    NSError *err;
    if (type<0) {
        NSString * sql2 = @"DELETE FROM logMsg";
        result = [self.db executeUpdate:sql2 values:nil error:&err];
    } else {
        NSString * sql2 = @"DELETE FROM logMsg WHERE type = ?";
        result = [self.db executeUpdate:sql2 values:@[@(type)]  error:&err];
    }
    if (result) {
        LogMsg(@"新增数据成功");
    } else {
        LogMsg(@"新增数据失败----err%@",err);
    }
    return result;
}
/**
 查询关键字日志
 */
- (BOOL)deleteId:(NSInteger)Id{
    BOOL result;
    NSError *err;
    NSString * sql2 = @"DELETE FROM logMsg WHERE id = ?";
    result = [self.db executeUpdate:sql2 values:@[@(Id)]  error:&err];
    if (result) {
        LogMsg(@"新增数据成功");
    } else {
        LogMsg(@"新增数据失败----err%@",err);
    }
    return result;
}
//select shopId from dyd_orders group by shopId  having count(*) > 1

/**
 查询文件列表
 @return 返回
 */
- (NSArray<LogToolMessageModel *> *)selectFileNames{
    FMResultSet *result;
    NSString * sql = @"select * from logMsg group by file  having count(*) > 1;";
    result = [self.db executeQuery:sql];
    NSMutableArray<LogToolMessageModel *> *array = [NSMutableArray array];
    while (result.next) {
        [array addObject:[self config:result]];
    }
    return array;
}

/**
 查询文件
 
 @param indexPage 第几页
 @return 数组
 */
- (NSArray<LogToolMessageModel *> *)selectFileNames:(NSInteger)indexPage fileName:(NSString *)fileName{
    NSInteger page = indexPage <= 1 ? 0 : (indexPage - 1) * Max_Sql_Count;
    FMResultSet *result;
    
    NSMutableArray<LogToolMessageModel *> *array = [NSMutableArray array];
    @try {
        NSString * sql = @"SELECT * FROM logMsg where file = ? ORDER BY time DESC LIMIT ?,?;";
        result = [self.db executeQuery:sql withArgumentsInArray:@[fileName,[NSNumber numberWithInteger:page],@(Max_Sql_Count)]];
        while (result.next) {
            [array addObject:[self config:result]];
        }
    } @catch (NSException *exception) {
        LogMsg(@" 查询日志按照时间排序%@",exception)
    } @finally {
        
    }
    return array;
}

@end
