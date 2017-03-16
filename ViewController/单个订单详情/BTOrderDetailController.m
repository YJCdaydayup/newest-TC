//
//  BTOrderDetailController.m
//  DianZTC
//
//  Created by 杨力 on 20/2/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "BTOrderDetailController.h"
#import "NetManager.h"
#import "MJRefresh.h"
#import "BTDetailModel.h"
#import "BTDetailCell.h"
#import "BTDetailSubModel.h"
#import "BatarProcessView.h"
#import "OrderDetailController.h"
#import "OrderCarModel.h"
#import <UIImageView+WebCache.h>

@interface BTOrderDetailController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UILabel * dateLbl;
    UILabel * statelbl;
    
    UILabel * outDetailLbl;
    
    NSInteger page;
    
    NSInteger cancelState;
    BOOL confirmState;
    
    BatarProcessView * processView;
    UIButton *cancelBtn;
    UIButton *confirmBtn;
}

@property (nonatomic,strong) UIButton * navLeftButton;

/** 列表 */
@property (nonatomic,strong) UITableView * tableView;

/** 网络请求对象 */
@property (nonatomic,strong) NetManager * manager;

/** 数组 */
@property (nonatomic,strong) NSMutableArray<BTDetailModel *> * items;

@end

@implementation BTOrderDetailController

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navLeftButton.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navLeftButton.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(confirmAction) name:ConfirmOrderNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelAction) name:CancelOrderNotification object:nil];
    [self batar_setNavibar:@"订单详情"];
}

//确认订单
-(void)confirmAction{
    
    [processView changeProgress:BatarConfirmStyle];
    cancelBtn.frame = CGRectMake(0, Hscreen-50*S6, Wscreen, 50*S6);
    confirmBtn.hidden = YES;
    confirmState = NO;
    self.state = @(12);
    [[NSNotificationCenter defaultCenter]postNotificationName:UpdateMyOrderNotification object:nil];
}

//取消订单
-(void)cancelAction{
    
    switch (cancelState) {
        case 10:
            [processView changeProgress:BatarDetailCancelStyle];
            break;
        case 11:
            [processView changeProgress:BatarWaitConfirmCancelStyle];
            break;
        case 12:
            [processView changeProgress:batarConfirmCancelStyle];
            break;
        default:
            break;
    }
    
    self.tableView.height = self.tableView.height+50*S6;
    cancelBtn.hidden = YES;
    confirmBtn.hidden = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:UpdateMyOrderNotification object:nil];
}

-(void)createView{
    
    //导航条设置
    self.navigationItem.hidesBackButton = YES;
    self.navLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navLeftButton setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    self.navLeftButton.frame = CGRectMake(15.5, 13, 24.5, 22.5);
    [self.navigationController.navigationBar addSubview:self.navLeftButton];
    [self.navLeftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self createHeader];
    [self createOutDetail];
}

-(void)createHeader{
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(-5, NAV_BAR_HEIGHT, Wscreen+10, 45*S6)];
    bgView.backgroundColor = RGB_COLOR(249, 249, 249, 0.2);
    [self.view addSubview:bgView];
    
    UILabel * date = [Tools createLabelWithFrame:CGRectMake(15*S6, 13.5*S6, 250*S6, 14*S6) textContent:[NSString stringWithFormat:@"订单号: %@",self.orderId] withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    dateLbl = date;
    [bgView addSubview:dateLbl];
    
    NSString * str = [self.date substringToIndex:10];
    
    UILabel * state = [Tools createLabelWithFrame:CGRectMake(Wscreen-100*S6, date.y, 100*S6, 14*S6) textContent:str withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentRight];
    [bgView addSubview:state];
}

-(void)createOutDetail{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView * stateBgView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT+45*S6, Wscreen, 50*S6)];
    [self.view addSubview:stateBgView];
    
    [self indicatorState:stateBgView];
    
    UILabel * title = [Tools createLabelWithFrame:CGRectMake(0,CGRectGetMaxY(stateBgView.frame), Wscreen, 45*S6) textContent:@"出货明细" withFont:[UIFont systemFontOfSize:15*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:title];
    
    
    CGFloat tableHeight = 0 ;
    tableHeight = Hscreen-title.y-30*S6-NAV_BAR_HEIGHT+10*S6;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame), Wscreen, tableHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addFooterWithTarget:self action:@selector(footerAction)];
    [self.view addSubview:self.tableView];
    
    self.items = [NSMutableArray array];
    page = 0;
    
    [self createData];
    
    if([self.state integerValue] == 1){
        
        NSArray * title = @[@"取消订单",@"确认订单"];
        for(int i =0;i<2;i++){
            UIButton * itemBtn = [Tools createNormalButtonWithFrame:CGRectMake(Wscreen/2.0*i, CGRectGetMaxY(self.tableView.frame), Wscreen/2.0, 50*S6) textContent:title[i] withFont:[UIFont systemFontOfSize:15*S6] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
            itemBtn.tag = i;
            [itemBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            if(i == 0){
                cancelBtn = itemBtn;
                
                [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                itemBtn.backgroundColor = RGB_COLOR(234, 234, 234, 1);
            }else{
                confirmBtn = itemBtn;
                itemBtn.backgroundColor = RGB_COLOR(220, 119, 40, 1);
                
                [itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            [self.view addSubview:itemBtn];
        }
    }else if([self.state integerValue] == 0||[self.state integerValue] == 2){
        UIButton * itemBtn = [Tools createNormalButtonWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), Wscreen, 50*S6) textContent:@"取消订单" withFont:[UIFont systemFontOfSize:15*S6] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        itemBtn.tag = 0;
        cancelBtn = itemBtn;
        [itemBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        itemBtn.backgroundColor = RGB_COLOR(234, 234, 234, 1);
        [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:itemBtn];
    }else{
        self.tableView.height = self.tableView.height+50*S6;
    }
}

#pragma mark - 设置状态进度条
-(void)indicatorState:(UIView *)bgVw{
    
    processView = [[BatarProcessView alloc]init];
    [bgVw addSubview:processView];
    
    switch ([self.state integerValue]) {
        case 0:
            [processView changeProgress:BatarWaitDetailStyle];
            break;
        case 1:
            [processView changeProgress:BatarWaitConfirmStyle];
            break;
        case 2:
            [processView changeProgress:BatarConfirmStyle];
            break;
        case 10:
            [processView changeProgress:BatarDetailCancelStyle];
            break;
        case 11:
            [processView changeProgress:BatarWaitConfirmCancelStyle];
            break;
        case 12:
            [processView changeProgress:batarConfirmCancelStyle];
            break;
            
        default:
            break;
    }
    
    bgVw.layer.borderColor = [BOARDCOLOR CGColor];
    bgVw.layer.borderWidth = 0.4*S6;
}

-(void)footerAction{
    
    page ++;
    [self createData];
}
-(void)clickBtn:(UIButton *)btn{
    
    NSString * urlStr = [NSString stringWithFormat:ChangeOrderState,[self.manager getIPAddress]];
    NSDictionary * dict;
    if(btn.tag == 0){
        //10回传取消   11待确认取消 12待确认取消
        if([self.state integerValue] == 0){
            dict = @{@"orderid":self.orderId,@"state":@"10"};
            cancelState = 10;
        }else if([self.state integerValue] == 1){
            dict = @{@"orderid":self.orderId,@"state":@"11"};
            cancelState = 11;
        }else{
            dict = @{@"orderid":self.orderId,@"state":@"12"};
            cancelState = 12;
        }
    }else{
        //确认订单
        dict = @{@"orderid":self.orderId,@"state":@"2"};
        confirmState = YES;
    }
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"正在操作...";
    self.hud.animationType = MBProgressHUDAnimationZoomOut;
    [self.manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
        if(responseObject){
            [self.hud hide:YES];
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if([dict[@"state"]integerValue] == 1){
                if(confirmState){
                    [[NSNotificationCenter defaultCenter]postNotificationName:ConfirmOrderNotification object:nil];
                }else{
                    [[NSNotificationCenter defaultCenter]postNotificationName:CancelOrderNotification object:nil];
                }
            }
        }else{
            NSLog(@"%@",error.description);
        }
    }];
}

-(void)createData{
    
    [self.hud show:YES];
    self.manager = [NetManager shareManager];
    NSString * urlStr  = [NSString stringWithFormat:OrderDetailUrl,[self.manager getIPAddress]];
    NSDictionary * dict = @{@"orderid":self.orderId,@"page":@(page),@"size":@"10"};
    [self.manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
        
        if(error == nil){
            [self.hud hide:YES];
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if(dict[@"products"]){
                
                NSArray * dataArray = dict[@"products"];
                for(NSDictionary * subDict in dataArray){
                    
                    BTDetailModel * model = [[BTDetailModel alloc]initWithDictionary:subDict error:nil];
                    [self.items addObject:model];
                }
                [self.tableView reloadData];
                [self.tableView footerEndRefreshing];
            }
            
        }else{
            NSLog(@"%@",error.description);
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.items.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BTDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[BTDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.items[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.state integerValue] == 0) return 0;
    return (0+self.items[indexPath.row].details.count*35)*S6;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGFloat lineWid = 0.8;
    
    BTDetailModel * model = [self.items objectAtIndex:section];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 72*S6)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, lineWid*S6)];
    topLine.backgroundColor = BOARDCOLOR;
    [bgView addSubview:topLine];
    
    UILabel * _noLbl = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(topLine.frame), 24.5*S6, 101*S6) textContent:GETSTRING(section+1) withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:_noLbl];
    
    UIView * midLine = [[UIView alloc]initWithFrame:CGRectMake(24.5*S6, _noLbl.y, lineWid*S6, 101*S6)];
    midLine.backgroundColor = BOARDCOLOR;
    [bgView addSubview:midLine];
    
    UIImageView  *_imgView = [[UIImageView alloc]initWithFrame:CGRectMake(midLine.x+10*S6, topLine.y+10*S6, 110*S6, 82.5*S6)];
    _imgView.layer.borderColor = [BOARDCOLOR CGColor];
    _imgView.layer.borderWidth = 2.5*S6;
    [bgView addSubview:_imgView];
    
    NSInteger width = 110*THUMBNAILRATE;
    NSInteger height = 165/2.0*THUMBNAILRATE;
    
    NSString * URLstring = [NSString stringWithFormat:BANNERCONNET,[self.manager getIPAddress]];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[Tools connectOriginImgStr:[NSString stringWithFormat:@"%@%@",URLstring,model.img] width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:[UIImage imageNamed:PLACEHOLDER]];
    
    UILabel *_nameLbl = [Tools createLabelWithFrame:CGRectMake(CGRectGetMaxX(_imgView.frame)+8*S6, _imgView.x+0*S6, 120*S6, 14*S6) textContent:model.name withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:_nameLbl];
    
    UILabel *_numberLbl = [Tools createLabelWithFrame:CGRectMake(CGRectGetMinX(_nameLbl.frame), CGRectGetMinY(_nameLbl.frame)+20*S6, _nameLbl.width, _nameLbl.height) textContent:model.number withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:_numberLbl];
    
    //添加详情按钮
    UIButton * detailBtn = [Tools createNormalButtonWithFrame:CGRectMake((24.5*S6+(Wscreen-24.5*S6)*2/3.0), 0, (Wscreen-24.5*S6)/3.0, 103*S6) textContent:@"需求详情" withFont:[UIFont systemFontOfSize:14*S6] textColor:RGB_COLOR(231, 140, 59, 1) textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:detailBtn];
    detailBtn.tag = section;
    [detailBtn addTarget:self action:@selector(detailCheck:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * sepLine = [[UIView alloc]initWithFrame:CGRectMake(detailBtn.x, detailBtn.y, lineWid*S6, midLine.height+1*S6)];
    sepLine.backgroundColor = BOARDCOLOR;
    [bgView addSubview:sepLine];
    
    if(![self.state integerValue] == 0){
        NSArray * titleArray = @[@"产品克重",@"出货克重",@"出货数量"];
        
        CGFloat itemWidth = (Wscreen-24.5*S6)/3.0;
        for(int i=0;i<titleArray.count;i++){
            
            UILabel * nameLbl = [Tools createLabelWithFrame:CGRectMake(24.5*S6+itemWidth*i, CGRectGetMaxY(midLine.frame), itemWidth+0.8*S6, 35*S6) textContent:titleArray[i] withFont:[UIFont systemFontOfSize:12*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
            nameLbl.layer.borderColor = [BOARDCOLOR CGColor];
            nameLbl.layer.borderWidth = lineWid*S6;
            [bgView addSubview:nameLbl];
        }
    }else{
        
        //待回传
        UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(midLine.frame)-0.8*S6, Wscreen, 0.8*S6)];
        bottomLine.backgroundColor = BOARDCOLOR;
        [bgView addSubview:bottomLine];
    }
    
    return bgView;
}

-(void)detailCheck:(UIButton *)btn{
    
    OrderCarModel * model = self.modelArray[btn.tag];
    //    if(self.modelArray.count>0){
    //
    //        NSDictionary * dict = self.modelArray[btn.tag];
    //        NSString * key = [[dict allKeys]lastObject];
    //        NSArray * array = dict[key];
    //        model = array[btn.tag];
    //    }
    
    NSString * noteStr;
    NSMutableArray * messageArray;
    if(model.note != nil){
        noteStr = model.note;
        NSData * data = [noteStr dataUsingEncoding:NSUTF8StringEncoding];
        messageArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }else{
        NSDictionary * dict = @{@"txt":@"暂无下单信息!"};
        messageArray = [[NSMutableArray alloc]initWithObjects:dict, nil];
    }
    
    OrderDetailController * orderDetailVc = [[OrderDetailController alloc]init];
    orderDetailVc.dataArray = messageArray;
    orderDetailVc.img = model.image;
    orderDetailVc.number = model.number;
    orderDetailVc.name = model.name;
    orderDetailVc.createTime = self.date;
    [self pushToViewControllerWithTransition:orderDetailVc withDirection:@"left" type:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([self.state integerValue] == 0)return 100*S6;
    return 102*S6+34*S6;
}

-(void)back{
    [self popToViewControllerWithDirection:@"right" type:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
