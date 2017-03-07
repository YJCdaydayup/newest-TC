//
//  FirstViewController.m
//  DianZTC
//
//  Created by 杨力 on 4/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "FirstViewController.h"
#import "CatagoryViewController.h"
#import "DetailViewController.h"
#import "ThemeViewController.h"
#import "SerizeCell.h"
#import "ProductCell.h"
#import "NetManager.h"
#import "BatarCommandModel.h"
#import "BatarCommandSubModel.h"
#import "SerizeViewController.h"
#import "SingleSearchCatagoryViewController.h"
#import "MyViewController.h"
#import "WebViewController.h"
#import "YLOrderControlView.h"
#import "YLVoicemanagerView.h"
#import "SearchViewController.h"
#import "YLLocationManager.h"
#import "ScanViewController.h"
#import "BannerModel.h"
#import "MJRefresh.h"

#define serizeCell @"serizeCell"
#define productCell @"productCell"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SDCycleScrollViewDelegate>{
    
    UIImageView * placeHolderImageView;
    NSDictionary * bottomDict; //底部数据模型
    NSMutableArray * tuiGuangArr;//中部的菜单推广数据
}

//导航栏搜索输入框
@property (nonatomic,strong) UITextField * searchTextField;

//表格属性
@property (nonatomic,strong) UITableView * tableView;
//@property (nonatomic,strong) NSMutableArray *popurityArray;
//@property (nonatomic,strong) NSMutableArray * newestArray;

//轮播图
@property (nonatomic,strong) SDCycleScrollView * cycleScrollView;
@property (nonatomic,strong) NSMutableArray * bannerArray;

//Logo的View
@property (nonatomic,strong) UIView * logoView;

//导航条底部的线
@property (nonatomic,strong) UIView * bottomLine;

//适配工具
@property (nonatomic,assign) CGFloat max_X;
@property (nonatomic,assign) CGFloat max_Y;

@property (nonatomic,strong) NetManager * manager;
@property (nonatomic,strong) NSMutableArray<BatarCommandModel *> * dataArray;

@end

@implementation FirstViewController

@synthesize manager = manager;

//界面即将消失时
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.searchTextField resignFirstResponder];
    self.searchTextField.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //导航条设置
    [self setNavigation];
    [self.searchTextField resignFirstResponder];
    self.searchTextField.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    manager = [NetManager shareManager];
    
    //隐藏系统的“返回导航按钮”
    self.navigationItem.hidesBackButton = YES;
    
    //请求分类搜索界面的数据
    [self downloadCatagory];
    
    //设置表格frame
    [self setTableView];
}

//刷新界面
-(void)updateView{
    
    [self viewDidLoad];
}

//设置表格frame
-(void)setTableView{
    
    UIImage * gifImage = [UIImage imageNamed:BANNERPLACEHOLDER];
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0*S6,Wscreen,150*S6) delegate:self placeholderImage:gifImage];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.cycleScrollView.currentPageDotColor = RGB_COLOR(215, 185, 29, 0.5); // 自定义分页控件小圆标颜色
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"lb1"];
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"lb2"];
    self.cycleScrollView.pageDotColor = RGB_COLOR(221, 193, 191,0.5);
    self.cycleScrollView.pageControlDotSize = CGSizeMake(8*S6,8*S6);
    self.cycleScrollView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,NAV_BAR_HEIGHT, Wscreen, Hscreen-NAV_BAR_HEIGHT-TABBAR_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = TABLEVIEWCOLOR;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[SerizeCell class] forCellReuseIdentifier:serizeCell];
    [self.tableView registerClass:[ProductCell class] forCellReuseIdentifier:productCell];
    [self.tableView addHeaderWithTarget:self action:@selector(headerAction)];
    self.tableView.tableHeaderView = self.cycleScrollView;
    [self.tableView headerBeginRefreshing];
}

-(void)headerAction{
    [self reloadView];
}

-(void)reloadView{
    
    //请求轮播图url
    [self getMenueInfo];
    [self downloadBanner];
}

-(void)getMenueInfo{
    
    NSString * urlStr = [NSString stringWithFormat:TUIGUANGINFO,[manager getIPAddress]];
    [manager downloadDataWithUrl:urlStr parm:nil callback:^(id responseObject, NSError *error) {
        
        if(error==nil){
            
            NSMutableArray * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            tuiGuangArr = [NSMutableArray array];
            for(NSDictionary * dict in array){
                
                BannerModel * model = [[BannerModel alloc]initWithDictionary:dict error:nil];
                [tuiGuangArr addObject:model];
                [self.tableView reloadData];
                [self.tableView headerEndRefreshing];
            }
        }else{
            NSLog(@"%@",error.description);
        }
    }];
    
    
    [self downloadNewestData];
    //    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)downloadNewestData{
    //拼接ip和port
    [self.dataArray removeAllObjects];
    NSString * URLstring = [NSString stringWithFormat:Batar_TUIJIAN,[manager getIPAddress]];
    [manager downloadDataWithUrl:URLstring parm:nil callback:^(id responseObject, NSError *error) {
        
        if(error == nil){
            NSMutableArray * muArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:Nil];
            for(NSDictionary * dict in muArray){
                
                NSMutableArray * array2 = [NSMutableArray array];
                NSArray * subArray = dict[@"products"];
                for(NSDictionary * subDict in subArray){
                    BatarCommandSubModel * subModel = [[BatarCommandSubModel alloc]initWithDictionary:subDict error:nil];
                    [array2 addObject:subModel];
                }
                BatarCommandModel * model = [[BatarCommandModel alloc]init];
                model.kid = dict[@"id"];
                model.products = array2;
                model.themename = dict[@"themename"];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
        }
        
    }];
}

#pragma mark -轮播图加载
-(void)downloadBanner{
    
    [self createBannerPlaceImage];
    
    self.bannerArray = [NSMutableArray array];
    //拼接ip和port
    NSString * URLstring = [NSString stringWithFormat:BANNERURL,[manager getIPAddress]];
    
    [manager downloadDataWithUrl:URLstring parm:nil callback:^(id responseObject, NSError *error) {
        
        if(error == nil){
            self.tableView.frame = CGRectMake(0, NAV_BAR_HEIGHT, Wscreen, Hscreen-NAV_BAR_HEIGHT-TABBAR_HEIGHT);
            [placeHolderImageView removeFromSuperview];
            
            NSArray * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            for(int i=0;i<array.count;i++){
                BannerModel * model = [[BannerModel alloc]initWithDictionary:array[i] error:nil];
                [self.bannerArray addObject:model];
            }
            
            NSMutableArray * imagesURLStrings = [NSMutableArray array];
            for(int i=0;i<self.bannerArray.count;i++){
                
                BannerModel * model = [self.bannerArray objectAtIndex:i];
                //拼接ip和port
                NSString * URLstring = [NSString stringWithFormat:NEWBANNERCONNET,[manager getIPAddress]];
                [imagesURLStrings addObject:[NSString stringWithFormat:@"%@%@",URLstring,model.img]];
            }
            self.cycleScrollView.imageURLStringsGroup = imagesURLStrings
            ;
        }
    }];
}

#pragma mark - 填充轮播默认图片
-(void)createBannerPlaceImage{
    
    //    self.tableView.frame = CGRectMake(0, NAV_BAR_HEIGHT+150*S6, Wscreen, Hscreen-NAV_BAR_HEIGHT-150*S6);
    //    placeHolderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, Wscreen, 150)];
    //    placeHolderImageView.image = [UIImage sd_animatedGIFNamed:@"move"];
    //    placeHolderImageView.contentMode = UIViewContentModeCenter;
    //    [self.view addSubview:placeHolderImageView];
}

#pragma mark -请求分类搜索界面的数据
-(void)downloadCatagory{
    
    [manager downloadCatagoryData];
    //请求广告页参数数据，并缓存在本地
    [manager bt_saveAdvertiseInfo];
}

//导航条设置
-(void)setNavigation{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //在导航条下面加一根线
    self.bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0,NAV_BAR_HEIGHT-20-1*S6, Wscreen, 1*S6)];
    self.bottomLine.backgroundColor = RGB_COLOR(204, 204, 204, 1);
    [self.navigationController.navigationBar addSubview:self.bottomLine];
    
    [self batar_setLeftNavButton:@[@"scan",@"search_type"] target:self selector:@selector(pushScanVc) size:CGSizeMake(25*S6, 30*S6) selector:@selector(goCatagoryVc) rightSize:CGSizeMake(33*S6,30*S6) topHeight:7*S6];
    
    [self createTextfield];
    
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
    self.searchTextField = [[UITextField alloc]initWithFrame:CGRectMake((33+49+33)/2.0*S6, 8.0*S6, 262.5*S6, tf_Y*S6)];
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.layer.cornerRadius = 5*S6;
    self.searchTextField.clipsToBounds = YES;
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,10*S6 , 55/2.0*S6)];
    self.searchTextField.leftView = leftView;
    
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,25.5*S6,55/2.0*S6)];
    UIImageView * rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,6.5*S6, 15.5*S6, 15*S6)];
    rightImg.image = [UIImage imageNamed:@"search_btn"];
    [rightView addSubview:rightImg];
    
    self.searchTextField.rightView = rightView;
    self.searchTextField.rightViewMode = UITextFieldViewModeAlways;
    
    self.searchTextField.delegate = self;
    self.searchTextField.leftViewMode =UITextFieldViewModeAlways;
    self.searchTextField.placeholder = @"黄金珠宝";
    [self.navigationController.navigationBar addSubview:self.searchTextField];
    
    //改变输入框placeholder的字体大小和颜色
    [self.searchTextField setValue:RGB_COLOR(153, 153, 153, 1) forKeyPath:@"_placeholderLabel.textColor"];
    self.searchTextField.font = [UIFont systemFontOfSize:14*S6];
    //改变输入框输入时字体的颜色
    self.searchTextField.textColor = RGB_COLOR(153, 153, 153, 1);
    self.searchTextField.font = [UIFont systemFontOfSize:14*S6];
    self.searchTextField.layer.borderWidth = 1.0*S6;
    self.searchTextField.layer.borderColor = [RGB_COLOR(76, 66, 41, 1)CGColor];
}

#pragma mark - 开始搜索
-(void)searchVc{
    
    SearchViewController * searchVc = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVc animated:NO];
}

-(void)goCatagoryVc{
    
    CatagoryViewController * catagoryVc = [[CatagoryViewController alloc]initWithController:self];
    catagoryVc.hidesBottomBarWhenPushed = YES;
    [self pushToViewControllerWithTransition:catagoryVc withDirection:@"left" type:NO];
    self.hidesBottomBarWhenPushed = NO;
}

//表格的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        SerizeCell * cell = [tableView dequeueReusableCellWithIdentifier:serizeCell];
        if(cell == nil){
            
            cell = [[SerizeCell alloc]init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(tuiGuangArr.count>0){
            [cell setImageViewWithArray:tuiGuangArr];
        }
        [cell clickImageWithBlock:^(NSInteger index) {
            BannerModel * model = tuiGuangArr[index];
            if(model.actionname.length==0){
                [self showAlertViewWithTitle:@"未找到数据"];
                return ;
            }
            
            if([model.type integerValue] == 1){
//                RECOMMANDCLICK
                SingleSearchCatagoryViewController * singeVc = [[SingleSearchCatagoryViewController alloc]initWithController:self];
                singeVc.catagoryItem = model.actionname;
                [self pushToViewControllerWithTransition:singeVc withDirection:@"right" type:NO];
            }else{
            
                ThemeViewController * themeVc = [[ThemeViewController alloc]init];
                themeVc.indexParm = model.actionname;
                themeVc.themeTitle = model.actionaliasname;
                [self pushToViewControllerWithTransition:themeVc withDirection:@"right" type:NO];
            }
        }];
        return cell;
        
    }else{
        
        ProductCell * cell = [tableView dequeueReusableCellWithIdentifier:productCell];
        if(cell == nil){
            cell = [[ProductCell alloc]init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.dataArray.count > 0){
            
            NSMutableArray * array = self.dataArray[indexPath.row].products;
            [cell setImageView:array];
            [cell clickImageForDetai:^(NSInteger index) {
                
                //                NSLog(@"%zi",index);
                DetailViewController * detailVc = [[DetailViewController alloc]initWithController:self];
                detailVc.index = self.dataArray[indexPath.row].products[index].number;
                [self pushToViewControllerWithTransition:detailVc withDirection:@"right" type:NO];
            }];
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0)
    {
        if(tuiGuangArr.count<8&&tuiGuangArr.count>0){
            return 95*S6;
        }else if(tuiGuangArr.count == 8){
            return 170*S6;
        }else{
            return 0;
        }
    }else{
        
        NSInteger count = self.dataArray[indexPath.row].products.count;
        if(count%2==0){
            return (175*count/2.0+5)*S6;
        }else{
            return (175*(count+1)/2.0+5)*S6;
        }
    }
}

//组头设置
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 46*S6)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [Tools createLabelWithFrame:CGRectMake(0, 0, view.width, view.height) textContent:[NSString stringWithFormat:@"———— %@ ————",self.dataArray[section-1].themename] withFont:[UIFont systemFontOfSize:15*S6] textColor:TABBARTEXTCOLOR textAlignment:NSTextAlignmentCenter];
    [view addSubview:label];
    
    UIButton * moreBtn = [Tools createButtonNormalImage:@"more_btns" selectedImage:nil tag:section-1 addTarget:self action:@selector(moreAction:)];
    moreBtn.frame = CGRectMake(Wscreen-93/2.0*S6, 15*S6, 40*S6, 18*S6);
    [view addSubview:moreBtn];
    return view;
}

#pragma mark - “more”按钮事件
-(void)moreAction:(UIButton *)btn{
    
    SingleSearchCatagoryViewController * singleVc = [[SingleSearchCatagoryViewController alloc]initWithController:self];
    singleVc.vc_flag = 3;
    singleVc.catagoryItem = self.dataArray[btn.tag].kid;
    [self pushToViewControllerWithTransition:singleVc withDirection:@"left" type:NO];
}

-(UILabel *)createMore:(UIView *)view selector:(SEL)selector{
    
    UILabel * moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.max_X+469/2.0*S6,15*S6,Wscreen-self.max_X-469/2.0*S6-5*S6, 15*S6)];
    moreLabel.text = @"more>";
    moreLabel.textAlignment = NSTextAlignmentRight;
    moreLabel.textColor = RGB_COLOR(136, 136, 136, 1);
    moreLabel.font = [UIFont systemFontOfSize:14*S6];
    moreLabel.userInteractionEnabled = YES;
    [view addSubview:moreLabel];
    return moreLabel;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section != 0){
        return 46*S6;
    }
    else{
        return 0.0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//跳回详细分类界面
-(void)pushScanVc{
    
    ScanViewController * scanVc = [[ScanViewController alloc]initWithController:self];
    scanVc.hidesBottomBarWhenPushed = YES;
    [self pushToViewControllerWithTransition:scanVc withDirection:@"left" type:NO];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark -轮播图的代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    BannerModel * model = self.bannerArray[index];
    DetailViewController * detailVc = [[DetailViewController alloc]init];
    NSDictionary * dict = model.action;
    //    NSLog(@"%@",dict);
    detailVc.index = dict[@"link"];
    NSNumber * type = dict[@"type"];
    if( [type intValue]==1){
        
        WebViewController * webView = [[WebViewController alloc]init];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:webView];
        webView.urlString = dict[@"link"];
        [self presentViewController:nvc animated:YES completion:nil];
        return;
    }
    [self pushToViewControllerWithTransition:detailVc withDirection:@"left" type:NO];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self searchVc];
    [textField resignFirstResponder];
    return YES;
}

-(NSMutableArray *)dataArray{
    
    if(_dataArray==nil){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
