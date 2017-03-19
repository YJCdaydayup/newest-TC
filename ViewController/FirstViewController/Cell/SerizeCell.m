//
//  SerizeCell.m
//  DianZTC
//
//  Created by 杨力 on 5/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "SerizeCell.h"
#import <UIButton+AFNetworking.h>
#import <UIImage+GIF.h>
#import "NetManager.h"
#import "BannerModel.h"

@implementation SerizeCell

-(void)prepareForReuse{
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = CELLBGCOLOR;
    }
    return self;
}

-(void)setImageViewWithArray:(NSMutableArray *)modelArray{
    
    for(UIView * subView in self.contentView.subviews){
        [subView removeFromSuperview];
    }
    
    modelArr = modelArray;
    NetManager * manager = [NetManager shareManager];
    NSString * URLstring = [NSString stringWithFormat:GETTUIGUANGIMG,[manager getIPAddress]];
    
    //两边的箭头
    leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(7.5*S6, 40*S6, 6.5*S6, 13.5*S6)];
    leftImg.image = [UIImage sd_animatedGIFNamed:@"leftImg"];
    leftImg.hidden = YES;
    [self.contentView addSubview:leftImg];
    
    rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(Wscreen-18.5*S6, 40*S6, 6.5*S6, 13.5*S6)];
    rightImg.image = [UIImage sd_animatedGIFNamed:@"rightImg"];
    [self.contentView addSubview:rightImg];
    
    if(modelArr.count<=4){
        leftImg.hidden = YES;
        rightImg.hidden = YES;
    }
    
    //横向分布
    horisonScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 85*S6)];
    horisonScrollView.delegate = self;
    horisonScrollView.showsHorizontalScrollIndicator = NO;
    horisonScrollView.contentSize = CGSizeMake(modelArray.count*(Wscreen-32*S6)/4.0, 85*S6);
    [self.contentView addSubview:horisonScrollView];
    
    for(int i=0;i<modelArray.count;i++){
        
        BannerModel * model = [modelArray objectAtIndex:i];
        UIButton * imgBtn = [Tools createButtonNormalImage:nil selectedImage:nil tag:i addTarget:self action:@selector(clickImgBtn:)];
        [imgBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[self connectImage:URLstring withFollow:model.img]] placeholderImage:[UIImage imageNamed:@"places"]];
        UILabel * label = [Tools createLabelWithFrame:CGRectMake((Wscreen-32*S6)/4.0*i+14*S6, 50*S6,(Wscreen-32*S6)/4.0 , 55*S6) textContent:model.aliasname withFont:[UIFont systemFontOfSize:12*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
        [horisonScrollView addSubview:label];
           [horisonScrollView addSubview:imgBtn];
        if(modelArray.count <= 4){
            imgBtn.frame = CGRectMake((Wscreen-32*S6)/4.0*i+30*S6, 10*S6, 55*S6, 55*S6);
        }else{
            imgBtn.frame = CGRectMake((Wscreen-43*S6)/4.0*i+16*S6, 10*S6, 55*S6, 55*S6);
            label.frame = CGRectMake((Wscreen-43*S6)/4.0*i+3*S6, 50*S6,(Wscreen-43*S6)/4.0 , 55*S6);
        }
     
        
        imgBtn.layer.cornerRadius = 55/2.0*S6;
        imgBtn.layer.masksToBounds = YES;
        
    
    }
}

-(void)clickImgBtn:(UIButton *)btn{
    
    if(self.block){
        self.block(btn.tag);
    }
}

-(void)clickImageWithBlock:(ClickBlock)block{
    
    self.block = block;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView.contentOffset.x>=(Wscreen-32*S6)/4.0-15*S6){
        leftImg.hidden = NO;
    }
    if(scrollView.contentOffset.x<(Wscreen-32*S6)/4.0-15*S6){
        leftImg.hidden = YES;
    }
    
    if(scrollView.contentOffset.x >= (Wscreen-32*S6)/4.0*(modelArr.count-4)-15*S6){
        rightImg.hidden = YES;
    }
    
    if(scrollView.contentOffset.x < (Wscreen-32*S6)/4.0*(modelArr.count-4)-15*S6){
        rightImg.hidden = NO;
    }
}

-(NSString *)connectImage:(NSString *)urlStr withFollow:(NSString *)followStr{
    
    return [NSString stringWithFormat:@"%@%@",urlStr,followStr];
}

//加载本地图片
-(NSString *)getLocalImagePath:(NSString *)imageName{
    
    return [[NSBundle mainBundle]pathForResource:imageName ofType:@"png"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
