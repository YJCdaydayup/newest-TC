//
//  CatagoryViewController.m
//  DianZTC
//
//  Created by 杨力 on 5/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "CatagoryViewController.h"
#import "SerizeViewController.h"
#import "FirstViewController.h"
#import "SearchCatagoryViewController.h"
#import "SingleSearchCatagoryViewController.h"
#import "PingleiCell.h"
#import "GongYiCell.h"
#import "CaizhiCell.h"
#import "WaixingCell.h"
#import "KezhongCell.h"
#import "LoginViewController.h"
#import "MyViewController.h"
#import "SearchViewController.h"

//品类cell
#define pinleiCell @"pinleiCell"
//工艺cell
#define gongyiCell @"gongyiCell"
//材质cell
#define caizhiCell @"caizhiCell"
//外形cell
#define waixingCell @"waixingCell"
//克重cell
#define kezhongCell @"kezhongCell"

@interface CatagoryViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    //品类
    UIView * bgView1;
    BOOL pinlei[10000];
    
    //外形
    UIView * bgView2;
    BOOL waixing[10000];
    
    //工艺
    UIView * bgView3;
    BOOL craft[10000];
    
    //材质
    UIView * bgView4;
    BOOL material[10000];
    
    //克重
    UIView * bgView5;
    BOOL weight[10000];
}

//导航条返回按钮
@property (nonatomic,retain) UITextField * searchTextField1;
@property (nonatomic,strong) UIButton * catagoryButton1;
@property (nonatomic,strong) UIView * addView;

//表格属性
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

///*最后选中的品类，放在这个数组中*/
@property (nonatomic,strong) NSMutableArray * pinleiSelectedArray;

//旋转箭头
@property (nonatomic,strong) UIImageView * xuanzhanImageView1;

//“品类”更多button
@property (nonatomic,strong) UIButton * moreButton1;
@property (nonatomic,strong) NSIndexPath * indexPath1;
@property (nonatomic,assign) BOOL flag1;
@property (nonatomic,strong) NSMutableArray * pinleiButtonNameArray;

//“工艺”更多按钮
@property (nonatomic,strong) UIButton * moreButton2;
@property (nonatomic,strong) NSIndexPath * indexPath2;
@property (nonatomic,assign) BOOL flag2;

//“材质”更多按钮
@property (nonatomic,strong) UIButton * moreButton3;
@property (nonatomic,strong) NSIndexPath * indexPath3;
@property (nonatomic,assign) BOOL flag3;

//“外形”更多button
@property (nonatomic,strong) UIButton * moreButton4;
@property (nonatomic,strong) NSIndexPath * indexPath4;
@property (nonatomic,assign) BOOL flag4;
@property (nonatomic,strong) NSMutableArray * waiXingButtonNameArray;

//“克重”更多按钮
@property (nonatomic,strong) UIButton * moreButton5;
@property (nonatomic,strong) NSIndexPath * indexPath5;
@property (nonatomic,assign) BOOL flag5;

//工艺
@property (nonatomic,strong,readwrite) NSMutableArray * craftNameArray;
//材质
@property (nonatomic,strong,readwrite) NSMutableArray * materialNameArray;
//克重
@property (nonatomic,strong,readwrite) NSMutableArray * weightNameArray;

//适配工具
@property (nonatomic,assign) CGFloat max_X;
@property (nonatomic,assign) CGFloat max_Y;

@property (nonatomic,strong) UIButton * exitBtn;

@end

@implementation CatagoryViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchTextField1 resignFirstResponder];
    self.searchTextField1.hidden = YES;
    [self resetBtn];
}

-(void)resetBtn{
    
    for(int i=0;i<10000;i++){
        pinlei[i] = NO;
        craft[i] = NO;
        material[i] = NO;
        waixing[i] = NO;
        weight[i] = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.pinleiSelectedArray removeAllObjects];
    self.searchTextField1.hidden = NO;
    [self configUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏系统本身的“back”导航按钮
    self.navigationItem.hidesBackButton = YES;
    
    [self setNavi];
}

-(void)setNavi{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = TABLEVIEWCOLOR;
    
    //导航条设置return 49/2.0*S6, 22.5*S6
    [self batar_setLeftNavButton:@[@"return",@""] target:self selector:@selector(back) size:CGSizeMake(49/2.0*S6, 22.5*S6) selector:nil rightSize:CGSizeZero topHeight:12*S6];
    [self createTextfield];
}

-(void)configUI{
    
    //设置“分类”和“系列“
    [self setCatagoryView];
    
    //表格设置
    [self setCataTableView];
}

-(void)logoutAction{
   
    MyViewController * myVc = [[MyViewController alloc]init];
    [self pushToViewControllerWithTransition:myVc withDirection:@"left" type:NO];
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
}

//设置“分类”和“系列“
-(void)setCatagoryView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, Wscreen, 40*S6)];
    bgView.backgroundColor = RGB_COLOR(76, 66, 41, 1);
    [self.view addSubview:bgView];
    
    //分类
    UIImageView * catagoryImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"catagory"]];
    catagoryImageView.frame = CGRectMake(66*S6, 13*S6+NAV_BAR_HEIGHT, 35/2.0*S6, 15*S6);
    [self.view addSubview:catagoryImageView];
    
    self.max_X = CGRectGetMaxX(catagoryImageView.frame);
    self.max_Y = CGRectGetMinY(catagoryImageView.frame);
    
    UILabel * fenleiLabel = [Tools createLabelWithFrame:CGRectMake(self.max_X+10*S6, self.max_Y, 80, 15*S6) textContent:@"分类" withFont:[UIFont systemFontOfSize:16*S6] textColor:RGB_COLOR(255, 255, 255, 1) textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:fenleiLabel];
    
    //系列
    UIView * serizeBgView = [[UIView alloc]initWithFrame:CGRectMake(375/2.0*S6, NAV_BAR_HEIGHT, 375/2.0*S6, 40*S6)];
    serizeBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:serizeBgView];
    
    UIImageView * serizeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(66*S6, 13*S6, 35/2.0*S6, 16*S6)];
    serizeImageView.image = [UIImage imageNamed:@"serize"];
    [serizeBgView addSubview:serizeImageView];
    
    self.max_X = CGRectGetMaxX(serizeImageView.frame);
    self.max_Y = CGRectGetMinY(serizeImageView.frame);
    UILabel * serizeLabel = [Tools createLabelWithFrame:CGRectMake(self.max_X+10*S6, self.max_Y, 80, 15*S6) textContent:@"系列" withFont:[UIFont systemFontOfSize:15*S6] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [serizeBgView addSubview:serizeLabel];
    
    //给serizeBgView添加手势，跳转到系列界面
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushForwardSerizeController)];
    [serizeBgView addGestureRecognizer:tap];
    
    //获取serizeBgView的底部frame
    self.max_Y = CGRectGetMaxY(serizeBgView.frame);
}

//表格设置
-(void)setCataTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.max_Y+10*S6, Wscreen, Hscreen-10*S6-self.max_Y-50*S6) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = TABLEVIEWCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //表尾设置
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, Hscreen-50*S6, Wscreen, 50*S6)];
    footerView.backgroundColor = LOGOUTBTNCOLOR;
    //添加手势，点击搜索分类信息
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchCatagory)];
    [footerView addGestureRecognizer:tap];
    UIImageView * searchImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_01"]];
    searchImageView.frame = CGRectMake(245/2.0*S6, 33/2.0*S6, 35/2.0*S6, 17*S6);
    [footerView addSubview:searchImageView];
    
    self.max_X = CGRectGetMaxX(searchImageView.frame);
    
    UILabel * searchLabel = [Tools createLabelWithFrame:CGRectMake(self.max_X+10*S6, 33/2.0*S6, 200, 17*S6) textContent:@"分类多选搜索" withFont:[UIFont systemFontOfSize:17*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    [footerView addSubview:searchLabel];
    [self.view addSubview:footerView];
    
    [self.tableView registerClass:[PingleiCell class] forCellReuseIdentifier:pinleiCell];
    [self.tableView registerClass:[GongYiCell class] forCellReuseIdentifier:gongyiCell];
    [self.tableView registerClass:[CaizhiCell class] forCellReuseIdentifier:caizhiCell];
    [self.tableView registerClass:[WaixingCell class] forCellReuseIdentifier:waixingCell];
    [self.tableView registerClass:[KezhongCell class] forCellReuseIdentifier:kezhongCell];
    
    [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.1];
    
}
//刷新表格
-(void)reloadTableView{
    
     [self.tableView reloadRowsAtIndexPaths:@[self.indexPath4] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark -跳转到品类的分组界面
-(void)searchCatagory{

    //遍历数组，找出哪些“品类”被选中
    NSMutableArray * categorys = [[NSMutableArray alloc]init];
    NSMutableArray * crafts = [[NSMutableArray alloc]init];
    NSMutableArray * materials = [[NSMutableArray alloc]init];
    NSMutableArray * shapes = [[NSMutableArray alloc]init];
    NSMutableArray * weights = [[NSMutableArray alloc]init];
    for(int i=0;i<10000;i++){
        
        if(pinlei[i]){
            
            [categorys addObject:[NSNumber numberWithInt:i+1]];
            [self.pinleiSelectedArray addObject:self.pinleiButtonNameArray[i]];
        }
        
        if(craft[i]){
            
            [crafts addObject:[NSNumber numberWithInt:i+1]];
        }
        if(material[i]){
            
            [materials addObject:[NSNumber numberWithInt:i+1]];
        }
        if(waixing[i]){
            
            [shapes addObject:[NSNumber numberWithInt:i+1]];
        }
        if(weight[i]){
            
            [weights addObject:[NSNumber numberWithInt:i+1]];
        }
    }
    
    NSDictionary * dict = @{
                            @"category": categorys,     //#品类
                            @"craft": crafts,           //#工艺
                            @"material": materials,     //#材质
                            @"shapes": shapes,          //#外形
                            @"weight": weights,         //#克重
                            @"others": @""              //#其他
                            };
    //品类选择按钮
    NSString * jsonStr = [self dictionaryToJson:dict];
    NSDictionary * dict1 = @{@"parm":jsonStr};
    
    CATransition * animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.duration = 0.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:animation forKey:@"123"];
    
    if(self.pinleiSelectedArray.count > 1){
        
        SearchCatagoryViewController * searchCatagoryViewController = [[SearchCatagoryViewController alloc]init];
        searchCatagoryViewController.pinleiArray = self.pinleiSelectedArray;
        searchCatagoryViewController.parmDict = dict1;
        [self.navigationController pushViewController:searchCatagoryViewController animated:YES];
        
    }else if(self.pinleiSelectedArray.count == 1){
        
        [kUserDefaults removeObjectForKey:@"temp"];
        SingleSearchCatagoryViewController * singleVc = [[SingleSearchCatagoryViewController alloc]init];
        singleVc.vc_flag = 0;
        singleVc.parmDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        singleVc.catagoryItem = self.pinleiSelectedArray[0];
        [self.navigationController pushViewController:singleVc animated:YES];
        
    }else{
        [kUserDefaults removeObjectForKey:@"temp"];
        SingleSearchCatagoryViewController * singleVc = [[SingleSearchCatagoryViewController alloc]init];
        singleVc.vc_flag = 1;
        [self.navigationController pushViewController:singleVc animated:NO];
    }
    
    [self cleanAllArrayData];
}

#pragma mark - 清除所有数组里面的数据
-(void)cleanAllArrayData{
    
    
}

#pragma mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        PingleiCell * cell = [tableView dequeueReusableCellWithIdentifier:pinleiCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.indexPath1 = indexPath;
        cell.backgroundColor = TABLEVIEWCOLOR;
        cell.clipsToBounds = YES;
        if(cell == nil){
            
            cell = [[PingleiCell alloc]init];
        }
        bgView1 = cell.bgView;
        [self addClickActionWithBaseTag:100 andArray:self.pinleiButtonNameArray andView:bgView1];
        
        return cell;
    }else if(indexPath.section == 1){
        
        GongYiCell * cell = [tableView dequeueReusableCellWithIdentifier:gongyiCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = TABLEVIEWCOLOR;
        self.indexPath2 = indexPath;
        if(cell == nil){
            cell = [[GongYiCell alloc]init];
        }
        cell.clipsToBounds = YES;
        bgView3 = cell.bgView;
        [self addClickActionWithBaseTag:10 andArray:self.craftNameArray andView:bgView3];
        
        return cell;
    }else if(indexPath.section == 2){
        
        CaizhiCell * cell = [tableView dequeueReusableCellWithIdentifier:caizhiCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = TABLEVIEWCOLOR;
        self.indexPath3 = indexPath;
        if(cell == nil){
            
            cell = [[CaizhiCell alloc]init];
        }
        cell.clipsToBounds = YES;
        bgView4 = cell.bgView;
        [self addClickActionWithBaseTag:40 andArray:self.materialNameArray andView:bgView4];
        
        return cell;
    }else if(indexPath.section == 3){
        
        WaixingCell * cell = [tableView dequeueReusableCellWithIdentifier:waixingCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.indexPath4 = indexPath;
        cell.clipsToBounds = YES;
        cell.backgroundColor = TABLEVIEWCOLOR;
        if(cell == nil){
            
            cell = [[WaixingCell alloc]init];
        }
        cell.clipsToBounds = YES;
        bgView2 = cell.bgView;
        //每个按钮添加事件
        [self addClickActionWithBaseTag:50 andArray:self.waiXingButtonNameArray andView:bgView2];
        return cell;
        
    }else{
        
        KezhongCell * cell = [tableView dequeueReusableCellWithIdentifier:kezhongCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = TABLEVIEWCOLOR;
        self.indexPath5 = indexPath;
        if(cell == nil){
            cell = [[KezhongCell alloc]init];
        }
        cell.clipsToBounds = YES;
        
        bgView5 = cell.bgView;
        [self addClickActionWithBaseTag:70 andArray:self.weightNameArray andView:bgView5];
        
        return cell;
    }
}

-(void)reloadWithSelectTags:(NSMutableArray *)array{
    
    if(array == self.pinleiButtonNameArray){
        for(int i=0;i<array.count;i++){
            
            UIButton * button = (UIButton *)[bgView1 viewWithTag:100+i];
            if(pinlei[button.tag-100]){
                button.backgroundColor = THEMECOLOR;
                button.selected = YES;
            }else{
                button.backgroundColor = [UIColor whiteColor];
                button.selected = NO;
            }
        }
    }
    
    if(array == self.craftNameArray){
        
        for(int i=0;i<array.count;i++){
            
            UIButton * button = (UIButton *)[bgView3 viewWithTag:10+i];
            if(craft[button.tag-10]){
                button.backgroundColor = THEMECOLOR;
                button.selected = YES;
                
            }else{
                button.backgroundColor = [UIColor whiteColor];
                button.selected = NO;
            }
        }
    }
    
    if(array == self.materialNameArray){
        
        for(int i=0;i<array.count;i++){
            
            UIButton * button = (UIButton *)[bgView4 viewWithTag:10+i];
            if(material[button.tag-40]){
                button.backgroundColor = THEMECOLOR;
                button.selected = YES;
                
            }else{
                button.backgroundColor = [UIColor whiteColor];
                button.selected = NO;
            }
        }
    }
    
    if(array == self.waiXingButtonNameArray){
        
        for(int i=0;i<array.count;i++){
            
            UIButton * button = (UIButton *)[bgView2 viewWithTag:50+i];
            if(waixing[button.tag-50]){
                button.backgroundColor = THEMECOLOR;
                button.selected = YES;
                
            }else{
                button.backgroundColor = [UIColor whiteColor];
                button.selected = NO;
            }
        }
    }
    
    if(array == self.weightNameArray){
        
        for(int i=0;i<array.count;i++){
            
            UIButton * button = (UIButton *)[bgView5 viewWithTag:70+i];
            if(weight[button.tag-70]){
                button.backgroundColor = THEMECOLOR;
                button.selected = YES;
                
            }else{
                button.backgroundColor = [UIColor whiteColor];
                button.selected = NO;
            }
        }
    }
}

#pragma mark -给每个按钮添加事件
-(void)addClickActionWithBaseTag:(int)tag andArray:(NSMutableArray *)array andView:(UIView *)bgView{
    
    if(array == self.pinleiButtonNameArray){
        for(int i=0;i<array.count;i++){
            
            UIButton * button = (UIButton *)[bgView viewWithTag:tag+i];
            [button addTarget:self action:@selector(pinleiAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if(array == self.waiXingButtonNameArray){
        for(int i = 0;i<array.count;i++){
            UIButton * button = (UIButton *)[bgView viewWithTag:tag+i];
            [button addTarget:self action:@selector(waixingClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if(array == self.craftNameArray){
        
        for(int i = 0;i<array.count;i++){
            UIButton * button = (UIButton *)[bgView viewWithTag:tag+i];
            [button addTarget:self action:@selector(craftClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if(array == self.materialNameArray){
        
        for(int i = 0;i<array.count;i++){
            UIButton * button = (UIButton *)[bgView viewWithTag:tag+i];
            [button addTarget:self action:@selector(materialClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if(array == self.weightNameArray){
        
        for(int i = 0;i<array.count;i++){
            UIButton * button = (UIButton *)[bgView viewWithTag:tag+i];
            [button addTarget:self action:@selector(weightClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    //根据tag值进行刷新
    [self reloadWithSelectTags:array];
}

#pragma mark -品类按钮按钮点击事件
-(void)pinleiAction:(UIButton *)button{
    
    button.selected = !button.selected;
    pinlei[button.tag-100] = button.selected;
    if(pinlei[button.tag-100]){
        button.backgroundColor = THEMECOLOR;
        button.selected = YES;
    }else{
        button.backgroundColor = [UIColor whiteColor];
        button.selected = NO;
    }
}

#pragma mark -工艺按钮点击事件
-(void)craftClick:(UIButton *)button{
    
    button.selected = !button.selected;
    craft[button.tag-10] = button.selected;
    if(craft[button.tag-10]){
        button.backgroundColor = THEMECOLOR;
        button.selected = YES;
    }else{
        button.backgroundColor = [UIColor whiteColor];
        button.selected = NO;
    }
}

#pragma mark -材质按钮点击事件
-(void)materialClick:(UIButton *)button{
    
    button.selected = !button.selected;
    material[button.tag-40] = button.selected;
    if(material[button.tag-40]){
        button.backgroundColor = THEMECOLOR;
        button.selected = YES;
    }else{
        button.backgroundColor = [UIColor whiteColor];
        button.selected = NO;
    }
}

#pragma mark -外形按钮点击事件
-(void)waixingClick:(UIButton *)button{
    
    button.selected = !button.selected;
    waixing[button.tag-50] = button.selected;
    if(waixing[button.tag-50]){
        button.backgroundColor = THEMECOLOR;
        button.selected = YES;
    }else{
        button.backgroundColor = [UIColor whiteColor];
        button.selected = NO;
    }
}

#pragma mark -克重按钮点击事件
-(void)weightClick:(UIButton *)button{
    
    button.selected = !button.selected;
    weight[button.tag-70] = button.selected;
    if(weight[button.tag-70]){
        button.backgroundColor = THEMECOLOR;
        button.selected = YES;
    }else{
        button.backgroundColor = [UIColor whiteColor];
        button.selected = NO;
    }
}

//设置“更多”按钮
-(void)configMoreButton:(UIButton *)button{
    
    [button addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
}

//点击更多按钮，进行cell的伸缩
-(void)showMore:(UIButton *)button{
    
    if(button == self.moreButton1){
        
        self.flag1 = !self.flag1;
        [self.tableView reloadRowsAtIndexPaths:@[self.indexPath1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else if (button == self.moreButton4){
        
        self.flag4 = !self.flag4;
        [self.tableView reloadRowsAtIndexPaths:@[self.indexPath4] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else if (button == self.moreButton2){
        
        self.flag2 = !self.flag2;
        [self.tableView reloadRowsAtIndexPaths:@[self.indexPath2] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else if (button == self.moreButton3){
        self.flag3 = !self.flag3;
        [self.tableView reloadRowsAtIndexPaths:@[self.indexPath3] withRowAnimation:UITableViewRowAnimationAutomatic];

    }else if (button == self.moreButton5){
        self.flag5 = !self.flag5;
        [self.tableView reloadRowsAtIndexPaths:@[self.indexPath5] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    //每个品类的按钮添加事件
    [self addClickActionWithBaseTag:100 andArray:self.pinleiButtonNameArray andView:bgView1];
    [self addClickActionWithBaseTag:50 andArray:self.waiXingButtonNameArray andView:bgView2];
    [self addClickActionWithBaseTag:10 andArray:self.craftNameArray andView:bgView3];
    [self addClickActionWithBaseTag:40 andArray:self.materialNameArray andView:bgView4];
    [self addClickActionWithBaseTag:70 andArray:self.weightNameArray andView:bgView5];
    
}
#pragma mark -返回cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height1 = 45;
    CGFloat height2 = 90;
    
    //从文件读取数据
    NSString * plistPath = [NSString stringWithFormat:@"%@catagory.plist",LIBPATH];
    NSArray * fileArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    if(indexPath.section == 0){
        
        NSArray * cataArray = fileArray[0];
        
        if(cataArray.count<=8){
            
            self.moreButton1.selected = YES;
            self.moreButton1.userInteractionEnabled = NO;
        }
        
        if(self.flag1 == NO){
            
            if(cataArray.count==0){
                return 5*S6;
            }
            if(cataArray.count<=4){
                return height1*S6;
            }else{
                return height2*S6;
            }
            
        }else{
            
            int height = cataArray.count/4*height1*S6;
            int leftHeight = cataArray.count%4>0?height1*S6:0;
            return height+leftHeight;
        }
    }else if(indexPath.section == 1){
        
        NSArray * craftArray = fileArray[1];
        
        if(craftArray.count<=8){
            
            self.moreButton2.selected = YES;
            self.moreButton2.userInteractionEnabled = NO;
        }
        
        if(self.flag2 == NO){
            
            if(craftArray.count==0){
                return 5*S6;
            }
            
            if(craftArray.count<=4){
                return height1*S6;
            }else{
    
                return height2*S6;
            }
        }else{
            
            int height = craftArray.count/4*height1*S6;
            int leftHeight = craftArray.count%4>0?height1*S6:0;
            return height+leftHeight;
        }
        
    }else if(indexPath.section == 2){
        NSArray * materialArray = fileArray[2];
        if(materialArray.count<=8){
            
            self.moreButton3.selected = YES;
            self.moreButton3.userInteractionEnabled = NO;
        }
        if(self.flag3 == NO){
            
            if(materialArray.count==0){
                return 5*S6;
            }
            
            if(materialArray.count<=4){
                return height1*S6;
            }else{
                return height2*S6;
            }
        }else{
            
            int height = materialArray.count/4*height1*S6;
            int leftHeight = materialArray.count%4>0?height1*S6:0;
            return height+leftHeight ;
        }
    }else if(indexPath.section == 3){
        NSArray * shapeArray = fileArray[3];
        if(shapeArray.count<=8){
            
            self.moreButton4.selected = YES;
            self.moreButton4.userInteractionEnabled = NO;
        }
        if(self.flag4 == NO){
            
            if(shapeArray.count==0){
                return 5*S6;
            }
            
            if(shapeArray.count<=4){
                return height1*S6;
            }else{
                return height2*S6;
            }
        }else{
            
            int height = shapeArray.count/4*height1*S6;
            int leftHeight = shapeArray.count%4>0?height1*S6:0;
            return height+leftHeight;
        }
    }else{
        NSArray * weightArray = fileArray[4];
        if(weightArray.count<=8){
            
            self.moreButton5.selected = YES;
            self.moreButton5.userInteractionEnabled = NO;
        }
        if(self.flag5 == NO){
            
            if(weightArray.count==0){
                return 5*S6;
            }
            
            if(weightArray.count<=4){
                return height1*S6;
            }else{
                return height2*S6;
            }
        }else{
            
            int height = weightArray.count/4*height1*S6;
            int leftHeight = weightArray.count%4>0?height1*S6:0;
            return height+leftHeight;
        }
    }
}

#pragma mark -组头设置
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray * titleArray = @[@"品类",@"工艺",@"材质",@"外形",@"克重"];
    NSArray * imgArray = @[@"pinlei",@"craft",@"material",@"shape",@"weight"];
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 44*S6)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * smalImgView = [[UIImageView alloc]initWithFrame:CGRectMake(12.5*S6, 12.5*S6, 16.5*S6, 17*S6)];
    smalImgView.image = [UIImage imageNamed:imgArray[section]];
    [bgView addSubview:smalImgView];
    
    UILabel * titleLabel = [Tools createLabelWithFrame:CGRectMake(CGRectGetMaxX(smalImgView.frame)+7.5*S6,12.5*S6,50,15*S6) textContent:titleArray[section] withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:titleLabel];
    
    //添加更多按钮
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(Wscreen-67.5*S6, 9*S6, 62.5*S6, 25*S6);
    [moreBtn setImage:[UIImage imageNamed:@"more_btn"] forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"no_btn"] forState:UIControlStateSelected];
    [bgView addSubview:moreBtn];
    
    moreBtn.userInteractionEnabled = YES;
    
    if(section == 0){
        self.moreButton1 = moreBtn;
        //设置“更多”按钮
        [self configMoreButton:self.moreButton1];
    }
    
    if(section == 1){
        
        self.moreButton2 = moreBtn;
        [self configMoreButton:self.moreButton2];
    }
    
    if(section == 2){
        
        self.moreButton3 = moreBtn;
        [self configMoreButton:self.moreButton3];
    }
    
    if(section == 3){
        
        self.moreButton4 = moreBtn;
        [self configMoreButton:self.moreButton4];
    }
    
    if(section == 4){
        
        self.moreButton5 = moreBtn;
        [self configMoreButton:self.moreButton5];
        
    }
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44*S6;
}

//滑动表格显示／隐藏下面的Logo
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    [self.searchTextField1 resignFirstResponder];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self searchVc];
    [textField resignFirstResponder];
    return YES;
}

-(void)searchVc{
    
    SearchViewController * searchVc = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVc animated:NO];
}

#pragma mark -跳转到系列界面，将选中的“品类”中的选项通过数组带过去
-(void)pushForwardSerizeController{
    
    SerizeViewController * serizeViewController = [[SerizeViewController alloc]initWithController:self];
    [self.navigationController pushViewController:serizeViewController animated:NO];
    [self removeNaviPushedController:self];
}

//返回首页
-(void)back{
    
    [self popToViewControllerWithDirection:@"right" type:NO];
}

//品类
-(NSMutableArray *)pinleiButtonNameArray{
    
    NSString * plistPath = [NSString stringWithFormat:@"%@catagory.plist",LIBPATH];
    NSArray * fileArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    if(_pinleiButtonNameArray == nil){
        
        _pinleiButtonNameArray = [[NSMutableArray alloc]initWithArray:fileArray[0]];
    }
    
    return _pinleiButtonNameArray;
}

-(NSMutableArray *)pinleiSelectedArray{
    
    if(_pinleiSelectedArray == nil){
        
        _pinleiSelectedArray = [[NSMutableArray alloc]init];
    }
    
    return _pinleiSelectedArray;
}
//外形
-(NSMutableArray *)waiXingButtonNameArray{
    
    NSString * plistPath = [NSString stringWithFormat:@"%@catagory.plist",LIBPATH];
    NSArray * fileArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
    if(_waiXingButtonNameArray == nil){
        
        _waiXingButtonNameArray = [[NSMutableArray alloc]initWithArray:fileArray[3]];
    }
    
    return _waiXingButtonNameArray;
}

//工艺
-(NSMutableArray *)craftNameArray{
    
    NSString * plistPath = [NSString stringWithFormat:@"%@catagory.plist",LIBPATH];
    NSArray * fileArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    if(!_craftNameArray){
        
        _craftNameArray = [[NSMutableArray alloc]initWithArray:fileArray[1]];
    }
    
    return _craftNameArray;
}

//材质
-(NSMutableArray *)materialNameArray{
    
    NSString * plistPath = [NSString stringWithFormat:@"%@catagory.plist",LIBPATH];
    NSArray * fileArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    if(_materialNameArray == nil){
        
        _materialNameArray = [[NSMutableArray alloc]initWithArray:fileArray[2]];
    }
    
    return _materialNameArray;
}

//克重
-(NSMutableArray *)weightNameArray{
    
    NSString * plistPath = [NSString stringWithFormat:@"%@catagory.plist",LIBPATH];
    NSArray * fileArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    if(_weightNameArray == nil){
        
        _weightNameArray = [[NSMutableArray alloc]initWithArray:fileArray[4]];
    }
    
    return _weightNameArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
