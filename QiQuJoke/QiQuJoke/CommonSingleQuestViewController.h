//
//  CommonSingleQuestViewController.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/1.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumManager.h"
#import "DefineManager.h"
#import "TrickModel.h"
#import "RiddleModel.h"
#import "SayingModel.h"
#import <ShareSDK/ShareSDK.h>
#import "LXActivity.h"
#import "UIManager.h"
@interface CommonSingleQuestViewController : UIViewController<LXActivityDelegate>

@property (nonatomic) id  cnt;
@property (nonatomic) ContentType cntType;

@end
