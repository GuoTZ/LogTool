//
//  UIImage+LogTool.h
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LogTool)
- (UIImage *)logtool_imageWithTintColor:(UIColor *)tintColor ;
+ (UIImage *)logtool_imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale actions:(void (^)(CGContextRef contextRef))actionBlock ;
+ (UIImage *)logtool_imageWithColor:(UIColor *)color ;

+ (UIImage *)logtool_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
@end

NS_ASSUME_NONNULL_END
