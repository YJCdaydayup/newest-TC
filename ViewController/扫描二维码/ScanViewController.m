//
//  ScanViewController.m
//  DianZTC
//
//  Created by 杨力 on 27/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "ScanViewController.h"
#import "SingleSearchCatagoryViewController.h"
#import "NetManager.h"

@interface ScanViewController()

@property (nonatomic,strong) UIButton * leftNViBtn;

@property (nonatomic,strong) UILabel * descripeLabel;
@property (nonatomic,strong) UIButton * scanCoder;
@property (nonatomic,strong) UIButton * inputCoder;
@property (nonatomic,strong) UIButton * scanPhotos;

//输入条码
@property (nonatomic,strong) UIView * inputBgView;
@property (nonatomic,strong) UITextField * coder_tf;
@property (nonatomic,strong) UIButton * confirmBtn;

@end

@implementation ScanViewController

@synthesize leftNViBtn = _leftNViBtn;
@synthesize scanCoder = _scanCoder;
@synthesize inputCoder = _inputCoder;
@synthesize scanPhotos = _scanPhotos;
@synthesize inputBgView = _inputBgView;
@synthesize coder_tf = _coder_tf;
@synthesize confirmBtn = _confirmBtn;

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    _leftNViBtn.hidden = NO;
    _scanPhotos.hidden = NO;
    _scanCoder.hidden = NO;
    _inputCoder.hidden = NO;
    _descripeLabel.hidden = NO;
    self.inputBgView.hidden = YES;
    [self setViews];
    self.app.window.backgroundColor = [UIColor blackColor];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    _leftNViBtn.hidden = YES;
    _scanPhotos.hidden = YES;
    _scanCoder.hidden = YES;
    _inputCoder.hidden = YES;
    _descripeLabel.hidden = YES;
    self.inputBgView.hidden = YES;
    self.app.window.backgroundColor = [UIColor whiteColor];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self batar_setNavibar:@"二维码/条形码"];
}

-(void)createView{
    
    [self batar_setLeftNavButton:@[@"return",@""] target:self selector:@selector(back) size:CGSizeMake(49/2.0*S6, 22.5*S6) selector:nil rightSize:CGSizeZero topHeight:12*S6];
    _leftNViBtn = [Tools createNormalButtonWithFrame:CGRectMake(Wscreen-70*S6, 40*S6, 50*S6, 20*S6) textContent:@"扫描历史" withFont:[UIFont systemFontOfSize:12*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    _leftNViBtn.layer.borderColor = [TEXTCOLOR CGColor];
    _leftNViBtn.layer.borderWidth = 0.5*S6;
    [self.navigationController.view addSubview:_leftNViBtn];
    [_leftNViBtn addTarget:self action:@selector(scanHistory) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setViews{
    
    LBXScanViewStyle * viewStyle = [[LBXScanViewStyle alloc]init];
    viewStyle.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    viewStyle.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    viewStyle.colorRetangleLine = [UIColor whiteColor];
    viewStyle.colorAngle = TABBARTEXTCOLOR;
    viewStyle.photoframeAngleH = 25*S6;
    viewStyle.photoframeAngleW = 25*S6;
    viewStyle.photoframeLineW = 5*S6;
    viewStyle.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    self.style = viewStyle;
    self.isNeedScanImage = NO;
    self.isOpenInterestRect = YES;
    self.qRScanView.hidden = NO;
    [self.scanObj startScan];
    [self createViews];
}

-(void)createViews{
    
    [_descripeLabel removeFromSuperview];
    [_scanPhotos removeFromSuperview];
    [_scanCoder removeFromSuperview];
    [_inputCoder removeFromSuperview];
    
    _descripeLabel = [Tools createLabelWithFrame:CGRectMake(0, 120*S6+TABBAR_HEIGHT, Wscreen, 12*S6) textContent:@"对准二维码/条形码到框内即可扫描" withFont:[UIFont systemFontOfSize:12*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [self.app.window addSubview:_descripeLabel];
    
    NSArray * titleArray = @[@"扫描条码",@"输入条码",@"识别图片"];
    for(int i=0;i<3;i++){
        
        UIButton * btn = [Tools createNormalButtonWithFrame:CGRectMake(i*Wscreen/3.0, Hscreen-TABBAR_HEIGHT, Wscreen/3.0, TABBAR_HEIGHT) textContent:titleArray[i] withFont:[UIFont systemFontOfSize:15*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
        btn.tag = i;
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderColor = [BatarPlaceTextCol CGColor];
        btn.layer.borderWidth = 0.5*S6;
        [btn setTitleColor:TABBARTEXTCOLOR forState:UIControlStateHighlighted];
        [btn setTitleColor:TABBARTEXTCOLOR forState:UIControlStateSelected];
        [self.app.window addSubview:btn];
        switch (i) {
            case 0:
                _scanCoder = btn;
                btn.selected = YES;
                break;
            case 1:
                _inputCoder = btn;
                break;
            case 2:
                _scanPhotos = btn;
                break;
            default:
                break;
        }
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    for(LBXScanResult * result in array){
        
        _descripeLabel.hidden = YES;
        _scanCoder.hidden = YES;
        _scanPhotos.hidden = YES;
        _inputCoder.hidden = YES;
        _inputBgView.hidden = YES;
        SingleSearchCatagoryViewController * singleVc = [[SingleSearchCatagoryViewController alloc]init];
        singleVc.vc_flag = 3;
        singleVc.catagoryItem = @"搜索结果";
        singleVc.catagoryIndex = [result.strScanned stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self pushToViewControllerWithTransition:singleVc withDirection:@"left" type:NO];
    }
}

-(void)clickBtn:(UIButton *)btn{
    
    _scanCoder.selected = NO;
    _scanPhotos.selected = NO;
    _inputCoder.selected = NO;
    
    btn.selected = YES;
    if(btn.tag == 0){
        //扫描条码
        self.inputBgView.hidden = YES;
        self.qRScanView.hidden = NO;
        _descripeLabel.hidden = NO;
        [self.scanObj startScan];
    }else if (btn.tag == 1){
        //输入条码
        self.inputBgView.hidden = NO;
        self.isNeedScanImage = YES;
        self.qRScanView.hidden = YES;
        _descripeLabel.hidden = YES;
        [self.scanObj stopScan];
    }else{
        //扫描图片
        self.inputBgView.hidden = YES;
        self.isNeedScanImage = YES;
        self.qRScanView.hidden = YES;
        _descripeLabel.hidden = YES;
        [self.scanObj stopScan];
        [self openLocalPhoto];
    }
}

-(void)back{
    
    [self popToViewControllerWithDirection:@"left" type:NO];
}

-(void)scanHistory{
    
    
}

-(UIView *)inputBgView{
    
    if(_inputBgView == nil){
        _inputBgView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, Wscreen, Hscreen-TABBAR_HEIGHT-NAV_BAR_HEIGHT)];
        _inputBgView.backgroundColor = RGB_COLOR(29, 29, 29, 0.5);
        _inputBgView.hidden = YES;
        [self.app.window addSubview:_inputBgView];
        
        self.coder_tf = [Tools createTextFieldFrame:CGRectMake(0, 255/2.0*S6, 215*S6, 55/2.0*S6) placeholder:@"" bgImageName:@"输入条码到框内确认即可" leftView:nil rightView:nil isPassWord:NO];
        self.coder_tf.centerX = self.view.centerX;
        self.coder_tf.backgroundColor = [UIColor whiteColor];
        [_inputBgView addSubview:self.coder_tf];
    }
    return _inputBgView;
}

@end
