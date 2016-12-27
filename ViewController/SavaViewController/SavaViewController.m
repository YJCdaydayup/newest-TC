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

//单个分类搜索Cell
#define saveCell @"saveCell"

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
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) NSMutableArray * dataArray;

//适配工具
@property (nonatomic,assign) CGFloat max_X;
@property (nonatomic,assign) CGFloat max_Y;

//“编辑”时，强制刷新表格
@property (nonatomic,strong) NSMutableArray * indexPathArray;
//存储选中的item的numberID
@property (nonatomic,strong) NSMutableArray * numberIDArray;
//存储cell
@property (nonatomic,strong) NSMutableArray * cellArray;


//全选数组
@property (nonatomic,assign) BOOL isSelectedAll;

@end

@implementation SavaViewController
singleM(SaveController)

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [kUserDefaults removeObjectForKey:SHOWSAVEBUTTON];
    
    for(UIView * subView in self.view.subviews){
        [subView removeFromSuperview];
    }
    [self setVc];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [kUserDefaults removeObjectForKey:SHOWSAVEBUTTON];
}

-(void)configUI{
    
    //导航条设置
    [self batar_setLeftNavButton:@[@"return",@""] target:self selector:@selector(backAct) size:CGSizeMake(49/2.0*S6, 22.5*S6) selector:nil rightSize:CGSizeZero topHeight:12*S6];
    
    //导航条标题
    NSString * titleStr = @"我的收藏";
    
    self.titlelabel = [Tools createLabelWithFrame:CGRectMake(10, 10, 100*S6, 20*S6) textContent:titleStr
                                         withFont:[UIFont systemFontOfSize:17*S6] textColor:RGB_COLOR(0, 0, 0, 1) textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = self.titlelabel;
    editBtn = [Tools createNormalButtonWithFrame:CGRectMake(0, 0, 40*S6, 35*S6) textContent:@"编辑" withFont:[UIFont systemFontOfSize:17*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentRight];
    [editBtn addTarget:self action:@selector(editSaveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * editbarBtn = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = editbarBtn;
}

-(void)setVc{
    
    //    隐藏系统“back”左导航按钮
    self.navigationItem.hidesBackButton = YES;
    
    //设置表格
    [self configCollectionView];
    
    //请求数据
    [self createData];
    
    //添加底部控制栏
    controlView = [[SaveContolView alloc]init];
    [self.view addSubview:controlView];
    
    //批量取消收藏
    [controlView clickDeleteBtn:^{
        
        [self selectAllCell];
    }];
    
    //点击删除按钮
    [controlView clickCancelBtn:^{
        
        if(self.numberIDArray.count == 0){
            alertController = [UIAlertController alertControllerWithTitle:@"暂未选择任何收藏产品" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return ;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            __block typeof(self)weakSelf = self;
            UIAlertController * alertController1 = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction * action;
            UIAlertAction * action1;
            
            action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            action1 = [UIAlertAction actionWithTitle:@"移除收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [weakSelf finalizeDeleteSaveList];
            }];
            
            [action1 setValue:[UIColor redColor] forKey:@"titleTextColor"];
            
            [self presentViewController:alertController1 animated:YES completion:^{
                
            }];
            [alertController1 addAction:action1];
            [alertController1 addAction:action];
        });
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self configUI];
}

-(void)selectAllCell{
    
    self.isSelectedAll = !self.isSelectedAll;
    for(int i=0;i<self.cellArray.count;i++){
        
        SaveCollectionCell * cell = self.cellArray[i];
        NSIndexPath * indexPath = self.indexPathArray[i];
        DBSaveModel * model = self.dataArray[indexPath.row];
        if(self.isSelectedAll){
            cell.seletedBtn.selected = YES;
            [self.numberIDArray addObject:model.number];
            cell.maskView.hidden = NO;
            controlView.deleteBtn.selected = YES;
        }else{
            cell.seletedBtn.selected = NO;
            [self.numberIDArray removeObject:model.number];
            cell.layer.borderWidth = 0;
            cell.layer.borderColor = [[UIColor redColor]CGColor];
            cell.maskView.hidden = YES;
            controlView.deleteBtn.selected = NO;
        }
    }
}

-(void)finalizeDeleteSaveList{
    
    DBWorkerManager * manager = [DBWorkerManager shareDBManager];
    for(NSString * number in self.numberIDArray){
        [manager cleanDataCacheWithNumber:number];
        [manager cleanDBDataWithNumber:number];
    }
    editBtn.selected = NO;
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [kUserDefaults removeObjectForKey:SHOWSAVEBUTTON];
    [self.numberIDArray removeAllObjects];
    controlView.hidden = YES;
    
    [self createData];
    [self resetView];
}

-(void)resetView{
    
    for(SaveCollectionCell * cell in self.cellArray){
        cell.seletedBtn.hidden = YES;
        cell.maskView.hidden = YES;
    }
    
    editBtn.selected = NO;
    [kUserDefaults removeObjectForKey:SHOWSAVEBUTTON];
    [self.numberIDArray removeAllObjects];
    controlView.hidden = YES;
    
    if(self.dataArray.count>0){
        [self.collectionView reloadItemsAtIndexPaths:self.indexPathArray];
    }else{
        [self.collectionView removeFromSuperview];
        [self showIndicator];
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

-(void)createData{
    
    DBWorkerManager * manager = [DBWorkerManager shareDBManager];
    [manager getAllObject:^(NSMutableArray *dataArray) {
        
        self.dataArray = dataArray;
        if(self.dataArray.count > 0){
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark -编辑cell
-(void)editSaveAction{
    
    DBWorkerManager * manager = [DBWorkerManager shareDBManager];
    if(![manager judgeSaveFileExists]){
        return;
    }
    
    editBtn.selected = !editBtn.selected;
    if(!editBtn.selected){
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self resetView];
    }else{
        [kUserDefaults setObject:SHOWSAVEBUTTON forKey:SHOWSAVEBUTTON];
        controlView.hidden = NO;
        [self.numberIDArray removeAllObjects];
        [self.collectionView reloadItemsAtIndexPaths:self.indexPathArray];
        editBtn.selected = YES;
        for(SaveCollectionCell * cell in self.cellArray){
            cell.seletedBtn.hidden = NO;
        }
        [editBtn setTitle:@"取消" forState:UIControlStateNormal];
        self.isSelectedAll = NO;
        controlView.deleteBtn.selected = NO;
    }
}

//设置表格
-(void)configCollectionView{
    
    UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc]init];
    [flowLayOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,10*S6, Wscreen, Hscreen) collectionViewLayout:flowLayOut];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    //注册Cell
    [self.collectionView registerClass:[SaveCollectionCell class] forCellWithReuseIdentifier:saveCell];
    
    DBWorkerManager * manager = [DBWorkerManager shareDBManager];
    [manager getAllObject:^(NSMutableArray *dataArray) {
        
        if(dataArray.count==0){
            [self showIndicator];
        }else{
            
        }
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(self.indexPathArray.count>0){
        [self.indexPathArray removeAllObjects];
    }
    if(self.cellArray.count>0){
        [self.cellArray removeAllObjects];
    }
    
    return self.dataArray.count;
}

//返回Cell的代理方法
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SaveCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:saveCell forIndexPath:indexPath];
    if(cell == nil){
        cell = [[SaveCollectionCell alloc]initWithFrame:CGRectMake(0,0, 10*S6, 165/2.0*S6)];
    }
    
    cell.seletedBtn.selected = NO;
    [self.indexPathArray addObject:indexPath];
    [cell configCellWithModel:self.dataArray[indexPath.row]];
    [cell clickSelectedBtn:^(UIButton *button) {
        
        DBSaveModel * model = self.dataArray[indexPath.row];
        button.selected = !button.selected;
        if(button.selected){
            [self.numberIDArray addObject:model.number];
            cell.maskView.hidden = NO;
        }else{
            cell.maskView.hidden = YES;
            [self.numberIDArray removeObject:model.number];
        }
    }];
    
    [self.cellArray addObject:cell];
    
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

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(editBtn.selected){
        
        SaveCollectionCell * cell = self.cellArray[indexPath.row];
        DBSaveModel * model = self.dataArray[indexPath.row];
        cell.seletedBtn.selected = !cell.seletedBtn.selected;
        if(cell.seletedBtn.selected){
            [self.numberIDArray addObject:model.number];
            cell.maskView.hidden = NO;
        }else{
            [self.numberIDArray removeObject:model.number];
            cell.layer.borderWidth = 0;
            cell.layer.borderColor = [[UIColor redColor]CGColor];
            cell.maskView.hidden = YES;
        }
        
        if(self.numberIDArray.count == self.cellArray.count){
            self.isSelectedAll = YES;
            controlView.deleteBtn.selected = YES;
        }else{
            self.isSelectedAll = NO;
            controlView.deleteBtn.selected = NO;
        }
        return;
    }
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    DetailViewController * detailVc = [[DetailViewController alloc]init];
    detailVc.fromSaveVc = 1;
    DBSaveModel * model = [self.dataArray objectAtIndex:indexPath.row];
    detailVc.number = model.number;
    detailVc.isFromSaveVc = YES;//等于YES表示从收藏界面push过去的
    [self pushToViewControllerWithTransition:detailVc withDirection:@"left" type:NO];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//返回到上一个界面
-(void)backAct{
    
    NSString * str = [kUserDefaults objectForKey:FROM_VC_TO_SAVE];
    if([str isEqualToString:@"mine"]||[str isEqualToString:@"order"]){
        [self popToViewControllerWithDirection:@"right" type:NO];
        return;
    }
    
    NSString * str2 = [kUserDefaults objectForKey:TEMP_FROM_VC_TO_SAVE];
    
    if([str2 isEqualToString:@"mine"]){
        
        MyViewController * myVc = [[MyViewController alloc]init];
        [self pushToViewControllerWithTransition:myVc withDirection:@"right" type:NO];
        return;
    }
    
    if([str2 isEqualToString:@"order"]){
        
        FinalOrderViewController * finalVc = [[FinalOrderViewController alloc]init];
        finalVc.isFromSavaVc = YES;
        [self pushToViewControllerWithTransition:finalVc withDirection:@"right" type:NO];
        return;
    }
    
    if([[kUserDefaults objectForKey:SAVE_PUSH_FLAG]integerValue]>0){
        
        //从收藏也“push”回来的
        DetailViewController * detailVc = [[DetailViewController alloc]init];
        detailVc.fromSaveVc = 0;
        detailVc.index = [kUserDefaults objectForKey:LONG_PRODUCT_ID];
        [self pushToViewControllerWithTransition:detailVc withDirection:@"right" type:NO];
        return;
    }
    [self popToViewControllerWithDirection:@"right" type:NO];
}

-(NSMutableArray *)dataArray{
    
    if(!_dataArray){
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(NSMutableArray *)indexPathArray{
    
    if(_indexPathArray == nil){
        
        _indexPathArray = [NSMutableArray array];
    }
    return _indexPathArray;
}

-(NSMutableArray *)numberIDArray{
    
    if(_numberIDArray == nil){
        _numberIDArray = [NSMutableArray array];
    }
    return _numberIDArray;
}

-(NSMutableArray *)cellArray{
    if(_cellArray == nil){
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
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
