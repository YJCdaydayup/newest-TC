
//
//  ProductCell.m
//  DianZTC
//
//  Created by 杨力 on 5/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "ProductCell.h"
#import "NetManager.h"
#import <UIImage+GIF.h>

@interface ProductCell()
{
    UIView *_leftBgVc;
    UIView *_rightBgVc;
    BatarCommandSubModel *imgLeftModel;
    BatarCommandSubModel *imgRightModel;
}
@property (nonatomic,strong) UIImageView *leftImgView;
@property (nonatomic,strong) UILabel *leftNameLbl;
@property (nonatomic,strong) UILabel *leftNumberLbl;

@property (nonatomic,strong) UIImageView *rightImgView;
@property (nonatomic,strong) UILabel *rightNameLbl;
@property (nonatomic,strong) UILabel *rightNumberLbl;

@end

@implementation ProductCell

-(void)prepareForReuse{
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
    }
    return self;
}

-(void)createView{
    
    _leftBgVc = [[UIControl alloc]initWithFrame:CGRectMake(5*S6, 5*S6, 175*S6, 171*S6)];
    _leftBgVc.backgroundColor = [UIColor clearColor];
    _leftBgVc.layer.borderWidth = 0.5f;
    _leftBgVc.layer.borderColor = [BTNBORDCOLOR CGColor];
    _leftBgVc.userInteractionEnabled = YES;
    [self.contentView addSubview:_leftBgVc];
    _rightBgVc = [[UIControl alloc]initWithFrame:CGRectMake(185*S6, 5*S6, 178*S6, 171*S6)];
    _rightBgVc.backgroundColor = [UIColor clearColor];
    _rightBgVc.layer.borderWidth = 0.5f;
    _rightBgVc.layer.borderColor = [BTNBORDCOLOR CGColor];
    _rightBgVc.userInteractionEnabled = YES;
    [self.contentView addSubview:_rightBgVc];
    
    self.leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(8*S6, 5*S6, 168*S6, 135*S6)];
    self.leftImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.leftNameLbl = [Tools createLabelWithFrame:CGRectMake(0, 140*S6,180*S6, 15) textContent:nil withFont:[UIFont systemFontOfSize:13*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    self.leftNumberLbl = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.leftNameLbl.frame)+1*S6, 180*S6, 9*S6) textContent:nil withFont:[UIFont systemFontOfSize:9*S6] textColor:RGB_COLOR(102, 102, 102, 1) textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.leftImgView];
    [self.leftImgView addSubview:self.leftNameLbl];
    [self.leftImgView addSubview:self.leftNumberLbl];
    
    
    self.rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(190*S6, 5*S6, 168*S6, 135*S6)];
    self.rightImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.rightNameLbl = [Tools createLabelWithFrame:CGRectMake(0, 140*S6,180*S6, 15) textContent:nil withFont:[UIFont systemFontOfSize:13*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    self.rightNumberLbl = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.rightNameLbl.frame)+1*S6, 180*S6, 9*S6) textContent:nil withFont:[UIFont systemFontOfSize:9*S6] textColor:RGB_COLOR(102, 102, 102, 1) textAlignment:NSTextAlignmentCenter];
    [self.rightImgView addSubview:self.rightNameLbl];
    [self.rightImgView addSubview:self.rightNumberLbl];
    [self.contentView addSubview:self.rightImgView];
    
}

-(void)configCellWithModel:(BatarCommandSubModel *)leftModel rightModel:(id)obj{
    
    //拼接ip和port
    NetManager * manager = [NetManager shareManager];
    NSString * URLstring = [NSString stringWithFormat:BANNERCONNET,[manager getIPAddress]];
    UIImage * gifImage = [UIImage imageNamed:PLACEHOLDER];
    
    NSInteger width = 180*THUMBNAILRATE;
    NSInteger height = 135*THUMBNAILRATE;
    
    //左边
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:[Tools connectOriginImgStr:[self connectImage:URLstring withFollow:leftModel.image] width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:gifImage];
    self.leftNameLbl.text = leftModel.name;
    self.leftNumberLbl.text = leftModel.number;
    imgLeftModel = leftModel;
    [self addClickAction:self.leftImgView];
    //右边
    if([obj isKindOfClass:[BatarCommandSubModel class]]){
        BatarCommandSubModel *rightModel = (BatarCommandSubModel *)obj;
        [self.rightImgView sd_setImageWithURL:[NSURL URLWithString:[Tools connectOriginImgStr:[self connectImage:URLstring withFollow:rightModel.image] width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:gifImage];
        self.rightNameLbl.text = rightModel.name;
        self.rightNumberLbl.text = rightModel.number;
        imgRightModel = rightModel;
        [self addClickAction:self.rightImgView];
    }
}

//给图片添加点击事件
-(void)addClickAction:(UIImageView *)imageView{
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    [imageView addGestureRecognizer:tap];
}

-(void)clickAction:(UITapGestureRecognizer *)tap{
    
    UIImageView * image = (UIImageView *)tap.view;
    if(self.block){
        if(image == self.leftImgView){
            self.block(imgLeftModel.number);
        }else{
            self.block(imgRightModel.number);
        }
    }
}

-(void)clickImageForDetai:(ClickImageBlock)block{
    
    self.block = block;
}

#pragma mark －拼接图片网址
-(NSString *)connectImage:(NSString *)urlStr withFollow:(NSString *)followStr{
    
    return [NSString stringWithFormat:@"%@%@",urlStr,followStr];
}

//获取本地图片路径
-(NSString *)captureLocalImage:(NSString *)imageName withType:(NSString *)imageType{
    
    return [[NSBundle mainBundle]pathForResource:imageName ofType:imageType];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
