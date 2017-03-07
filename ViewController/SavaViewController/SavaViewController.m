//
//  SavaViewController.m
//  DianZTC
//
//  Created by 杨力 on 4/9/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "SavaViewController.h"
#import "SaveCollectionCell.h"
#import "RecommandImageModel.h"
#import "DetailViewController.h"
#import "DBWorkerManager.h"
#import "DBSaveModel.h"
#import "SaveContolView.h"
#import "MyViewController.h"
#import "FinalOrderViewController.h"
#import "NetManager.h"

//Cell
NSString * const saveCell = @"saveCell";

@interface SavaViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
    SaveContolView * controlView;
    UIButton * editBtn;
    UIAlertController * alertController;
    BOOL reloadAfterDetete;
}

//左导航按钮和导航栏标题
@property (nonatomic,strong) UIButton * navLeftButton;
@property (nonatomic,strong) UILabel * titlelabel;

//表格属性
@property (nonatomic,strong) UICollectionView * collectionViews;
@property (nonatomic,strong) NSMutableArray * dataArray;

//适配工具
@property (nonatomic,assign) CGFloat max_X;
@property (nonatomic,assign) CGFloat max_Y;

//存储选中的item
@property (nonatomic,strong) NSMutableArray * selectArray;

//全选数组
@property (nonatomic,assign) BOOL isSelectedAll;

@property (nonatomic,strong) DBWorkerManager * manager;

@end

@implementation SavaViewController

@synthesize manager = _manager;
@synthesize collectionViews = _collectionViews;

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SaveOrNotSave object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dateChanged) name:SaveOrNotSave object:nil];
    
    _manager = [DBWorkerManager shareDBManager];
    [_manager createSaveDB];
    
    [self createView];
    //设置表格
    [self configCollectionView];
    //数据
    [self createData];
}

-(void)dateChanged{
    
    [self createData];
}

-(void)createView{
    
    //隐藏系统“back”左导航按钮
    self.navigationItem.hidesBackButton = YES;
    
    //导航条设置
    [self batar_setLeftNavButton:@[@"return",@""] target:self selector:@selector(backAct) size:CGSizeMake(49/2.0*S6, 22.5*S6) selector:nil rightSize:CGSizeZero topHeight:12*S6];
    
    //导航条标题
    NSString * titleStr = @"我的收藏";
    
    self.titlelabel = [Tools createLabelWithFrame:CGRectMake(10, 10, 100*S6, 20*S6) textContent:titleStr withFont:[UIFont systemFontOfSize:17*S6] textColor:RGB_COLOR(0, 0, 0, 1) textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = self.titlelabel;
    editBtn = [Tools createNormalButtonWithFrame:CGRectMake(0, 0, 40*S6, 35*S6) textContent:@"编辑" withFont:[UIFont systemFontOfSize:17*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentRight];
    [editBtn setTitle:@"取消" forState:UIControlStateSelected];
    [editBtn addTarget:self action:@selector(editSaveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * editbarBtn = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = editbarBtn;
    
    //底部控制栏
    [self setBottomVc];
}

-(void)setBottomVc{
    //添加底部控制栏
    controlView = [[SaveContolView alloc]init];
    [self.view addSubview:controlView];
    __block typeof(self)weakSelf = self;
    //点击删除按钮
    [controlView clickDeleteBtn:^{
        
        if(weakSelf.selectArray.count == 0){
            alertController = [UIAlertController alertControllerWithTitle:@"暂未选择任何收藏产品" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [weakSelf presentViewController:alertController animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return ;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController * alertController1 = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction * action;
            UIAlertAction * action1;
            
            action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            action1 = [UIAlertAction actionWithTitle:@"移除收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [weakSelf deleteSave];
            }];
            
            [action1 setValue:[UIColor redColor] forKey:@"titleTextColor"];
            
            [self presentViewController:alertController1 animated:YES completion:^{
                
            }];
            [alertController1 addAction:action1];
            [alertController1 addAction:action];
        });
    }];
    //批量收藏
    [controlView clickSelectAll:^{
        [weakSelf selectAllCell];
    }];
}

-(void)selectAllCell{
    
    self.isSelectedAll = !self.isSelectedAll;
    controlView.selectAllBtn.selected = self.isSelectedAll;
    for(DBSaveModel * model in self.dataArray){
        if(self.isSelectedAll){
            //全选
            model.selected = YES;
            if(![self.selectArray containsObject:model]){
                [self.selectArray addObject:model];
            }
        }else{
            //取消全选
            model.selected = NO;
            [self.selectArray removeObject:model];
        }
    }
    [self.collectionViews reloadData];
}

//设置表格
-(void)configCollectionView{
    
    UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc]init];
    [flowLayOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionViews = [[UICollectionView alloc]initWithFrame:CGRectMake(0,10*S6+NAV_BAR_HEIGHT,Wscreen, Hscreen-50*S6-NAV_BAR_HEIGHT) collectionViewLayout:flowLayOut];
    [_collectionViews registerClass:[SaveCollectionCell class] forCellWithReuseIdentifier:saveCell];
    _collectionViews.delegate = self;
    _collectionViews.dataSource = self;
    _collectionViews.userInteractionEnabled = YES;
    _collectionViews.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionViews];
    [self.view bringSubviewToFront:controlView];
}

-(void)createData{
    
    [self.dataArray removeAllObjects];
    
    if(CUSTOMERID){
        [self.hud show:YES];
        //从服务器获取收藏信息
        NetManager * manager = [NetManager shareManager];
        NSString * urlStr = [NSString stringWithFormat:GetSaveURL,[manager getIPAddress]];
        NSDictionary * dict = @{@"user":CUSTOMERID,@"page":@"0",@"size":@"100"};
        [manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
            //DBSaveModel
            if(error == nil){
                [self.hud hide:YES];
                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                if(dict){
                    
                    if(![dict[@"page"]isKindOfClass:[NSArray class]]){
                        return ;
                    }
                    
                    NSArray * array = [dict objectForKey:@"page"];
                    if(array.count>0){
                        for(NSDictionary * subDict in array){
                            DBSaveModel * model = [[DBSaveModel alloc]init];
                            model.name = subDict[@"name"];
                            model.number = subDict[@"number"];
                            model.image = subDict[@"image"];
                            model.selected = NO;
                            [self.dataArray addObject:model];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_collectionViews reloadData];
                        });
                    }else{
                        for(UIView * subView in self.view.subviews){
                            [subView removeFromSuperview];
                        }
                        [self showIndicator];
                    }
                }
            }
        }];
    }else{
        [_manager getAllObject:^(NSMutableArray *dataArray) {
            
            if(dataArray.count==0){
                for(UIView * subView in self.view.subviews){
                    [subView removeFromSuperview];
                }
                [self showIndicator];
            }else{
                self.dataArray = dataArray;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_collectionViews reloadData];
            });
        }];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

//返回Cell的代理方法
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SaveCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:saveCell forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[SaveCollectionCell alloc]initWithFrame:CGRectMake(0,0, 10*S6, 165/2.0*S6)];
    }
    [cell configCellWithModel:self.dataArray[indexPath.row]];
    [cell clickSelectedBtn:^(UIButton *button) {
        
        if(editBtn.selected){
            DBSaveModel * model = self.dataArray[indexPath.row];
            button.selected = !button.selected;
            if(button.selected){
                [self.selectArray addObject:model];
                cell.maskView.hidden = NO;
                model.selected = YES;
                
                if(self.selectArray.count == self.dataArray.count){
                    controlView.selectAllBtn.selected = YES;
                    self.isSelectedAll = YES;
                }
                
            }else{
                cell.maskView.hidden = YES;
                [self.selectArray removeObject:model];
                model.selected = NO;
                controlView.selectAllBtn.selected = NO;
                self.isSelectedAll = NO;
            }
        }
    }];
    
    //对于没有生成的cell，滑动界面时，就会生成，这个时候，需要再次发送编辑通知
    if(editBtn.selected){
        [[NSNotificationCenter defaultCenter]postNotificationName:SaveCellEditNotification object:nil];
    }
    
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 17.5*S6, 0, 17.5*S6);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(110*S6, (82.5+73/2.0)*S6);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SaveCollectionCell * cell = (SaveCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if(editBtn.selected == NO){
        cell.saveImgView.userInteractionEnabled = NO;
        DetailViewController * detailVc = [[DetailViewController alloc]initWithController:self];
        DBSaveModel * model = [self.dataArray objectAtIndex:indexPath.row];
        detailVc.index = model.number;
        [self.navigationController pushViewController:detailVc animated:NO];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(editBtn.selected){
        return NO;
    }else{
        return YES;
    }
}

//删除收藏
-(void)deleteSave{
    
    if(CUSTOMERID){
        //删除服务端
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.labelText = @"正在删除中...";
        self.hud.animationType = MBProgressHUDAnimationZoomOut;
        
        
        NSMutableArray * numberArray = [NSMutableArray array];
        for(DBSaveModel * model in self.selectArray){
            [numberArray addObject:model.number];
        }
        NSDictionary * dict = @{@"user":CUSTOMERID,@"numberlist":[self myArrayToJson:numberArray]};
        NetManager * manager = [NetManager shareManager];
        NSString * urlStr = [NSString stringWithFormat:DeleteSaveURL,[manager getIPAddress]];
        [manager downloadDataWithUrl:urlStr parm:dict callback:^(id responseObject, NSError *error) {
            
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if([[dict objectForKey:@"state"]integerValue]){
                self.hud.labelText = @"删除成功!";
                controlView.selectAllBtn.selected = NO;
                self.isSelectedAll = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.hud hide:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self createData];
                    });
                });
            }
        }];
    }else{
        //删除本地
        for(DBSaveModel * model in self.selectArray){
            [_manager cleanDBDataWithNumber:model.number];
            [_manager cleanDataCacheWithNumber:model.number];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createData];
        });
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:SaveCellDeleteNotification object:nil];
    //删除本地选中的model
    [self.selectArray removeAllObjects];
    //改变编辑栏状态
    if(self.dataArray.count==0){
        editBtn.selected = NO;
    }else{
        editBtn.selected = YES;
    }
}

-(void)showIndicator{
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 35)];
    label.text = @"您的收藏夹空空如也!";
    label.font = [UIFont fontWithName:@"Arial" size:16*S6];
    label.center = self.view.center;
    label.font = [UIFont systemFontOfSize:19*S6];
    label.textColor = RGB_COLOR(29, 29, 29, 0.5);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

#pragma mark -编辑cell
-(void)editSaveAction{
    
    if(!CUSTOMERID){
        if(![_manager judgeSaveFileExists]){
            return;
        }
    }
    
    editBtn.selected = !editBtn.selected;
    if(!editBtn.selected){
        //取消编辑
        [[NSNotificationCenter defaultCenter]postNotificationName:SaveCellCancelEditNotification object:nil];
        controlView.hidden = YES;
    }else{
        //编辑
        controlView.hidden = NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:SaveCellEditNotification object:nil];
    }
    
    //回归初始状态
    for(DBSaveModel * model in self.dataArray){
        model.selected = NO;
    }
    [self.selectArray removeAllObjects];
    [self.collectionViews reloadData];
    
    self.isSelectedAll = NO;
    controlView.selectAllBtn.selected = NO;
}

//返回到上一个界面
-(void)backAct{
    [self popToViewControllerWithDirection:@"right" type:NO];
}

-(NSMutableArray *)dataArray{
    
    if(!_dataArray){
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(NSMutableArray *)selectArray{
    
    if(_selectArray == nil){
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
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
