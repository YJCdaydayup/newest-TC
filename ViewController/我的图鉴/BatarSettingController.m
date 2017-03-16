//
//  BatarSettingController.m
//  DianZTC
//
//  Created by 杨力 on 24/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "BatarSettingController.h"
#import "BatarLoginController.h"
#import "SavaViewController.h"
#import "HKPieChartView.h"
#import "YLLocationManager.h"
#import "NetManager.h"
#import "YLLoginView.h"
#import "YLCoder2D.h"
#import "FinalOrderViewController.h"
#import "BatarBadgeView.h"

@interface BatarSettingController(){
    
    YLCoder2D * andriod_coder2DView;
    YLCoder2D * ios_coder2DView;
    UIView * _bgView;
    NSDictionary * bottomDict;
}

@property (nonatomic,strong) UILabel * userName;

/** 待确认角标 */
@property (nonatomic,strong) BatarBadgeView * badgeView;

@end

@implementation BatarSettingController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hasLogined) name:UploadOrders object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBadge) name:ServerMsgNotification object:nil];
    
    [self getBottomData];
}

#pragma 改变角标
-(void)changeBadge{
    
    [self.badgeView changeBadgeValue:[NSString stringWithFormat:@"%@",SocketModel.state_1]];
}

-(void)hasLogined{
    
    self.userName.text = [NSString stringWithFormat:@"客户编号: %@",CUSTOMERID];
}

-(void)getBottomData{
    
    NetManager * manager = [NetManager shareManager];
    NSString * urlStr = [NSString stringWithFormat:BOTTOMPIC,[manager getIPAddress]];
    [manager downloadDataWithUrl:urlStr parm:nil callback:^(id responseObject, NSError *error) {
        
        if(responseObject){
            bottomDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
    }];
}

-(void)createView{
    [self batar_setLeftNavButton:@[@"",@"login"] target:self selector:nil size:CGSizeZero selector:@selector(logoOut) rightSize:CGSizeMake(22*S6, 22*S6) topHeight:11];
    [self batar_setNavibar:@"我的图鉴"];
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, Wscreen, LineY(95))];
    imgView.image = [UIImage imageNamed:@"set_bg"];
    imgView.userInteractionEnabled = YES;
    [self.view addSubview:imgView];
    
    NSString * customerStr;
    if(CUSTOMERID){
        customerStr = [NSString stringWithFormat:@"客户编号: %@",CUSTOMERID];
    }else{
        customerStr = @"点击登录";
    }
    self.userName = [Tools createLabelWithFrame:CGRectMake(0,40*S6, Wscreen, 17*S6) textContent:customerStr withFont:[UIFont systemFontOfSize:16*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [imgView addSubview:self.userName];
    
    @WeakObj(self);
    [self.userName addTapGestureCallback:^{
        if(!CUSTOMERID){
            YLLoginView * loginView = [[YLLoginView alloc]initWithVC:selfWeak.app.window withVc:selfWeak];
            [selfWeak.app.window addSubview:loginView];
            [loginView clickCancelBtn:^{
                
            }];
            
            NSLog(@"***%p",loginView);
            return;
        }
    }];
    
    
    for(int i=0;i<4;i++){
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(imgView.frame)+30*S6+i*60*S6, Wscreen, 0.5*S6)];
        if(i ==0||i ==1){
            line.backgroundColor = [UIColor clearColor];
        }else{
            line.backgroundColor = CELLBGCOLOR;
        }
        [self.view addSubview:line];
    }
    
    UILabel * title = [Tools createLabelWithFrame:CGRectMake(15*S6, CGRectGetMaxY(imgView.frame)+8*S6, Wscreen, 15*S6) textContent:@"我的订单" withFont:[UIFont systemFontOfSize:16*S6] textColor:BatarPlaceTextCol textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:title];
    
    NSArray * imgArray = @[@"all_order",@"waiting_feedback",@"waiting_confirm",@"confirm"];
    NSArray * titleArray = @[@"全部订单",@"待明细",@"待确认",@"已确认"];
    for(int i =0;i<4;i++){
        
        UIButton * btn = [Tools createButtonNormalImage:imgArray[i] selectedImage:nil tag:i addTarget:self action:@selector(clickFunction:)];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10*S6];
        btn.frame = CGRectMake(i*Wscreen/4.0, CGRectGetMaxY(imgView.frame)+30*S6, Wscreen/4.0, LineY(60));
        btn.layer.borderColor = [CELLBGCOLOR CGColor];
        btn.layer.borderWidth = 0.5*S6;
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(28*S6, 0, 0, 15*S6)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 36*S6, 18*S6, 0)];
        
        [self.view addSubview:btn];
        
        if(i == 2){
            
            //待确认的角标
            BatarBadgeView * badgeVw = [[BatarBadgeView alloc]initWithFrame:CGRectMake(56*S6, 2*S6, 10, 10)];
            self.badgeView = badgeVw;
            [btn addSubview:badgeVw];
            
            BatarSocketModel * model = [BatarSocketModel shareBatarSocketModel];
            [badgeVw changeBadgeValue:[NSString stringWithFormat:@"%@",model.state_1]];
        }
    }
    
    NSArray * titleArr = @[@"我的收藏",@"清除缓存",@"联系我们"];
    UIButton * button;
    for(int i=0;i<titleArr.count;i++){
        
        UIButton * btn = [Tools createNormalButtonWithFrame:CGRectMake(0,CGRectGetMaxY(imgView.frame)+90*S6+i*60*S6, Wscreen, LineY(60)) textContent:titleArr[i] withFont:[UIFont systemFontOfSize:15*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
        [btn setTitleColor:RGB_COLOR(29, 29, 29, 0.6) forState:UIControlStateHighlighted];
        btn.tag = i;
        [self.view addSubview:btn];
        if(i == 2){
            button = btn;
        }
        [btn addTarget:self action:@selector(findMidSetting:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame), Wscreen, Hscreen-TABBAR_HEIGHT-button.y)];
    bgView.backgroundColor = RGB_COLOR(234, 234, 234, 1);
    _bgView = bgView;
    [self.view addSubview:bgView];
    
    NSString * descripe = [NSString stringWithFormat:@"扫描或点击二维码可下载珠宝图鉴最新客户端! (版本:%@)",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    UILabel * describe = [Tools createLabelWithFrame:CGRectMake(0, 5*S6, Wscreen, 18*S6) textContent:descripe withFont:[UIFont systemFontOfSize:9*S6] textColor:BatarPlaceTextCol textAlignment:NSTextAlignmentCenter];
    [_bgView addSubview:describe];
    
    ios_coder2DView = [[YLCoder2D alloc]initWithFrame:CGRectMake(40*S6, 28*S6, 234/2.0*S6, LineY(235/2.0))];
    ios_coder2DView.urlStr = IOS_APPURL;
    [ios_coder2DView createView2DCoder];
    [bgView addSubview:ios_coder2DView];
    
    andriod_coder2DView = [[YLCoder2D alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ios_coder2DView.frame)+60*S6, 28*S6, ios_coder2DView.width, ios_coder2DView.height)];
    andriod_coder2DView.urlStr = ANDARIOD_APPURL;
    [andriod_coder2DView createView2DCoder];
    [bgView addSubview:andriod_coder2DView];
    
    UITapGestureRecognizer * ios_longAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iosScan)];
    [ios_coder2DView addGestureRecognizer:ios_longAction];
    
    //添加版本类型
    [self createCustomerName:@"iOS客户端" with:ios_coder2DView];
    [self createCustomerName:@"安卓客户端" with:andriod_coder2DView];
}

#pragma mark -我的订单部分
-(void)clickFunction:(UIButton *)btn{
    
    if(!CUSTOMERID){
        YLLoginView * loginView = [[YLLoginView alloc]initWithVC:self.app.window withVc:self];
        [self.app.window addSubview:loginView];
        [loginView clickCancelBtn:^{
            
        }];
            NSLog(@"----%p",loginView);
        return;
    }
    
    FinalOrderViewController * finalvc = [[FinalOrderViewController alloc]initWithController:self];
    finalvc.selectIndex = btn.tag;
    switch (btn.tag) {
        case 0:
            finalvc.type = @(-2);
            break;
        case 1:
            finalvc.type = @0;
            break;
        case 2:
            finalvc.type = @1;
            break;
        case 3:
            finalvc.type = @2;
            break;
        default:
            break;
    }
    finalvc.hidesBottomBarWhenPushed = YES;
    [self pushToViewControllerWithTransition:finalvc withDirection:@"right" type:NO];
}

#pragma mark - 我的设置
-(void)findMidSetting:(UIButton *)button{
    
    switch (button.tag) {
        case 0:
        {
            SavaViewController * saveVc = [[SavaViewController alloc]initWithController:self];
            saveVc.hidesBottomBarWhenPushed = YES;
            [self pushToViewControllerWithTransition:saveVc withDirection:@"right" type:NO];
        }
            break;
        case 1:
        {
            [self showAlert:@"正在清除缓存..."];
        }
            break;
        case 2:
        {//联系我们
            if([bottomDict[@"address"] isKindOfClass:[NSString class]]){
                YLLocationManager * locationManager = [[YLLocationManager alloc]initShareLocationManager:bottomDict[@"address"] ViewController:self];
                locationManager.bottomDict = bottomDict;
                [locationManager createLocationManager];
            }
            
        }
            break;
            
        default:
            break;
    }
}

-(void)showAlert:(NSString *)title{
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIView * maskView = [[UIView alloc]initWithFrame:self.view.frame];
    maskView.backgroundColor = RGB_COLOR(29, 29, 29, 0.5);
    [app.window addSubview:maskView];
    //    [self.view bringSubviewToFront:maskView];
    
    CGFloat width = 150;
    HKPieChartView * pieChartView = [[HKPieChartView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - width)/2, 150, width, width) withTitle:title];
    [pieChartView updatePercent:100 animation:YES];
    [maskView addSubview:pieChartView];
    
    [pieChartView animationStop:^{
        
        [UIView animateWithDuration:0.5 animations:^{
            maskView.alpha = 0;
            pieChartView.alpha = 0;
        } completion:^(BOOL finished) {
            [maskView removeFromSuperview];
            [pieChartView removeFromSuperview];
        }];
    }];
}

-(void)createCustomerName:(NSString *)name with:(YLCoder2D *)coderView{
    
    UILabel * name_label = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(coderView.frame)+5*S6, 234/2.0*S6, 15*S6) textContent:name withFont:[UIFont systemFontOfSize:9*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    name_label.centerX = coderView.centerX;
    [_bgView addSubview:name_label];
}

-(void)iosScan{
    
    NSURL * url = [NSURL URLWithString:IOS_APPURL];
    if ([[UIApplication sharedApplication] canOpenURL: url]) {
        [[UIApplication sharedApplication] openURL: url];
    } else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle: @"警告" message: [NSString stringWithFormat: @"%@:%@", @"无法解析的二维码", IOS_APPURL] delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

-(void)logoOut{
    
    BatarLoginController * loginVc = [[BatarLoginController alloc]initWithController:self];
    loginVc.hidesBottomBarWhenPushed = YES;
    [self pushToViewControllerWithTransition:loginVc withDirection:@"left" type:YES];
}


@end
