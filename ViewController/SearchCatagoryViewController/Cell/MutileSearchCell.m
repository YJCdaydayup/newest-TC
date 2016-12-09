//
//  MutileSearchCell.m
//  DianZTC
//
//  Created by 杨力 on 6/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "MutileSearchCell.h"
#import "NetManager.h"

@implementation MutileSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setImageView];
    }
    return self;
}

-(void)setImageView{
    
    UIView * topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 1*S6)];
    topLineView.backgroundColor = RGB_COLOR(245, 245, 245, 1);
    [self.contentView addSubview:topLineView];
    
    for(int i=0;i<3;i++){
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(17.5*S6+i%3*110*S6+i%3*5*S6, 10*S6, 110*S6, 165/2.0*S6)];
        
        //给图片圆角
        imageView.layer.cornerRadius = 5.0*S6;
        imageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:imageView];
        
        if(i == 0){
            self.imageView1 = imageView;
        }else if (i == 1){
            
            self.imageView2 = imageView;
        }else{
            self.imageView3 = imageView;
        }
    }
    
    //在每个cell的下面添加一个灰色底
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, (20+165+18)/2.0*S6, Wscreen, 10*S6)];
    bottomView.backgroundColor = TABLEVIEWCOLOR;
    [self.contentView addSubview:bottomView];
}

-(void)setModel:(SearchCatagoryModel *)model{

    NSInteger width = 110*THUMBNAILRATE;
    NSInteger height = 82.5*THUMBNAILRATE;
    
    NetManager * manager = [NetManager shareManager];
    //拼接ip和port
    NSString * URLstring = [NSString stringWithFormat:BANNERCONNET,[manager getIPAddress]];
    UIImage * gifImage = [UIImage imageNamed:PLACEHOLDER];
    NSArray * imgDataArray = model.context;
    
    self.imageView1.image = [UIImage new];
    self.imageView2.image = [UIImage new];
    self.imageView3.image = [UIImage new];
    
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[Tools connectOriginImgStr:[NSString stringWithFormat:@"%@%@",URLstring,imgDataArray[0][@"img"]] width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:gifImage];
    if(imgDataArray.count>=2){
        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:[Tools connectOriginImgStr:[NSString stringWithFormat:@"%@%@",URLstring,imgDataArray[1][@"img"]] width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:gifImage];
        if(imgDataArray.count == 3){
            [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:[Tools connectOriginImgStr:[NSString stringWithFormat:@"%@%@",URLstring,imgDataArray[2][@"img"]] width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:gifImage];
        }
    }
    
    
    [self configImageShape:self.imageView1];
    [self configImageShape:self.imageView2];
    [self configImageShape:self.imageView3];
    
}

//让图片不变形
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
