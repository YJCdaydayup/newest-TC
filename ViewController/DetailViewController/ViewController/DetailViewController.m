//
//  DetailViewController.m
//  DianZTC
//
//  Created by 杨力 on 7/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "DetailViewController.h"
#import "NetManager.h"
#import "DetailModel.h"
#import "YLScrollerView.h"
#import "DBWorkerManager.h"
#import "STPhotoBrowserController.h"
#import "YLOrderControlView.h"
#import "YLVoicemanagerView.h"
#import "SavaViewController.h"
#import "MyOrdersController.h"
#import "YLShareView.h"
#import "YLLoginView.h"
#import "AppDelegate.h"

@interface DetailViewController ()<YLScrollerViewDelegate,STPhotoBrowserDelegate>{
    
    //详情model
    DetailModel * detailModel;
    
    NSMutableArray * modelArray; //排序后保存图片url
    
    //缩略图
    NSInteger currentPhotoIndex;
    
    //滑动背景
    UIScrollView * scrollerView;
    UIView * backgroundView;
    UIView * largeImgBgView;//大图的背景图
    UIScrollView * ylsubScrollView;
    
    //获取ylScrollerView的图组合当前图
    NSMutableArray * allImageArray;
    
    id obj;//获取下载下载的二进制文件
    NSString * numberID;
    
    BOOL isSaved;//是否收藏
    
    YLOrderControlView * bottomControlView;
    
    UIButton * save_Button;
}
//左导航按钮和导航栏标题
@property (nonatomic,strong) UIButton * navLeftButton;
@property (nonatomic,strong) UILabel * titlelabel;

//四个图片属性
@property (nonatomic,strong) UIImageView * largeImageView;
@property (nonatomic,strong) UIImageView * imageView1;
@property (nonatomic,strong) UIImageView * imageView2;
@property (nonatomic,strong) UIImageView * imageView3;

//适配工具
@property (nonatomic,assign) CGFloat max_X;
@property (nonatomic,assign) CGFloat max_Y;

@property (nonatomic,strong) NSMutableArray * sortItemsArray;

//中间滑动图片
@property (nonatomic,strong) YLScrollerView * ylScrollerView;
@property (nonatomic,strong) UIView * bgView;

//第三方分享
@property (nonatomic,strong) STShareTool * shareTool;
@property (nonatomic,strong) YLShareView * shareView;

//判断是否上传成功的状态
@property (nonatomic,assign) BOOL isUpload;

@end

@implementation DetailViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navLeftButton.hidden = NO;
    self.titlelabel.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navLeftButton.hidden = YES;
    self.titlelabel.hidden = YES;
    
    //    self.ylScrollerView = nil;
    //    [self.ylScrollerView removeFromSuperview];
    
    //移除消息路径
    [kUserDefaults removeObjectForKey:RECORDPATH];
    
    //将播放停止
    YLVoicemanagerView * voiceManager = [[YLVoicemanagerView alloc]initWithFrame:self.view.frame withVc:[UIView new]];
    [voiceManager stopWhenPushAway];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [kUserDefaults setObject:@"123" forKey:CustomerID];
    //    [kUserDefaults removeObjectForKey:CustomerID];
    //    NSLog(@"%@",self.index);
    [self createView];
}

-(void)createView{
    self.navigationItem.hidesBackButton = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createBgView];
    
    [self configUI];
    [self createData];
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction)];
    [self.view addGestureRecognizer:swipe];
}

-(void)swipeAction{
    
    CATransition * animation = [CATransition animation];
    animation.type = kCATransitionReveal;
    animation.duration = 0.5f;
    animation.subtype = kCATransitionFromLeft;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [self.navigationController.view.layer addAnimation:animation forKey:@"123"];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)createBgView{
    
    scrollerView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollerView.userInteractionEnabled = YES;
    scrollerView.contentSize = CGSizeMake(Wscreen, 880*S6);
    [self.view addSubview:scrollerView];
    
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 880*S6)];
    [scrollerView addSubview:backgroundView];
}

-(YLScrollerView *)ylScrollerView{
    
    if(_ylScrollerView == nil){
        
        _ylScrollerView = [YLScrollerView shareImageManager];
        _ylScrollerView.delegate = self;
        ylsubScrollView = _ylScrollerView.scollerView;
        [self.bgView addSubview:_ylScrollerView];
    }
    return _ylScrollerView;
}

-(void)getSmallImageArray{
    
    NSMutableArray * imageArray = detailModel.imgs;
    
    modelArray = [NSMutableArray array];
    for(int i=0;i<imageArray.count;i++){
        
        NSDictionary * dict = imageArray[i];
        //拼接ip和port
        NetManager * manager = [NetManager shareManager];
        NSString * URLstring = [NSString stringWithFormat:BANNERCONNET,[manager getIPAddress]];
        [modelArray addObject:[NSString stringWithFormat:@"%@%@",URLstring,dict[@"img"]]];
    }
    //暂时给每个图片添加示例图片
    currentPhotoIndex = 0;
    UIImage * gifImage = [UIImage imageNamed:PLACEHOLDER];
    if (modelArray.count > 0) {
        [self.largeImageView  sd_setImageWithURL:[NSURL URLWithString:modelArray[0]] placeholderImage:gifImage];
    }
    
    [self.ylScrollerView configScrollView:NO WithArray:modelArray];
    allImageArray = [[NSMutableArray alloc]initWithArray:self.ylScrollerView.totalImgArray];
    
    //给大图添加缩略图效果
    if(modelArray.count > 0){
        self.largeImageView.userInteractionEnabled = YES;
    }
    UITapGestureRecognizer * zoomAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomActions)];
    [self.largeImageView addGestureRecognizer:zoomAction];
}

#pragma mark -点击图片放大效果
-(void)zoomActions{
    
    //原图父控件避免越界
    for(int i=0;i<modelArray.count;i++){
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:largeImgBgView.bounds];
        [largeImgBgView addSubview:imgView];
    }
    
    //启动图片浏览器
    STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
    browserVc.sourceImagesContainerView = largeImgBgView; // 原图的父控件
    browserVc.countImage = modelArray.count; // 图片总数
    browserVc.currentPage = currentPhotoIndex;
    browserVc.delegate = self;
    [browserVc show];
}

#pragma mark - photobrowser代理方法
- (NSURL *)photoBrowser:(STPhotoBrowserController *)browser highQualityImageURLForIndex:(NSInteger)index
{
    //    NSLog(@"返回图片的网站");
    if(modelArray.count>0){
        return [NSURL URLWithString:modelArray[index]];
    }else{
        return nil;
    }
}

- (UIImage *)photoBrowser:(STPhotoBrowserController *)browser placeholderImageForIndex:(NSInteger)index
{
    //    NSLog(@"返回UIImage");
    NSMutableArray * subImageArray = [NSMutableArray array];
    for(UIView * subView in self.ylScrollerView.scollerView.subviews){
        if([subView isKindOfClass:[UIImageView class]]){
            UIImageView * imgView = (UIImageView *)subView;
            [subImageArray addObject:imgView];
        }
    }
    return self.largeImageView.image;
}

-(void)photoBrowser:(STPhotoBrowserController *)browser getCurrentIndex:(NSInteger)currentIndex{
    
    currentPhotoIndex = currentIndex;
    UIImageView * currentImg = allImageArray[currentIndex];
    [self didClickScrollerImage:currentIndex withImageView:currentImg withImgArray:allImageArray];
    //自动改变contenOffSet
    if(allImageArray.count>3){
        
        if(currentImg.tag >= 1&&currentImg.tag !=0&&currentImg.tag != allImageArray.count-1){
            [ylsubScrollView setContentOffset:CGPointMake(115*S6*(currentImg.tag-1), 0)];
        }
    }
}

#pragma mark -YLScrollerViewDelegate
-(void)didClickScrollerImage:(NSInteger)index withImageView:(UIImageView *)imageView withImgArray:(NSMutableArray *)imgArray{
    
    UIImage * gifImage = [UIImage imageNamed:PLACEHOLDER];
    [self.largeImageView  sd_setImageWithURL:[NSURL URLWithString:modelArray[index]] placeholderImage:gifImage];
    
    for(int i=0;i<imgArray.count;i++){
        
        UIImageView * imgView = imgArray[i];
        imgView.layer.borderColor = [BTNBORDCOLOR CGColor];
        imgView.layer.borderWidth = 1*S6;
    }
    imageView.layer.borderWidth = 2.5f*S6;
    imageView.layer.borderColor = [RGB_COLOR(231, 140, 59, 1) CGColor];
    currentPhotoIndex = index;
}

#pragma mark -获取珠宝数据
-(void)createData{
    
    [self.ylScrollerView clearSubViews];
    
    if(self.fromSaveVc == 0||self.fromSaveVc == 3){
        [kUserDefaults setObject:self.index forKey:LONG_PRODUCT_ID];
        NetManager * manager = [NetManager shareManager];
        NSDictionary * dict = @{@"number":self.index};
        //拼接ip和port
        NSString * URLstring = [NSString stringWithFormat:BANNERCLICKURL,[manager getIPAddress]];
        [self.hud show:YES];
        [manager downloadDataWithUrl:URLstring parm:dict callback:^(id responseObject, NSError *error) {
            obj = responseObject;
            //                NSLog(@"%@",obj);
            [self captureData:responseObject];
        }];
    }else if (self.fromSaveVc == 1){
        DBWorkerManager * manager = [DBWorkerManager shareDBManager];
        [manager getAllDetailCache:self.number completion:^(id responseObject) {
            obj = responseObject;
            [self captureData:responseObject];
        }];
    }else if(self.fromSaveVc == 2){
        DBWorkerManager * manager = [DBWorkerManager shareDBManager];
        [manager order_getAllDetailCache:self.number completion:^(id responseObject) {
            obj = responseObject;
            [self captureData:responseObject];
            //                NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        }];
    }
}

-(void)captureData:(id)responseObject{
    
    if(responseObject){
        [self.hud hide:YES];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        detailModel = [[DetailModel alloc]initWithDictionary:dict error:nil];
        //判断是否已经收藏过
        DBWorkerManager * manager = [DBWorkerManager shareDBManager];
        save_Button.selected = [manager bt_productIsBeenSaveWithNumberID:detailModel.number];
        
        //将产品ID改成消息路径
        [kUserDefaults setObject:detailModel.number forKey:RECORDPATH];
        [self setValueToView];
        [self getSmallImageArray];
    }else{
        //清除重影图片
        [self.ylScrollerView clearSubViews];
    }
}

#pragma mark - 将model里面的数据清理出来，没有的参数就不显示
-(void)sortOutModel{
    
    [self addItemIntoArray:detailModel.number withTitle:@"    编       号"];
    [self addItemIntoArray:detailModel.category withTitle:@"    类       别"];
    [self addItemIntoArray:detailModel.material withTitle:@"    材       质"];
    [self addItemIntoArray:detailModel.craft withTitle:@"    工       艺"];
    [self addItemIntoArray:detailModel.weight withTitle:@"    克       重"];
    [self addItemIntoArray:detailModel.shapes withTitle:@"    外观形态"];
    [self addItemIntoArray:detailModel.crowd withTitle:@"    适合人群"];
    [self addItemIntoArray:detailModel.size withTitle:@"    尺寸规格"];
    //    [self addItemIntoArray:detailModel.description withTitle:@"    产品描述"];
    //展示先这样
    //    [self addItemIntoArray:@"我是产品描述我是产品描述我是产品描述我是产品描述我是产品描述我是产品描述我是产品描述我是产品描述我是产品描述我是产品描述我是产品描述我是产品描述我是产品描述我是产品描述我是产品描述我是产品描述我是产品描述我是产品描述" withTitle:@" 产品描述"];
}

-(void)addItemIntoArray:(NSString *)item withTitle:(NSString *)title{
    
    if([item isEqualToString:@"*"]||item == nil){
    }else{
        NSDictionary * dict = @{title:item};
        [self.sortItemsArray addObject:dict];
    }
}

-(void)setValueToView{
    
    self.titlelabel.text = detailModel.name;
    [self sortOutModel];
    UILabel * label;
    for(int i=0;i<self.sortItemsArray.count;i++){
        
        NSDictionary * dict = self.sortItemsArray[i];
        NSString * key = [[dict allKeys]lastObject];
        NSString * value = dict[key];
        NSString * content = [NSString stringWithFormat:@"%@: %@",key,value];
        UILabel * itemLabel = [Tools createLabelWithFrame:CGRectMake(0, 5*S6+self.max_Y+22.5*S6*i, Wscreen, 22.5*S6) textContent:content withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
        [backgroundView addSubview:itemLabel];
        
        if(i == self.sortItemsArray.count-1){
            
            label = itemLabel;
            //            label.frame = CGRectMake(10*S6, 5*S6+self.max_Y+22.5*S6*i, Wscreen-20*S6, 22.5*S6);
            label.numberOfLines = 0;
            label.lineSpace = 0.5*S6;
            label.height = [self getDescriptionHeight:content];
        }
        
        if(i == 0){
            
            UIButton * shareBtn = [Tools createButtonNormalImage:@"share_out" selectedImage:nil tag:1 addTarget:self action:@selector(shareToPlaforms)];
            shareBtn.frame = CGRectMake(Wscreen-69.5*S6,CGRectGetMaxY(self.bgView.frame)+5*S6, 119/2.0*S6, 23.5*S6);
            [backgroundView addSubview:shareBtn];
        }
    }
    
    NSDictionary * dict = [self.sortItemsArray lastObject];
    NSString * content = [[dict allValues]lastObject];
    backgroundView.height = backgroundView.height+[self getDescriptionHeight:content]+self.sortItemsArray.count*22.5*S6;
    scrollerView.contentSize = CGSizeMake(scrollerView.contentSize.width, scrollerView.contentSize.height+[self getDescriptionHeight:content]+self.sortItemsArray.count+22.5*S6);
    
    //中间隔条
    UIView * separete_view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+10*S6, Wscreen, 8*S6)];
    separete_view.backgroundColor = TABLEVIEWCOLOR;
    [backgroundView addSubview:separete_view];
    
    UIView * line_view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(separete_view.frame), Wscreen, 1*S6)];
    line_view.backgroundColor = RGB_COLOR(216, 133, 57, 1);
    [backgroundView addSubview:line_view];
    
    //下单备注
    UILabel * remark_label = [Tools createLabelWithFrame:CGRectMake(20*S6, 9*S6+CGRectGetMaxY(line_view.frame), Wscreen, 14*S6) textContent:@"下单备注:" withFont:[UIFont systemFontOfSize:14*S6] textColor:RGB_COLOR(0, 0, 0, 1) textAlignment:NSTextAlignmentLeft];
    [backgroundView addSubview:remark_label];
    
#pragma mark -这里填写录音控件
    self.automaticallyAdjustsScrollViewInsets = NO;
    YLVoicemanagerView * YL = [[YLVoicemanagerView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(remark_label.frame)+10*S6, Wscreen, 230*S6) withVc:backgroundView];
    [backgroundView addSubview:YL];
}

#pragma mark -分享到第三方平台
-(void)shareToPlaforms{
    
    NetManager * manager = [NetManager shareManager];
    NSString * str = [self.index stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString * shareUrl = [NSString stringWithFormat:ShAREPLATFORMS,[manager getIPAddress],str];
    NSDictionary * dict;
    if(detailModel.name&&detailModel.description&&self.largeImageView.image&&shareUrl){
        dict = @{STShareTitleKey : @"百泰首饰",
                 STShareContentKey : detailModel.name,
                 STShareImageKey : self.largeImageView.image,
                 STShareURLKey : shareUrl};
        self.shareView = [YLShareView shareManager];
        [UIView animateWithDuration:0.2 animations:^{
            self.shareView.maskView.alpha = 1;
            self.shareView.y = Hscreen-80*S6;
        }];
        
        [self.shareView clickShareBtn:^(NSInteger index) {
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.shareView.maskView.alpha = 0;
                self.shareView.y = Hscreen;
            }];
            
            switch (index) {
                case 0:
                    //QQ
                    [self.shareTool shareToQQ:dict];
                    break;
                case 1:
                    //QQ空间
                    [self.shareTool shareToQZone:dict];
                    break;
                case 2:
                    //微信
                    [self.shareTool shareToWeChatSession:dict];
                    break;
                case 3:
                    //朋友圈
                    [self.shareTool shareToWeChatTimeline:dict];
                    break;
                default:
                    break;
            }
            
        }];
    }else{
        [self showAlertViewWithTitle:@"部分产品信息未获取到，请稍后再试!"];
    }
}

-(void)configUI{
    
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    //导航条设置
    self.navLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navLeftButton setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    self.navLeftButton.frame = CGRectMake(15.5, 13, 24.5, 22.5);
    [self.navigationController.navigationBar addSubview:self.navLeftButton];
    [self.navLeftButton addTarget:self action:@selector(backOut) forControlEvents:UIControlEventTouchUpInside];
    
    //收藏按钮
    save_Button = [Tools createNormalButtonWithFrame:CGRectMake(0, 0, 0, 0) textContent:@"点击收藏" withFont:[UIFont systemFontOfSize:16*S6] textColor:RGB_COLOR(231, 140, 59, 1) textAlignment:NSTextAlignmentRight];
    [save_Button setTitle:@"取消收藏" forState:UIControlStateSelected];
    save_Button.frame = CGRectMake(100, 0, 85*S6, 41/2.0*S6);
    [save_Button addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:save_Button];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    //导航条标题
    self.titlelabel = [Tools createLabelWithFrame:CGRectMake(15, 10,100, 20*S6) textContent:nil withFont:[UIFont systemFontOfSize:17*S6] textColor:RGB_COLOR(0, 0, 0, 1) textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = self.titlelabel;
    
    //布局整个页面
    [self autoWholePage];
}

#pragma mark -收藏
-(void)saveAction:(UIButton *)btn{
    
    if(![obj isKindOfClass:[NSData class]]){
        
        [self showAlert];
        return;
    }
    btn.selected = !btn.selected;
    DBWorkerManager * manager = [DBWorkerManager shareDBManager];
    if(btn.selected){
        [manager insertInfo:detailModel withData:UIImagePNGRepresentation(self.largeImageView.image) withNumber:detailModel.number];
        [manager saveDatailCache:detailModel.number withData:obj];
    }else{
        [manager cleanDBDataWithNumber:detailModel.number];
        [manager cleanDataCacheWithNumber:detailModel.number];
    }
}

-(void)showSuceedAlert{
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"添加成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:controller animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [controller dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

-(void)showAlert{
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"数据正在加载中，请稍后..." message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:controller animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [controller dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

//布局整个页面
-(void)autoWholePage{
    
    largeImgBgView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, Wscreen, 563/2.0*S6)];
    [backgroundView addSubview:largeImgBgView];
    
    self.largeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, Wscreen,563/2.0*S6)];
    self.largeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [largeImgBgView addSubview:self.largeImageView];
    
    
    [self createBottomView];
}

-(UIView *)bgView{
    
    if(_bgView == nil){
        //设置滑动图片下面的背景
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0,563/2.0*S6+NAV_BAR_HEIGHT, Wscreen, (15+165+15)/2.0*S6)];
        _bgView.backgroundColor = TABLEVIEWCOLOR;
        [backgroundView addSubview:_bgView];
        self.max_Y = CGRectGetMaxY(_bgView.frame);
    }
    return _bgView;
}

-(void)createBottomView{
    
    bottomControlView = [[YLOrderControlView alloc]init];
    [self.view addSubview:bottomControlView];
    [self.view bringSubviewToFront:bottomControlView];
    
    [bottomControlView clickBottomBtn:^(NSInteger tag) {
        
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        switch (tag) {
            case 0:{
                FirstViewController * firstVC = [[FirstViewController alloc]init];
                [self pushToViewControllerWithTransition:firstVC withDirection:@"left" type:NO];
            }
                
                break;
            case 1:
            {
                SavaViewController * saveVc = [[SavaViewController alloc]init];
                [self pushToViewControllerWithTransition:saveVc withDirection:@"left" type:NO];
            }
                break;
            case 2:{
                
                if([kUserDefaults objectForKey:CustomerID]){
                    MyOrdersController * ordersVc = [[MyOrdersController alloc]init];
                    [kUserDefaults setObject:self.index forKey:PRODUCTNUMBER];
                    [self pushToViewControllerWithTransition:ordersVc withDirection:@"left" type:NO];
                }else{
                    
                    YLLoginView * loginView = [[YLLoginView alloc]initWithVC:app.window withVc:self];
                    [app.window addSubview:loginView];
                }
            }
                
                break;
            case 3:{
                
                //加入选购单
                if([kUserDefaults objectForKey:CustomerID]){
                    
                    DBWorkerManager * manager = [DBWorkerManager shareDBManager];
                    [manager order_insertInfo:detailModel withData:UIImagePNGRepresentation(self.largeImageView.image)  withNumber:detailModel.number];
                    [manager order_saveDatailCache:detailModel.number withData:obj];
                    [self addMyOrders];
                    
                }else{
                    YLLoginView * loginView = [[YLLoginView alloc]initWithVC:app.window withVc:self];
                    [app.window addSubview:loginView];
                }
            }
                break;
                
            default:
                break;
        }
    }];
}
//加入我的选购单
-(void)addMyOrders{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"产品备注正在上传...";
    self.hud.animationType = MBProgressHUDAnimationZoomOut;
    
    YLVoicemanagerView * recordManager = [[YLVoicemanagerView alloc]initWithFrame:self.view.frame withVc:[UIView new]];
    
    NSMutableArray * reNameVoiceArray = [NSMutableArray array];//获取所有的语音数组
    NSMutableArray * voiceArray = [recordManager getAllVoiceMessages];
    for(int i = 0;i<voiceArray.count;i++){
        
        NSDictionary * dict = [voiceArray objectAtIndex:i];
        NSString * key = [[dict allKeys]lastObject];
        NSData * data = dict[key];
        
        NSString * newKey = [NSString stringWithFormat:@"%@@%@@%@.wav",[kUserDefaults objectForKey:CustomerID],key,detailModel.number];
        NSDictionary * newDict = @{newKey:data};
        [reNameVoiceArray addObject:newDict];
    }
    
    NetManager * netmanager = [NetManager shareManager];
    NSString * urlStr = [NSString stringWithFormat:UPLOADORDERCAR,[netmanager getIPAddress]];
    //    NSLog(@"%@",[recordManager getAllTextMessageStr]);
    NSDictionary * subDict;
    if([recordManager getAllTextMessageStr].count>0){
        subDict = @{@"number":detailModel.number,@"customerid":[kUserDefaults objectForKey:CustomerID],@"message":[self arrayToJson:[recordManager getAllTextMessageStr]]};
    }else{
        subDict = @{@"number":detailModel.number,@"customerid":[kUserDefaults objectForKey:CustomerID],@"message":@""};
    }
    [netmanager downloadDataWithUrl:urlStr parm:subDict callback:^(id responseObject, NSError *error) {
        
        if(responseObject){
            if(reNameVoiceArray.count == 0){
                self.hud.labelText = @"上传成功!";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.hud hide:YES];
                });
            }else{
                [self sendVoiceToServer:reNameVoiceArray];
            }
        }else{
            NSLog(@"%@",error.description);
        }
    }];
}

-(void)sendVoiceToServer:(NSMutableArray *)array{
    
    NetManager * manager = [NetManager shareManager];
    // 把语音数据（作为请求体）传过去
    AFHTTPSessionManager * fileManager = [AFHTTPSessionManager manager];
    fileManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    fileManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"application/octet-stream",@"application/x-www-form-urlencoded",@"text/plain",nil];
    NSString * voiceUrl = [NSString stringWithFormat:UPLOADVOICE,[manager getIPAddress]];
    [fileManager POST:voiceUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //先将数据写入文件
        for(int i = 0;i<array.count;i++){
            
            NSDictionary * dict = array[i];
            NSString * fileName = [[dict allKeys]lastObject];
            NSData * data = [dict objectForKey:fileName];
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject){
            
            if(responseObject){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     self.hud.labelText = @"上传成功!";
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.hud hide:YES];
                });
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
}

#pragma mark -图片url拼接
-(NSString *)connectImage:(NSString *)path1 withPath2:(NSString *)path2{
    
    return [NSString stringWithFormat:@"%@%@",path1,path2];
}

#pragma mark -获取图片路径
-(NSString *)captureImage:(NSString *)imageName withType:(NSString *)imageType{
    
    return [[NSBundle mainBundle]pathForResource:imageName ofType:imageType];
}

//设置标题Label
-(void)configTitleLabel:(UILabel *)label{
    
    label.font = [UIFont systemFontOfSize:14*S6];
    label.textColor = TEXTCOLOR;
}

//设置title旁边的内容Label
-(void)configContentLabel:(UILabel *)label{
    label.font = [UIFont systemFontOfSize:16*S6];
    label.textColor = RGB_COLOR(51, 51, 51, 1);
}

//返回到上一个界面
-(void)backOut{
    
    FirstViewController * firstVc = [[FirstViewController alloc]init];
    if(self.fromSaveVc == 0){
        
        if(self.isFromSearchVc||self.isFromThemeVc){
            [self popToViewControllerWithDirection:@"right" type:NO];
            return;
        }
        [self pushToViewControllerWithTransition:firstVc withDirection:@"right" type:NO];
        return;
    }
    
    if(self.isFromSaveVc == YES){
        
        SavaViewController * saveVc = [[SavaViewController alloc]init];
        [self pushToViewControllerWithTransition:saveVc withDirection:@"right" type:NO];
        [kUserDefaults setObject:[kUserDefaults objectForKey:FROM_VC_TO_SAVE] forKey:TEMP_FROM_VC_TO_SAVE];
        [kUserDefaults removeObjectForKey:FROM_VC_TO_SAVE];
        [kUserDefaults setObject:@"123" forKey:SAVE_PUSH_FLAG];
        return;
    }
    
    [self popToViewControllerWithDirection:@"right" type:NO];
}

-(NSMutableArray *)sortItemsArray{
    
    if(_sortItemsArray == nil){
        _sortItemsArray = [NSMutableArray array];
    }
    return _sortItemsArray;
}

-(STShareTool *)shareTool{
    
    if(_shareTool == nil){
        
        _shareTool = [STShareTool toolWithViewController:self];
    }
    return _shareTool;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
