//
//  UIManager.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/1.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "UIManager.h"
#import <UIKit/UIKit.h>
@implementation UIManager

+(void)showAlert:(NSString *)content{
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:NSLocalizedString(@"tip", nil) contentText:content leftButtonTitle:nil  rightButtonTitle:NSLocalizedString(@"confirm", nil)];
    [alert show];
}

+(void)showAlert:(NSString *)content title:(NSString*)title{
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:title contentText:content leftButtonTitle:nil  rightButtonTitle:NSLocalizedString(@"confirm", nil)];
    [alert show];
}

+(UIColor *)btnDefaultColor{
    return [UIColor colorWithRed:87.0/255.0 green:135.0/255.0 blue:173.0/255.0 alpha:1];
}

@end
