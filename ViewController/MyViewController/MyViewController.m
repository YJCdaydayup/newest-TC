//
//  MyViewController.m
//  DianZTC
//
//  Created by 杨力 on 7/9/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "MyViewController.h"
#import "LoginViewController.h"
#import "SavaViewController.h"
#import "HKPieChartView.h"
#import "DBWorkerManager.h"
#import "YLCoder2D.h"
#import "NetManager.h"

#import "MyInfoModel.h"
#import "MyInfoCell.h"

#define infoCell @"infoCell"

@interface MyViewController()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView * infoTableView;
    NSMutableArray * dataArray;
    HKPieChartView * pieChartView;
    UIView * maskView;
    YLCoder2D * andriod_coder2DView;
    YLCoder2D * ios_coder2DView;
    
    NSString * andriodUrl;
}

@property (nonatomic,strong) UIButton * navLeftButton;
@property (nonatomic,strong) UILabel * titlelabel;

@end

@implementation MyViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navLeftButton.hidden = NO;
    self.titlelabel.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navLeftButton.hidden = YES;
    self.titlelabel.hidden = YES;
}

-(void)viewDidLoad{
    
    //隐藏系统的“返回导航按钮”
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = RGB_COLOR(234, 234, 234, 1);
    
//    NetManager * manager = [NetManager shareManager];
    andriodUrl = [NSString stringWithFormat:@"%@",ANDARIOD_APPURL];
    
    [self configUI];
    [self createTableView];
    [self createData];
    [self createLogoutBtn];
    
}

-(void)andriodScan{
    
    NSURL * url = [NSURL URLWithString:andriodUrl];
    if ([[UIApplication sharedApplication] canOpenURL: url]) {
        [[UIApplication sharedApplication] openURL: url];
    } else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle: @"警告" message: [NSString stringWithFormat: @"%@:%@", @"无法解析的二维码", ANDARIOD_APPURL] delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
        [alertView show];
    }
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

-(void)createLogoutBtn{
    
    UIButton * logoutBtn = [Tools createNormalButtonWithFrame:CGRectMake(0, CGRectGetMaxY(infoTableView.frame)+17.5*S6, 255*S6, 37.5*S6) textContent:@"注销" withFont:[UIFont systemFontOfSize:18*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    logoutBtn.centerX = self.view.centerX;
    logoutBtn.backgroundColor = LOGOUTBTNCOLOR;
    logoutBtn.layer.cornerRadius = 5*S6;
    logoutBtn.clipsToBounds = YES;
    [logoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    
    UILabel * versionName = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(logoutBtn.frame)+115/2.0*S6, Wscreen, 20*S6) textContent:nil withFont:[UIFont systemFontOfSize:15*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    versionName.centerX = self.view.centerX;
    versionName.text = [NSString stringWithFormat:@"版本号:%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [self.view addSubview:versionName];
    
    andriod_coder2DView = [[YLCoder2D alloc]initWithFrame:CGRectMake(50*S6, CGRectGetMaxY(versionName.frame)+17*S6, 115*S6, 115*S6)];
    andriod_coder2DView.urlStr = andriodUrl;
    [andriod_coder2DView createView2DCoder];
    [self.view addSubview:andriod_coder2DView];
    
    ios_coder2DView = [[YLCoder2D alloc]initWithFrame:CGRectMake(CGRectGetMaxX(andriod_coder2DView.frame)+50*S6, CGRectGetMaxY(versionName.frame)+17*S6, 115*S6, 115*S6)];
    ios_coder2DView.urlStr = IOS_APPURL;
    [ios_coder2DView createView2DCoder];
    [self.view addSubview:ios_coder2DView];
    
    UILongPressGestureRecognizer * andriod_longAction = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(andriodScan)];
    [andriod_coder2DView addGestureRecognizer:andriod_longAction];
    
    UILongPressGestureRecognizer * ios_longAction = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(iosScan)];
    [ios_coder2DView addGestureRecognizer:ios_longAction];
    
    //添加版本类型
    [self createCustomerName:@"iOS客户端" with:ios_coder2DView];
    [self createCustomerName:@"安卓客户端" with:andriod_coder2DView];
}

-(void)createCustomerName:(NSString *)name with:(YLCoder2D *)coderView{
    
    UILabel * name_label = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(coderView.frame)+15*S6, 115*S6, 15*S6) textContent:name withFont:[UIFont systemFontOfSize:15*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    name_label.centerX = coderView.centerX;
    [self.view addSubview:name_label];
}

#pragma mark -注销
-(void)logoutAction{
    
    LoginViewController * loginVc = [[LoginViewController alloc]init];
    [self pushToViewControllerWithTransition:loginVc withDirection:@"left" type:YES];
}

-(void)createData{
    
    NSArray * itemArray = @[@"清除缓存",@"清除收藏夹缓存",@"我的收藏"];
    NSArray * itemImgArray = @[@"clean_saveCache",@"clean_saveCache",@"mySave"];
    dataArray = [NSMutableArray array];
    for(int i=0;i<itemArray.count;i++){
        
        MyInfoModel * model = [[MyInfoModel alloc]init];
        model.itemName = itemArray[i];
        model.imageName = itemImgArray[i];
        [dataArray addObject:model];
    }
    [infoTableView reloadData];
}

-(void)createTableView{
    
    infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,Wscreen ,65*3*S6+NAV_BAR_HEIGHT)];
    infoTableView.delegate = self;
    infoTableView.dataSource = self;
    [infoTableView registerClass:[MyInfoCell class] forCellReuseIdentifier:infoCell];
    infoTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:infoTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:infoCell];
    if(cell == nil){
        cell = [[MyInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoCell];
    }
    MyInfoModel * model = [dataArray objectAtIndex:indexPath.row];
    [cell configCellWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65*S6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DBWorkerManager * manager = [DBWorkerManager shareDBManager];
    
    switch (indexPath.row) {
        case 0:{
            
            [self showAlert:@"清除缓存，请稍后..."];
//            [manager cleanUpImageInCache];
        }
            break;
        case 1:{
            [manager cleanAllSavedImageDiskAndCache];
            [self showAlert:@"清除收藏夹缓存，请稍后..."];
        }
            break;
        case 2:{
            SavaViewController * saveVc = [[SavaViewController alloc]init];
            [kUserDefaults setObject:@"mine" forKey:FROM_VC_TO_SAVE];
            [self pushToViewControllerWithTransition:saveVc withDirection:@"left" type:NO];
        }
            break;
        default:
            break;
    }
}

-(void)showAlert:(NSString *)title{
    
    maskView = [[UIView alloc]initWithFrame:self.view.frame];
    maskView.backgroundColor = RGB_COLOR(29, 29, 29, 0.5);
    [self.view addSubview:maskView];
    [self.view bringSubviewToFront:maskView];
    
    CGFloat width = 150;
    pieChartView = [[HKPieChartView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - width)/2, 150, width, width) withTitle:title];
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

-(void)configUI{
    
    //导航条设置
    self.navLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navLeftButton setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    if(IS_IPHONE == IS_IPHONE_6||IS_IPHONE == IS_IPHONE_6P){
        
        self.navLeftButton.frame = CGRectMake(31/2.0*S6, 22.5/2*S6, 49/2.0*S6, 22.5*S6);
    }else{
        self.navLeftButton.frame = CGRectMake(31/2.0*S6, 26/2*S6, 49/2.0*S6, 22.5*S6);
    }
    [self.navigationController.navigationBar addSubview:self.navLeftButton];
    [self.navLeftButton addTarget:self action:@selector(backOut) forControlEvents:UIControlEventTouchUpInside];
    
    //导航条标题
    NSString * titleStr = @"个人设置";
    
    self.titlelabel = [Tools createLabelWithFrame:CGRectMake(10, 10, 100*S6, 20*S6) textContent:titleStr
                                         withFont:[UIFont systemFontOfSize:17*S6] textColor:RGB_COLOR(0, 0, 0, 1) textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = self.titlelabel;
}

-(void)backOut{

    [self popToViewControllerWithDirection:@"right" type:NO];
}

@end
