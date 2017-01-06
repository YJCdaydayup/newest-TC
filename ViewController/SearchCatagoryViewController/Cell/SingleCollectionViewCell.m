//
//  SingleCollectionViewCell.m
//  DianZTC
//
//  Created by 杨力 on 6/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "SingleCollectionViewCell.h"
#import "NetManager.h"
#import "DBSaveModel.h"

@implementation SingleCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self configImageView];
        
        self.layer.borderColor = [BOARDCOLOR CGColor];
        self.layer.borderWidth = 0.5*S6;
    }
    return self;
}


-(void)configImageView{
    
    self.showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0*S6,0, 179*S6, 154*S6)];
//    self.showImageView.layer.borderWidth = 0.5*S6;
//    self.showImageView.layer.borderColor = [RGB_COLOR(29, 227, 227, 1) CGColor];
    [self.contentView addSubview:self.showImageView];
    
    //添加半透明的View
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*S6,145*S6,173*S6,16*S6)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13*S6];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.alpha = 0.9;
    self.titleLabel.centerX = self.showImageView.centerX;
    [self addSubview:self.titleLabel];
    self.backgroundColor = [UIColor whiteColor];
    
    self.numberLabel = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame)+2*S6, Wscreen, 9*S6) textContent:nil withFont:[UIFont systemFontOfSize:9*S6] textColor:RGB_COLOR(102, 102, 102, 1) textAlignment:NSTextAlignmentCenter];
    self.numberLabel.centerX = self.showImageView.centerX;
    [self.contentView addSubview:self.numberLabel];
    
    self.showImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSingleImage)];
    [self.showImageView addGestureRecognizer:tap];
}

-(void)clickImageView:(ClickImageBlock)block{
    
    self.block = block;
}

#pragma mark -点击图片
-(void)clickSingleImage{
    
    if(self.block){
        
        self.block(self.number);
    }
}

-(void)configCell:(id)model{
    
    NSInteger width = 179*THUMBNAILRATE;
    NSInteger height = 154*THUMBNAILRATE;
    
    if([model isKindOfClass:[RecommandImageModel class]]){
        
        RecommandImageModel * re_Model = (RecommandImageModel *)model;
        self.number = re_Model.number;
        //拼接ip和port
        NetManager * manager = [NetManager shareManager];
        NSString * URLstring = [NSString stringWithFormat:BANNERCONNET,[manager getIPAddress]];
        UIImage * gifImage = [UIImage imageNamed:PLACEHOLDER];
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:[Tools connectOriginImgStr:[NSString stringWithFormat:@"%@%@",URLstring,re_Model.img] width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:gifImage];
        self.showImageView.contentMode = UIViewContentModeScaleAspectFit;
        if(re_Model.name){
            self.titleLabel.text = re_Model.name;
        }else{
            self.titleLabel.text = @"Product Name";
        }
        self.numberLabel.text = re_Model.number;
    }
}

#pragma mark －拼接图片网址
-(NSString *)connectImage:(NSString *)urlStr withFollow:(NSString *)followStr{
    
    return [NSString stringWithFormat:@"%@%@",urlStr,followStr];
}

//获取本地图片路径
-(NSString *)captureLocalImage:(NSString *)imageName withType:(NSString *)imageType{
    
    return [[NSBundle mainBundle]pathForResource:imageName ofType:imageType];
}


@end
