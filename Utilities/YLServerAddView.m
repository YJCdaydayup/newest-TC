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

#define FrameY  265.0
#define FrameW  135.0
#define FrameH  40

@interface YLServerAddView()
{
    BatarLoginController * _bgVc;
    NSMutableArray * _btnArray;
    NSString * selectIp_port;
    YLAddServer * addServer;
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
            [self configAddBtn:btn];
        }
        if(i == 0){
            btn.selected = YES;
        }
        [self addSubview:btn];
        [_btnArray addObject:btn];
    }
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
    //取货当前ip，port
    selectIp_port = self.serverArray[btn.tag];
    [kUserDefaults setObject:[self getIpWithPort:selectIp_port][0] forKey:IPSTRING];
    [kUserDefaults setObject:[self getIpWithPort:selectIp_port][1] forKey:PORTSTRING];
    NSLog(@"域名:%@---端口号:%@",[kUserDefaults objectForKey:IPSTRING],[kUserDefaults objectForKey:PORTSTRING]);
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
        
        [self getSelectedBtn];
        NSLog(@"域名:%@---端口号:%@",[kUserDefaults objectForKey:IPSTRING],[kUserDefaults objectForKey:PORTSTRING]);
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
    
    for(UIButton * btn in _btnArray){
        btn.selected = NO;
    }
    NSInteger index = [self.serverArray indexOfObject:temp];
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
    NSArray * localServers = @[@"zbtj.batar.cn:9999",@"zbtj.batar.cn:8888",@"zbtj.batar.cn:7777",@"zbtj.batar.cn:6660000"];
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
