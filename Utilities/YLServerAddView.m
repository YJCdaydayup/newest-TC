//
//  YLServerAddView.m
//  DianZTC
//
//  Created by 杨力 on 22/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLServerAddView.h"
#import "YLAddServer.h"
#import "NetManager.h"
#import "AppDelegate.h"
#import "UIView+Shake.h"

#define FrameY  265.0
#define FrameW  135.0
#define FrameH  40

@interface YLServerAddView()
{
    BatarLoginController * _bgVc;
    NSMutableArray * _btnArray;
    NSString * selectIp_port;
    YLAddServer * addServer;
    BOOL isEdited;
    UIButton * addServerBtn;
}

@property (nonatomic,strong) UIImageView * selectImgView;
@end

@implementation YLServerAddView

-(instancetype)initWithView:(BatarLoginController *)motherVc{
    
    if(self = [super init]){
        _bgVc = motherVc;
    }
    return self;
}

-(void)updateServerView{
    
    for(UIView * subView in self.subviews){
        [subView removeFromSuperview];
    }
    self.serverArray = [NetManager batar_getAllServers];
    _btnArray = [NSMutableArray array];
    NSMutableArray * totalArr = [NSMutableArray arrayWithArray:self.serverArray];
    [totalArr addObject:@"temp"];
    NSInteger count = totalArr.count;
    NSInteger row = 0;
    if(count%2 == 0){
        row = count/2;
    }else{
        row = count/2+1;
    }
    self.frame = CGRectMake(0, FrameY*S6, 300*S6, (FrameH+10)*row*S6);
    self.y = FrameY*S6;
    self.centerX = _bgVc.view.centerX;
    [_bgVc.view addSubview:self];
    NSArray * localImgNames = @[@"showking",@"batar_jew",@"king_batar",@"batar_group"];
    for(int i=0;i<count;i++){
        
        NSString * currentServer = totalArr[i];
        NSString * currentImg = [self getCompareServer:currentServer];
        UIButton * btn;
        if([localImgNames containsObject:currentImg]){
            //是本地设定的服务器
            btn = [Tools createButtonNormalImage:currentImg selectedImage:nil tag:i addTarget:self action:@selector(chooseServer:)];
            btn.frame = CGRectMake((i%2*FrameW+i%2*30)*S6, i/2*FrameH*S6+i/2*10*S6, FrameW*S6, FrameH*S6);
            
        }else{
            //不是本地设定的服务器
            btn = [Tools createNormalButtonWithFrame:CGRectMake((i%2*FrameW+i%2*30)*S6, i/2*FrameH*S6+i/2*10*S6, FrameW*S6, FrameH*S6) textContent:currentServer withFont:[UIFont systemFontOfSize:14*S6] textColor:BatarPlaceTextCol textAlignment:NSTextAlignmentCenter];
            btn.tag = i;
            [btn setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(chooseServer:) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.borderColor = [BOARDCOLOR CGColor];
            btn.layer.borderWidth = 0.5*S6;
            btn.titleLabel.numberOfLines = 0;
        }
        btn.layer.cornerRadius = 5*S6;
        btn.layer.masksToBounds = YES;
        [btn setImage:[self btnSelectedImg:currentImg] forState:UIControlStateSelected];
        if(i == count-1){
            //增加服务器按钮
            addServerBtn = btn;
            [self configAddBtn:btn];
        }
        if(i == 0){
            btn.selected = YES;
        }
        [self addSubview:btn];
        [_btnArray addObject:btn];
        if(i != count - 1){
            UILongPressGestureRecognizer * longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(editBtns:)];
            longTap.minimumPressDuration = 1.0f;
            [btn addGestureRecognizer:longTap];
        }
    }
}

#pragma mark - 长按进行编辑
-(void)editBtns:(UILongPressGestureRecognizer *)tap{
    
    if(tap.state == UIGestureRecognizerStateBegan){
        [self startEdit];
    }
}

-(void)startEdit{
    //            NSLog(@"长按进行编辑");
    [self updateServerView];
    for(int i = 0;i<_btnArray.count-1;i++){
        UIButton * btn = _btnArray[i];
        btn.layer.borderColor = [BOARDCOLOR CGColor];
        btn.layer.borderWidth = 0.6*S6;
        btn.titleLabel.numberOfLines = 0;
        btn.layer.masksToBounds = NO;
        
        for(UIView * subView in btn.subviews){
            if(![subView isKindOfClass:[UILabel class]]){
                [subView removeFromSuperview];
            }
        }
        
        UIView * view = [self getShakeView];
        view.tag = btn.tag+10;
        [btn addSubview:view];
        [btn bringSubviewToFront:view];
        //                [btn shakeWithOptions:SCShakeOptionsAtEndRestart force:0.005 duration:MAXFLOAT iterationDuration:0.007 completionHandler:^{
        //                }];
        [btn shake];
        
        UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(btn.x-6.5*S6, btn.y-6.5*S6, 20*S6,20*S6)];
        maskView.tag = btn.tag+11;
        [self addSubview:maskView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteServer:)];
        [maskView addGestureRecognizer:tap];
        
        UIView * spaceView = [[UIView alloc]initWithFrame:CGRectMake(btn.x+12*S6, btn.y+7*S6, btn.width-12*S6, btn.height-7*S6)];
        [self addSubview:spaceView];
        
        UITapGestureRecognizer * cancelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelEdit)];
        [spaceView addGestureRecognizer:cancelTap];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:ServerEditNotification object:nil];
    }
    addServerBtn.userInteractionEnabled = NO;
}

-(void)cancelEdit{
    
//    NSLog(@"取消编辑");
    addServerBtn.userInteractionEnabled = YES;
    [self updateServerView];
    [self getSelectedBtn];
    
    for(UIButton * btn in _btnArray){
        [btn endShake];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:ServerEditCancelNotification object:nil];
}

-(void)deleteServer:(UITapGestureRecognizer *)tap{
    
    //在这里清除
    NSInteger btnTag = tap.view.tag - 11;
    [NetManager batar_deleteServerWithIndex:btnTag];
    
    for(int i=0;i<_btnArray.count;i++){
        UIButton * btn = _btnArray[i];
        [btn endShake];
        
        for(UIView * subView in btn.subviews){
            if(subView.tag == btn.tag+10||subView.tag == btn.tag+11){
                [subView removeFromSuperview];
            }
        }
    }
    [self updateServerView];
    
    if(self.serverArray.count==0){
        //没有服务器了
        [kUserDefaults removeObjectForKey:IPSTRING];
        [kUserDefaults removeObjectForKey:PORTSTRING];
    }else{
        //选择最后面的那个服务器
        NSString * lastServer = [self.serverArray lastObject];
        [kUserDefaults setObject:[self getIpWithPort:lastServer][0] forKey:IPSTRING];
        [kUserDefaults setObject:[self getIpWithPort:lastServer][1] forKey:PORTSTRING];
    }
//    [self getSelectedBtn];
    [self startEdit];
    [[NSNotificationCenter defaultCenter]postNotificationName:DeleteServer object:nil];
}

-(UIView *)getShakeView{
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(-6.5*S6, -6.5*S6, 17*S6, 17*S6)];
    UIImageView * imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"delete_remark"]];
    imgView.frame = CGRectMake(0, 0, 17*S6, 17*S6);
    [bgView addSubview:imgView];
    return bgView;
}

-(void)configAddBtn:(UIButton *)btn{
    
    [btn setTitle:nil forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    UIImageView * addImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*S6, 10*S6, 22*S6, 22*S6)];
    addImg.image = [UIImage imageNamed:@"add_logo"];
    [btn addSubview:addImg];
    
    UILabel * title = [Tools createLabelWithFrame:CGRectMake(CGRectGetMaxX(addImg.frame)+8*S6, 10*S6, 100*S6, 22*S6) textContent:@"添加服务地址" withFont:[UIFont systemFontOfSize:14*S6] textColor:BatarPlaceTextCol textAlignment:NSTextAlignmentLeft];
    [btn addSubview:title];
}

//获取当前选中的服务器的index
-(NSInteger)getSelectedServer{
    
    NSString * str = [NSString stringWithFormat:@"%@:%@",IPSTRING,PORTSTRING];
    return [self.serverArray indexOfObject:str];
}

-(void)chooseServer:(UIButton *)btn{
    
    if(btn.tag == _btnArray.count-1){
        //        NSLog(@"添加按钮");
        [self addServer];
        return;
    }
    
    for(UIButton * button in _btnArray){
        if(button != btn){
            button.selected = NO;
            button.layer.borderWidth = 0.5*S6;
            button.layer.borderColor = [BOARDCOLOR CGColor];
        }
    }
    btn.selected = !btn.selected;
    if(btn.selected){
        btn.layer.borderWidth = 0;
        self.selectImgView.hidden = NO;
        self.selectImgView.frame = btn.bounds;
        [btn addSubview:self.selectImgView];
    }else{
        self.selectImgView.hidden = YES;
        btn.layer.borderWidth = 0.5*S6;
        btn.layer.borderColor = [BOARDCOLOR CGColor];
    }
    //取当前ip，port
    selectIp_port = self.serverArray[btn.tag];
    [kUserDefaults setObject:[self getIpWithPort:selectIp_port][0] forKey:IPSTRING];
    [kUserDefaults setObject:[self getIpWithPort:selectIp_port][1] forKey:PORTSTRING];
//    NSLog(@"域名:%@---端口号:%@",[kUserDefaults objectForKey:IPSTRING],[kUserDefaults objectForKey:PORTSTRING]);
}

-(NSArray *)getIpWithPort:(NSString *)str{
    
    return [str componentsSeparatedByString:@":"];
}

-(void)addServer{
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    addServer = [[YLAddServer alloc]initWithVC:app.window withVc:_bgVc];
    [app.window addSubview:addServer];
    
    __block typeof(self)weakSelf = self;
    [addServer clickConfirmBlock:^{
        [weakSelf updateServerView];
        //取货当前ip，port
        selectIp_port = [self.serverArray lastObject];
        [kUserDefaults setObject:[self getIpWithPort:selectIp_port][0] forKey:IPSTRING];
        [kUserDefaults setObject:[self getIpWithPort:selectIp_port][1] forKey:PORTSTRING];
        [[NSNotificationCenter defaultCenter]postNotificationName:DeleteServer object:nil];
        [self getSelectedBtn];
//        NSLog(@"域名:%@---端口号:%@",[kUserDefaults objectForKey:IPSTRING],[kUserDefaults objectForKey:PORTSTRING]);
    }];
}

-(void)getSelectedBtn{
    
    NSString * ip = [kUserDefaults objectForKey:IPSTRING];
    NSString * port = [kUserDefaults objectForKey:PORTSTRING];
    
    NSString * temp;
    NSString * ip_port = [NSString stringWithFormat:@"%@:%@",ip,port];
    for(NSString * str in self.serverArray){
        if([str isEqualToString:ip_port]){
            temp = str;
            break;
        }
    }
    
    if(_btnArray.count==1){
        return;
    }
    for(UIButton * btn in _btnArray){
        btn.selected = NO;
    }
    
    NSInteger index;
    if(temp==nil){
        index = 0;
    }else{
        index = [self.serverArray indexOfObject:temp];
    }
    
    UIButton * btn = [_btnArray objectAtIndex:index];
    btn.selected = YES;
    
    if(btn.selected){
        btn.layer.borderWidth = 0;
        self.selectImgView.hidden = NO;
        self.selectImgView.frame = btn.bounds;
        [btn addSubview:self.selectImgView];
    }else{
        self.selectImgView.hidden = YES;
        btn.layer.borderWidth = 0.5*S6;
        btn.layer.borderColor = [BOARDCOLOR CGColor];
    }
    
//    NSLog(@"域名:%@---端口号:%@",[kUserDefaults objectForKey:IPSTRING],[kUserDefaults objectForKey:PORTSTRING]);
}

-(UIImage *)btnSelectedImg:(NSString *)currentImg{
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, FrameW*S6, FrameH*S6)];
    imgView.image = [UIImage imageNamed:currentImg];
    CALayer * layer = [CALayer layer];
    layer.frame = imgView.frame;
    layer.cornerRadius = 3*S6;
    layer.masksToBounds = YES;
    layer.contents = (id)[UIImage imageNamed:@"outside"].CGImage;
    [imgView.layer addSublayer:layer];
    return imgView.image;
}

-(NSString *)getCompareServer:(NSString *)currentServer{
    
    //尚金缘，和合，金百泰,百泰集团
    NSArray * localServers = @[@"zbtj.batar.cn:9999",@"zbtj.batar.cn:8888",@"zbtj.batar.cn:7777",@"zbtj.batar.cn:6666"];
    NSArray * localImgNames = @[@"showking",@"batar_jew",@"king_batar",@"batar_group"];
    NSString * imgName = currentServer;
    for(int i=0;i<localServers.count;i++){
        if([currentServer isEqualToString:localServers[i]]){
            imgName = localImgNames[i];
            break;
        }
    }
    return imgName;
}

-(UIImageView *)selectImgView{
    
    if(_selectImgView == nil){
        _selectImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"outside"]];
    }
    return _selectImgView;
}

@end
