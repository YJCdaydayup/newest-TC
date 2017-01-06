//
//  SearchCatagoryViewController.m
//  DianZTC
//
//  Created by 杨力 on 6/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "SearchCatagoryViewController.h"
#import "CatagoryViewController.h"
#import "MutileSearchCell.h"
#import "NetManager.h"
#import "SearchCatagoryModel.h"
#import "SingleSearchCatagoryViewController.h"

//多类搜索Cell
#define mutileCell @"mutileCell"

@interface SearchCatagoryViewController ()<UITableViewDataSource,UITableViewDelegate>

//左导航按钮
@property (nonatomic,strong) UIButton * navLeftButton;
//导航栏标题
@property (nonatomic,strong) UILabel * titlelabel;

//表格属性
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

//连接cell中的三个图片
@property (nonatomic,strong) UIImageView * imageView1;
@property (nonatomic,strong) UIImageView * imageView2;
@property (nonatomic,strong) UIImageView * imageView3;

//适配工具
@property (nonatomic,assign) CGFloat max_X;
@property (nonatomic,assign) CGFloat max_Y;

@end

@implementation SearchCatagoryViewController

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
   
//    隐藏系统“back”左导航按钮
    self.navigationItem.hidesBackButton = YES;
    
    [self configUI];
    
    //设置表格
    [self configTableView];
    
    //加载数据
    [self createData];
}

-(void)createData{
    
    self.dataArray = [NSMutableArray array];
    
    [self.hud show:YES];
    
    NetManager * manager = [NetManager shareManager];
    NSString * URLstring = [NSString stringWithFormat:CATAGORYURL,[manager getIPAddress]];
    [manager downloadDataWithUrl:URLstring parm:self.parmDict callback:^(id responseObject, NSError *error) {
       
       
        if(error == nil){
             [self.hud hide:YES];
            NSArray * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            for(int i=0;i<array.count;i++){
                
                SearchCatagoryModel * model = [[SearchCatagoryModel alloc]initWithDictionary:array[i] error:nil];
                [self.dataArray addObject:model];
            }
            
            [self.tableView reloadData];
        }else{
            NSLog(@"%@",error.description);
        }
    }];
}

-(void)configUI{
    
    //导航条设置
    self.navLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navLeftButton setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    if(IS_IPHONE == IS_IPHONE_6||IS_IPHONE == IS_IPHONE_6P){
        
        self.navLeftButton.frame = CGRectMake(31/2.0*S6, 20.5/2*S6, 49/2.0*S6, 22.5*S6);
    }else{
        self.navLeftButton.frame = CGRectMake(31/2.0*S6, 22/2*S6, 49/2.0*S6, 22.5*S6);
    }
    
    [self.navigationController.navigationBar addSubview:self.navLeftButton];
    [self.navLeftButton addTarget:self action:@selector(backToFirstViewController) forControlEvents:UIControlEventTouchUpInside];
    
    //导航条标题
    self.titlelabel = [Tools createLabelWithFrame:CGRectMake(10, 10, 100*S6, 20*S6) textContent:@"分类多选搜索"
                                         withFont:[UIFont systemFontOfSize:17*S6] textColor:RGB_COLOR(0, 0, 0, 1) textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = self.titlelabel;
    
}

-(void)configTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, Hscreen)];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TABLEVIEWCOLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[MutileSearchCell class] forCellReuseIdentifier:mutileCell];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.pinleiArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MutileSearchCell * cell = [tableView dequeueReusableCellWithIdentifier:mutileCell];
    if(cell == nil){
        
        cell = [[MutileSearchCell alloc]init];
    }
    
    if(self.dataArray.count > 0){
        SearchCatagoryModel * model = [self.dataArray objectAtIndex:indexPath.section];
        cell.model = model;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (20+165+18+20)/2.0*S6;
}

#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SingleSearchCatagoryViewController * singleVc = [[SingleSearchCatagoryViewController alloc]initWithController:self];
    singleVc.vc_flag = 0;
    singleVc.catagoryItem = self.pinleiArray[indexPath.section];
    NSMutableDictionary * muDict = [self dictionaryWithJsonString:[self.parmDict objectForKey:@"parm"]];
    NSInteger row = indexPath.row + 1;
    NSNumber * rowStr = @(row);
    NSArray * array = [[NSArray alloc]initWithObjects:rowStr, nil];
    [muDict setObject:array forKey:@"category"];
    singleVc.parmDict = muDict;
    [self.navigationController pushViewController:singleVc animated:YES];
}

//组头设置
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 77/2.0*S6)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [Tools createLabelWithFrame:CGRectMake(35/2.0*S6, 15*S6, 100, 27/2.0*S6) textContent:self.pinleiArray[section] withFont:[UIFont systemFontOfSize:14*S6] textColor:NAVICOLOR textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:titleLabel];
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 77/2.0*S6;
}
//返回到上一个界面
-(void)backToFirstViewController{
    
//    FirstViewController * firstVc = [[FirstViewController alloc]init];
    
    CATransition * animation = [CATransition animation];
    animation.type = kCATransitionReveal;
    animation.duration = 0.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:animation forKey:@"123"];
    [self.navigationController popViewControllerAnimated:NO];
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
