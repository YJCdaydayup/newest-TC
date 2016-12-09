
//
//  ThemeCell.m
//  DianZTC
//
//  Created by 杨力 on 9/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "ThemeCell.h"
#import "NetManager.h"

@implementation ThemeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configImageView];
    }
    return self;
}

-(void)configImageView{
    
    self.productImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110*S6, 165/2.0*S6)];
    [self.contentView addSubview:self.productImageView];
    
    max_X = CGRectGetMaxX(self.productImageView.frame);
    //中间线条
    UIView * midLineView = [[UIView alloc]initWithFrame:CGRectMake(max_X, 0, 0.5*S6, 165/2.0*S6)];
    midLineView.backgroundColor = RGB_COLOR(227, 227, 227, 1);
    [self.contentView addSubview:midLineView];
    
    max_X = CGRectGetMaxX(midLineView.frame);
    
    //名称Label
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(max_X+75/2.0*S6, 69/2.0*S6, 100*S6, 14*S6)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:15*S6];
    self.titleLabel.textColor = TEXTCOLOR;
    [self.contentView addSubview:self.titleLabel];
    
    //底部加线条
    max_Y = CGRectGetMaxY(self.productImageView.frame);
    UIView * bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, max_Y-0.5*S6,self.frame.size.width, 0.5*S6)];
    bottomLineView.backgroundColor = RGB_COLOR(227, 227, 227, 1);
    [self.contentView addSubview:bottomLineView];
}

-(void)setModel:(ThemeDetailModel *)model{
    
    NSInteger width = 110*THUMBNAILRATE;
    NSInteger height = 82.5*THUMBNAILRATE;
    
    //拼接ip和port
    NetManager * manager = [NetManager shareManager];
    NSString * URLstring = [NSString stringWithFormat:BANNERCONNET,[manager getIPAddress]];
    self.titleLabel.text = model.name;
   UIImage * gifImage = [UIImage imageNamed:PLACEHOLDER];
    NSString * imgStr = [NSString stringWithFormat:@"%@%@",URLstring,model.image];
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:[Tools  connectOriginImgStr:imgStr width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:gifImage];
//    NSLog(@"%@",[Tools  connectOriginImgStr:imgStr width:GETSTRING(width) height:GETSTRING(height)]);
    [self configImageShape:self.productImageView];
}

-(void)configImageShape:(UIImageView *)imageView{
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.clipsToBounds = YES;
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
