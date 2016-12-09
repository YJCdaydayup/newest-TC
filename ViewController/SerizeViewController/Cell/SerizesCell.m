
//
//  SerizesCell.m
//  DianZTC
//
//  Created by 杨力 on 6/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "SerizesCell.h"
#import "NetManager.h"

@implementation SerizesCell

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
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(16.5*S6+i%3*110*S6+i%3*5*S6, 10*S6, 110*S6, 165/2.0*S6)];
        [self.contentView addSubview:imageView];
        
        if(i == 0){
            
            self.imageView1 = imageView;
        }else if (i == 1){
            
            self.imageView2 = imageView;
        }else{
            self.imageView3 = imageView;
        }
    }
}

-(void)setModel:(SerizeModel *)model{
    
    NSArray * imgArray = model.imgs;
    //拼接ip和port
    NetManager * manager = [NetManager shareManager];
    NSString * URLstring = [NSString stringWithFormat:BANNERCONNET,[manager getIPAddress]];
    UIImage * gifImage = [UIImage imageNamed:PLACEHOLDER];
    
     NSInteger width = 110*THUMBNAILRATE;
    NSInteger height = 165/2.0*THUMBNAILRATE;
    
    if(imgArray.count == 3){
        
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[Tools connectOriginImgStr:[NSString stringWithFormat:@"%@%@",URLstring,imgArray[0][@"img"]] width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:gifImage];
         [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:[Tools connectOriginImgStr:[NSString stringWithFormat:@"%@%@",URLstring,imgArray[1][@"img"]] width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:gifImage];
         [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:[Tools connectOriginImgStr:[NSString stringWithFormat:@"%@%@",URLstring,imgArray[2][@"img"]] width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:gifImage];
        
        self.imageView1.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView2.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView3.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    [self configImg:self.imageView1];
    [self configImg:self.imageView2];
    [self configImg:self.imageView3];
}

-(void)configImg:(UIImageView *)imgView{
    
    imgView.layer.borderColor = [BTNBORDCOLOR CGColor];
    imgView.layer.borderWidth = 1*S6;
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
