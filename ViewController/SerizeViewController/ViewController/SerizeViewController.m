
//
//  SerizeViewController.m
//  DianZTC
//
//  Created by 杨力 on 6/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "SerizeViewController.h"
#import "CatagoryViewController.h"
#import "SerizesCell.h"
#import "NetManager.h"
#import "SerizeModel.h"
#import "ThemeViewController.h"
#import "LoginViewController.h"
#import "MyViewController.h"
#import "SearchViewController.h"

//系列Cell
#define xilieCell @"xilieCell"

@interface SerizeViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

//导航条返回按钮
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIButton * catagoryButton1;
@property (nonatomic,strong) UIView * addView;
@property (nonatomic,strong) UITextField *searchTextField1;
@property (nonatomic,strong) UIButton * exitBtn;

//表格属性
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;


//适配工具
@property (nonatomic,assign) CGFloat max_X;
@property (nonatomic,assign) CGFloat max_Y;

@end

@implementation SerizeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.catagoryButton1.hidden = NO;
    self.searchTextField1.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.catagoryButton1.hidden = YES;
    self.searchTextField1.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏系统本身的“back”导航按钮
    self.navigationItem.hidesBackButton = YES;
    [self configUI];
}

-(void)configUI{
    
    self.view.backgroundColor = TABLEVIEWCOLOR;
    
    //导航条设置
    self.catagoryButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.catagoryButton1 setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    if(IS_IPHONE == IS_IPHONE_6||IS_IPHONE == IS_IPHONE_6P){
        
        self.catagoryButton1.frame = CGRectMake(31/2.0*S6, 20.5/2*S6, 49/2.0*S6, 22.5*S6);
    }else{
        self.catagoryButton1.frame = CGRectMake(31/2.0*S6, 22/2*S6, 49/2.0*S6, 22.5*S6);
    }
    
    [self.navigationController.navigationBar addSubview:self.catagoryButton1];
    [self.catagoryButton1 addTarget:self action:@selector(backToFirstViewController) forControlEvents:UIControlEventTouchUpInside];
    [self createTextfield];
    //导航条标题
//    self.titleLabel = [Tools createLabelWithFrame:CGRectMake(10, 10, 100*S6, 20*S6) textContent:@"系列产品" withFont:[UIFont systemFontOfSize:17*S6] textColor:RGB_COLOR(0, 0, 0, 1) textAlignment:NSTextAlignmentCenter];
//    self.navigationItem.titleView = self.titleLabel;
    
    //设置“分类”和“系列”
    if(self.pushFlag == 0){
        [kUserDefaults setObject:SHOWMENUE forKey:SHOWMENUE];
        [self setCatagoryAndSerize];
    }else{
        [kUserDefaults removeObjectForKey:SHOWMENUE];
    }
    
    //设置表格
    [self configTableView];
    
    //获取数据
    [self createData];
}

-(void)createTextfield{
    
    CGFloat tf_Y;
    if(IS_IPHONE == IS_IPHONE_5||IS_IPHONE == IS_IPHONE_4_OR_LESS){
        tf_Y = 62/2.0;
    }else if(IS_IPHONE == IS_IPHONE_6){
        tf_Y = 57/2.0;
    }else if (IS_IPHONE == IS_IPHONE_6P){
        tf_Y = 53/2.0;
    }
    self.searchTextField1 = [[UITextField alloc]initWithFrame:CGRectMake((33+49+33)/2.0*S6, 8.0*S6, 290*S6, tf_Y*S6)];
    self.searchTextField1.backgroundColor = [UIColor whiteColor];
    self.searchTextField1.layer.cornerRadius = 5*S6;
    self.searchTextField1.clipsToBounds = YES;
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,10*S6 , 55/2.0*S6)];
    self.searchTextField1.leftView = leftView;
    
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,25.5*S6,55/2.0*S6)];
    UIImageView * rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,6.5*S6, 15.5*S6, 15*S6)];
    rightImg.image = [UIImage imageNamed:@"search_btn"];
    [rightView addSubview:rightImg];
    
    self.searchTextField1.rightView = rightView;
    self.searchTextField1.rightViewMode = UITextFieldViewModeAlways;
    
    self.searchTextField1.delegate = self;
    self.searchTextField1.leftViewMode =UITextFieldViewModeAlways;
    self.searchTextField1.placeholder = @"输入您想要的宝贝";
    [self.navigationController.navigationBar addSubview:self.searchTextField1];
    
    //改变输入框placeholder的字体大小和颜色
    [self.searchTextField1 setValue:RGB_COLOR(153, 153, 153, 1) forKeyPath:@"_placeholderLabel.textColor"];
    self.searchTextField1.font = [UIFont systemFontOfSize:14*S6];
    //改变输入框输入时字体的颜色
    self.searchTextField1.textColor = RGB_COLOR(153, 153, 153, 1);
    self.searchTextField1.font = [UIFont systemFontOfSize:14*S6];
    self.searchTextField1.layer.borderWidth = 1.0*S6;
    self.searchTextField1.layer.borderColor = [RGB_COLOR(76, 66, 41, 1)CGColor];
    
    //添加搜索按钮
//    self.exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25*S6, 30*S6)];
//    UITapGestureRecognizer * taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(outAction)];
//    [searchView addGestureRecognizer:taps];
//    
//    CGFloat height;
//    if(IS_IPHONE == IS_IPHONE_6){
//        height = 5.0*S6;
//    }else if (IS_IPHONE == IS_IPHONE_6P){
//        height = 6.0*S6;
//    }else if (IS_IPHONE == IS_IPHONE_5){
//        height = 2*S6;
//    }
//    self.exitBtn.frame = CGRectMake(5*S6,height, 19*S6, 41/2.0*S6);
//    [self.exitBtn setImage:[UIImage imageNamed:@"mine"] forState:UIControlStateNormal];
//    [self.exitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    [searchView addSubview:self.exitBtn];
//    UIBarButtonItem * searBarBtn = [[UIBarButtonItem alloc]initWithCustomView:searchView];
//    self.navigationItem.rightBarButtonItem = searBarBtn;
//    [self.exitBtn addTarget:self action:@selector(outAction) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self searchVc];
    [textField resignFirstResponder];
    return YES;
}

-(void)searchVc{
    
    SearchViewController * searchVc = [[SearchViewController alloc]init];
    searchVc.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:searchVc animated:NO];
}

//-(void)outAction{
//    
//    MyViewController * myVc = [[MyViewController alloc]init];
//        MyViewController.hidesBottomBarWhenPushed = NO;
//    [self pushToViewControllerWithTransition:myVc withDirection:@"left" type:NO];
//}

#pragma mark - 获取数据
-(void)createData{
    
    self.dataArray = [NSMutableArray array];
    
    [self.hud show:YES];
    
    NetManager * manager = [NetManager shareManager];
    NSString * URLstring = [NSString stringWithFormat:SERIZEURL,[manager getIPAddress]];
    [manager downloadDataWithUrl:URLstring parm:nil callback:^(id responseObject, NSError *error) {
        
       
        if(error == nil){
             [self.hud hide:YES];
            NSArray * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            for(NSDictionary * dict in array){
                
                SerizeModel * model = [[SerizeModel alloc]initWithDictionary:dict error:nil];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
    }];
}

//设置“分类”和“系列”
-(void)setCatagoryAndSerize{
    
    //分类
    UIView * catagoryBgView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, 375/2.0*S6, 40*S6)];
    catagoryBgView.backgroundColor = [UIColor whiteColor];
    //给catagoryBgView添加手势，跳转到分类界面
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToCatagory)];
    [catagoryBgView addGestureRecognizer:tap];
    [self.view addSubview:catagoryBgView];
    UIImageView * catagoryImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"catagory_select"]];
    catagoryImageView.frame = CGRectMake(66*S6, 13*S6+NAV_BAR_HEIGHT, 35/2.0*S6, 15*S6);
    [self.view addSubview:catagoryImageView];
    
    self.max_X = CGRectGetMaxX(catagoryImageView.frame);
    self.max_Y = CGRectGetMinY(catagoryImageView.frame);
    
    UILabel * fenleiLabel = [Tools createLabelWithFrame:CGRectMake(self.max_X+10*S6, self.max_Y, 80, 15*S6) textContent:@"分类" withFont:[UIFont systemFontOfSize:16*S6] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:fenleiLabel];
    
    //系列
    UIView * serizeBgView = [[UIView alloc]initWithFrame:CGRectMake(375/2.0*S6, NAV_BAR_HEIGHT, 375/2.0*S6, 40*S6)];
    serizeBgView.backgroundColor = THEMECOLORS;
    [self.view addSubview:serizeBgView];
    
    UIImageView * serizeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(66*S6, 13*S6, 35/2.0*S6, 16*S6)];
    serizeImageView.image = [UIImage imageNamed:@"serize_select"];
    [serizeBgView addSubview:serizeImageView];
    
    self.max_X = CGRectGetMaxX(serizeImageView.frame);
    self.max_Y = CGRectGetMinY(serizeImageView.frame);
    UILabel * serizeLabel = [Tools createLabelWithFrame:CGRectMake(self.max_X+10*S6, self.max_Y, 80, 15*S6) textContent:@"系列" withFont:[UIFont systemFontOfSize:15*S6] textColor:RGB_COLOR(255, 255, 255, 1) textAlignment:NSTextAlignmentLeft];
    [serizeBgView addSubview:serizeLabel];
    
    //获取serizeBgView的底部frame
    self.max_Y = CGRectGetMaxY(serizeBgView.frame);
}

//设置“分类”和“系列”
-(void)configTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.max_Y+10*S6,Wscreen, (Hscreen - self.max_Y - 10*S6))];
    if(self.pushFlag != 0){
        self.tableView.y = self.max_Y;
    }
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SerizesCell class] forCellReuseIdentifier:xilieCell];
}

//表格的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SerizesCell * cell = [tableView dequeueReusableCellWithIdentifier:xilieCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil){
        cell = [[SerizesCell alloc]init];
    }
    
    if(self.dataArray.count > 0){
        
        SerizeModel * model = [self.dataArray objectAtIndex:indexPath.section];
        cell.model = model;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (20+165)/2.0*S6;
}

//建立组头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44*S6)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    SerizeModel * model = [self.dataArray objectAtIndex:section];
    
    //设置标题Label
    UILabel * titleLabel = [Tools createLabelWithFrame:CGRectMake(14*S6,10, 100, 10) textContent:model.name withFont:[UIFont systemFontOfSize:16*S6] textColor:RGB_COLOR(0, 0, 0, 1) textAlignment:NSTextAlignmentCenter];
    [titleLabel sizeToFit];
//    titleLabel.center = headerView.center;
    titleLabel.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:titleLabel];
    
    //设置两边的圈圈
//    self.max_X = CGRectGetMinX(titleLabel.frame);
//    self.max_Y = CGRectGetMinY(titleLabel.frame);
//    UIImageView * leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.max_X-15*S6,self.max_Y+6.5*S6 , 5*S6, 5*S6)];
//    leftImageView.image = [UIImage imageNamed:@"quan"];
//    [headerView addSubview:leftImageView];
//    
//    self.max_X = CGRectGetMaxX(titleLabel.frame);
//    [Tools createImageViewWithFrame:CGRectMake(self.max_X+10*S6, self.max_Y+6.5*S6, 5*S6, 5*S6) imageName:@"quan" View:headerView];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44*S6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SerizeModel * model = [self.dataArray objectAtIndex:indexPath.section];
    ThemeViewController * themeVc = [[ThemeViewController alloc]init];
    themeVc.themeTitle = model.name;
    themeVc.indexParm = model.seriesid;
//    NSLog(@"%@",model.seriesindex);
    themeVc.fromVc = 1;
    [self.navigationController pushViewController:themeVc animated:YES];
}

//返回主页
-(void)backToFirstViewController{
    
    [self popToViewControllerWithDirection:@"right" type:NO];
}
//返回上一个分类界面
-(void)backToCatagory{

    CatagoryViewController * catagoryVc = [[CatagoryViewController alloc]initWithController:self];
    catagoryVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:catagoryVc animated:NO];
    [self removeNaviPushedController:self];
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
