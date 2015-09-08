//
//  ViewController.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/8/28.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)initView{
    RiddleViewController *rvCtrl = [[RiddleViewController alloc]init];
    rvCtrl.tabBarItem.title = NSLocalizedString(@"riddle", nil);
    rvCtrl.tabBarItem.image = [UIImage imageNamed:@"chat_b"];
    
    TrickViewController *trickCtrl = [[TrickViewController alloc]init];
    trickCtrl.tabBarItem.title = NSLocalizedString(@"trick", nil);
    trickCtrl.tabBarItem.image = [UIImage imageNamed:@"icloud_b"];
    
    SayingViewController *sayingCtrl =[[SayingViewController alloc]init];
    sayingCtrl.tabBarItem.title = NSLocalizedString(@"saying", nil);
    sayingCtrl.tabBarItem.image = [UIImage imageNamed:@"kb_b"];
    
    [self addChildViewController:[[MLNavigationController alloc] initWithRootViewController:rvCtrl]];
    [self addChildViewController:[[MLNavigationController alloc] initWithRootViewController:trickCtrl]];
    [self addChildViewController:[[MLNavigationController alloc] initWithRootViewController:sayingCtrl]];
//    [self addChildViewController:rvCtrl];
//    [self addChildViewController:trickCtrl];
//    [self addChildViewController:sayingCtrl];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
