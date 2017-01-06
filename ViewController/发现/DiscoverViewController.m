//
//  DiscoverViewController.m
//  DianZTC
//
//  Created by 杨力 on 26/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "DiscoverViewController.h"
#import "SingleCollectionViewCell.h"
#import "DetailViewController.h"
#import "NetManager.h"
#import "MJRefresh.h"


#define singleCell @"singleCell"

@interface DiscoverViewController()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
    NSInteger page;
}

@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation DiscoverViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self batar_setNavibar:@"发现"];
}

-(void)createView{
    
    [self configCollectionView];
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

-(void)headerAction{
    
    page = 0;
    [self createData];
}

-(void)footerAction{
    
    page ++;
    [self createData];
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

-(NSMutableArray *)dataArray{
    
    if(!_dataArray){
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

@end
