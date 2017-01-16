
//
//  MyOrdersController.m
//  DianZTC
//
//  Created by 杨力 on 1/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "MyOrdersController.h"
#import "DBWorkerManager.h"
#import "MySelectedOrderCell.h"
#import "DBSaveModel.h"
#import "DetailViewController.h"
#import "YLOrdersController.h"
#import "NetManager.h"
#import "OrderCarModel.h"
#import "FirstViewController.h"
#import "FinalOrderViewController.h"
#import "YLVoicemanagerView.h"
#import "BatarMainTabBarContoller.h"

#define SELECTEDCELL  @"selectCell"

@interface MyOrdersController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView * order_tableView;
    UIButton * selectAllBtn;
}

@property (nonatomic,strong) UIButton * navLeftButton;
@property (nonatomic,strong) UILabel * titlelabel;

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * selected_array;

@property (nonatomic,strong) YLVoicemanagerView * ylVoiceView;

@end

@implementation MyOrdersController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    [self createNav];
    
    [self createView];
}

-(void)createView{
    
    //顶部“全选”
    selectAllBtn = [Tools createNormalButtonWithFrame:CGRectMake(12.5*S6, 12.5*S6+NAV_BAR_HEIGHT, 16.5*S6, 16.5*S6) textContent:nil withFont:nil textColor:nil textAlignment:NSTextAlignmentCenter];
    [selectAllBtn setImage:[UIImage imageNamed:@"order_selectAll"] forState:UIControlStateSelected];
    [selectAllBtn setImage:[UIImage imageNamed:@"order_selectNotAll"] forState:UIControlStateNormal];
    [selectAllBtn addTarget:self action:@selector(selectAllAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectAllBtn];
    
    UILabel * selectLabel = [Tools createLabelWithFrame:CGRectMake(CGRectGetMaxX(selectAllBtn.frame)+15.5*S6, CGRectGetMinY(selectAllBtn.frame), 100, 14*S6) textContent:@"全选" withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:selectLabel];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(selectAllBtn.frame)+11.5*S6, Wscreen, 2*S6)];
    lineView.backgroundColor = RGB_COLOR(216, 133, 57, 1);
    [self.view addSubview:lineView];
    
    order_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(selectAllBtn.frame)+13.5*S6, Wscreen, Hscreen-CGRectGetMaxY(selectAllBtn.frame)*S6-80*S6) style:UITableViewStylePlain];
    order_tableView.delegate = self;
    order_tableView.dataSource = self;
    order_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:order_tableView];
    
    YLOrdersController * ylOrderController = [[YLOrdersController alloc]init];
    [self.view addSubview:ylOrderController];
    
    //底部控制
    [ylOrderController clickBottomBtn:^(NSInteger tag) {
        
        switch (tag) {
            case 0://回到首页
            {
                FirstViewController * firstVc = [[FirstViewController alloc]init];
                [self pushToViewControllerWithTransition:firstVc withDirection:@"left" type:NO];
                [self removeNaviPushedController:self];
                
                BatarMainTabBarContoller * tabbarVc = [BatarMainTabBarContoller sharetabbarController];
                self.delegate = tabbarVc;
                [self.delegate changeRootController];
            }
                break;
            case 1://我的订单
            {
                FinalOrderViewController * finalVc = [[FinalOrderViewController alloc]init];
                [self pushToViewControllerWithTransition:finalVc withDirection:@"left" type:NO];
            }
                break;
            case 2://删除购物单
                [self removeCarOrder];
                break;
            case 3://确认订单
            {
                [self confirmOrder];
            }
                break;
            default:
                break;
        }
    }];
    
    [self createData];
}

#pragma mark -确认订单
-(void)confirmOrder{
    
    if(self.selected_array.count == 0){
        [self showAlertViewWithTitle:@"您暂未选择任何产品"];
        return;
    }
    
    if(self.selected_array.count >0 ){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.labelText = @"正在提交产品数据...";
        self.hud.animationType = MBProgressHUDAnimationZoomOut;
    }
    
    NetManager * manager = [NetManager shareManager];
    NSDictionary * dict = @{@"customerid":CUSTOMERID,@"shopcontext":[self myArrayToJson:self.selected_array]};
    NSString * urlStr = [NSString stringWithFormat:CONFRIMORDR,[manager getIPAddress]];
    
    [manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
        if(responseObject){
            self.hud.labelText = @"提交成功!";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.hud hide:YES];
                [self createData];
            });
        }
    }];
    
    //移除本地缓存语音和文字信息
    [self removeLocalMessageInfo];
}

-(void)removeLocalMessageInfo{
    
    for(NSString * number in self.selected_array){
        
        [kUserDefaults setObject:number forKey:RECORDPATH];
        YLVoicemanagerView * voiceManager = [[YLVoicemanagerView alloc]initWithFrame:self.view.frame withVc:[UIView new]];
        [voiceManager cleanAllVoiceData];
    }
}

-(void)afterNetWork{
    selectAllBtn.selected = NO;
    NSMutableArray * tempArray = [NSMutableArray array];
    for(NSString * number in self.selected_array){
        for(int i=0;i<self.dataArray.count;i++){
            OrderCarModel * model = self.dataArray[i];
            if([model.number isEqualToString:number]){
                [tempArray addObject:model];
            }
        }
    }
    [self.dataArray removeObjectsInArray:tempArray];
}

#pragma mark -选择全部
-(void)selectAllAction:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    if(btn.selected){
        //全选
        [self.selected_array removeAllObjects];
        for(OrderCarModel * model in self.dataArray){
            
            model.selected = YES;
            [self.selected_array addObject:model.number];
        }
    }else{
        //取消全选
        [self.selected_array removeAllObjects];
        for(OrderCarModel * model in self.dataArray){
            model.selected = NO;
            [self.selected_array removeObject:model.number];
        }
    }
    
    [order_tableView reloadData];
}

-(void)removeCarOrder{
    
    if(self.selected_array.count == 0){
        
        [self showAlertViewWithTitle:@"您暂未选择任何产品"];
        return;
    }
    
    NetManager * manager = [NetManager shareManager];
    NSDictionary * dict = @{@"order":[self myArrayToJson:self.selected_array],@"customerid":CUSTOMERID};
    NSString * urlStr = [NSString stringWithFormat:REMOVECARORDER,[manager getIPAddress]];
    [manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
        if(responseObject){
            [self createData];
        }
    }];
}

-(void)createData{
    
    selectAllBtn.selected = NO;
    self.dataArray = [NSMutableArray array];
    [self.selected_array removeAllObjects];
    [self.hud show:YES];
    NetManager * manager = [NetManager shareManager];
    NSString * urlStr = [NSString stringWithFormat:MYORDERCAR,[manager getIPAddress]];
    NSDictionary * dict = @{@"customerid":CUSTOMERID};
    [manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
        
        if(responseObject){
            
            [self.hud hide:YES];
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            id objs = dict[@"products"];
            if([dict isKindOfClass:[NSArray class]]){
                return ;
            }
            if([objs isKindOfClass:[NSNull class]]){
                [self.dataArray removeAllObjects];
            }else{
                NSMutableArray * modelArray = dict[@"products"];
                NSMutableArray * tempArray = [[NSMutableArray alloc]init];
                for(NSDictionary * dict in modelArray){
                    OrderCarModel * model = [[OrderCarModel alloc]initWithDictionary:dict error:nil];
                    [tempArray addObject:model];
                }
                [self.dataArray addObjectsFromArray:tempArray];
            }
            [order_tableView reloadData];
        }else{
            NSLog(@"%@",error.description);
        }
    }];
}

#pragma mark -表格代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MySelectedOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:SELECTEDCELL];
    if(cell == nil){
        cell = [[MySelectedOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SELECTEDCELL];
    }
    
    OrderCarModel * model = self.dataArray[indexPath.row];
    [cell configCellWithModel:model];
    
    __block typeof(self)weakSelf = self;
    [cell clickSelectedOrderBlock:^(UIButton *btn) {
        
        if(btn.selected){
            //选择
            model.selected = YES;
            [weakSelf.selected_array addObject:model.number];
            if(self.selected_array.count == self.dataArray.count){
                selectAllBtn.selected = YES;
            }
        }else{
            //取消选择
            model.selected = NO;
            selectAllBtn.selected = NO;
            [weakSelf.selected_array removeObject:model.number];
        }
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 103.5*S6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderCarModel * model = self.dataArray[indexPath.row];
    DetailViewController * subVc = [[DetailViewController alloc]init];
    [self addChildViewController:subVc];
    subVc.fromSaveVc = 3;
    subVc.index = model.module;
    [self.navigationController pushViewController:subVc animated:YES];
}

-(void)createNav{
    
    //导航条设置
    self.navLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navLeftButton setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    self.navLeftButton.frame = CGRectMake(15.5, 13, 24.5, 22.5);
    [self.navigationController.navigationBar addSubview:self.navLeftButton];
    [self.navLeftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //导航条标题
    self.titlelabel = [Tools createLabelWithFrame:CGRectMake(15, 10,100, 20*S6) textContent:nil withFont:[UIFont systemFontOfSize:17*S6] textColor:RGB_COLOR(0, 0, 0, 1) textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = self.titlelabel;
    self.titlelabel.text = @"我的购物车";
}

-(void)back{
    
    DetailViewController * detailVc = [[DetailViewController alloc]init];
    detailVc.index = [kUserDefaults objectForKey:LONG_PRODUCT_ID];
    detailVc.fromSaveVc = 0;
    [self pushToViewControllerWithTransition:detailVc withDirection:@"right" type:NO];
    //    [self presentViewController:nvc animated:YES completion:nil];
    //    [self popToViewControllerWithDirection:@"right" type:NO];
}

-(NSMutableArray *)selected_array{
    
    if(_selected_array == nil){
        
        _selected_array = [[NSMutableArray alloc]init];
    }
    return _selected_array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
