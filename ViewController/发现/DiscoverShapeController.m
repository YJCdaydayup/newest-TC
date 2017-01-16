//
//  DiscoverShapeController.m
//  DianZTC
//
//  Created by 杨力 on 7/1/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "DiscoverShapeController.h"
#import "DiscoverViewController.h"
#import "DetailViewController.h"
#import "BatarResultModel.h"
#import "RecommandImageModel.h"
#import "MySelectedOrderCell.h"
#import "MJRefresh.h"
#import "NetManager.h"

#define CODERCELL  @"codercell"

@interface DiscoverShapeController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    NSInteger page;
}

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray<BatarResultModel *>*dataArray;
@property (nonatomic,strong) UIButton * layoutBtn;
@property (nonatomic,strong) NSIndexPath * indexPath;

@end

@implementation DiscoverShapeController


@synthesize tableView = _tableView;
@synthesize dataArray = _dataArray;
@synthesize layoutBtn = _layoutBtn;

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    _layoutBtn.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    _layoutBtn.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)createView{
    
    [self batar_setNavibar:@"发现"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _layoutBtn = [Tools createNormalButtonWithFrame:CGRectMake(Wscreen-38*S6, 31, 22*S6, 22*S6) textContent:nil withFont:[UIFont systemFontOfSize:15*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentRight];
    [_layoutBtn setImage:[UIImage imageNamed:@"shape_sel"] forState:UIControlStateNormal];
    [_layoutBtn setImage:[UIImage imageNamed:@"shape_nor"] forState:UIControlStateHighlighted];
    [self.navigationController.view addSubview:_layoutBtn];
    _layoutBtn.selected = NO;
    [_layoutBtn addTarget:self action:@selector(changeLayout) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, Wscreen, Hscreen-NAV_BAR_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(headerAction)];
    [_tableView addFooterWithTarget:self action:@selector(footerAction)];
    [self headerAction];
}

-(void)changeLayout{
    
    DiscoverViewController * shapeVc = [[DiscoverViewController alloc]initWithController:self];
    shapeVc.currentIndexPath = self.currentIndexPath;
    shapeVc.initialDataArray = self.dataArray;
    [self.navigationController pushViewController:shapeVc animated:NO];
    [self removeNaviPushedController:self];
}

-(void)createData{
    
    [self.hud show:YES];
    
    NSDictionary * parmDict;
    NSString * urlStr;
    NetManager * manager = [NetManager shareManager];
    NSString * URLstring1 = [NSString stringWithFormat:RECOMMENDURL,[manager getIPAddress]];
    NSString * URLstring = [NSString stringWithFormat:URLstring1,[manager getIPAddress]];
    urlStr = URLstring;
    NSString * pageStr = [NSString stringWithFormat:@"%zi",page];
    parmDict = @{@"page":pageStr,@"itemperpage":@"10"};
    [manager downloadDataWithUrl:urlStr parm:parmDict callback:^(id responseObject, NSError *error) {
        
        if(error == nil){
            [self.hud hide:YES];
            if(page == 0){
                
                [self.dataArray removeAllObjects];
            }
            
            id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray * downArray = [NSMutableArray array];
            if([obj isKindOfClass:[NSDictionary class]]){
                
                NSDictionary * muDict = obj;
                NSMutableArray * muArray = muDict[@"page"];
                for(NSDictionary * dict in muArray){
                    
                    BatarResultModel * model = [[BatarResultModel alloc]initWithDictionary:dict error:nil];
                    [downArray addObject:model];
                }
                
            }else{
                NSMutableArray * muArray = obj;
                NSDictionary * muDict = muArray[0];
                NSArray * array = muDict[@"context"];
                for(int i=0;i<array.count;i++){
                    
                    BatarResultModel * model = [[BatarResultModel alloc]init];
                    model.name = array[i][@"name"];
                    model.number = array[i][@"number"];
                    model.image = array[i][@"img"];
                    [downArray addObject:model];
                }
            }
            [self.dataArray addObjectsFromArray:downArray];
            if(self.dataArray.count==0){
                [self showAlertViewWithTitle:@"未搜到任何产品信息!"];
                [self.tableView headerEndRefreshing];
                return;
            }
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
        }else{
            
            NSLog(@"%@",error.description);
        }
    }];
}
/*
 -(void)createData{
 
 NetManager * manager = [NetManager shareManager];
 NSString * URLstring = [NSString stringWithFormat:SEARCHURL,[manager getIPAddress]];
 self.param = [self.param stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
 NSString * str = [NSString stringWithFormat:@"%@?key=%@&",URLstring,self.param];
 NSString * pageStr = [NSString stringWithFormat:@"%zi",page];
 NSString * urlStr = [NSString stringWithFormat:@"%@page=%@&size=%@",str,pageStr,@"100"];
 [manager downloadDataWithUrl:urlStr parm:nil callback:^(id responseObject, NSError *error) {
 NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
 NSArray * array = dict[@"page"];
 if(page == 0){
 [self.dataArray removeAllObjects];
 }
 for(NSDictionary * dict in array){
 BatarResultModel * model = [[BatarResultModel alloc]initWithDictionary:dict error:nil];
 [self.dataArray addObject:model];
 }
 [_tableView reloadData];
 [_tableView headerEndRefreshing];
 [_tableView footerEndRefreshing];
 }];
 }
 */

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MySelectedOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:CODERCELL];
    if(cell == nil){
        cell = [[MySelectedOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CODERCELL];
    }
    
    BatarResultModel * model = self.dataArray[indexPath.row];
    [cell configResultCellWithModel:model];
    cell.select_btn.hidden = YES;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102.5*S6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DetailViewController * detailVc = [[DetailViewController alloc]initWithController:self];
    detailVc.index = self.dataArray[indexPath.row].number;
    [self pushToViewControllerWithTransition:detailVc withDirection:@"left" type:NO];
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentIndexPath = indexPath;
}

-(void)headerAction{
    
    if(self.initialDataArray.count>0){
        
        [self getInitialData];
        [self.tableView reloadData];
        [self changeScrollPosition];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [self.initialDataArray removeAllObjects];
        return;
    }
    page = 0;
    [self createData];
}

#pragma mark - 改变偏移位置
-(void)changeScrollPosition{
    
    //    if(self.currentIndexPath.row%2){
    //        self.indexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row+6 inSection:self.currentIndexPath.section];
    //    }else{
    //        self.indexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row/2 inSection:self.currentIndexPath.section];
    //    }
    //    [_tableView scrollToRowAtIndexPath:self.indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

-(void)getInitialData{
    
    [self.dataArray removeAllObjects];
    for(RecommandImageModel * initialModel in self.initialDataArray){
        BatarResultModel * model = [[BatarResultModel alloc]init];
        model.number = initialModel.number;
        model.name = initialModel.name;
        model.image = initialModel.img;
        [self.dataArray addObject:model];
    }
}

-(void)footerAction{
    page ++;
    [self createData];
}

-(void)back{
    [self popToViewControllerWithDirection:@"right" type:NO];
}

-(NSMutableArray *)dataArray{
    
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
