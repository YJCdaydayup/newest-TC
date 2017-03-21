//
//  BatarIndicatorView.m
//  DianZTC
//
//  Created by 杨力 on 20/3/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "BatarIndicatorView.h"

@interface BatarIndicatorView()

@property (nonatomic,strong) UILabel *titleLbl;

@end

@implementation BatarIndicatorView

+(instancetype)shareInstance{
    
    static BatarIndicatorView *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[BatarIndicatorView alloc]init];
        _instance.frame = CGRectMake(110*S6, 300/2.0*S6, 165*S6, 165*S6);
        _instance.titleLbl = [Tools createLabelWithFrame:CGRectMake(_instance.x-50*S6, _instance.y+_instance.height+15.5*S6, _instance.width+100*S6, 12*S6) textContent:nil withFont:[UIFont systemFontOfSize:12*S6] textColor:BatarPlaceTextCol textAlignment:NSTextAlignmentCenter];
    });
    return _instance;
}

+(void)showIndicatorWithTitle:(NSString *)title imageName:(NSString *)imgName inView:(UIView *)bgView hide:(BOOL)hide{
    
    BatarIndicatorView *indicator = [BatarIndicatorView shareInstance];
    indicator.image = [UIImage imageNamed:imgName];
    [bgView addSubview:indicator];
    
    indicator.titleLbl.text = title;
    [bgView addSubview:indicator.titleLbl];
    
    if(hide==YES){
        indicator.hidden = YES;
        indicator.titleLbl.hidden = YES;
    }else{
        indicator.hidden = NO;
        indicator.titleLbl.hidden = NO;
    }
}

@end
