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
#import "YLSocketManager.h"

@interface BatarLoginController()<UITextFieldDelegate,YLSocketDelegate>
{
    UIButton * _closeBtn;
    UITextField * userCode_tf;
    BOOL clear_server;
    YLSocketManager *_socketManager;
}

@property (nonatomic,strong) YLServerAddView * serverView;
@property (nonatomic,strong) UIButton * loginBtn;
@property (nonatomic,strong) NetManager * manager;
@property (nonatomic,copy) NSString * tempIP_Port;

/** 客户断网时的等待框 */
@property (nonatomic,strong) MBProgressHUD * p_hup;

@end

@implementation BatarLoginController

@synthesize manager = _manager;
@synthesize loginBtn = _loginBtn;

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DeleteServer object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:ServerEditNotification name:ServerEditNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:ServerEditCancelNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteServer) name:DeleteServer object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editServer) name:ServerEditNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelServerEdit) name:ServerEditCancelNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _manager = [NetManager shareManager];
    //进来之前就判断是否服务器清空
    if([NetManager batar_getAllServers].count==0){
        clear_server = YES;
    }
    
    //获取当前ip和端口
    self.tempIP_Port = [_manager getIPAddress];
}

-(void)editServer{
    
    _loginBtn.enabled = NO;
    userCode_tf.enabled = NO;
    _closeBtn.enabled = NO;
}

-(void)cancelServerEdit{
    
    _loginBtn.enabled = YES;
    userCode_tf.enabled = YES;
    _closeBtn.enabled = YES;
}

-(void)deleteServer{
    
    _closeBtn.hidden = YES;
    _closeBtn.enabled = NO;
    NSMutableArray * serverArray = [NetManager batar_getAllServers];
    if(serverArray.count>0){
        clear_server = NO;
    }else{
        clear_server= YES;
    }
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
    userCode_tf.delegate = self;
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
    _loginBtn = loginBtn;
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
    
    [self.hud show:YES];
    
    if(clear_server){
        
        [self showAlertViewWithTitle:@"服务器已清空，请添加服务器再登录!"];
        return;
    }
    
    if(userCode_tf.text.length == 0){
        [kUserDefaults removeObjectForKey:CustomerID];
        [self setWindowTabbar];
        //断开长连接
        YLSocketManager * socket = [YLSocketManager shareSocketManager];
        [socket closeServerByForce:YES];
    }else{
        [self checkUserCode];
    }
}

-(void)checkUserCode{
    
    //只需要检验客户编号即可
    //    self.hud = [[MBProgressHUD alloc]initWithFrame:self.view.frame];
    //    [self.view addSubview:self.hud];
    self.hud.labelText = @"正在检验客户编号...";
    [self.hud show:YES];
    NSString * urlStr = [NSString stringWithFormat:LOGIN_URL,[_manager getIPAddress]];
    NSDictionary * dict = @{@"number":userCode_tf.text};
    [_manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSMutableDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString * state = [dict objectForKey:@"state"];
            if([state intValue] == 1){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.hud.labelText = @"正在等待连接...";
                });
                [self.hud hide:YES];
                
                YLSocketManager * socketManager = [YLSocketManager shareSocketManager];
                //与服务器建立长连接
                NSString *socketUrl = [NSString stringWithFormat:ConnectWithServer,[self.manager getIPAddress]];
                [socketManager createSocket:socketUrl delegate:self];
                
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

#pragma mark - 获取服务端数据
-(void)ylWebSocketDidOpen:(SRWebSocket *)webSocket{
    
    NSString * str = [NSString stringWithFormat:@"{\"\cmd\"\:%@,\"\message\"\:\"\%@\"\}",@"2",userCode_tf.text];
    [webSocket send:str];
    
    self.p_hup = [[MBProgressHUD alloc]initWithFrame:self.view.frame];
    [self.app.window addSubview:self.p_hup];
    self.p_hup.labelText = @"正在连接中...";
    [self.p_hup show:YES];
}

-(void)ylSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
//    NSLog(@"登录界面---%@",message);
    message = (NSString *)message;
    
    [self.p_hup hide:YES];
    if([message containsString:@"ok"]){
        //发出通知
        [kUserDefaults setObject:userCode_tf.text forKey:CustomerID];
        [self setWindowTabbar];
        NSString * str = [NSString stringWithFormat:@"{\"\cmd\"\:%@,\"\message\"\:\"\%@\"\}",@"0",userCode_tf.text];
        [webSocket send:str];
    }else if([message containsString:@"logined"]){
        webSocket.delegate = nil;
        webSocket = nil;
        [self showAlertViewWithTitle:@"该客户编号已在其他地方登陆"];
        [[NSNotificationCenter defaultCenter]postNotificationName:ServerMsgNotification object:nil];
    }
}

-(void)setWindowTabbar{
    
    //登录后，下次进来改变入口
    [kUserDefaults setObject:BatarEntrance forKey:BatarEntrance];
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BatarMainTabBarContoller * tabbar = [BatarMainTabBarContoller sharetabbarController];
    [tabbar changeRootController];
    app.window.rootViewController = tabbar;
    [[NSNotificationCenter defaultCenter]postNotificationName:SwitchSerser object:nil];
}

#pragma mark - 退出登录界面
-(void)closeLogin{
    
    [self repairIP_Port];
    [self popToViewControllerWithDirection:@"left" type:YES];
}

-(void)repairIP_Port{
    
    NSArray * array = [_tempIP_Port componentsSeparatedByString:@":"];
    [kUserDefaults setObject:array[0] forKey:IPSTRING];
    [kUserDefaults setObject:array[1] forKey:PORTSTRING];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [_serverView cancelEdit];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self loginAction];
    return YES;
}

@end
