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
#import "BannerModel.h"
#import "PopurityModel.h"
#import "SerizeViewController.h"
#import "SingleSearchCatagoryViewController.h"
#import "MyViewController.h"
#import "WebViewController.h"
#import "YLOrderControlView.h"
#import "YLVoicemanagerView.h"
#import "SearchViewController.h"
#import "YLLocationManager.h"

#define serizeCell @"serizeCell"
#define productCell @"productCell"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SDCycleScrollViewDelegate>{
    
    UIImageView * placeHolderImageView;
    NSDictionary * bottomDict; //底部数据模型
    NSMutableArray * tuiGuangArr;//中部的菜单推广数据
}

//导航栏搜索输入框
@property (nonatomic,strong) UITextField * searchTextField;
@property (nonatomic,strong) UIButton * catagoryButton;
@property (nonatomic,strong) UIButton * searchBtn;

//表格属性
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray *popurityArray;
@property (nonatomic,strong) NSMutableArray * newestArray;

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

@end

@implementation FirstViewController

//界面即将消失时
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.catagoryButton.hidden = YES;
    self.searchTextField.hidden = YES;
    self.searchBtn.hidden = YES;
    self.bottomLine.hidden = YES;
    [self.searchTextField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.catagoryButton.hidden = NO;
    self.searchTextField.hidden = NO;
    self.searchBtn.hidden = NO;
    self.bottomLine.hidden = NO;
    [self.searchTextField resignFirstResponder];
}

-(void)reloadView{
    
    //请求轮播图url
    [self downloadBanner];
    
    //请求“人气产品”和“最新产品”数据
    [self downloadNewestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏系统的“返回导航按钮”
    self.navigationItem.hidesBackButton = YES;
    
    //导航条设置
    [self setNavigation];
    
    //请求分类搜索界面的数据
    [self downloadCatagory];
    
    //加载数据
    [self reloadView];
}

#pragma mark -请求“人气产品”和“最新产品”数据
-(void)downloadNewestData{
    
    NetManager * manager = [NetManager shareManager];
    //拼接ip和port
    NSString * URLstring = [NSString stringWithFormat:POPULARITY,[manager getIPAddress]];
    [manager downloadDataWithUrl:URLstring parm:nil callback:^(id responseObject, NSError *error) {
        
        if(error == nil){
            NSMutableArray * downArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            for(int i=0;i<downArray.count;i++){
                
                PopurityModel * model = [[PopurityModel alloc]initWithDictionary:downArray[i] error:nil];
                [self.popurityArray addObject:model];
            }
            [self.tableView reloadData];
            if(downArray.count > 0){
                //拼接ip和port
                NSString * URLstring = [NSString stringWithFormat:NEWPRODUCT,[manager getIPAddress]];
                [manager downloadDataWithUrl:URLstring parm:nil callback:^(id responseObject, NSError *error) {
                    
                    if(error == nil){
                        NSMutableArray * downArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                        for(int i=0;i<downArray.count;i++){
                            
                            PopurityModel * model = [[PopurityModel alloc]initWithDictionary:downArray[i] error:nil];
                            [self.newestArray addObject:model];
                        }
                        [self.tableView reloadData];
                        //请求首页中间的菜单
                        [self getMenueInfo:manager];
                    }
                }];
            }
        }
    }];
}

-(void)getMenueInfo:(NetManager *)manager{
    
    NSString * urlStr = [NSString stringWithFormat:TUIGUANGINFO,[manager getIPAddress]];
    [manager downloadDataWithUrl:urlStr parm:nil callback:^(id responseObject, NSError *error) {
        
        [self.hud hide:YES];
        if(error==nil){
            
            NSMutableArray * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            tuiGuangArr = [NSMutableArray array];
            for(NSDictionary * dict in array){
                
                BannerModel * model = [[BannerModel alloc]initWithDictionary:dict error:nil];
                [tuiGuangArr addObject:model];
            }
            
            //            [tuiGuangArr addObectsFromArray:tuiGuangArr];
            
            [self.tableView reloadData];
        }else{
            NSLog(@"%@",error.description);
        }
    }];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -轮播图加载
-(void)downloadBanner{
    
    [self createBannerPlaceImage];
    
    [self.hud show:YES];
    
    self.bannerArray = [NSMutableArray array];
    NetManager * manager = [NetManager shareManager];
    //拼接ip和port
    NSString * URLstring = [NSString stringWithFormat:BANNERURL,[manager getIPAddress]];
    
    [manager downloadDataWithUrl:URLstring parm:nil callback:^(id responseObject, NSError *error) {
        
        if(error == nil){
            self.tableView.frame = CGRectMake(0, NAV_BAR_HEIGHT, Wscreen, Hscreen-NAV_BAR_HEIGHT);
            [placeHolderImageView removeFromSuperview];
            
            NSArray * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            for(int i=0;i<array.count;i++){
                BannerModel * model = [[BannerModel alloc]initWithDictionary:array[i] error:nil];
                [self.bannerArray addObject:model];
            }
            
            NSMutableArray * imagesURLStrings = [NSMutableArray array];
            NetManager * manager = [NetManager shareManager];
            for(int i=0;i<self.bannerArray.count;i++){
                
                BannerModel * model = [self.bannerArray objectAtIndex:i];
                //拼接ip和port
                NSString * URLstring = [NSString stringWithFormat:BANNERCONNET,[manager getIPAddress]];
                [imagesURLStrings addObject:[NSString stringWithFormat:@"%@%@",URLstring,model.img]];
            }
            UIImage * gifImage = [UIImage imageNamed:BANNERPLACEHOLDER];
            self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0*S6,Wscreen,150*S6) delegate:self placeholderImage:gifImage];
            self.cycleScrollView.imageURLStringsGroup = imagesURLStrings
            ;
            self.cycleScrollView.delegate = self;
            self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            self.cycleScrollView.currentPageDotColor = RGB_COLOR(215, 185, 29, 0.5); // 自定义分页控件小圆标颜色
            self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"lb1"];
            self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"lb2"];
            self.cycleScrollView.pageDotColor = RGB_COLOR(221, 193, 191,0.5);
            self.cycleScrollView.pageControlDotSize = CGSizeMake(8*S6,8*S6);
            self.cycleScrollView.contentMode = UIViewContentModeScaleAspectFill;
            self.tableView.tableHeaderView = self.cycleScrollView;
        }
    }];
}

#pragma mark - 填充轮播默认图片
-(void)createBannerPlaceImage{
    
    self.tableView.frame = CGRectMake(0, NAV_BAR_HEIGHT+150*S6, Wscreen, Hscreen-NAV_BAR_HEIGHT-150*S6);
    placeHolderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, Wscreen, 150)];
    placeHolderImageView.image = [UIImage sd_animatedGIFNamed:@"move"];
    placeHolderImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:placeHolderImageView];
}

#pragma mark -请求分类搜索界面的数据
-(void)downloadCatagory{
    
    NetManager * manager = [NetManager shareManager];
    [manager downloadCatagoryData];
}

//导航条设置
-(void)setNavigation{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //在导航条下面加一根线
    self.bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0,NAV_BAR_HEIGHT-20-1*S6, Wscreen, 1*S6)];
    self.bottomLine.backgroundColor = RGB_COLOR(204, 204, 204, 1);
    [self.navigationController.navigationBar addSubview:self.bottomLine];
    
    
    self.catagoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(IS_IPHONE == IS_IPHONE_6||IS_IPHONE == IS_IPHONE_6P){
        
        self.catagoryButton.frame = CGRectMake(31/2.0*S6, 20.5/2*S6, 49/2.0*S6, 22.5*S6);
    }else{
        self.catagoryButton.frame = CGRectMake(31/2.0*S6, 22/2*S6, 49/2.0*S6, 22.5*S6);
    }
    [self.catagoryButton setImage:[UIImage imageNamed:@"catagory_btn"] forState:UIControlStateNormal];
    [self.catagoryButton addTarget:self action:@selector(pushForwardCatagoryController) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.catagoryButton];
    
    [self createTextfield];
    
    //添加搜索按钮
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25*S6, 30*S6)];
    UITapGestureRecognizer * taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoMyVc)];
    [searchView addGestureRecognizer:taps];
    
    CGFloat height;
    if(IS_IPHONE == IS_IPHONE_6){
        height = 5.0*S6;
    }else if (IS_IPHONE == IS_IPHONE_6P){
        height = 6.0*S6;
    }else if (IS_IPHONE == IS_IPHONE_5){
        height = 2*S6;
    }
    
    self.searchBtn.frame = CGRectMake(5*S6,height, 19*S6, 41/2.0*S6);
    [self.searchBtn setImage:[UIImage imageNamed:@"mine"] forState:UIControlStateNormal];
    [self.searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [searchView addSubview:self.searchBtn];
    UIBarButtonItem * searBarBtn = [[UIBarButtonItem alloc]initWithCustomView:searchView];
    self.navigationItem.rightBarButtonItem = searBarBtn;
    [self.searchBtn addTarget:self action:@selector(gotoMyVc) forControlEvents:UIControlEventTouchUpInside];
    
    //设置表格frame
    [self setTableView];
    
    //设置下面的集团LOGO
    [self setLogo];
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
    self.searchTextField.placeholder = @"输入您想要的宝贝";
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

-(void)searchVc{
    
    SearchViewController * searchVc = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVc animated:NO];
}

#pragma mark - 开始搜索
-(void)gotoMyVc{
    
    MyViewController * myVc = [[MyViewController alloc]init];
    [self pushToViewControllerWithTransition:myVc withDirection:@"left" type:NO];
}

//设置表格frame
-(void)setTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,NAV_BAR_HEIGHT, Wscreen, Hscreen-NAV_BAR_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = TABLEVIEWCOLOR;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.tableView registerClass:[SerizeCell class] forCellReuseIdentifier:serizeCell];
    [self.tableView registerClass:[ProductCell class] forCellReuseIdentifier:productCell];
}


//表格的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
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
            ThemeViewController * themeVc = [[ThemeViewController alloc]init];
            themeVc.indexParm = model.actionname;
            themeVc.themeTitle = model.actionaliasname;
            [self pushToViewControllerWithTransition:themeVc withDirection:@"right" type:NO];
        }];
        
        return cell;
        
    }else{
        
        ProductCell * cell = [tableView dequeueReusableCellWithIdentifier:productCell];
        if(cell == nil){
            
            cell = [[ProductCell alloc]init];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.section == 1){
            if(self.newestArray.count > 0){
                [cell setImageView:self.newestArray];
                [cell configCellWithArray:self.newestArray];
                [cell clickImageForDetai:^(NSInteger index) {
                    if(self.newestArray.count>index){
                        PopurityModel * model = self.newestArray[index];
                        DetailViewController * detailVc = [[DetailViewController alloc]init];
                        detailVc.index = model.number;
                        [kUserDefaults removeObjectForKey:FROM_VC_TO_SAVE];
                        [kUserDefaults removeObjectForKey:TEMP_FROM_VC_TO_SAVE];
                        [self pushToViewControllerWithTransition:detailVc withDirection:@"left" type:NO];
                    }
                    
                }];
            }
        }else if(indexPath.section == 2){
            
            if(self.popurityArray.count > 0){
                [cell setImageView:self.popurityArray];
                [cell configCellWithArray:self.popurityArray];
                [cell clickImageForDetai:^(NSInteger index) {
                    if(self.popurityArray.count>index){
                        PopurityModel * model = self.popurityArray[index];
                        DetailViewController * detailVc = [[DetailViewController alloc]init];
                        detailVc.index = model.number;
                        [self pushToViewControllerWithTransition:detailVc withDirection:@"left" type:NO];
                        [kUserDefaults removeObjectForKey:FROM_VC_TO_SAVE];
                        [kUserDefaults removeObjectForKey:TEMP_FROM_VC_TO_SAVE];
                    }
                }];
            }
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
    }else if(indexPath.section == 1){
        if(self.newestArray.count%2==0){
            return (175*self.newestArray.count/2.0+10)*S6;
        }else{
            return (175*(self.newestArray.count+1)/2.0+10)*S6;
        }
    }else{
        if(self.popurityArray.count%2==0){
            return (175*self.popurityArray.count/2.0+10)*S6;
        }else
            return (175*(self.popurityArray.count+1)/2.0+10)*S6;
    }
}

//组头设置
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray * sectionImageNameArray = @[@"new_product",@"popur_product"];
    NSArray *sectionTitleArray = @[@"新款产品",@"人气产品"];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 46*S6)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView * sectionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(3.5*S6, 16.5*S6, 18*S6, 17.5*S6)];
    [view addSubview:sectionImageView];
    
    self.max_X = CGRectGetMaxX(sectionImageView.frame);
    self.max_Y = CGRectGetMinY(sectionImageView.frame);
    
    UILabel * sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.max_X+7.5*S6, self.max_Y,60*S6, 15*S6)];
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    sectionLabel.font = [UIFont systemFontOfSize:14*S6];
    sectionLabel.textColor = RGB_COLOR(85, 85, 85, 1);
    [view addSubview:sectionLabel];
    
    if(section == 1){
        
        sectionImageView.image = [UIImage imageNamed:sectionImageNameArray[0]];
        sectionLabel.text = sectionTitleArray[0];
        
        UILabel * label1 = [self createMore:view selector:@selector(action1)];
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action1)];
        [label1 addGestureRecognizer:tap1];
    }else if(section == 2){
        
        sectionImageView.image = [UIImage imageNamed:sectionImageNameArray[1]];
        sectionLabel.text = sectionTitleArray[1];
        UILabel * label2 = [self createMore:view selector:@selector(action2)];
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action2)];
        [label2 addGestureRecognizer:tap1];
    }
    
    self.max_X = CGRectGetMaxX(sectionLabel.frame);
    self.max_Y = CGRectGetMinY(sectionLabel.frame);
    
    return view;
}

-(void)action1{
    SingleSearchCatagoryViewController * singleVc = [[SingleSearchCatagoryViewController alloc]init];
    singleVc.vc_flag = 1;
    [kUserDefaults setObject:@"1" forKey:@"temp"];
    [self pushToViewControllerWithTransition:singleVc withDirection:@"left" type:NO];
}

-(void)action2{
    SingleSearchCatagoryViewController * singleVc = [[SingleSearchCatagoryViewController alloc]init];
    singleVc.vc_flag = 1;
    [kUserDefaults setObject:@"2" forKey:@"temp"];
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

#pragma mark - “more”按钮事件
-(void)moreAction1{
    
    SingleSearchCatagoryViewController * singleVc = [[SingleSearchCatagoryViewController alloc]init];
    singleVc.vc_flag = 1;
    [self pushToViewControllerWithTransition:singleVc withDirection:@"left" type:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section != 0){
        return 46*S6;
    }
    else{
        return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)setLogo{
    
    CGFloat bottomHeight = (28+68+16)/2*S6;
    self.logoView = [[UIView alloc]initWithFrame:CGRectMake(0, Hscreen - bottomHeight, Wscreen, bottomHeight)];
    self.logoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.logoView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showInfo)];
    [self.logoView addGestureRecognizer:tap];
    
    [self getBottomData];
}

-(void)getBottomData{
    NetManager * manager = [NetManager shareManager];
    NSString * urlStr = [NSString stringWithFormat:BOTTOMPIC,[manager getIPAddress]];
    [manager downloadDataWithUrl:urlStr parm:nil callback:^(id responseObject, NSError *error) {
        
        if(responseObject){
            bottomDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [self setBottomView];
        }
    }];
}

-(void)setBottomView{
    
    NetManager * manager = [NetManager shareManager];
    BOOL isopen = [bottomDict[@"isopen"]boolValue];
    id imgObj = bottomDict[@"image"];
    NSString * str;
    if([imgObj isKindOfClass:[NSString class]]){
        str = [imgObj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else{
        self.logoView .hidden = YES;
    }
    
    if(isopen == NO){
        [self.logoView removeFromSuperview];
    }else{
        NSString * imgUrl = [NSString stringWithFormat:BOTTOMIMG,[manager getIPAddress],str];
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:self.logoView.bounds];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage new] options:SDWebImageRetryFailed];
        [self.logoView addSubview:imgView];
    }
}

-(void)showInfo{
    
    NetManager * manager = [NetManager shareManager];
    NSString * urlStr = [NSString stringWithFormat:BOTTOMPIC,[manager getIPAddress]];
    [manager downloadDataWithUrl:urlStr parm:nil callback:^(id responseObject, NSError *error) {
        
        if(responseObject){
            bottomDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            YLLocationManager * locationManager = [[YLLocationManager alloc]initShareLocationManager:bottomDict[@"address"] ViewController:self];
            locationManager.bottomDict = bottomDict;
            [locationManager createLocationManager];
            NetManager * manager = [NetManager shareManager];
            BOOL isopen = [bottomDict[@"isopen"]boolValue];
            id imgObj = bottomDict[@"image"];
            NSString * str;
            if([imgObj isKindOfClass:[NSString class]]){
                str = [imgObj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            }else{
                self.logoView .hidden = YES;
            }
            
            if(isopen == NO){
                [self.logoView removeFromSuperview];
            }else{
                NSString * imgUrl = [NSString stringWithFormat:BOTTOMIMG,[manager getIPAddress],str];
                UIImageView * imgView = [[UIImageView alloc]initWithFrame:self.logoView.bounds];
                [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage new] options:SDWebImageRetryFailed];
                [self.logoView addSubview:imgView];
            }
        }
    }];
}

////设置下面的集团LOGO
//-(void)setLogo{
//
//
//    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0,0,Wscreen, 1*S6)];
//    lineView.backgroundColor = BOARDCOLOR;
//    [self.logoView addSubview:lineView];
//
//    self.max_Y = CGRectGetMaxY(lineView.frame);
//    UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(115/2.0*S6, self.max_Y+10*S6, 200/2.0*S6, 70/2.0*S6)];
//    logoImageView.image = [UIImage imageNamed:@"logo"];
//    [self.logoView addSubview:logoImageView];
//
//    self.max_X = CGRectGetMaxX(logoImageView.frame);
//    self.max_Y = CGRectGetMinY(logoImageView.frame);
//
//    UIImageView * positionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.max_X+22*S6, self.max_Y,8*S6,10*S6)];
//    positionImageView.image = [UIImage imageNamed:@"address"];
//    [self.logoView addSubview:positionImageView];
//
//    self.max_X = CGRectGetMaxX(positionImageView.frame);
//
//    UILabel * positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.max_X+5*S6, self.max_Y, 300*S6, 10*S6)];
//    positionLabel.text = @"深圳市罗湖区水贝二路特力大厦3楼";
//    positionLabel.textColor = LOGOTEXTCOLOR;
//    positionLabel.font = [UIFont systemFontOfSize:9*S6];
//    [self.logoView addSubview:positionLabel];
//
//    self.max_Y = CGRectGetMaxY(positionImageView.frame);
//    self.max_X = CGRectGetMinX(positionImageView.frame);
//
//    UIImageView * telImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.max_X, self.max_Y+5*S6, 8*S6, 8.5*S6)];
//    telImageView.image = [UIImage imageNamed:@"phone_img"];
//    [self.logoView addSubview:telImageView];
//
//    self.max_X = CGRectGetMaxX(telImageView.frame);
//    UILabel * telLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.max_X+5*S6, self.max_Y+5*S6, 300*S6, 8.5*S6)];
//    telLabel.text = @"0755-22929812";
//    telLabel.textColor = LOGOTEXTCOLOR;
//    telLabel.font = [UIFont systemFontOfSize:9*S6];
//    [self.logoView addSubview:telLabel];
//
//    self.max_Y = CGRectGetMaxY(telImageView.frame);
//    self.max_X = CGRectGetMinX(telImageView.frame);
//
//    UIImageView * netImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.max_X, self.max_Y+5*S6, 8*S6, 8.5*S6)];
//    netImageView.image = [UIImage imageNamed:@"mark_img"];
//    [self.logoView addSubview:netImageView];
//
//    self.max_X = CGRectGetMaxX(netImageView.frame);
//    UILabel * netLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.max_X+5*S6, self.max_Y+5*S6, 300*S6, 8.5*S6)];
//    netLabel.text = @"www.batar.cn";
//    netLabel.font = [UIFont systemFontOfSize:9*S6];
//    netLabel.textColor = LOGOTEXTCOLOR;
//    [self.logoView addSubview:netLabel];
//}

//滑动表格显示／隐藏下面的Logo
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if(velocity.y>0){
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.logoView.transform = CGAffineTransformMakeTranslation(0, self.logoView.frame.size.height);
        }];
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            
            self.logoView.transform = CGAffineTransformIdentity;
        }];
    }
    
    [self.searchTextField resignFirstResponder];
}
//跳回详细分类界面
-(void)pushForwardCatagoryController{
    
    CatagoryViewController * cataViewController = [[CatagoryViewController alloc]init];
    [self pushToViewControllerWithTransition:cataViewController withDirection:@"left" type:NO];
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

//懒加载
-(NSMutableArray *)popurityArray{
    
    if(!_popurityArray){
        
        _popurityArray = [NSMutableArray array];
    }
    return _popurityArray;
}

-(NSMutableArray *)newestArray{
    
    if(!_newestArray){
        
        _newestArray = [NSMutableArray array];
    }
    return _newestArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
