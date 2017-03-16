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

@interface BTAdverController ()
{
    NetManager *_manager;
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
    
    self.bgImgView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.bgImgView];
    
    NetManager * manager = [NetManager shareManager];
    _manager = manager;
    self.bgImgView.image = [UIImage imageWithData:[manager bt_getAdvertiseInfo]];
    
    NSDictionary * info = [manager bt_getAdvertiseControlInfo];
    CGFloat showTime = [info[@"showtime"]floatValue];
    self.showTime = showTime;
    
    [self showTimerLabel];
}

-(void)showTimerLabel{
    
    self.timerLbl = [Tools createLabelWithFrame:CGRectMake(Wscreen-105*S6, Hscreen-62.5*S6, 75*S6,40*S6) textContent:@"" withFont:[UIFont systemFontOfSize:14*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    self.timerLbl.backgroundColor = RGB_COLOR(0, 0, 0, 0.6);
    self.timerLbl.layer.cornerRadius = 7.5*S6;
    self.timerLbl.layer.masksToBounds = YES;
    [self.bgImgView addSubview:self.timerLbl];
    
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
        BatarMainTabBarContoller * tabbar = [[BatarMainTabBarContoller alloc]init];
        app.window.rootViewController = tabbar;
}

@end
