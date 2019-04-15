//
//  LogToolMessageModel.h
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogToolMessageModel : NSObject
@property (nonatomic,assign) NSInteger Id;

/**
  0 HTTP 1 Info 2Other 3Warning 4Error
 */
@property (nonatomic,assign) int type;
@property (nonatomic,strong) NSDate *dataStr;
@property (nonatomic,copy  ) NSString *fileStr;
@property (nonatomic,assign) int line;
@property (nonatomic,copy  ) NSString *menthodStr;
@property (nonatomic,copy  ) NSString *formatStrStr;
@end

NS_ASSUME_NONNULL_END
