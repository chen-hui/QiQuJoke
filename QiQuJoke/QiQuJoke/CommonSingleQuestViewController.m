//
//  CommonSingleQuestViewController.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/1.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "CommonSingleQuestViewController.h"

@interface CommonSingleQuestViewController(){
    UILabel *cntLbl;
    UIButton *answerBtn;
    UIButton *shareBtn;
}

@end

@implementation CommonSingleQuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    // Do any additional setup after loading the view.
}

-(void)initView{
    [self.navigationController setNavigationBarHidden:false];
    self.title = NSLocalizedString(@"canYouGuess", nil);
    self.view.backgroundColor =[UIColor whiteColor];
    cntLbl = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetHeight(self.view.frame)/3, CGRectGetWidth(self.view.frame) - 50, 100)];
    cntLbl.textAlignment = NSTextAlignmentCenter;
    cntLbl.numberOfLines = 0;
    [self.view addSubview:cntLbl];
    
    answerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    answerBtn.frame = CGRectMake((CGRectGetWidth(self.view.frame)-kBtnNormalWidth)/2, CGRectGetMaxY(cntLbl.frame)+30, kBtnNormalWidth, kBtnDefaultHeight);
    answerBtn.layer.cornerRadius = 2;
    [answerBtn addTarget:self action:@selector(btnAnswerClicked:) forControlEvents:UIControlEventTouchUpInside];
    [answerBtn setBackgroundColor:[UIManager btnDefaultColor]];
    [answerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [answerBtn setTitle:NSLocalizedString(@"openResult", nil) forState:UIControlStateNormal];
    [self.view addSubview:answerBtn];
    
    shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn.frame = CGRectMake(CGRectGetMinX(answerBtn.frame), CGRectGetMaxY(answerBtn.frame)+15, CGRectGetWidth(answerBtn.frame), CGRectGetHeight(answerBtn.frame));
    shareBtn.layer.cornerRadius = 2;
    [shareBtn addTarget:self action:@selector(btnShareClicked) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setBackgroundColor:[UIManager btnDefaultColor]];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn setTitle:NSLocalizedString(@"share", nil) forState:UIControlStateNormal];
    [self.view addSubview:shareBtn];
    
    
    if (_cntType == CTTrick) {
        TrickModel *trickModel = _cnt;
        cntLbl.text =trickModel.content;
    }
    else if (_cntType == CTRiddle) {
        RiddleModel *riddleModel = _cnt;
        cntLbl.text = riddleModel.content;
    }
    else if (_cntType == CTSaying) {
        SayingModel *sayingModel = _cnt;
        cntLbl.text = sayingModel.content;
        answerBtn.hidden = YES;
    }
    
}

-(void)btnShareClicked{
    LXActivity  *sheetView = [[LXActivity alloc]initWithTitle:NSLocalizedString(@"shareToWhere", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) ShareButtonTitles:@[NSLocalizedString(@"wechat", nil),NSLocalizedString(@"wechatFriends", nil),NSLocalizedString(@"QQ", nil),NSLocalizedString(@"QQZone", nil)] withShareButtonImagesName:@[@"sns_icon_wechat",@"sns_icon_friends",@"sns_icon_qq",@"sns_icon_zone" ]];
    [sheetView showInView:self.view];
}

-(void)btnAnswerClicked:(id)sender{
    if (_cntType == CTTrick) {
        TrickModel *trickModel = _cnt;
        [UIManager showAlert:trickModel.answer  title:NSLocalizedString(@"rightAnswer", nil)];
    }
    else if (_cntType == CTRiddle) {
        RiddleModel *riddleModel =_cnt;
        [UIManager showAlert:riddleModel.answer title:NSLocalizedString(@"rightAnswer", nil) ];
    }
    else if (_cntType == CTSaying) {
        
    }
    
    
}

-(void)shareToWechat{
    [self shareCommon:SSDKPlatformTypeWechat];
}

-(void)shareToWechatFriends{
    [self shareCommon:SSDKPlatformSubTypeWechatTimeline];
}

-(void)shareCommon:(SSDKPlatformType)platformType{
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:cntLbl.text
                                     images:@[[UIImage imageNamed:@"shareImg"]]
                                        url:[NSURL URLWithString:@"http://mob.com"]
                                      title:self.tabBarItem.title
                                       type:SSDKContentTypeImage];
    
    //进行分享
    [ShareSDK share:platformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [UIManager showAlert:nil title:NSLocalizedString(@"shareSuccess", nil)];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [UIManager showAlert:[NSString stringWithFormat:@"%@", error]  title:NSLocalizedString(@"shareFailed", nil)];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 [UIManager showAlert:nil title:NSLocalizedString(@"shareCancel", nil)];
                 break;
             }
             default:
                 break;
         }
         
     }];
}

-(void)shareToQQ{
    [self shareCommon:SSDKPlatformTypeQQ];
}

-(void)shareToZone{
    [self shareCommon:SSDKPlatformSubTypeQZone];
}

-(void)didClickOnImageIndex:(NSInteger *)imageIndex{
    if ((NSInteger)imageIndex == 0) { //微信
        [self shareToWechat];
    }
    else if((NSInteger)imageIndex == 1){//微信朋友圈
        [self shareToWechatFriends];
        
    }
    else if((NSInteger)imageIndex == 2){//qq
        [self shareToQQ];
        
    }else if((NSInteger)imageIndex ==3){//qq空间
        [self shareToZone];
        
    }
}

-(void)initData{
    
}

@end
