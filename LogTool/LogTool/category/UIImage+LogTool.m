//
//  UIImage+LogTool.m
//  LogTool
//
//  Created by DingYD on 2019/3/29.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "UIImage+LogTool.h"
#import <CoreGraphics/CoreGraphics.h>
#define ScreenScale ([[UIScreen mainScreen] scale])
CG_INLINE CGFloat
removeFloatMin(CGFloat floatValue) {
    return floatValue == CGFLOAT_MIN ? 0 : floatValue;
}
CG_INLINE CGFloat
flatSpecificScale(CGFloat floatValue, CGFloat scale) {
    floatValue = removeFloatMin(floatValue);
    scale = scale ?: ScreenScale;
    CGFloat flattedValue = ceil(floatValue * scale) / scale;
    return flattedValue;
}
CG_INLINE CGFloat
flat(CGFloat floatValue) {
    return flatSpecificScale(floatValue, 0);
}

CG_INLINE CGRect
CGRectMakeWithSize(CGSize size) {
    return CGRectMake(0, 0, size.width, size.height);
}
CG_INLINE BOOL
CGSizeIsEmpty(CGSize size) {
    return size.width <= 0 || size.height <= 0;
}
/// 将一个 CGSize 像素对齐
CG_INLINE CGSize
CGSizeFlatted(CGSize size) {
    return CGSizeMake(flat(size.width), flat(size.height));
}


@implementation UIImage (LogTool)
- (UIImage *)logtool_imageWithTintColor:(UIColor *)tintColor {
    return [UIImage logtool_imageWithSize:self.size opaque:self.qmui_opaque scale:self.scale actions:^(CGContextRef contextRef) {
        CGContextTranslateCTM(contextRef, 0, self.size.height);
        CGContextScaleCTM(contextRef, 1.0, -1.0);
        CGContextSetBlendMode(contextRef, kCGBlendModeNormal);
        CGContextClipToMask(contextRef, CGRectMakeWithSize(self.size), self.CGImage);
        CGContextSetFillColorWithColor(contextRef, tintColor.CGColor);
        CGContextFillRect(contextRef, CGRectMakeWithSize(self.size));
    }];
}
+ (UIImage *)logtool_imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale actions:(void (^)(CGContextRef contextRef))actionBlock {
    if (!actionBlock || CGSizeIsEmpty(size)) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    actionBlock(context);
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOut;
}
- (BOOL)qmui_opaque {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    BOOL opaque = alphaInfo == kCGImageAlphaNoneSkipLast
    || alphaInfo == kCGImageAlphaNoneSkipFirst
    || alphaInfo == kCGImageAlphaNone;
    return opaque;
}
+ (UIImage *)logtool_imageWithColor:(UIColor *)color {
    return [UIImage logtool_imageWithColor:color size:CGSizeMake(4, 4) cornerRadius:0];
}

+ (UIImage *)logtool_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    size = CGSizeFlatted(size);
//    CGContextInspectSize(size);
    
    color = color ? color : [UIColor clearColor];
    BOOL opaque = (cornerRadius == 0.0);
    return [UIImage logtool_imageWithSize:size opaque:opaque scale:0 actions:^(CGContextRef contextRef) {
        CGContextSetFillColorWithColor(contextRef, color.CGColor);
        
        if (cornerRadius > 0) {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMakeWithSize(size) cornerRadius:cornerRadius];
            [path addClip];
            [path fill];
        } else {
            CGContextFillRect(contextRef, CGRectMakeWithSize(size));
        }
    }];
}
@end
