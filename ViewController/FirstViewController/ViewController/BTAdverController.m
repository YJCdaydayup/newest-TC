//
//  BTAdverController.m
//  DianZTC
//
//  Created by 杨力 on 15/2/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "BTAdverController.h"
#import "NetManager.h"
#import "AppDelegate.h"
#import "BatarMainTabBarContoller.h"
#import "WebViewController.h"
#import "DetailViewController.h"

@interface BTAdverController ()
{
    NetManager *_manager;
    NSDictionary *_infoDict;
}
@property (nonatomic,strong) UIImageView * bgImgView;

/** 计时器 */
@property (nonatomic,strong) UILabel * timerLbl;
@property (nonatomic,assign) NSInteger showTime;
@property (nonatomic,strong) NSTimer * advTimer;


@end

@implementation BTAdverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NetManager * manager = [NetManager shareManager];
    _manager = manager;
    NSDictionary * info = [manager bt_getAdvertiseControlInfo];
    _infoDict = info;
    self.bgImgView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.bgImgView];
    self.bgImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImg)];
    [self.bgImgView addGestureRecognizer:tap];
    self.bgImgView.image = [UIImage imageWithData:[manager bt_getAdvertiseInfo]];
    CGFloat showTime = [info[@"showtime"]floatValue];
    self.showTime = showTime;
    self.showTime = 10;
    [self showTimerLabel];
}

/*
 {
 action = "<null>";
 actiontype = 1;
 image = cc1a59a05d4f36b4547f8453cb4eca97;
 isopen = 1;
 showtime = 2;
 }
 */
-(void)clickImg{
    
    [self changeMode];
    BatarMainTabBarContoller * mainVc = [BatarMainTabBarContoller sharetabbarController];
    UINavigationController * nvc = mainVc.viewControllers[0];
    FirstViewController * firstVc = nvc.viewControllers[0];
    switch ([_infoDict[@"actiontype"]integerValue]) {
        case 1:
            //推广类别
        {
            //            type = 1的接口
            [firstVc showRecommandType:1 param:_infoDict[@"action"]];
        }
            break;
        case 2:
            //产品详情
        {
            [firstVc showDetailViewNumber:_infoDict[@"action"]];
            
        }
            break;
        case 3:
            //网页跳转
        {
            [firstVc showWebViewVc:_infoDict[@"action"]];
        }
            break;
        case 11:
        {
            //推广类别
            //type = 2的接口
            [firstVc showRecommandType:2 param:_infoDict[@"action"]];
            
        }
            break;
        default:
            break;
    }
    [self.advTimer setFireDate:[NSDate distantFuture]];
    [self.advTimer invalidate];
    self.advTimer = nil;
}

-(void)showTimerLabel{
    
    self.timerLbl = [Tools createLabelWithFrame:CGRectMake(Wscreen-105*S6, Hscreen-62.5*S6, 75*S6,40*S6) textContent:@"" withFont:[UIFont systemFontOfSize:14*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    self.timerLbl.backgroundColor = RGB_COLOR(0, 0, 0, 0.6);
    self.timerLbl.layer.cornerRadius = 7.5*S6;
    self.timerLbl.layer.masksToBounds = YES;
    [self.bgImgView addSubview:self.timerLbl];
    
    @WeakObj(self);
    [self.timerLbl addTapGestureCallback:^{
        [selfWeak changeMode];
        [selfWeak.advTimer setFireDate:[NSDate distantFuture]];
        [selfWeak.advTimer invalidate];
        selfWeak.advTimer = nil;
    }];
    
    self.timerLbl.text = [NSString stringWithFormat:@"跳过 %zi",self.showTime];
    self.advTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.advTimer forMode:NSRunLoopCommonModes];
    [self.advTimer setFireDate:[NSDate distantPast]];
}

-(void)timeDown{
    
    self.showTime = self.showTime -1;
    self.timerLbl.text =  self.timerLbl.text = [NSString stringWithFormat:@"跳过 %zi",self.showTime];
    if(self.showTime==0){
        [self changeMode];
        [self.advTimer setFireDate:[NSDate distantFuture]];
        [self.advTimer invalidate];
        self.advTimer = nil;
    }
}

-(void)changeMode{
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BatarMainTabBarContoller * tabbar = [BatarMainTabBarContoller sharetabbarController];
    app.window.rootViewController = tabbar;
}

@end
