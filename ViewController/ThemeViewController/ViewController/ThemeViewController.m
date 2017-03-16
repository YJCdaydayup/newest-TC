


//
//  ThemeViewController.m
//  DianZTC
//
//  Created by 杨力 on 9/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "ThemeViewController.h"
#import "FirstViewController.h"
#import "ThemeCell.h"
#import "NetManager.h"
#import "ThemeModel.h"
#import "ThemeDetailModel.h"
#import "DetailViewController.h"
#import "SerizeViewController.h"

#define themeCell @"themeCell"

@interface ThemeViewController ()<UITableViewDataSource,UITableViewDelegate>

//左导航按钮和导航栏标题
@property (nonatomic,strong) UIButton * navLeftButton;
@property (nonatomic,strong) UILabel * titlelabel;

//主题属性
@property (nonatomic,strong) NSMutableArray * themeArray;
@property (nonatomic,strong) UITableView * productTableView;
@property (nonatomic,strong) NSMutableArray * productArray;

//适配工具
@property (nonatomic,assign) CGFloat max_X;
@property (nonatomic,assign) CGFloat max_Y;

//监听按钮是否被剪辑
@property (nonatomic,assign) BOOL isClicked;

@end

@implementation ThemeViewController

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
    
    //界面设置
    [self configUI];
    //设置主题表格
    [self setProductTableView1];
    //请求数据
    [self createData];
}

-(void)createData{
    
    [self.hud show:YES];
    NetManager * manager = [NetManager shareManager];
    NSString * URLstring = [NSString stringWithFormat:MERRYURL,[manager getIPAddress]];
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",URLstring,self.indexParm];
    [manager downloadDataWithUrl:urlStr parm:nil callback:^(id responseObject, NSError *error) {
        
        if(error == nil){
            [self.hud hide:YES];
            NSArray * dataArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            for(int i=0;i<dataArray.count;i++){
                
                NSDictionary * dataDict = dataArray[i];
                
                ThemeModel * model = [[ThemeModel alloc]init];
                model.theme = dataDict[@"theme"];
                
                NSArray * array = dataDict[@"context"];
                NSMutableArray * detailArray = [NSMutableArray array];
                for(int i=0;i<array.count;i++){
                    
                    ThemeDetailModel * model = [[ThemeDetailModel alloc]initWithDictionary:array[i] error:nil];
                    [detailArray addObject:model];
                }
                model.context = detailArray;
                
                [self.themeArray addObject:model];
            }
            
            [self setThemeButton];
            [self.productTableView reloadData];
        }
    }];
}

-(void)configUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    self.titlelabel = [Tools createLabelWithFrame:CGRectMake(10, 10, 100*S6, 20*S6) textContent:self.themeTitle
                                         withFont:[UIFont systemFontOfSize:18*S6] textColor:RGB_COLOR(0, 0, 0, 1) textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = self.titlelabel;
    NSLog(@"%@",self.themeTitle);
}

//设置主题表格
-(void)setThemeButton{
    
    for(int i = 0;i<self.themeArray.count;i++){
        
        ThemeModel * model = self.themeArray[i];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, NAV_BAR_HEIGHT+i*41*S6+0.3*S6, 96*S6, 40*S6);//
        [button setTitle:model.theme forState:UIControlStateNormal];
        [button setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderColor = [RGB_COLOR(227, 227, 227, 1)CGColor];
        button.layer.borderWidth = 0.3f*S6;
        button.titleLabel.font = [UIFont systemFontOfSize:15*S6];
        button.titleLabel.numberOfLines = 0;
        [self.view addSubview:button];
        
        if(i == 0){
            
            button.selected = YES;
            button.backgroundColor = THEMECOLORS;
        }
        
        //给予button的tag从100开始
        button.tag = i+100;
        [button addTarget:self action:@selector(changeTheme:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//改变主题
-(void)changeTheme:(UIButton *)button{
    
    self.isClicked = YES;
    for(int i = 0;i<self.themeArray.count;i++){
        
        UIButton * button = (UIButton *)[self.view viewWithTag:100+i];
        button.selected = NO;
        button.backgroundColor = [UIColor whiteColor];
    }
    
    button.selected = YES;
    button.backgroundColor = THEMECOLORS;
    
    //改变表格ProductTableView的偏移位置
    [self.productTableView reloadData];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:button.tag-100];
    
    //防止没数据崩溃
    ThemeModel * model = [self.themeArray objectAtIndex:button.tag-100];
    NSArray * array = model.context;
    if(array.count==0){
        return;
    }
    [self.productTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(void)setProductTableView1{
    
    self.productTableView = [[UITableView alloc]initWithFrame:CGRectMake(96*S6-0.5*S6,0, (220+340)/2.0*S6,Hscreen)];
    self.productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.productTableView.tableFooterView = [[UIView alloc]init];
    self.productTableView.delegate = self;
    self.productTableView.dataSource = self;
    [self.view addSubview:self.productTableView];
    [self.productTableView reloadData];
    
    self.productTableView.layer.borderColor = [RGB_COLOR(227, 227, 227, 1)CGColor];
    self.productTableView.layer.borderWidth = 0.5f*S6;
    [self.productTableView registerClass:[ThemeCell class] forCellReuseIdentifier:themeCell];
}

//表格的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.themeArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ThemeModel * model = [self.themeArray objectAtIndex:section];
    NSArray * array = model.context;
    //每个主题下的种类数量
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ThemeCell * cell = [tableView dequeueReusableCellWithIdentifier:themeCell];
    
    if(cell == nil){
        cell = [[ThemeCell alloc]init];
    }
    
    ThemeModel * model = self.themeArray[indexPath.section];
    NSArray * array = model.context;
    ThemeDetailModel * detailModel = array[indexPath.row];
    cell.model = detailModel;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 165/2.0*S6;
}

//组头设置

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.productTableView.frame.size.width, 30*S6)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 30*S6, headerView.frame.size.width, 1*S6)];
    lineView.backgroundColor = RGB_COLOR(231, 140, 49, 1);
    [headerView addSubview:lineView];
    
    //设置标题Label
    ThemeModel * model = [self.themeArray objectAtIndex:section];
    UILabel * titleLabel = [Tools createLabelWithFrame:CGRectMake(10,10, 100, 10) textContent:model.theme withFont:[UIFont systemFontOfSize:15*S6] textColor:RGB_COLOR(231, 140, 49, 1) textAlignment:NSTextAlignmentCenter];
    [titleLabel sizeToFit];
    titleLabel.center = headerView.center;
    titleLabel.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:titleLabel];
    
    //设置两边的圈圈
    self.max_X = CGRectGetMinX(titleLabel.frame);
    self.max_Y = CGRectGetMinY(titleLabel.frame);
    UIImageView * leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.max_X-15*S6,self.max_Y+6.5*S6 , 5*S6, 5*S6)];
    leftImageView.image = [UIImage imageNamed:@"quan"];
    [headerView addSubview:leftImageView];
    
    self.max_X = CGRectGetMaxX(titleLabel.frame);
    [Tools createImageViewWithFrame:CGRectMake(self.max_X+10*S6, self.max_Y+6.5*S6, 5*S6, 5*S6) imageName:@"quan" View:headerView];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30*S6;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(!self.isClicked){
        //根据偏移量找到是属于表格的哪一个indexPath对象
        NSIndexPath *path =  [self.productTableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
        
        for(int i = 0;i<self.themeArray.count;i++){
            
            UIButton * button = (UIButton *)[self.view viewWithTag:100+i];
            button.selected = NO;
            button.backgroundColor = [UIColor whiteColor];
        }
        
        UIButton * button = (UIButton *)[self.view viewWithTag:100+path.section];
        button.selected = YES;
        button.backgroundColor = THEMECOLORS;
    }
    self.isClicked = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ThemeModel * model = self.themeArray[indexPath.section];
    NSArray * array = model.context;
    ThemeDetailModel * detailModel = array[indexPath.row];
    
    DetailViewController * detailVc = [[DetailViewController alloc]init];
    detailVc.index = detailModel.number;
    detailVc.isFromThemeVc = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}

//返回首页
-(void)backToFirstViewController{
    
    [self popToViewControllerWithDirection:@"right" type:NO];
}

//懒加载
-(NSMutableArray *)themeArray{
    
    if(_themeArray == nil){
        
        _themeArray = [NSMutableArray array];
    }
    
    return _themeArray;
}

-(NSMutableArray *)productArray{
    
    if(_productArray == nil){
        
        _productArray = [NSMutableArray array];
    }
    return _productArray;
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
