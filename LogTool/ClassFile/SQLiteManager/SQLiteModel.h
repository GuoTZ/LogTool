//
//  SQLiteModel.h
//  LogStatistical
//
//  Created by RM on 2018/6/23.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogMessage.h"
@interface SQLiteModel : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString  *msg;
@property (nonatomic, strong) NSString  *time;
@property (nonatomic, assign) LogMessageType type;
@end
