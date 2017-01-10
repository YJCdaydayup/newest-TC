//
//  BatarLoginController.m
//  DianZTC
//
//  Created by 杨力 on 22/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "BatarLoginController.h"
#import "YLServerAddView.h"
#import "NetManager.h"
#import "YLCustomerHUD.h"
#import "BatarMainTabBarContoller.h"
#import "AppDelegate.h"
#import "BatarSettingController.h"

@interface BatarLoginController()<UITextFieldDelegate>
{
    UIButton * _closeBtn;
    UITextField * userCode_tf;
}

@property (nonatomic,strong) YLServerAddView * serverView;


@end

@implementation BatarLoginController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)createView{
    
    _closeBtn = [Tools createButtonNormalImage:@"close" selectedImage:nil tag:0 addTarget:self action:@selector(closeLogin)];
    _closeBtn.frame = CGRectMake(25*S6, 25*S6, 22*S6, 22*S6);
    [self.view addSubview:_closeBtn];
    if([self.fatherVc isMemberOfClass:[BatarSettingController class]]){
        _closeBtn.hidden = NO;
    }else{
        _closeBtn.hidden = YES;
    }
    
    UIImageView * logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 70*S6, 80*S6, 80*S6)];
    logoImg.image = [UIImage imageNamed:@"login_logo"];
    logoImg.centerX = self.view.centerX;
    [self.view addSubview:logoImg];
    
    userCode_tf = [Tools createTextFieldFrame:CGRectMake(0, CGRectGetMaxY(logoImg.frame)+35*S6, 300*S6, 40*S6) placeholder:@"请向销售人员索取(可为空)" bgImageName:nil leftView:nil rightView:nil isPassWord:YES];
    userCode_tf.centerX = self.view.centerX;
    [self configTf:userCode_tf withView:@"users"];
    [self.view addSubview:userCode_tf];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(userCode_tf.frame)+20*S6, userCode_tf.width, 1*S6)];
    line.centerX = self.view.centerX;
    line.backgroundColor = BTNBORDCOLOR;
    [self.view addSubview:line];
    
    self.serverView = [[YLServerAddView alloc]initWithView:self];
    self.serverView.y = line.y+10*S6;
    [self.serverView updateServerView];
    [self.serverView getSelectedBtn];
    
    UIButton * loginBtn = [Tools createNormalButtonWithFrame:CGRectMake(10, Hscreen-50*S6-NAV_BAR_HEIGHT, 300*S6, 40*S6) textContent:@"登录" withFont:[UIFont systemFontOfSize:18*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [loginBtn setTitleColor:RGB_COLOR(29, 29, 29, 0.5) forState:UIControlStateHighlighted];
    loginBtn.centerX = self.view.centerX;
    loginBtn.layer.cornerRadius = 20*S6;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = TABBARTEXTCOLOR;
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)configTf:(UITextField *)tf withView:(NSString *)imgName{
    
    tf.delegate = self;
    tf.backgroundColor = [UIColor whiteColor];
    tf.centerX = self.view.centerX;
    tf.layer.borderWidth = 1*S6;
    tf.layer.borderColor = [BTNBORDCOLOR CGColor];
    tf.layer.cornerRadius = 5*S6;
    tf.layer.masksToBounds = YES;
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40*S6, 20*S6)];
    tf.leftView = leftView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.returnKeyType = UIReturnKeyDone;
    
    UIImageView * placeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    placeImg.frame = CGRectMake(10*S6,1*S6, 17*S6, 17*S6);
    [leftView addSubview:placeImg];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(placeImg.frame)+5*S6, 1*S6, 1*S6, 17*S6)];
    lineView.backgroundColor = BTNBORDCOLOR;
    [leftView addSubview:lineView];
    
    //改变输入框placeholder的字体大小和颜色
    [tf setValue:BatarPlaceTextCol forKeyPath:@"_placeholderLabel.textColor"];
    tf.font = [UIFont systemFontOfSize:12];
}

#pragma mark - 登录
-(void)loginAction{
    
    if(userCode_tf.text.length == 0){
        [kUserDefaults removeObjectForKey:CustomerID];
        [self setWindowTabbar];
    }else{
        [self checkUserCode];
    }
}

-(void)checkUserCode{
    
    //只需要检验客户编号即可
    self.hud = [[MBProgressHUD alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"正在检验客户编号...";
    [self.hud show:YES];
    NetManager * manager = [NetManager shareManager];
    NSString * urlStr = [NSString stringWithFormat:LOGIN_URL,[manager getIPAddress]];
    NSDictionary * dict = @{@"number":userCode_tf.text};
    [manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.hud hide:YES];
            NSMutableDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString * state = [dict objectForKey:@"state"];
            if([state intValue] == 1){
                [kUserDefaults setObject:userCode_tf.text forKey:CustomerID];
                [self setWindowTabbar];
            }else{
                AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                YLCustomerHUD * hud = [[YLCustomerHUD alloc]initWithWindow:app.window];
                [kUserDefaults removeObjectForKey:CustomerID];
                [hud clickCustomerBtn:^(NSInteger index) {
                    if (index == 0) {
                        //下次再说
                        [self setWindowTabbar];
                    }else{
                        [kUserDefaults removeObjectForKey:CustomerID];
                        //再次填写客户编号
                        [UIView animateWithDuration:0.2 animations:^{
                            hud.alpha = 0;
                            [hud removeFromSuperview];
                        }];
                    }
                }];
            }
        });
    }];
}

-(void)setWindowTabbar{
    
    //登录后，下次进来改变入口
    [kUserDefaults setObject:BatarEntrance forKey:BatarEntrance];
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BatarMainTabBarContoller * tabbar = [[BatarMainTabBarContoller alloc]init];
    app.window.rootViewController = tabbar;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:SwitchSerser object:nil];
}

#pragma mark - 退出登录界面
-(void)closeLogin{
    
    [self popToViewControllerWithDirection:@"left" type:YES];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
