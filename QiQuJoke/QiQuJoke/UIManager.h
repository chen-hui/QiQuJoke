//
//  UIManager.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/1.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXAlertView.h"
#import <UIKit/UIKit.h>
@interface UIManager : NSObject
+(void)showAlert:(NSString*)content;
+(void)showAlert:(NSString *)content title:(NSString*)title;
+(UIColor*)btnDefaultColor;
@end
