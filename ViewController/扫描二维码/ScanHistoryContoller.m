//
//  ScanHistoryContoller.m
//  DianZTC
//
//  Created by 杨力 on 30/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "ScanHistoryContoller.h"
#import "DetailViewController.h"
#import "BatarResultController.h"
#import "DBWorkerManager.h"
#import "DBSaveModel.h"
#import "ScanHistoryCell.h"

NSString * const CellID = @"cellID";

@interface ScanHistoryContoller()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton * cleanHistoryBtn;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray<DBSaveModel *> * dataArray;
@property (nonatomic,strong) DBWorkerManager * manager;

@end

@implementation ScanHistoryContoller

@synthesize cleanHistoryBtn = _cleanHistoryBtn;
@synthesize tableView = _tableView;
@synthesize dataArray = _dataArray;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _cleanHistoryBtn.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _cleanHistoryBtn.hidden = YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)createView{
    self.manager = [DBWorkerManager shareDBManager];
    [self.manager createScanDB];
    
    [self batar_setNavibar:@"扫描历史"];
    [self batar_setLeftNavButton:@[@"return",@""] target:self selector:@selector(back) size:CGSizeMake(49/2.0*S6, 22.5*S6) selector:nil rightSize:CGSizeZero topHeight:12*S6];
    _cleanHistoryBtn = [Tools createNormalButtonWithFrame:CGRectMake(Wscreen-65*S6, 33, 55*S6, 20*S6) textContent:@"清空" withFont:[UIFont systemFontOfSize:15*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    [self.navigationController.view addSubview:_cleanHistoryBtn];
    [_cleanHistoryBtn addTarget:self action:@selector(cleanHistory) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, Hscreen-NAV_BAR_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self createData];
}

-(void)createData{
    
    __block typeof(self)weakSelf = self;
    [self.manager scan_getAllObject:^(NSMutableArray *dataArray) {
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:dataArray];
        [_tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ScanHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if(!cell){
        cell = [[ScanHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*S6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DBSaveModel * model = self.dataArray[indexPath.row];
    if([model.searchType isEqualToString:CodeTypeAccurary]){
        DetailViewController * detailVc = [[DetailViewController alloc]initWithController:self];
        detailVc.index = model.number;
        [self pushToViewControllerWithTransition:detailVc withDirection:@"left" type:NO];
    }else if([model.searchType isEqualToString:CodeTypeInaccurary]){
        
        BatarResultController * searchVc = [[BatarResultController alloc]initWithController:[ScanHistoryContoller new]];
        searchVc.param = model.number;
        [self pushToViewControllerWithTransition:searchVc withDirection:@"left" type:NO];
    }else{
        //错误码
        NSLog(@"%@",model.searchType);
        [self showAlertViewWithTitle:@"此编码不存在"];
    }
}

-(void)cleanHistory{
    
    __block typeof(self)weakSelf = self;
    [self.manager scan_cleanAllDBData:^(BOOL clear) {
        if(clear){
            dispatch_async(dispatch_get_main_queue(), ^{
               [weakSelf createData]; 
            });
        }
    }];
}

-(void)back{
    
    [self  popToViewControllerWithDirection:@"right" type:NO];
}

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
