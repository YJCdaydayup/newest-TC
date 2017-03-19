//
//  BatarCarController.m
//  DianZTC
//
//  Created by 杨力 on 26/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "BatarCarController.h"
#import "DBWorkerManager.h"
#import "MySelectedOrderCell.h"
#import "YLShoppingCarBottom.h"
#import "DetailViewController.h"
#import "YLLoginView.h"
#import "NetManager.h"
#import "YLOrdersController.h"
#import "FinalOrderViewController.h"
#import "YLVoicemanagerView.h"
#import "BatarManagerTool.h"

#define CELL @"CARCell"

@interface BatarCarController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) DBWorkerManager * manager;

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray<DBSaveModel *> * selectedArray;
@property (nonatomic,strong) YLShoppingCarBottom * carBottom;
@property (nonatomic,strong) YLLoginView * loginView;

@end

@implementation BatarCarController

@synthesize carBottom = _carBottom;
@synthesize loginView = _loginView;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AddShoppingCar object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if([self.fatherVc isKindOfClass:[DetailViewController class]]||[self.fatherVc isKindOfClass:[FinalOrderViewController class]]){
        self.tabBarController.tabBar.hidden = YES;
    }else{
        self.tabBarController.tabBar.hidden = NO;
    }
    [self createBottom];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self batar_setNavibar:@"购物车"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateList) name:AddShoppingCar object:nil];
}

-(void)updateView{
    [self getData];
}

-(void)updateList{
    [self getData];
}

-(void)createView{
    
    self.navigationItem.hidesBackButton = YES;
    
    YLOrdersController * ylOrderController = [[YLOrdersController alloc]init];
    [self.view addSubview:ylOrderController];
    
    if([self.fatherVc isKindOfClass:[DetailViewController class]]||[self.fatherVc isKindOfClass:[FinalOrderViewController class]]){
        ylOrderController.hidden = NO;
    }
    
    //底部控制
    [ylOrderController clickBottomBtn:^(NSInteger tag) {
        
        switch (tag) {
            case 0://回到首页
            {
                FirstViewController * firstVc = [[FirstViewController alloc]initWithController:self];
                [self pushToViewControllerWithTransition:firstVc withDirection:@"left" type:NO];
                [self removeNaviPushedController:self];
                BatarMainTabBarContoller * tabbar = [BatarMainTabBarContoller sharetabbarController];
                self.delegate = tabbar;
                [self.delegate changeRootController];
            }
                break;
            case 1://我的订单
            {
                //确认选购
                if(CUSTOMERID){
                    //直接上传到服务器
                    
                    FinalOrderViewController * finalVc = [[FinalOrderViewController alloc]initWithController:self];
                    [self pushToViewControllerWithTransition:finalVc withDirection:@"left" type:NO];
                }else{
                    YLLoginView * loginView = [[YLLoginView alloc]initWithVC:self.app.window withVc:self];
                    [self.app.window addSubview:loginView];
                    [loginView clickCancelBtn:^{
                        
                    }];
                }
            }
                break;
            case 2://删除购物单
                [self deleteOrder];
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
    
    
    if([self.fatherVc isKindOfClass:[DetailViewController class]]||[self.fatherVc isKindOfClass:[FinalOrderViewController class]]){
        
        [self batar_setLeftNavButton:@[@"return",@""] target:self selector:@selector(back) size:CGSizeMake(49/2.0*S6, 22.5*S6) selector:nil rightSize:CGSizeZero topHeight:12*S6];
    }
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, Wscreen, Hscreen-40.5*S6-TABBAR_HEIGHT-NAV_BAR_HEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self createBottom];
    [self getData];
}

-(void)back{
    
    [self popToViewControllerWithDirection:@"right" type:NO];
}

-(void)createBottom{
    
    YLShoppingCarBottom * bottomView = [YLShoppingCarBottom shareCarBottom];
    _carBottom = bottomView;
    bottomView.selectAllBtn.selected = NO;
    [self.view addSubview:bottomView];
    
    if([self.fatherVc isKindOfClass:[DetailViewController class]]||[self.fatherVc isKindOfClass:[FinalOrderViewController class]]){
        bottomView.deleteBtn.hidden = YES;
        bottomView.confirmBtn.hidden = YES;
    }else{
        bottomView.deleteBtn.hidden = NO;
        bottomView.confirmBtn.hidden = NO;
    }
    
    [YLShoppingCarBottom clickShoppingCar:^(NSInteger index) {
        if(index == 0){
            if(_carBottom.selectAllBtn.selected){
                //全选
                for(DBSaveModel * model in self.dataArray){
                    [self addOrderModel:model];
                }
            }else{
                //取消全选
                for(DBSaveModel * model in self.dataArray){
                    [self deleteOrderModel:model];
                }
            }
            [self.tableView reloadData];
        }else if(index == 1){
            //删除产品
            [self deleteOrder];
        }else{
            //确认订单
            [self confirmOrder];
        }
    }];
}

-(void)confirmOrder{
    //确认选购
    if(CUSTOMERID){
        //直接上传到服务器
        
        if(self.selectedArray.count == 0){
            [self showAlertViewWithTitle:@"您暂未选择任何产品"];
            return;
        }
        
        if(self.selectedArray.count >0 ){
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.labelText = @"正在确认产品订单...";
            self.hud.animationType = MBProgressHUDAnimationZoomOut;
        }
        
        NSMutableArray * orderSeleArray = [NSMutableArray array];
        //获取订单数组
        for(DBSaveModel * model in self.selectedArray){
            [orderSeleArray addObject:model.number];
        }
        
        NetManager * manager = [NetManager shareManager];
        NSDictionary * dict = @{@"customerid":CUSTOMERID,@"shopcontext":[self myArrayToJson:orderSeleArray]};
        NSString * urlStr = [NSString stringWithFormat:CONFRIMORDR,[manager getIPAddress]];
        
        @WeakObj(self);
        [manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
            if(responseObject){
                selfWeak.hud.labelText = @"确认成功";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [selfWeak.hud hide:YES];
                    [selfWeak getData];
                    selfWeak.carBottom.selectAllBtn.selected = NO;
                });
            }
        }];
        
        //移除本地缓存语音和文字信息
        [self removeLocalMessageInfo];
        
    }else{
        YLLoginView * loginView = [[YLLoginView alloc]initWithVC:self.app.window withVc:self];
        [self.app.window addSubview:loginView];
        [loginView clickCancelBtn:^{
            
        }];
        self.carBottom.selectAllBtn.selected = NO;
    }
}

-(void)removeLocalMessageInfo{
    
    DetailViewController * detailVc = nil;
    for(RootViewController * vc in self.navigationController.viewControllers){
        if([vc isKindOfClass:[DetailViewController class]]){
            detailVc = (DetailViewController *)vc;
            for(DBSaveModel * model in self.selectedArray){
                [kUserDefaults setObject:model.number forKey:RECORDPATH];
                [detailVc deleteLocalRemark];
            }
        }
    }
}

-(void)deleteOrder{
    
    if(self.selectedArray.count==0){
        [self showAlertViewWithTitle:@"暂未选择任何产品!"];
        return ;
    }
    //删除
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction * delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(CUSTOMERID){
            [self removeOrders:YES];
        }else{
            [self removeOrders:NO];
            [BatarManagerTool caculateDatabaseOrderCar];
        }
        
        if([self.fatherVc isKindOfClass:[DetailViewController class]]){
            self.tabBarController.tabBar.hidden = YES;
        }else{
            self.tabBarController.tabBar.hidden = NO;
        }
    }];
    //修改按钮
    [delete setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [controller addAction:cancel];
    [controller addAction:delete];
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void)removeOrders:(BOOL)islogged{
    
    DBWorkerManager * dbManager = [DBWorkerManager shareDBManager];
    if(islogged){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.labelText = @"正在删除中...";
        self.hud.animationType = MBProgressHUDAnimationZoomOut;
        //删除服务端订单
        NSMutableArray * selectArray = [NSMutableArray array];
        for(DBSaveModel * model in self.selectedArray){
            [selectArray addObject:model.number];
        }
        NetManager * manager = [NetManager shareManager];
        NSDictionary * dict = @{@"order":[self myArrayToJson:selectArray],@"customerid":CUSTOMERID};
        NSString * urlStr = [NSString stringWithFormat:REMOVECARORDER,[manager getIPAddress]];
        [manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if([[dict objectForKey:@"state"]integerValue]){
                self.hud.labelText = @"删除成功!";
                [BatarManagerTool caculateServerOrderCar];
                _carBottom.selectAllBtn.selected = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.hud hide:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self getData];
                    });
                });
            }
        }];
        _carBottom.selectAllBtn.selected = NO;
    }else{
        //删除本地订单
        [self.dataArray removeObjectsInArray:self.selectedArray];
        for(DBSaveModel * model in self.selectedArray){
            [dbManager order_cleanDBDataWithNumber:model.number];
        }
        _carBottom.selectAllBtn.selected = NO;
        [self.tableView reloadData];
    }
}

-(void)getData{
    
    @WeakObj(self);
    [self.selectedArray removeAllObjects];
    [self.dataArray removeAllObjects];
    if(CUSTOMERID){
        //服务器获取数据
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
                        DBSaveModel * model = [[DBSaveModel alloc]init];
                        model.name = dict[@"name"];
                        model.number = dict[@"number"];
                        model.image = dict[@"image"];
                        [tempArray addObject:model];
                    }
                    [self.dataArray addObjectsFromArray:tempArray];
                }
                [BatarManagerTool caculateServerOrderCar];
                [selfWeak.tableView reloadData];
                
            }else{
                NSLog(@"%@",error.description);
            }
        }];
    }else
    {
        //本地购物车获取数据
        [self.manager createOrderDB];
        [self.manager order_getAllObject:^(NSMutableArray *dataArray) {
            selfWeak.dataArray = dataArray;
            [selfWeak.tableView reloadData];
        }];
    }
}

#pragma mark -表格代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MySelectedOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL];
    if(cell == nil){
        cell = [[MySelectedOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL];
    }
    
    DBSaveModel * model = self.dataArray[indexPath.row];
    [cell configCellWithModel:model];
    
    __block typeof(self)weakSelf = self;
    [cell clickSelectedOrderBlock:^(UIButton *btn) {
        if(btn.selected){
            [weakSelf addOrderModel:model];
        }else{
            [weakSelf deleteOrderModel:model];
        }
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController * detailVc = [[DetailViewController alloc]initWithController:self];
    DBSaveModel * model = self.dataArray[indexPath.row];
    detailVc.index = model.number;
    [self pushToViewControllerWithTransition:detailVc withDirection:@"right" type:NO];
}

-(void)addOrderModel:(DBSaveModel *)model{
    
    if(![self.selectedArray containsObject:model]){
        
        model.selected = YES;
        [self.selectedArray addObject:model];
        if(self.selectedArray.count == self.dataArray.count){
            _carBottom.selectAllBtn.selected = YES;
        }
    }
}

-(void)deleteOrderModel:(DBSaveModel *)model{
    
    model.selected = NO;
    [self.selectedArray removeObject:model];
    _carBottom.selectAllBtn.selected = NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 102.5*S6;
}

-(DBWorkerManager *)manager{
    
    if(_manager == nil){
        _manager = [DBWorkerManager shareDBManager];
    }
    return _manager;
}

-(NSMutableArray *)selectedArray{
    
    if(!_selectedArray){
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
