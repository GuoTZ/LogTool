//
//  UIView+VC.m
//  LogStatistical
//
//  Created by RM on 2018/6/23.
//  Copyright © 2018年 GTZ. All rights reserved.
//

#import "UIView+VC.h"

@implementation UIView (VC)
/**
 *  @brief  找到当前view所在的viewcontroler
 */
- (UIViewController *)viewCtl {
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    } while (responder);
    return nil;
}
@end
