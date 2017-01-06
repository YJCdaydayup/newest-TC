
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

@implementation ProductCell

@synthesize bgVc = _bgVc;

-(void)prepareForReuse{
    
    [_bgVc removeFromSuperview];
    _bgVc = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

-(void)setImageView:(NSMutableArray *)imgArray{
    
    UIImageView * lastImg;
    
    for(int i=0;i<imgArray.count;i++){
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5*S6+i%2*185*S6, i/2*175*S6, 180*S6, 135*S6)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imgView];
        
        _bgVc = [[UIView alloc]initWithFrame:CGRectMake(5*S6+i%2*185*S6, i/2*175*S6, 180*S6, 175*S6)];
        _bgVc.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_bgVc];
        
        _bgVc.layer.borderWidth = 0.5f;
        _bgVc.layer.borderColor = [BTNBORDCOLOR CGColor];
        
        self.max_X = CGRectGetMinX(imgView.frame);
        self.max_Y = CGRectGetMaxY(imgView.frame);
        
        UILabel * titleLabel = [Tools createLabelWithFrame:CGRectMake(0, 140*S6,180*S6, 15) textContent:nil withFont:[UIFont systemFontOfSize:13*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
        UILabel * numberLabel = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+2*S6, 180*S6, 9*S6) textContent:nil withFont:[UIFont systemFontOfSize:9*S6] textColor:RGB_COLOR(102, 102, 102, 1) textAlignment:NSTextAlignmentCenter];
        [imgView addSubview:titleLabel];
        [imgView addSubview:numberLabel];
        
        imgView.tag = 6666+i;
        if(i==imgArray.count-1){
            lastImg = imgView;
        }
        
        [self addClickAction:imgView withTag:imgView.tag];
    }
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lastImg.frame)+40*S6, Wscreen, 5*S6)];
    bgView.backgroundColor = TABLEVIEWCOLOR;
    [self.contentView addSubview:bgView];
    
    [self configCellWithArray:imgArray];
}

-(void)configCellWithArray:(NSArray *)dataArray{
    
    for(int i=0;i<dataArray.count;i++){
        
        [self addImageData:i withModel:dataArray[i]];
    }
}

-(void)addImageData:(NSInteger)tag withModel:(BatarCommandSubModel *)model{
    
    //拼接ip和port
    NetManager * manager = [NetManager shareManager];
    NSString * URLstring = [NSString stringWithFormat:BANNERCONNET,[manager getIPAddress]];
    
    UIImageView * imgView = (UIImageView *)[self.contentView viewWithTag:6666+tag];
    UIImage * gifImage = [UIImage imageNamed:PLACEHOLDER];
    
    NSInteger width = 180*THUMBNAILRATE;
    NSInteger height = 135*THUMBNAILRATE;
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:[Tools connectOriginImgStr:[self connectImage:URLstring withFollow:model.image] width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:gifImage];
    UILabel * nameLabel = imgView.subviews.firstObject;
    UILabel * numberLabel = imgView.subviews[1];
    nameLabel.text = model.name;
    numberLabel.text = model.number;
}

//给图片添加点击事件
-(void)addClickAction:(UIImageView *)imageView withTag:(NSInteger)tag{
    
    imageView.userInteractionEnabled = YES;
    imageView.tag = tag;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    [imageView addGestureRecognizer:tap];
}

-(void)clickAction:(UITapGestureRecognizer *)tap{
    
    UIImageView * image = (UIImageView *)tap.view;
    if(self.block){
        self.block(image.tag-6666);
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
