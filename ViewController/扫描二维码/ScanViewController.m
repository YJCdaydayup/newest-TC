//
//  ScanViewController.m
//  DianZTC
//
//  Created by 杨力 on 27/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "ScanViewController.h"
#import "BatarResultController.h"
#import "ScanHistoryContoller.h"
#import "DetailViewController.h"
#import "NetManager.h"
#import "DBWorkerManager.h"

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

@property (nonatomic,strong) DBWorkerManager * dbManager;

@end

@implementation ScanViewController

@synthesize leftNViBtn = _leftNViBtn;
@synthesize scanCoder = _scanCoder;
@synthesize inputCoder = _inputCoder;
@synthesize scanPhotos = _scanPhotos;
@synthesize inputBgView = _inputBgView;
@synthesize coder_tf = _coder_tf;
@synthesize confirmBtn = _confirmBtn;
@synthesize dbManager = _dbManager;

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
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
    [_coder_tf resignFirstResponder];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShows:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHides:) name:UIKeyboardWillHideNotification object:nil];
    
    _dbManager = [DBWorkerManager shareDBManager];
    [_dbManager createScanDB];
    [self batar_setNavibar:@"二维码/条形码"];
    
}

-(void)keyBoardWillShows:(NSNotification *)notification{
    
    // 获取通知的信息字典
    NSDictionary *userInfo = [notification userInfo];
    
    // 获取键盘弹出后的rect
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        _scanCoder.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
        _scanPhotos.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
        _inputCoder.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
    }];
}
-(void)keyBoardWillHides:(NSNotification *)notification{
    
    // 获取通知的信息字典
    NSDictionary *userInfo = [notification userInfo];
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 调用代理
    [UIView animateWithDuration:animationDuration animations:^{
        _scanPhotos.transform = CGAffineTransformIdentity;
        _scanCoder.transform = CGAffineTransformIdentity;
        _inputCoder.transform = CGAffineTransformIdentity;
    }];
}

-(void)createView{
    
    [self batar_setLeftNavButton:@[@"return",@""] target:self selector:@selector(back) size:CGSizeMake(49/2.0*S6, 22.5*S6) selector:nil rightSize:CGSizeZero topHeight:12*S6];
    _leftNViBtn = [Tools createNormalButtonWithFrame:CGRectMake(Wscreen-65*S6, 33, 55*S6, 20*S6) textContent:@"扫描历史" withFont:[UIFont systemFontOfSize:11*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
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
        
        UIButton * btn = [Tools createNormalButtonWithFrame:CGRectMake(i*(Wscreen/3.0-2*S6), Hscreen-TABBAR_HEIGHT, Wscreen/3.0-2*S6, TABBAR_HEIGHT) textContent:titleArray[i] withFont:[UIFont systemFontOfSize:15*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
        if(i == 1){
            btn.width = btn.width+6*S6;
        }else if (i == 2){
            btn.x = btn.x + 6*S6;
        }
        
        btn.tag = i;
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderColor = [BatarPlaceTextCol CGColor];
        btn.layer.borderWidth = 0.3*S6;
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
        
        if(result.strScanned.length == 0){
            [self showAlertViewWithTitle:@"未找到任何产品信息!"];
            return;
        }
        
//        NSLog(@"%@",result.strBarCodeType);
        
        [NetManager judgeCoderWithCode:result.strScanned Type:^(CoderType type) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                switch (type) {
                    case CoderTypeAccurateType:
                    {
                        DetailViewController * detailVc = [[DetailViewController alloc]initWithController:self];
                        detailVc.index = result.strScanned;
                        detailVc.searchType = CodeTypeAccurary;
                        if([result.strBarCodeType containsString:@"QRCode"]){
                            detailVc.codeType = CodeTypeQRCode;
                        }else{
                            detailVc.codeType = CodeTypeBarCode;
                        }
                        [self pushToViewControllerWithTransition:detailVc withDirection:@"left" type:NO];

                    }
                        break;
                    case CoderTypeFailCoder:{
                        [self showAlertViewWithTitle:@"找不到该产品!"];
                        NSString * type;
                        if([result.strBarCodeType containsString:@"QRCode"]){
                            type = CodeTypeQRCode;
                        }else{
                            type = CodeTypeBarCode;
                        }
                        [_dbManager scan_insertInfo:[DetailModel new] withData:nil withNumber:result.strScanned date:[self getCurrentDate] type:type searchType:CodeTypeFail];
                        [self.scanObj startScan];
                    }
                        break;
                    default:
                        break;
                }
                
            });
        }];
        break;
    }
    [self createViews];
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
        [_coder_tf resignFirstResponder];
    }else if (btn.tag == 1){
        //输入条码
        self.inputBgView.hidden = NO;
        self.isNeedScanImage = YES;
        self.qRScanView.hidden = YES;
        _descripeLabel.hidden = YES;
        [self.scanObj stopScan];
        [_coder_tf becomeFirstResponder];
    }else{
        //扫描图片
        [_coder_tf resignFirstResponder];
        self.inputBgView.hidden = YES;
        self.isNeedScanImage = YES;
        self.qRScanView.hidden = YES;
        _descripeLabel.hidden = YES;
        [self.scanObj stopScan];
        [self openLocalPhoto];
    }
}

-(void)back{
    
    [self popToViewControllerWithDirection:@"right" type:NO];
}

-(void)scanHistory{
    
    ScanHistoryContoller * historyVc = [[ScanHistoryContoller alloc]initWithController:self];
    [self pushToViewControllerWithTransition:historyVc withDirection:@"right" type:NO];
}

-(UIView *)inputBgView{
    
    if(_inputBgView == nil){
        _inputBgView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, Wscreen, Hscreen-TABBAR_HEIGHT-NAV_BAR_HEIGHT)];
        _inputBgView.backgroundColor = RGB_COLOR(29, 29, 29, 0.5);
        _inputBgView.hidden = YES;
        [self.app.window addSubview:_inputBgView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideBoard)];
        [_inputBgView addGestureRecognizer:tap];
        
        self.coder_tf = [Tools createTextFieldFrame:CGRectMake(0, 255/2.0*S6, 240*S6, 65/2.0*S6) placeholder:@"输入条码到框内确认即可" bgImageName:@"scan_bg" leftView:nil rightView:nil isPassWord:NO];
        self.coder_tf.font = [UIFont systemFontOfSize:14*S6];
        self.coder_tf.background = [UIImage imageNamed:@"scan_bg"];
        self.coder_tf.centerX = self.view.centerX;
        self.coder_tf.keyboardType = UIKeyboardTypeASCIICapable;
        self.coder_tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.coder_tf.backgroundColor = [UIColor whiteColor];
        [_inputBgView addSubview:self.coder_tf];
        
        UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 7.5*S6, 55/2.0*S6)];
        self.coder_tf.leftViewMode = UITextFieldViewModeAlways;
        self.coder_tf.leftView = leftView;
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 250/2.0*S6, 245*S6, 38*S6)];
        imgView.centerX = self.view.centerX;
        imgView.image = [UIImage imageNamed:@"scan_bg"];
        [_inputBgView addSubview:imgView];
        
        _confirmBtn = [Tools createNormalButtonWithFrame:CGRectMake(0, CGRectGetMaxY(self.coder_tf.frame)+35/2.0*S6, 240*S6,65/2.0*S6) textContent:@"确定" withFont:[UIFont systemFontOfSize:14*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        [_confirmBtn setTitleColor:RGB_COLOR(29, 29, 29, 0.5) forState:UIControlStateHighlighted];
        _confirmBtn.centerX = self.view.centerX;
        _confirmBtn.backgroundColor = RGB_COLOR(222, 166, 100, 1);
        [_inputBgView addSubview:_confirmBtn];
        
        [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inputBgView;
}

-(void)confirmAction{
    
    if(_coder_tf.text.length == 0){
        [self showAlertViewWithTitle:@"请输入产品编号"];
        return;
    }
    [NetManager judgeCoderWithCode:_coder_tf.text Type:^(CoderType type) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (type) {
                case CoderTypeAccurateType:
                {
                    DetailViewController * detailVc = [[DetailViewController alloc]initWithController:self];
                    detailVc.index = _coder_tf.text;
                    detailVc.codeType = CodeTypeBarCode;
                    detailVc.searchType = CodeTypeAccurary;
                    [self pushToViewControllerWithTransition:detailVc withDirection:@"left" type:NO];
                }
                    break;
                case CoderTypeInaccurateType:
                {
                    BatarResultController * resultVc = [[BatarResultController alloc]initWithController:self];
                    resultVc.param = _coder_tf.text;
                    [self pushToViewControllerWithTransition:resultVc withDirection:@"left" type:NO];
                    [_dbManager scan_insertInfo:[DetailModel new] withData:@"111" withNumber:_coder_tf.text date:[self getCurrentDate] type:CodeTypeBarCode searchType:CodeTypeInaccurary];
                }
                    break;
                case CoderTypeFailCoder:
                    //错误码
                    [self showAlertViewWithTitle:@"找不到该产品，请确认后重新输入"];
                    [_dbManager scan_insertInfo:[DetailModel new] withData:nil withNumber:_coder_tf.text date:[self getCurrentDate] type:CodeTypeFailCode searchType:CodeTypeFail];
                    break;
                default:
                    break;
            }
            _coder_tf.text = nil;
        });
    }];
}

-(void)hideBoard{
    [_coder_tf resignFirstResponder];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_coder_tf resignFirstResponder];
}

@end
