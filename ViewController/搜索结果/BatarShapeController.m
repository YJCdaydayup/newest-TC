//
//  BatarShapeController.m
//  DianZTC
//
//  Created by 杨力 on 3/1/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "BatarShapeController.h"
#import "RecommandImageModel.h"
#import "ScanViewController.h"
#import "SingleCollectionViewCell.h"
#import "BatarResultController.h"
#import "DetailViewController.h"
#import "BatarResultModel.h"
#import "MJRefresh.h"
#import "NetManager.h"

NSString * const singleCell = @"singleCell";

@interface BatarShapeController()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UIScrollViewDelegate>{
    
    NSInteger page;
}

@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UITextField * result_Tf;
@property (nonatomic,strong) UIButton * layoutBtn;
@property (nonatomic,strong) NSIndexPath * indexPath;

@end

@implementation BatarShapeController

@synthesize result_Tf = _result_Tf;
@synthesize layoutBtn = _layoutBtn;

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    _layoutBtn.hidden = NO;
    if(![self.fatherVc isKindOfClass:[ScanViewController class]]){
        self.result_Tf.hidden = NO;
        [self batar_setNavibar:nil];
    }else{
        self.result_Tf.hidden = YES;
        [self batar_setNavibar:@"搜索结果"];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    _result_Tf.hidden = YES;
    _layoutBtn.hidden = YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)createView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self batar_setLeftNavButton:@[@"return",@""] target:self selector:@selector(back) size:CGSizeMake(49/2.0*S6, 22.5*S6) selector:nil rightSize:CGSizeZero topHeight:12*S6];
    
    [self createTextfield];
    
    
    _layoutBtn = [Tools createNormalButtonWithFrame:CGRectMake(Wscreen-38*S6, 31, 22*S6, 22*S6) textContent:nil withFont:[UIFont systemFontOfSize:15*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentRight];
    [_layoutBtn setImage:[UIImage imageNamed:@"shape_nor"] forState:UIControlStateNormal];
    [_layoutBtn setImage:[UIImage imageNamed:@"shape_nor"] forState:UIControlStateHighlighted];
    [self.navigationController.view addSubview:_layoutBtn];
    _layoutBtn.selected = NO;
    [_layoutBtn addTarget:self action:@selector(changeLayout) forControlEvents:UIControlEventTouchUpInside];
    
    [self configCollectionView];
}

-(void)changeLayout{
    
    BatarResultController * resultVc = [[BatarResultController alloc]initWithController:[ScanViewController new]];
    resultVc.param = self.param;
    resultVc.currentIndexPath = self.currentIndexPath;
    resultVc.initialDataArray = self.dataArray;
    [self.navigationController pushViewController:resultVc animated:NO];
    [self removeNaviPushedController:self];
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
    self.result_Tf = [[UITextField alloc]initWithFrame:CGRectMake((33+49+33)/2.0*S6, 8.0*S6, 262.5*S6, tf_Y*S6)];
    [self.result_Tf resignFirstResponder];
    self.result_Tf.backgroundColor = [UIColor whiteColor];
    self.result_Tf.layer.cornerRadius = 5*S6;
    self.result_Tf.clipsToBounds = YES;
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,10*S6 , 55/2.0*S6)];
    self.result_Tf.leftView = leftView;
    self.result_Tf.clearButtonMode = UITextFieldViewModeAlways;
    self.result_Tf.leftViewMode =UITextFieldViewModeAlways;
    self.result_Tf.placeholder = @"输入您想要的宝贝";
    self.result_Tf.returnKeyType = UIReturnKeySearch;
    [self.navigationController.navigationBar addSubview:self.result_Tf];
    self.result_Tf.userInteractionEnabled = YES;
    //改变输入框placeholder的字体大小和颜色
    [self.result_Tf setValue:RGB_COLOR(153, 153, 153, 1) forKeyPath:@"_placeholderLabel.textColor"];
    self.result_Tf.font = [UIFont systemFontOfSize:14*S6];
    //改变输入框输入时字体的颜色
    self.result_Tf.delegate = self;
    self.result_Tf.textColor = RGB_COLOR(153, 153, 153, 1);
    self.result_Tf.font = [UIFont systemFontOfSize:14*S6];
    self.result_Tf.layer.borderWidth = 1.0*S6;
    self.result_Tf.layer.borderColor = [RGB_COLOR(76, 66, 41, 1)CGColor];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)back{
    [self popToViewControllerWithDirection:@"right" type:NO];
}


//设置表格
-(void)configCollectionView{
    
    UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc]init];
    [flowLayOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT+4*S6, Wscreen-4*S6, Hscreen-NAV_BAR_HEIGHT-4*S6) collectionViewLayout:flowLayOut];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    //[self.collectionView addHeaderWithTarget:self action:@selector(headerAction)];
    [self.collectionView addFooterWithTarget:self action:@selector(footerAction)];
    
    //注册Cell
    [self.collectionView registerClass:[SingleCollectionViewCell class] forCellWithReuseIdentifier:singleCell];
    
    //    [self.collectionView headerBeginRefreshing];
    [self headerAction];
}

-(void)headerAction{
    
    if(self.initialDataArray.count>0){
        
        [self getInitialData];
        [self.collectionView reloadData];
        //改变偏移位置
        [self changeScrollPosition];
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
        [self.initialDataArray removeAllObjects];
        return;
    }
    page = 0;
    [self createData];
}

#pragma mark - 改变偏移位置
-(void)changeScrollPosition{
    
    if(self.currentIndexPath.row<=4){
        self.indexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row inSection:self.currentIndexPath.section];
    }else{
        self.indexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row+5 inSection:self.currentIndexPath.section];
    }
    //    self.currentIndexPath = [[NSIndexPath alloc]initWithIndex:self.currentIndexPath.row+3];
    
    
    [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

-(void)getInitialData{
    
    [self.dataArray removeAllObjects];
    for(BatarResultModel * initialModel in self.initialDataArray){
        RecommandImageModel * model = [[RecommandImageModel alloc]init];
        model.number = initialModel.number;
        model.name = initialModel.name;
        model.img = initialModel.image;
        [self.dataArray addObject:model];
    }
}

-(void)footerAction{
    page ++;
    [self createData];
}

-(void)createData{
    
    [self.hud show:YES];
    
    NetManager * manager = [NetManager shareManager];
    NSString * URLstring = [NSString stringWithFormat:SEARCHURL,[manager getIPAddress]];
    self.param = [self.param stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString * str = [NSString stringWithFormat:@"%@?key=%@&",URLstring,self.param];
    NSString * pageStr = [NSString stringWithFormat:@"%zi",page];
    NSString * urlStr = [NSString stringWithFormat:@"%@page=%@&size=%@",str,pageStr,@"100"];
    [manager downloadDataWithUrl:urlStr parm:nil callback:^(id responseObject, NSError *error) {
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
                    
                    RecommandImageModel * model = [[RecommandImageModel alloc]init];
                    model.number = dict[@"number"];
                    model.name = dict[@"name"];
                    model.img = dict[@"image"];
                    [downArray addObject:model];
                }
            }else{
                NSMutableArray * muArray = obj;
                NSDictionary * muDict = muArray[0];
                NSArray * array = muDict[@"context"];
                for(int i=0;i<array.count;i++){
                    
                    RecommandImageModel * model = [[RecommandImageModel alloc]initWithDictionary:array[i] error:nil];
                    [downArray addObject:model];
                }
            }
            
            if(downArray.count==0){
                [self showAlertViewWithTitle:@"未找到更多产品信息"];
            }
            [self.dataArray addObjectsFromArray:downArray];
            if(self.dataArray.count==0){
                [self showAlertViewWithTitle:@"未搜到任何产品信息!"];
                [self.collectionView headerEndRefreshing];
                return;
            }
            [self.collectionView reloadData];
            [self.collectionView headerEndRefreshing];
            [self.collectionView footerEndRefreshing];
        }else{
            
            NSLog(@"%@",error.description);
        }
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

//返回Cell的代理方法
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SingleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:singleCell forIndexPath:indexPath];
    if(cell == nil){
        cell = [[SingleCollectionViewCell alloc]initWithFrame:CGRectMake(0,0, 0*S6, 179*S6)];
    }
    [cell configCell:self.dataArray[indexPath.row]];
    
    __block typeof(self)weakSelf = self;
    [cell clickImageView:^(NSString *number) {
        
        DetailViewController * detailVc = [[DetailViewController alloc]initWithController:self];
        detailVc.index = cell.number;
        [weakSelf.navigationController pushViewController:detailVc animated:YES];
    }];
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0,5*S6, 0*S6,0*S6);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(180.3*S6, 179*S6);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5*S6;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 6*S6;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.currentIndexPath = indexPath;
}

-(NSMutableArray *)dataArray{
    
    if(!_dataArray){
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}



@end
