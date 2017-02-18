
//
//  FinalOrderViewController.m
//  DianZTC
//
//  Created by 杨力 on 11/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "FinalOrderViewController.h"
#import "OrderDetailController.h"
#import "FirstViewController.h"
#import "SavaViewController.h"
#import "MyOrdersController.h"
#import "YLFinalOrderView.h"
#import "FinalOrderCell.h"
#import "OrderCarModel.h"
#import "NetManager.h"
#import "HeaderModel.h"
#import "MJRefresh.h"
#import "BatarSettingController.h"

@interface FinalOrderViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView * orderTableView;
    YLFinalOrderView * finalBottomView;
    UIButton * selectAllBtn;
    
    NSInteger page;
}

@property (nonatomic,strong) UIButton * navLeftButton;
@property (nonatomic,strong) UILabel * titlelabel;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * titleArray;
@property (nonatomic,strong) NSMutableArray * stateArray;
@property (nonatomic,strong) NSMutableArray * selectedHeaderArray;

@end

@implementation FinalOrderViewController

@synthesize type = type;

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
    
    [self configNav];
    [self createTableView];
    [self createBottomView];
}

-(void)createData{
    
    NetManager * manager = [NetManager shareManager];
    NSString * urlStr = [NSString stringWithFormat:CHECKORDER,[manager getIPAddress]];
    NSDictionary * dict = @{@"customerid":CUSTOMERID,@"page":@(page),@"size":@"10",@"type":type};
    NSLog(@"%@",urlStr);
    [manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
        
        if(!responseObject){
            return ;
        }
        NSMutableArray * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",array);
        if(![array isKindOfClass:[NSArray class]]){
            return ;
        }
        if(page == 0){
            [self.dataArray removeAllObjects];
            [self.stateArray removeAllObjects];
            [self.selectedHeaderArray removeAllObjects];
        }
        
        for(int i =0;i<array.count;i++){
            
            NSDictionary * dict = array[i];
            HeaderModel * model = [[HeaderModel alloc]init];
            model.createTime = dict[@"createtime"];
            model.orderid = dict[@"orderid"];
            model.isSelected = NO;
            model.state = dict[@"state"];
            [self.titleArray addObject:model];
            
            if(i == 0){
                [self.stateArray addObject:@"1"];
            }else{
                [self.stateArray addObject:@"0"];
            }
            NSArray * productArray = dict[@"products"];
            NSMutableArray * modelArr = [NSMutableArray array];
            for(NSDictionary * subDict in productArray){
                OrderCarModel * order_model = [[OrderCarModel alloc]initWithDictionary:subDict error:nil];
                [modelArr addObject:order_model];
                if(selectAllBtn.selected){
                    model.isSelected = YES;
                    [self.selectedHeaderArray addObject:model];
                }
            }
            NSDictionary * dicts = @{model.orderid:modelArr};
            [self.dataArray addObject:dicts];
        }
        
        
        
        [orderTableView reloadData];
        [orderTableView headerEndRefreshing];
        [orderTableView footerEndRefreshing];
    }];
}

-(void)createBottomView{
    
    finalBottomView = [[YLFinalOrderView alloc]init];
    [self.view addSubview:finalBottomView];
    
    [finalBottomView clickBottomBtn:^(NSInteger tag) {
        
        switch (tag) {
            case 0:
            {//首页
                FirstViewController * firstVc = [[FirstViewController alloc]init];
                [self pushToViewControllerWithTransition:firstVc withDirection:@"left" type:NO];
            }
                break;
            case 1:
            {//我的收藏
                SavaViewController * saveVc = [[SavaViewController alloc]init];
                [kUserDefaults setObject:@"order" forKey:FROM_VC_TO_SAVE];
                [self pushToViewControllerWithTransition:saveVc withDirection:@"left" type:NO];
            }
                break;
            case 2:
            {//选购单
                [self popToViewControllerWithDirection:@"right" type:NO];
            }
                break;
            case 3:
            {//删除
                [self deleteOrders];
            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - 删除我的订单
-(void)deleteOrders{
    
    if(self.selectedHeaderArray.count == 0){
        [self showAlertViewWithTitle:@"您尚未选择任何产品!"];
        return;
    }
    //删除
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction * delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray * orderlist = [[NSMutableArray alloc]init];
        for(HeaderModel * model in self.selectedHeaderArray){
            [orderlist addObject:model.orderid];
        }
        
        NetManager * manager = [NetManager shareManager];
        NSString * urlStr = [NSString stringWithFormat:DELETEMYORDER,[manager getIPAddress]];
        NSDictionary * dict = @{@"orderlist":[self myArrayToJson:orderlist]};
        [manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
            
            if(responseObject){
                
                NSMutableArray * tempArray = [[NSMutableArray alloc]init];
                for(HeaderModel * model in self.selectedHeaderArray){
                    for(int i=0;i<self.dataArray.count;i++){
                        
                        NSDictionary * dicts = self.dataArray[i];
                        NSString * key = [[dicts allKeys]lastObject];
                        if([key isEqualToString:model.orderid]){
                            [tempArray addObject:dicts];
                            [self.titleArray removeObject:model];
                            [self.stateArray removeObjectAtIndex:i];
                        }
                    }
                }
                for(NSDictionary * dataDict in tempArray){
                    [self.dataArray removeObject:dataDict];
                }
                
                [self.selectedHeaderArray removeAllObjects];
                [orderTableView reloadData];
                selectAllBtn.selected = NO;
            }
        }];
    }];
    //修改按钮
    [delete setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [controller addAction:cancel];
    [controller addAction:delete];
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)createTableView{
    
    UISegmentedControl * segmentView = [[UISegmentedControl alloc]initWithItems:@[@"全部订单",@"待详单回传",@"待确认详单",@"已确认详单"]];
    segmentView.tintColor = BOARDCOLOR;
    segmentView.frame = CGRectMake(-5*S6, NAV_BAR_HEIGHT-1*S6, Wscreen+10*S6, 45*S6);
    segmentView.layer.borderColor = [BOARDCOLOR CGColor];
    segmentView.layer.borderWidth = 0.5*S6;
    segmentView.selectedSegmentIndex = self.selectIndex;
    
    //设置文字属性
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14*S6],NSForegroundColorAttributeName: RGB_COLOR(64, 64, 64, 1)};
    [segmentView setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    [self.view addSubview:segmentView];
    
    [segmentView addTarget:self action:@selector(switchItem:) forControlEvents:UIControlEventValueChanged];
    
    orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(segmentView.frame),Wscreen,Hscreen-210*S6) style:UITableViewStylePlain];
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:orderTableView];
    
    if(![self.fatherVc isKindOfClass:[BatarSettingController class]]){
        type = @(-1);
    }
    [orderTableView addHeaderWithTarget:self action:@selector(headerAction)];
    [orderTableView addFooterWithTarget:self action:@selector(footerAction)];
    [orderTableView headerBeginRefreshing];
    
    //顶部“全选”
    selectAllBtn = [Tools createNormalButtonWithFrame:CGRectMake(12.5*S6, Hscreen-34*S6-45*S6, 16.5*S6, 16.5*S6) textContent:nil withFont:nil textColor:nil textAlignment:NSTextAlignmentCenter];
    [selectAllBtn setImage:[UIImage imageNamed:@"order_selectAll"] forState:UIControlStateSelected];
    [selectAllBtn setImage:[UIImage imageNamed:@"order_selectNotAll"] forState:UIControlStateNormal];
    [selectAllBtn addTarget:self action:@selector(selectAllAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectAllBtn];
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(-5, selectAllBtn.y-12*S6, Wscreen+10*S6, 40*S6)];
    bgView.layer.borderWidth = 0.5*S6;
    bgView.layer.borderColor = [BOARDCOLOR CGColor];
    bgView.backgroundColor = RGB_COLOR(250, 250, 250, 0.1);
    [self.view addSubview:bgView];
    
    UIControl * control = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 120*S6, 40*S6)];
    [bgView addSubview:control];
    [control addTarget:self action:@selector(zoomInSelectBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:selectAllBtn];
    
    UILabel * selectLabel = [Tools createLabelWithFrame:CGRectMake(CGRectGetMaxX(selectAllBtn.frame)+15.5*S6, CGRectGetMinY(selectAllBtn.frame), 100, 14*S6) textContent:@"全选" withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:selectLabel];
}

-(void)zoomInSelectBtn{
    
    [self selectAct:selectAllBtn];
}

-(void)switchItem:(UISegmentedControl *)seg{
    
    [self.dataArray removeAllObjects];
    [self.selectedHeaderArray removeAllObjects];
    [self.stateArray removeAllObjects];
    [self.titleArray removeAllObjects];
    
    selectAllBtn.selected = NO;
    
    page = 0;
    switch (seg.selectedSegmentIndex) {
        case 0:
        {
            type = @(-1);
            [self createData];
        }
            break;
        case 1:
        {
            type = @(0);
            [self createData];
        }
            break;
        case 2:
        {
            type = @(1);
            [self createData];
        }
            break;
        case 3:
        {
            type = @(2);
            [self createData];
        }
            break;
        default:
            break;
    }
}

//-(void)cleanAllSubVc{
//
//    [self cleanVc:waitingCheckVc];
//    [self cleanVc:waitingOrderVc];
//    [self cleanVc:confirmedVc];
//}

-(void)cleanVc:(RootViewController *)vc{
    
    [vc.view removeFromSuperview];
    vc.view.hidden = YES;
    vc = nil;
}

-(void)headerAction{
    page = 0;
    selectAllBtn.selected = NO;
    [self createData];
}

-(void)footerAction{
    page ++;
    [self createData];
}

#pragma mark - mark -全选按钮
-(void)selectAllAction:(UIButton *)btn{
    
    [self selectAct:btn];
}

-(void)selectAct:(UIButton *)btn{
    
    for(int i =0;i<self.titleArray.count;i++){
        
        if(i == 0){
            [self.stateArray addObject:@"1"];
        }else{
            [self.stateArray addObject:@"0"];
        }
    }
    
    btn.selected = !btn.selected;
    if(btn.selected){
        [self.selectedHeaderArray removeAllObjects];
        [self.selectedHeaderArray addObjectsFromArray:self.titleArray];
    }else{
        [self.selectedHeaderArray removeAllObjects];
    }
    [orderTableView reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary * dict = self.dataArray[section];
    NSMutableArray * array = [[dict allValues]lastObject];
    NSString * status = self.stateArray[section];
    if ([status isEqualToString:@"1"]) {
        return array.count;
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"cell";
    FinalOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[FinalOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if(self.dataArray.count>0){
        
        NSDictionary * dict = self.dataArray[indexPath.section];
        NSString * key = [[dict allKeys]lastObject];
        NSArray * array = dict[key];
        OrderCarModel * model = array[indexPath.row];
        [cell configCellWithModel:model];
    }
    
    HeaderModel * model = self.titleArray[indexPath.section];
    [cell clickDetailBtn:^(NSMutableArray *OrderMessage, UIImage *img, NSString *number,NSString * name) {
        
        OrderDetailController * orderDetailVc = [[OrderDetailController alloc]init];
        orderDetailVc.dataArray = OrderMessage;
        //        NSLog(@"%@",OrderMessage);
        orderDetailVc.img = img;
        orderDetailVc.number = number;
        orderDetailVc.name = name;
        orderDetailVc.createTime = model.createTime;
        [self pushToViewControllerWithTransition:orderDetailVc withDirection:@"left" type:NO];
    }];
    
    return cell;
}

#pragma 返回组头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40*S6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 103.5*S6;
}

#pragma mark 返回组头的视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 40*S6)];
    bgView.tag = section+10000;
    bgView.backgroundColor = RGB_COLOR(249, 249, 249, 1);
    
    UIView * zoomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50*S6, 40*S6)];
    //    zoomView.backgroundColor = [UIColor redColor];
    zoomView.tag = section+100000;
    UITapGestureRecognizer * zoomTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomSelect:)];
    [zoomView addGestureRecognizer:zoomTap];
    [bgView addSubview:zoomView];
    
    UIButton * selectBtn = [Tools createButtonNormalImage:@"order_selectNotAll" selectedImage:@"order_selectAll" tag:section+1000 addTarget:self action:@selector(selectAction:)];
    selectBtn.frame = CGRectMake(12.5*S6, 11.5*S6,16.5*S6,16.5*S6);
    [zoomView addSubview:selectBtn];
    
    //根据选择数组改变按钮的选中状态
    HeaderModel * model = self.titleArray[section];
    if([self.selectedHeaderArray containsObject:model]){
        selectBtn.selected = YES;
    }else{
        selectBtn.selected = NO;
    }
    
    UILabel * dateLabel = [Tools createLabelWithFrame:CGRectMake(CGRectGetMaxX(selectBtn.frame)+17.5*S6, 12.5*S6, 200, 16*S6) textContent:nil withFont:[UIFont systemFontOfSize:16*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    dateLabel.text = model.createTime;
    [bgView addSubview:dateLabel];
    
    UIButton * showOutBtn = [Tools createButtonNormalImage:@"show_up" selectedImage:@"show_down" tag:section+100 addTarget:self action:@selector(buttonAction:)];
    showOutBtn.frame = CGRectMake(Wscreen-25*S6, 15*S6, 15*S6, 10*S6);
    [bgView addSubview:showOutBtn];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 39*S6, Wscreen, 0.5*S6)];
    line.backgroundColor = BOARDCOLOR;
    [bgView addSubview:line];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showOut:)];
    [bgView addGestureRecognizer:tap];
    
    UILabel * stateLbl = [Tools createLabelWithFrame:CGRectMake(Wscreen-showOutBtn.width-100*S6, showOutBtn.y, 80*S6, 14*S6) textContent:@"待确认" withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:stateLbl];
    
    if([model.state integerValue] == 0){
        stateLbl.text = @"待回传";
        stateLbl.textColor = RGB_COLOR(166, 83, 33, 1);
    }else if([model.state integerValue] == 1){
        stateLbl.text = @"待确认";
        stateLbl.textColor = TEXTCOLOR;
    }else{
        stateLbl.text = @"已确认";
        stateLbl.textColor = BatarPlaceTextCol;
    }
    
    return bgView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)zoomSelect:(UITapGestureRecognizer *)tap{
    
    UIView * zoomView = (UIView *)tap.view;
    NSInteger index = zoomView.tag - 100000;
    UIButton * btn = (UIButton *)[zoomView viewWithTag:1000+index];
    btn.selected = !btn.selected;
    
    HeaderModel * model = [self.titleArray objectAtIndex:index];
    
    if(btn.selected){
        //选择
        model.isSelected = YES;
        [self.selectedHeaderArray addObject:model];
        if(self.selectedHeaderArray.count == self.titleArray.count){
            selectAllBtn.selected = YES;
        }
    }else{
        //取消选择
        model.isSelected = NO;
        selectAllBtn.selected = NO;
        [self.selectedHeaderArray removeObject:model];
    }
}

-(void)selectAction:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    NSInteger index = btn.tag-1000;
    
    HeaderModel * model = [self.titleArray objectAtIndex:index];
    
    if(btn.selected){
        //选择
        model.isSelected = YES;
        [self.selectedHeaderArray addObject:model];
        if(self.selectedHeaderArray.count == self.titleArray.count){
            selectAllBtn.selected = YES;
        }
    }else{
        //取消选择
        model.isSelected = NO;
        selectAllBtn.selected = NO;
        [self.selectedHeaderArray removeObject:model];
    }
}

#pragma mark 处理展开和关闭的方法
-(void)buttonAction:(UIButton *)button{
    
    //直接去改变_statusArray相应位置的状态
    int index = button.tag - 100;
    if(self.stateArray.count>0){
        NSString * status = [self.stateArray objectAtIndex:index];
        if([status isEqualToString:@"0"]){
            for(int i=0;i<self.stateArray.count;i++){
                [self.stateArray replaceObjectAtIndex:i withObject:@"0"];
            }
            [self.stateArray replaceObjectAtIndex:index withObject:@"1"];
        }
        //刷新表格的某一个分组
        [orderTableView reloadData];
    }
}

-(void)showOut:(UITapGestureRecognizer *)tap{
    
    UIView * bgView = (UIView *)tap.view;
    NSInteger index = bgView.tag - 10000;
    if(self.stateArray.count>0){
        NSString * status = [self.stateArray objectAtIndex:index];
        if([status isEqualToString:@"0"]){
            for(int i=0;i<self.stateArray.count;i++){
                [self.stateArray replaceObjectAtIndex:i withObject:@"0"];
            }
            [self.stateArray replaceObjectAtIndex:index withObject:@"1"];
        }
        
        //刷新表格的某一个分组
        [orderTableView reloadData];
    }
}

-(void)configNav{
    
    //导航条设置
    self.navLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navLeftButton setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    self.navLeftButton.frame = CGRectMake(15.5, 13, 24.5, 22.5);
    [self.navigationController.navigationBar addSubview:self.navLeftButton];
    [self.navLeftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //导航条标题
    self.titlelabel = [Tools createLabelWithFrame:CGRectMake(15, 10,100, 20*S6) textContent:nil withFont:[UIFont systemFontOfSize:17*S6] textColor:RGB_COLOR(0, 0, 0, 1) textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = self.titlelabel;
    self.titlelabel.text = @"我的订单";
}

-(void)back{
    
    [self popToViewControllerWithDirection:@"right" type:NO];
}

-(NSMutableArray *)titleArray{
    
    if(_titleArray == nil){
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

-(NSMutableArray *)selectedHeaderArray{
    
    if(_selectedHeaderArray == nil){
        _selectedHeaderArray = [[NSMutableArray alloc]init];
    }
    return _selectedHeaderArray;
}

-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(NSMutableArray *)stateArray{
    
    if(_stateArray == nil){
        
        _stateArray = [[NSMutableArray alloc]init];
    }
    return _stateArray;
}

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
