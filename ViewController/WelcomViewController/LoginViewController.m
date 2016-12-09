//
//  LoginViewController.m
//  DianZTC
//
//  Created by 杨力 on 10/8/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "LoginViewController.h"
#import "FirstViewController.h"
#import "AppDelegate.h"
#import "NetManager.h"
#import "NSTimer+Net.h"
#import "YCDropTB.h"
#import "YLCustomerHUD.h"

@interface LoginViewController (){
    
    UIImageView * headerView;
    UITextField * ipTextfield;
    UITextField * portTextfield;
    UITextField * userCodeTextfield;
    UILabel * faultLabel;
    NSString * warningStr;
    CGFloat max_X;
    CGFloat max_Y;
}

@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,assign) CGFloat timeCount;
@property (nonatomic,assign) BOOL netState;

//下拉列表
@property (nonatomic,strong) YCDropTB * ipListView;
@property (nonatomic,strong) NSArray * ip_Port_Array;
@property (nonatomic,strong) NSMutableArray * ipArray;
@property (nonatomic,strong) NSMutableArray * portArray;

@property (nonatomic,strong) YLCustomerHUD * customerHud;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    if([kUserDefaults objectForKey:IPSTRING]){
        
        ipTextfield.text = [kUserDefaults objectForKey:IPSTRING];
        portTextfield.text = [kUserDefaults objectForKey:PORTSTRING];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString * path = [NSString stringWithFormat:@"%@ip_port.plist",LIBPATH];
    self.ip_Port_Array = [NSArray arrayWithContentsOfFile:path];
    
    [self createView];
}

- (BOOL)prefersStatusBarHidden{
    
    return YES; //返回NO表示要显示，返回YES将hiden
}

-(void)createView{
    
    headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, Wscreen*262/750)];
    headerView.image = [UIImage imageNamed:@"header"];
    [self.view addSubview:headerView];
    
    max_Y = CGRectGetMaxY(headerView.frame);
    UILabel * user_code = [Tools createLabelWithFrame:CGRectMake(28*S6, max_Y+40*S6, 80*S6, 35*S6) textContent:@"客户编号" withFont:[UIFont systemFontOfSize:17] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:user_code];
    
    userCodeTextfield = [Tools createTextFieldFrame:CGRectMake(10*S6+CGRectGetMaxX(user_code.frame), max_Y+40*S6, 227*S6, 35*S6) placeholder:@"请向业务员索取(可暂不填)" bgImageName:nil leftView:nil rightView:nil isPassWord:NO];
    [self resetTextfield:userCodeTextfield withTag:3335];
    [self.view addSubview:userCodeTextfield];
    
    max_Y = CGRectGetMaxY(user_code.frame);
    ipTextfield = [Tools createTextFieldFrame:CGRectMake(30*S6, max_Y+20*S6, 200*S6, 35*S6) placeholder:@"填写IP地址或域名" bgImageName:nil leftView:nil rightView:nil isPassWord:NO];
    [self resetTextfield:ipTextfield withTag:3333];
    [self.view addSubview:ipTextfield];
    
    max_X = CGRectGetMaxX(ipTextfield.frame);
    max_Y = CGRectGetMinY(ipTextfield.frame);
    portTextfield = [Tools createTextFieldFrame:CGRectMake(max_X+10*S6, max_Y, 105*S6, 35*S6) placeholder:@"端口" bgImageName:nil leftView:nil rightView:nil isPassWord:NO];
    [self resetTextfield:portTextfield withTag:3334];
    [self.view addSubview:portTextfield];
    
    //显示登陆错误信息
    max_X = CGRectGetMinX(ipTextfield.frame);
    max_Y = CGRectGetMaxY(ipTextfield.frame);
    faultLabel = [Tools createLabelWithFrame:CGRectMake(max_X, max_Y+12.5*S6, Wscreen, 14) textContent:nil withFont:[UIFont systemFontOfSize:14*S6] textColor:[UIColor redColor] textAlignment:NSTextAlignmentLeft];
    faultLabel.alpha = 0;
    [self.view addSubview:faultLabel];
    
    //登录按钮
    max_Y = CGRectGetMaxY(faultLabel.frame);
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(60*S6, max_Y+27.5*S6, 510/2.0*S6, 75/2.0*S6);
    [loginBtn setImage:[UIImage imageNamed:@"denglu"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //欢迎登陆
    max_Y = CGRectGetMaxY(loginBtn.frame);
    UILabel * loginLabel = [Tools createLabelWithFrame:CGRectMake(0,max_Y+15*S6, Wscreen, 20) textContent:@"You are welcome to login" withFont:[UIFont systemFontOfSize:14*S6] textColor:RGB_COLOR(153, 153, 153, 1) textAlignment:NSTextAlignmentCenter];
    loginLabel.centerX = self.view.centerX;
    [self.view addSubview:loginLabel];
}

-(void)resetTextfield:(UITextField *)textfield withTag:(NSInteger)tag{
    
    textfield.keyboardType = UIKeyboardTypeDefault;
    textfield.layer.borderWidth = 1.0*S6;
    textfield.layer.borderColor = [RGB_COLOR(231, 140, 59, 1)CGColor];
    textfield.layer.cornerRadius = 5*S6;
    textfield.layer.masksToBounds = YES;
    [textfield setValue:RGB_COLOR(153, 153, 153, 1) forKeyPath:@"_placeholderLabel.textColor"];
    textfield.font = [UIFont systemFontOfSize:14*S6];
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10*S6, 35*S6)];
    textfield.leftView = leftView;
    textfield.leftViewMode =UITextFieldViewModeAlways;
    
    if(tag == 3335){
        return;
    }
    
    //添加下拉标记
    max_X = CGRectGetMaxX(textfield.frame);
    max_Y = CGRectGetMinY(textfield.frame);
    UIButton * listBtn = [Tools createButtonNormalImage:@"xiala" selectedImage:nil tag:tag addTarget:self action:@selector(listAction:)];
    listBtn.frame = CGRectMake(max_X-0*S6, max_Y+6.5*S6, 40*S6,40*S6);
    textfield.rightView = listBtn;
    textfield.rightViewMode = UITextFieldViewModeAlways;
}

#pragma mark -下拉列表
-(void)listAction:(UIButton *)sender{
    
    if(sender.tag == 3333){
        
        [self getListData];
        [self.ipListView showBlowView:ipTextfield];
        self.ipListView.Size = CGSizeMake(ipTextfield.width, self.ipArray.count*30*S6);
    }else if (sender.tag == 3334){
        [self getPortData];
        [self.ipListView showBlowView:portTextfield];
        self.ipListView.Size = CGSizeMake(portTextfield.width, self.portArray.count*30*S6);
    }
}

#pragma mark - 当ip输入框有值时
-(void)getPortData{
    
    if(ipTextfield.text){
        
        NSString * port;
        [self.portArray removeAllObjects];
        for(int i=0;i<self.ip_Port_Array.count;i++){
            
            NSDictionary * dict = self.ip_Port_Array[i];
            port = [dict objectForKey:ipTextfield.text];
            if(port){
                [self.portArray addObject:port];
            }
        }
        [self createList:self.portArray];
    }
}

#pragma mark -获取IP 端口数据
-(void)getListData{
    
    [self.ipArray removeAllObjects];
    for(int i=0;i<self.ip_Port_Array.count;i++){
        
        NSDictionary * dict = self.ip_Port_Array[i];
        NSString * ip = [[dict allKeys]firstObject];
        [self.ipArray addObject:ip];
    }
    //将输出去重复
    self.ipArray = [self removeRepreatSegment:self.ipArray];
    
    [self createList:self.ipArray];
}

-(void)createList:(NSMutableArray *)array{
    
    // 数据转换为能用的数组
    _ipListView = [YCDropTB YCDropTBWithDataSource:array backIndexOfDataSource:^(NSInteger index, UIView * __nullable blewView) {
        
        NSString * port;
        if (blewView == ipTextfield) {
            [self.portArray removeAllObjects];
            ipTextfield.text = self.ipArray[index];
            for(int i=0;i<self.ip_Port_Array.count;i++){
                
                NSDictionary * dict = self.ip_Port_Array[i];
                port = [dict objectForKey:ipTextfield.text];
                if(port){
                    [self.portArray addObject:port];
                }
            }
            
            self.ipListView.dataSource = self.portArray;
            
        } else  if( blewView == portTextfield ){
            
            [self getPortData];
            portTextfield.text = self.portArray[index];
        }
    }];
}



#pragma mark - 将数据去重复
-(NSMutableArray *)removeRepreatSegment:(NSMutableArray *)array{
    
    NSMutableArray * muArray = [NSMutableArray array];
    
    for(NSString * str in array){
        
        if(![muArray containsObject:str]){
            [muArray addObject:str];
        }
    }
    return muArray;
}

-(void)loginAction{
    
    self.netState = NO;
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"正在验证登录IP和端口号...";
    [self.hud show:YES];
    
    [self.view endEditing:YES];
    [self checkIPWithPort];
}

-(void)checkIPWithPort{
    
    self.timeCount = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerEnd) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    faultLabel.alpha = 0;
    [kUserDefaults setObject:ipTextfield.text forKey:IPSTRING];
    [kUserDefaults setObject:portTextfield.text forKey:PORTSTRING];
    
    NetManager * manager = [NetManager shareManager];
    [manager checkIPCompareWithPort:^(NSString *response, NSError *error) {
        
        if(response){
            
            if(userCodeTextfield.text.length>0){
                
                [self.timer setFireDate:[NSDate distantFuture]];
         
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    //验证客户编号
                    self.hud.labelText = @"正在验证客户编号...";
                    [self performSelector:@selector(confrimAction) withObject:nil afterDelay:1.5];
                });
            }else{
                [self.hud hide:YES];
                [kUserDefaults removeObjectForKey:CustomerID];
                [kUserDefaults setObject:@"1" forKey:ISLOGIN];
                faultLabel.alpha = 0;
                FirstViewController * firstVc = [[FirstViewController alloc]init];
                [self pushToViewControllerWithTransition:firstVc withDirection:@"left" type:YES];
                //保存ip和端口
                [manager saveCurrentIP:ipTextfield.text withPort:portTextfield.text];
            }
            
        }else{
            
            //IP或端口错误
            [kUserDefaults removeObjectForKey:ISLOGIN];
            [kUserDefaults removeObjectForKey:IPSTRING];
            [kUserDefaults removeObjectForKey:PORTSTRING];
            [UIView animateWithDuration:0.2 animations:^{
                
                if(self.netState == YES){
                    return ;
                }
                if(![error.description containsString:@"The request timed out"]){
                    [self.hud hide:YES];
                    
                    self.netState = NO;//服务器地址或端口错误
                    faultLabel.text = @"服务器地址或端口错误，请重新填写!";
                    faultLabel.alpha = 1;
                    [self.timer setFireDate:[NSDate distantFuture]];
                    self.timeCount = 0;
                    
                    if([manager checkOutIfHasCorrenctIp_port]){
                        //登录失败，如果有默认的ip和端口，则使用默认的
                        [kUserDefaults setObject:LOGINFAILED forKey:LOGINFAILED];
                        [manager getNewestIp_PortWhenLoginFailed];
                    }else{
                        //登录失败，没有默认的ip和端口
                        [kUserDefaults removeObjectForKey:LOGINFAILED];
                    }
                    
                }
            }];
        }
    }];
}

-(void)confrimAction{
    
    NetManager * manager = [NetManager shareManager];
    NSString * urlStr = [NSString stringWithFormat:LOGIN_URL,[manager getIPAddress]];
    NSDictionary * dict = @{@"number":userCodeTextfield.text};
    [manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
        
        NSMutableDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString * state = [dict objectForKey:@"state"];
        if([state intValue] == 1){
            
            [kUserDefaults setObject:@"1" forKey:ISLOGIN];
            faultLabel.alpha = 0;
            FirstViewController * firstVc = [[FirstViewController alloc]init];
            [self pushToViewControllerWithTransition:firstVc withDirection:@"left" type:YES];
            //保存ip和端口
            [manager saveCurrentIP:ipTextfield.text withPort:portTextfield.text];
            //判断是否输入客户编号
            [self.hud hide:YES];
            [kUserDefaults setObject:userCodeTextfield.text forKey:CustomerID];
        }else{
            
            [self.hud hide:YES];
            AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            self.hud.labelText = @"客户编码错误";
            YLCustomerHUD * hud = [[YLCustomerHUD alloc]initWithWindow:app.window];
            [kUserDefaults removeObjectForKey:CustomerID];
            
            [hud clickCustomerBtn:^(NSInteger index) {
                
                if (index == 0) {
                    //下次再说
                    [kUserDefaults setObject:@"1" forKey:ISLOGIN];
                    faultLabel.alpha = 0;
                    FirstViewController * firstVc = [[FirstViewController alloc]init];
                    [self pushToViewControllerWithTransition:firstVc withDirection:@"left" type:YES];
                    //保存ip和端口
                    [manager saveCurrentIP:ipTextfield.text withPort:portTextfield.text];
                    
                }else{
                    
                    //再次填写客户编号
                    
                }
                
            }];
        }
    }];
}

-(void)timerEnd{
    
    self.timeCount ++;
    if(self.timeCount > 2){
        
        [self.hud hide:YES];
        [UIView animateWithDuration:0.2 animations:^{
            faultLabel.text = @"登录失败，请检查网络或服务器地址，重新登录!";
            self.netState = YES;
            faultLabel.alpha = 1;
            [self.timer setFireDate:[NSDate distantFuture]];
        }];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

-(NSMutableArray *)ipArray{
    
    if(_ipArray == nil){
        
        _ipArray = [NSMutableArray array];
    }
    return _ipArray;
}

-(NSMutableArray *)portArray{
    
    if(_portArray == nil){
        _portArray = [NSMutableArray array];
    }
    return _portArray;
}

//-(YLCustomerHUD *)customerHud{
//
//    if(!_customerHud){
//        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        _customerHud = [[YLCustomerHUD alloc]initWithWindow:app.window];
//    }
//    return _customerHud;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

