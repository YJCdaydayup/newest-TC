//
//  SingleSearchCatagoryViewController.m
//  DianZTC
//
//  Created by 杨力 on 6/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "SingleSearchCatagoryViewController.h"
#import "CatagoryViewController.h"
#import "SingleCollectionViewCell.h"
#import "NetManager.h"
#import "MJRefresh.h"
#import "RecommandImageModel.h"
#import "DetailViewController.h"

//单个分类搜索Cell
#define singleCell @"singleCell"

@interface SingleSearchCatagoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
    NSInteger page;
}

//左导航按钮和导航栏标题
@property (nonatomic,strong) UIButton * navLeftButton;
@property (nonatomic,strong) UILabel * titlelabel;

//表格属性
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) NSMutableArray * dataArray;

//适配工具
@property (nonatomic,assign) CGFloat max_X;
@property (nonatomic,assign) CGFloat max_Y;
@end

@implementation SingleSearchCatagoryViewController

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
    [self configCollectionView];
    
    //请求数据
    [self createData];
}

-(void)headerAction{
    
    page = 0;
    [self createData];
}

-(void)footerAction{
    
    page ++;
    [self createData];
}

-(void)createData{
    
    [self.hud show:YES];
    
    NSDictionary * parmDict;
    NSString * urlStr;
    NetManager * manager = [NetManager shareManager];
    
    //判断参数的类型
    if([self.fatherVc isKindOfClass:[FirstViewController class]]){
        
        switch (self.vc_flag) {
            case 1:{
                urlStr = [NSString stringWithFormat:RECOMMANDCLICK,[manager getIPAddress]];
                parmDict = @{@"page":@(page+1),@"size":@"10",@"id":self.catagoryItem};
                self.titlelabel.text = self.themeTitle;
            }
                break;
            case 2:{
                urlStr = [NSString stringWithFormat:RecommandClickOther,[manager getIPAddress]];
                parmDict = @{@"page":@(page+1),@"size":@"10",@"id":self.catagoryItem};
                self.titlelabel.text = self.themeTitle;
            }
                break;
            case 3:
            {
                //拼接ip和port
                NSString * URLstring = [NSString stringWithFormat:CLICKMORE,[manager getIPAddress]];
                NSString * str = [NSString stringWithFormat:@"%@?id=%@",URLstring,self.catagoryItem];
                NSString * pageStr = [NSString stringWithFormat:@"%zi",page];
                parmDict = nil;
                urlStr = [NSString stringWithFormat:@"%@&page=%@&size=%@",str,pageStr,@"10"];
            }
                break;
                
            default:
                break;
        }
        
    }else{
        switch (self.vc_flag) {
                
            case 0:{
                //字典传过来
                NSString * URLstring = [NSString stringWithFormat:CATAGORYURL,[manager getIPAddress]];
                
                urlStr = URLstring;
                NSString * pageStr = [NSString stringWithFormat:@"%zi",page];
                NSString * otherParm = [NSString stringWithFormat:@"%@%@",pageStr,@"@10"];
                [self.parmDict setObject:otherParm forKey:@"others"];
                NSString * jsonStr = [self dictionaryToJson:self.parmDict];
                parmDict = @{@"parm":jsonStr};
            }
                break;
            case 1:
                //无参数
            {
                NSString * URLstring1 = [NSString stringWithFormat:RECOMMENDURL,[manager getIPAddress]];
                NSString * URLstring = [NSString stringWithFormat:URLstring1,[manager getIPAddress]];
                urlStr = URLstring;
                NSString * pageStr = [NSString stringWithFormat:@"%zi",page];
                parmDict = @{@"page":pageStr,@"itemperpage":@"10"};
            }
                break;
            case 2:
                //需要传参
            {
                //拼接ip和port
                NSString * URLstring = [NSString stringWithFormat:CATAGORYPUSHURL,[manager getIPAddress]];
                NSString * str = [NSString stringWithFormat:@"%@?id=%@",URLstring,self.catagoryItem];
                NSString * pageStr = [NSString stringWithFormat:@"%zi",page];
                parmDict = nil;
                urlStr = [NSString stringWithFormat:@"%@page=%@&itemperpage=%@",str,pageStr,@"10"];
            }
                break;
            case 3:
            {
            }
                break;
            default:
                break;
        }
    }
    
    [manager downloadDataWithUrl:urlStr parm:parmDict callback:^(id responseObject, NSError *error) {
        
        if(error == nil){
            [self.hud hide:YES];
            if(page == 0){
                [self.dataArray removeAllObjects];
            }
            id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray * downArray = [NSMutableArray array];
            if([obj isKindOfClass:[NSDictionary class]]){
                
                if([obj[@"page"]isKindOfClass:[NSArray class]]){
                    NSMutableArray * muArray = obj[@"page"];
                    for(NSDictionary * dict in muArray){
                        
                        RecommandImageModel * model = [[RecommandImageModel alloc]init];
                        model.number = dict[@"number"];
                        model.name = dict[@"name"];
                        model.img = dict[@"image"];
                        [downArray addObject:model];
                    }
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
    [self.navLeftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //导航条标题
    NSString * titleStr;
    
    if(self.catagoryItem){
        if(self.vc_flag==3){
            titleStr = @"更多";
        }else{
            titleStr = self.catagoryItem;
        }
    }else{
        if([[kUserDefaults objectForKey:@"temp"] isEqualToString:@"1"]){
            titleStr = @"新款产品";
        }else if([[kUserDefaults objectForKey:@"temp"]isEqualToString:@"2"]){
            titleStr = @"人气产品";
        }else{
            titleStr = @"分类搜索列表";
        }
    }
    
    self.titlelabel = [Tools createLabelWithFrame:CGRectMake(10, 10, 100*S6, 20*S6) textContent:titleStr
                                         withFont:[UIFont systemFontOfSize:17*S6] textColor:RGB_COLOR(0, 0, 0, 1) textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = self.titlelabel;
}

//设置表格
-(void)configCollectionView{
    
    UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc]init];
    [flowLayOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Wscreen-4*S6, Hscreen) collectionViewLayout:flowLayOut];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView addHeaderWithTarget:self action:@selector(headerAction)];
    [self.collectionView addFooterWithTarget:self action:@selector(footerAction)];
    
    //注册Cell
    [self.collectionView registerClass:[SingleCollectionViewCell class] forCellWithReuseIdentifier:singleCell];
    
    [self.collectionView headerBeginRefreshing];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

//返回Cell的代理方法
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SingleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:singleCell forIndexPath:indexPath];
    if(cell == nil){
        
        cell = [[SingleCollectionViewCell alloc]initWithFrame:CGRectMake(0,0, 173*S6, 160*S6)];
    }
    
    [cell configCell:self.dataArray[indexPath.row]];
    
    __block typeof(self)weakSelf = self;
    [cell clickImageView:^(NSString *number) {
        
        DetailViewController * detailVc = [[DetailViewController alloc]init];
        detailVc.index = cell.number;
        detailVc.isFromSearchVc = YES;
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

//返回到上一个界面
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
    
    
    [[SDImageCache sharedImageCache]cleanDisk];
    [[SDImageCache sharedImageCache]clearMemory];
    
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
