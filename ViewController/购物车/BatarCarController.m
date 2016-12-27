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
#import "YLLoginView.h"

#define CELL @"CARCell"

@interface BatarCarController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) DBWorkerManager * manager;

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * selectedArray;
@property (nonatomic,strong) YLShoppingCarBottom * carBottom;
@property (nonatomic,strong) YLLoginView * loginView;

@end

@implementation BatarCarController

@synthesize carBottom = _carBottom;
@synthesize loginView = _loginView;

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self createBottom];
    [self getData];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self batar_setNavibar:@"购物车"];
}

-(void)createView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, Hscreen-40.5*S6-TABBAR_HEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self createBottom];
    [self getData];
}

-(void)createBottom{
    
    YLShoppingCarBottom * bottomView = [YLShoppingCarBottom shareCarBottom];
    _carBottom = bottomView;
    bottomView.selectAllBtn.selected = NO;
    [self.view addSubview:bottomView];
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
            if(self.selectedArray.count==0){
                [self showAlertViewWithTitle:@"暂未选择任何产品!"];
                return ;
            }
            //删除
            if([kUserDefaults objectForKey:CustomerID]){
                [self removeOrders:YES];
            }else{
                [self removeOrders:NO];
            }
        }else{
            //确认选购
            if([kUserDefaults objectForKey:CustomerID]){
                //直接传入服务器
                [[NSNotificationCenter defaultCenter]postNotificationName:CustomerID object:nil];
            }else{
                YLLoginView * loginView = [[YLLoginView alloc]initWithVC:self.app.window withVc:self];
                [self.app.window addSubview:loginView];
                [loginView clickCancelBtn:^{
                    
                }];
            }
        }
    }];
}

-(void)removeOrders:(BOOL)islogged{
    
    DBWorkerManager * dbManager = [DBWorkerManager shareDBManager];
    if(islogged){
        //删除服务端订单
        
        
        
    }else{
        //删除本地订单
        [self.dataArray removeObjectsInArray:self.selectedArray];
        for(DBSaveModel * model in self.selectedArray){
            [dbManager order_cleanDBDataWithNumber:model.number];
        }
    }
    _carBottom.selectAllBtn.selected = NO;
    [self.tableView reloadData];
}

-(void)getData{
    
    [self.selectedArray removeAllObjects];
    WEAKSELF(WEAKSS);
    [self.manager order_getAllObject:^(NSMutableArray *dataArray) {
        WEAKSS.dataArray = dataArray;
        [WEAKSS.tableView reloadData];
    }];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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

@end
