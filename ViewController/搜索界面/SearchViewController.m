//
//  SearchViewController.m
//  DianZTC
//
//  Created by 杨力 on 4/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "SearchViewController.h"
#import "NetManager.h"
#import "VVAttrHeper.h"
#import "BatarResultController.h"

@interface SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIView * _bgView;
}

@property (nonatomic,strong) UIButton * backBtn;
@property (nonatomic,strong) UITextField * search_Tf;
@property (nonatomic,strong) UITableView * search_tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation SearchViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.backBtn.hidden = NO;
    self.search_Tf.hidden = NO;
    self.search_tableView.hidden = YES;
    [self.search_Tf becomeFirstResponder];
     self.view.transform = CGAffineTransformIdentity;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.backBtn.hidden = YES;
    self.search_Tf.hidden = YES;
    [self.search_Tf resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavi];
}


-(void)getDataWithText{
    
    NetManager * manager = [NetManager shareManager];
    NSString * urlStr = [NSString stringWithFormat:SEARCHINDICOTOR,[manager getIPAddress]];
    //    NSString * content = [self.search_Tf.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSDictionary * dict = @{@"key":self.search_Tf.text};
    [manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
        if(responseObject){
            
            NSMutableArray * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            [self.dataArray removeAllObjects];
            if(array.count>0){
                [self.dataArray addObjectsFromArray:array];
            }else{
                [self.dataArray addObject:@"未查询到产品!"];
            }
            self.search_tableView.hidden = NO;
            [self.search_tableView reloadData];
        }else{
            NSLog(@"%@",error.description);
        }
    }];
}

#pragma mark -UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32*S6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellid = @"cellid";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        UILabel * name_label = [Tools createLabelWithFrame:CGRectMake(54*S6, 1.5*S6, 200*S6, 30*S6) textContent:nil withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
        name_label.tag = 3333;
        [cell.contentView addSubview:name_label];
    }
    
    UILabel * label = (UILabel *)[cell.contentView viewWithTag:3333];
    label.text = self.dataArray[indexPath.row];
    if([label.text isEqualToString:@"未查询到产品!"]){
        //不变红
    }else{
        //变红
        [self setKeyWord:self.dataArray[indexPath.row] withKeyWords:self.search_Tf.text Label:label];
    }
    
    return cell;
}

-(void)setKeyWord:(NSString *)text withKeyWords:(NSString *)keyWord Label:(UILabel *)label{
    
    NSMutableArray * rangeArray1 = [VVAttrHeper vv_getRangeWithTotalString:text SubString:keyWord];
    keyWord = [keyWord uppercaseString];
    NSMutableArray * rangeArray2 = [VVAttrHeper vv_getRangeWithTotalString:text SubString:keyWord];
    NSMutableArray * rangeArray = [NSMutableArray array];
    [rangeArray addObjectsFromArray:rangeArray1];
    [rangeArray addObjectsFromArray:rangeArray2];
    
    NSRange range = [text rangeOfString:keyWord];
    if(range.location == 0){
        
        [rangeArray addObject:[NSNumber valueWithRange:range]];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    for(NSNumber *rangeNumber in rangeArray){
        
        NSRange range = [rangeNumber rangeValue];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    }
    
    label.attributedText = attributedString;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * str = [self.dataArray objectAtIndex:indexPath.row];
    if([str containsString:@"未查询"]){
        return;
    }
    tableView.hidden = YES;
    [self searchContentWithTitle:self.dataArray[indexPath.row]];
    [self.search_Tf resignFirstResponder];
    [self createHistoryView];
}

-(void)setNavi{
    
    self.navigationItem.hidesBackButton = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = TABLEVIEWCOLOR;
    
    //导航条设置
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    if(IS_IPHONE == IS_IPHONE_6||IS_IPHONE == IS_IPHONE_6P){
        
        self.backBtn.frame = CGRectMake(31/2.0*S6, 20.5/2*S6, 49/2.0*S6, 22.5*S6);
    }else{
        self.backBtn.frame = CGRectMake(31/2.0*S6, 22/2*S6, 49/2.0*S6, 22.5*S6);
    }
    
    [self.navigationController.navigationBar addSubview:self.backBtn];
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25*S6, 30*S6)];
    UITapGestureRecognizer * taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchActions)];
    [searchView addGestureRecognizer:taps];
    
    CGFloat height;
    if(IS_IPHONE == IS_IPHONE_6){
        height = 5.0*S6;
    }else if (IS_IPHONE == IS_IPHONE_6P){
        height = 6.0*S6;
    }else if (IS_IPHONE == IS_IPHONE_5){
        height = 2*S6;
    }
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0*S6,height, 32*S6, 41/2.0*S6);
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16*S6];
    [searchBtn addTarget:self action:@selector(searchActions) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    UIBarButtonItem * searBarBtn = [[UIBarButtonItem alloc]initWithCustomView:searchView];
    self.navigationItem.rightBarButtonItem = searBarBtn;
    
    [self createTextfield];
    //搜索
    UILabel * searchLabel = [Tools createLabelWithFrame:CGRectMake(17.5*S6, 12.5*S6+NAV_BAR_HEIGHT, 50*S6, 12*S6) textContent:@"最近搜索" withFont:[UIFont systemFontOfSize:12*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:searchLabel];
    
    UIButton * deleteBtn = [Tools createButtonNormalImage:@"delete_btn" selectedImage:nil tag:1 addTarget:self action:@selector(deleteAction)];
    deleteBtn.frame = CGRectMake(CGRectGetMaxX(searchLabel.frame)+283*S6, 12.5*S6+NAV_BAR_HEIGHT, 12*S6, 14*S6);
    [self.view addSubview:deleteBtn];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(17.5*S6, CGRectGetMaxY(deleteBtn.frame)+12.5*S6, Wscreen-35*S6, Hscreen)];
    [self.view addSubview:_bgView];
    [self createHistoryView];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_search_Tf resignFirstResponder];
}

-(void)createHistoryView{
    
    for(UIView * subView in _bgView.subviews){
        [subView removeFromSuperview];
    }
    self.search_Tf.text = nil;
    NetManager * manager = [NetManager shareManager];
    NSArray * dataArray = [manager getSearchContent];
    
    CGFloat width_sum = 0;
    int rows=0;
    int reset = 1;
    int j=0;
    for(int i=0;i<dataArray.count;i++){
        
        width_sum = [self getProductTextWidth:dataArray[i]]+width_sum;
        
        if(width_sum+j*10>_bgView.width){
            rows++;
            width_sum = [self getProductTextWidth:dataArray[i]];
            reset = 0;
            j = 0;
        }
        
        UILabel * label = [Tools createLabelWithFrame:CGRectMake(width_sum-[self getProductTextWidth:dataArray[i]]+10*S6*j*reset,rows*40*S6 , [self getProductTextWidth:dataArray[i]], 30*S6) textContent:dataArray[i] withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
        label.backgroundColor = RGB_COLOR(243, 243, 243, 1);
        label.layer.cornerRadius = 2.5*S6;
        label.layer.masksToBounds = YES;
        label.layer.borderWidth = 0;
        reset = 1;
        j++;
        [_bgView addSubview:label];
        
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBtn:)];
        [label addGestureRecognizer:tap];
    }
}

-(void)clickBtn:(UITapGestureRecognizer *)tap{
    
    UILabel * label = (UILabel *)tap.view;
    self.search_Tf.text = label.text;
    [self.search_Tf becomeFirstResponder];
    [self getDataWithText];
}

#pragma mark - 搜索网路请求
-(void)searchContentWithTitle:(NSString *)text{
    
    NetManager * manager = [NetManager shareManager];
    [manager saveSearchText:text];
    [self createHistoryView];
    BatarResultController * resultVc = [[BatarResultController alloc]initWithController:self];
    resultVc.param = text;
    [self pushToViewControllerWithTransition:resultVc withDirection:@"left" type:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(![self judgeSpace:textField.text]){
        return NO;
    }
    
    [self searchContentWithTitle:textField.text];
    [textField resignFirstResponder];
    [self createHistoryView];
    return YES;
}

-(BOOL)judgeSpace:(NSString *)text{
    
    NSArray * array = [text componentsSeparatedByString:@" "];
    NSInteger lenth = text.length;
    if(array.count-1 == lenth){
        return NO;
    }else{
        return YES;
    }
}

-(CGFloat)getProductTextWidth:(NSString *)text{
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30*S6) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*S6]} context:nil].size;
    return size.width+20*S6;
}

-(void)deleteAction{
    
    NetManager * manager = [NetManager shareManager];
    [manager cleanHistorySearch];
    [self createHistoryView];
}

#pragma mark - 搜索内容
-(void)searchActions{
    if(![self judgeSpace:_search_Tf.text]){
        return ;
    }
    [self searchContentWithTitle:self.search_Tf.text];
    [self createHistoryView];
    [self.search_Tf resignFirstResponder];
}

-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:NO];
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
    self.search_Tf = [[UITextField alloc]initWithFrame:CGRectMake((33+49+33)/2.0*S6, 8.0*S6, 262.5*S6, tf_Y*S6)];
    self.search_Tf.backgroundColor = [UIColor whiteColor];
    self.search_Tf.layer.cornerRadius = 5*S6;
    self.search_Tf.clipsToBounds = YES;
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,10*S6 , 55/2.0*S6)];
    self.search_Tf.leftView = leftView;
    self.search_Tf.clearButtonMode = UITextFieldViewModeAlways;
    self.search_Tf.delegate = self;
    self.search_Tf.leftViewMode =UITextFieldViewModeAlways;
    self.search_Tf.placeholder = @"输入您想要的宝贝";
    self.search_Tf.returnKeyType = UIReturnKeySearch;
    [self.navigationController.navigationBar addSubview:self.search_Tf];
    [self.search_Tf becomeFirstResponder];
    self.search_Tf.userInteractionEnabled = YES;
    [self.search_Tf addTarget:self action:@selector(getDataWithText) forControlEvents:UIControlEventEditingChanged];
    
    //改变输入框placeholder的字体大小和颜色
    [self.search_Tf setValue:RGB_COLOR(153, 153, 153, 1) forKeyPath:@"_placeholderLabel.textColor"];
    self.search_Tf.font = [UIFont systemFontOfSize:14*S6];
    //改变输入框输入时字体的颜色
    self.search_Tf.textColor = RGB_COLOR(153, 153, 153, 1);
    self.search_Tf.font = [UIFont systemFontOfSize:14*S6];
    self.search_Tf.layer.borderWidth = 1.0*S6;
    self.search_Tf.layer.borderColor = [RGB_COLOR(76, 66, 41, 1)CGColor];
}

-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(UITableView *)search_tableView{
    
    if(_search_tableView == nil){
        _search_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, Wscreen, Hscreen-NAV_BAR_HEIGHT)];
        _search_tableView.delegate = self;
        _search_tableView.dataSource = self;
        [self.view addSubview:_search_tableView];
        _search_tableView.hidden = YES;
        _search_tableView.tableFooterView = [[UIView alloc]init];
    }
    return _search_tableView;
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
