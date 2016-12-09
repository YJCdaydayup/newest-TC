
//  YLScrollerView.m
//  自己写图片浏览器
//
//  Created by 杨力 on 28/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#define Y_POINT 7.5f
#define Height 165.0/2

#define LeftImageWidth 33.0/2

#import "YLScrollerView.h"

@interface YLScrollerView(){
    
   
    UIView * leftScanView;
    UIView * rightScanView;
}

@end

@implementation YLScrollerView

+(instancetype)shareImageManager{
    
    static YLScrollerView * ylView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ylView = [[YLScrollerView alloc]init];
    });
    return ylView;
}

-(instancetype)init{
    
    if(self = [super init]){
        self.frame = CGRectMake(0, Y_POINT*S6, Wscreen, Height*S6);
        [self createView];
    }
    return self;
}

-(void)createView{
    
    //左边的按钮
    leftScanView = [[UIView alloc]initWithFrame:CGRectMake(0,0, LeftImageWidth*S6,Height*S6)];
    leftScanView.backgroundColor = [UIColor clearColor];
    [self addSubview:leftScanView];
    
    //右边的按钮
    rightScanView = [[UIView alloc]initWithFrame:CGRectMake(Wscreen-LeftImageWidth*S6, 0, LeftImageWidth*S6, Height*S6)];
    rightScanView.backgroundColor = [UIColor clearColor];
    [self addSubview:rightScanView];
    
    //滚动视图
    self.scollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(LeftImageWidth*S6, 0, Wscreen-2*LeftImageWidth*S6, Height*S6)];
    self.scollerView.backgroundColor = [UIColor clearColor];
    self.scollerView.contentOffset = CGPointMake(0, 0);
    self.scollerView.delegate = self;
    self.scollerView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self addSubview:self.scollerView];
}

-(void)configScrollView:(BOOL)fromTag WithArray:(NSArray *)array{
    
//    NSInteger width = 110*THUMBNAILRATE;
//    NSInteger height = Height*THUMBNAILRATE;
    
    [self clearSubViews];
    self.scollerView.contentOffset = CGPointMake(0, 0);
    self.totalImgArray = [NSMutableArray array];
    if(fromTag == YES){
        
        self.scollerView.contentSize = CGSizeMake(115*S6*(array.count-1)+110*S6, Height*S6);
        for(int i=0;i<array.count;i++){
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*115*S6, 0, 110*S6, Height*S6)];
            imageView.image = [UIImage imageNamed:array[i]];
            [self resetImageView:imageView withTag:i];
        }
    }else{
        
        self.scollerView.contentSize = CGSizeMake(115*(array.count-1)*S6+110*S6, Height*S6);
        for(int i=0;i<array.count;i++){
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*115*S6, 0, 110*S6, Height*S6)];
            UIImage * gifImage = [UIImage imageNamed:PLACEHOLDER];
            [imageView sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:gifImage];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:[Tools connectOriginImgStr:array[i] width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:gifImage];
            [self resetImageView:imageView withTag:i];
        }
    }
}

-(void)resetImageView:(UIImageView *)imageView withTag:(NSInteger)tag{
    
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tag = tag;
    [self.scollerView addSubview:imageView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)];
    [imageView addGestureRecognizer:tap];
    [self.totalImgArray addObject:imageView];
    
    imageView.layer.borderColor = [BTNBORDCOLOR CGColor];
    imageView.layer.borderWidth = 1*S6;
    
    if(tag == 0){
        imageView.layer.borderWidth = 2.5*S6;
        imageView.layer.borderColor = [RGB_COLOR(231, 140, 59, 1) CGColor];
    }
}

-(void)clickImage:(UITapGestureRecognizer *)tap{
    UIImageView * imageView = (UIImageView *)tap.view;
    self.currentImgView = imageView;
    [self.delegate didClickScrollerImage:imageView.tag withImageView:imageView withImgArray:self.totalImgArray];
    
    //自动改变contenOffSet
    if(self.totalImgArray.count>3){
        
        if(imageView.tag >= 1&&imageView.tag !=0&&imageView.tag != self.totalImgArray.count-1){
            
            [self.scollerView setContentOffset:CGPointMake(115*S6*(imageView.tag-1), 0) animated:YES];
        }
    }
}

-(NSString *)captureLocalImage:(NSString *)imageName withType:(NSString *)imageType{
    
    return [[NSBundle mainBundle]pathForResource:imageName ofType:imageType];
}

-(void)clearSubViews{
    
    for(UIView * subView in self.scollerView.subviews){
        [subView removeFromSuperview];
    }
}


@end
