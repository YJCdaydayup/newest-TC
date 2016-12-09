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
    }
    return self;
}


-(void)configImageView{
    
    self.showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*S6, 10*S6, 173*S6, 130*S6)];
    self.showImageView.layer.borderWidth = 2.5*S6;
    self.showImageView.layer.borderColor = [RGB_COLOR(227, 227, 227, 0.3) CGColor];
    [self.contentView addSubview:self.showImageView];
    
    //添加半透明的View
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*S6,148*S6,173*S6,16*S6)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:16*S6];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.alpha = 0.9;
    [self addSubview:self.titleLabel];
    self.backgroundColor = [UIColor whiteColor];
    
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
    
    NSInteger width = 173*THUMBNAILRATE;
    NSInteger height = 130*THUMBNAILRATE;
    
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
