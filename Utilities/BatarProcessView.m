//
//  BatarProcessView.m
//  进度
//
//  Created by 杨力 on 6/3/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "BatarProcessView.h"

@interface BatarProcessView()
{
    UIImageView *_firstImgView;
    UILabel *_firstLbl;
    
    UIImageView *_cancelImgView1;
    UILabel *_cancelLbl1;
    
    UIImageView *_secondImgView;
    UILabel *_secondLbl;
    
    UIImageView *_cancelImgView2;
    UILabel *_cancelLbl2;
    
    UIImageView *_thirdImgView;
    UILabel *_thirdLbl;
    
    UIView *_line1;
    UIView *_line2;
    UIView *_line3;
    UIView *_line4;
}
@end

#define Hscreen [UIScreen mainScreen].bounds.size.height
#define Wscreen [UIScreen mainScreen].bounds.size.width

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation BatarProcessView

-(instancetype)init{
    
    if(self = [super init]){
        
        [self createView];
    }
    return self;
}

-(void)createView{
    
    self.frame = CGRectMake(0, 0, Wscreen, 50*S6);
    UIView * bgLV = [[UIView alloc]initWithFrame:CGRectMake(50*S6, 31.5*S6, Wscreen-100*S6, 2.5*S6)];
    bgLV.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [self addSubview:bgLV];
    
    _line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bgLV.width/4, bgLV.height)];
    _line1.backgroundColor = [UIColor colorWithRed:210/255.0 green:140/255.0 blue:66/255.0 alpha:1];
    [bgLV addSubview:_line1];
    
    _line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bgLV.width/2, bgLV.height)];
    _line2.backgroundColor = [UIColor colorWithRed:210/255.0 green:140/255.0 blue:66/255.0 alpha:1];
    [bgLV addSubview:_line2];
    
    _line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bgLV.width*3/4, bgLV.height)];
    _line3.backgroundColor = [UIColor colorWithRed:210/255.0 green:140/255.0 blue:66/255.0 alpha:1];
    [bgLV addSubview:_line3];
    
    _line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bgLV.width, bgLV.height)];
    _line4.backgroundColor = [UIColor colorWithRed:210/255.0 green:140/255.0 blue:66/255.0 alpha:1];
    [bgLV addSubview:_line4];
    
    CGFloat lineW = bgLV.frame.size.width;
    CGFloat lineH = bgLV.frame.size.height;
    
    CGPoint point1 = CGPointMake(0, lineH/2.0);
    CGPoint point2 = CGPointMake(lineW/4.0,lineH/2.0);
    CGPoint point3 = CGPointMake(lineW/2.0, lineH/2.0);
    CGPoint point4 = CGPointMake(lineW*3/4, lineH/2.0);
    CGPoint point5 = CGPointMake(lineW, lineH/2.0);
    
    NSArray * array = @[NSStringFromCGPoint(point1),NSStringFromCGPoint(point2),NSStringFromCGPoint(point3),NSStringFromCGPoint(point4),NSStringFromCGPoint(point5)];
    
    NSArray * title = @[@"待明细",@"已取消",@"待确认",@"已取消",@"已确认"];
    for(NSInteger i = 0;i<5;i++){
        
        UIImageView * imgV = [[UIImageView alloc]init];
        imgV.center = CGPointFromString(array[i]);
        imgV.size = CGSizeMake(13*S6, 13*S6);
        imgV.y = imgV.y -6*S6;
        imgV.x = imgV.x - 6*S6;
        imgV.image = [UIImage imageNamed:@"process_sel"];
        [bgLV addSubview:imgV];
        
        UILabel * label = [Tools createLabelWithFrame:CGRectMake(-15*S6, imgV.y-12*S6, 45*S6, 12*S6) textContent:title[i] withFont:[UIFont systemFontOfSize:12*S6] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        [imgV addSubview:label];
        
        switch (i) {
            case 0:
                _firstImgView = imgV;
                _firstLbl = label;
                break;
            case 1:
                _cancelImgView1 = imgV;
                _cancelLbl1 = label;
                break;
            case 2:
                _secondImgView = imgV;
                _secondLbl = label;
                break;
            case 3:
                _cancelImgView2 = imgV;
                _cancelLbl2 = label;
                break;
            case 4:
                _thirdImgView = imgV;
                _thirdLbl = label;
                break;
            default:
                break;
        }
    }
    
    UIView * bottom = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)-1*S6, Wscreen, 0.5*S6)];
    bottom.backgroundColor = BOARDCOLOR;
    [self addSubview:bottom];
}

-(void)changeProgress:(ProcessStyle)style{
    
    switch (style) {
        case BatarWaitDetailStyle:
            
            _cancelImgView1.hidden = YES;
            _cancelImgView2.hidden = YES;
            _secondImgView.image = [UIImage imageNamed:@"process_nor"];
            _thirdImgView.image = [UIImage imageNamed:@"process_nor"];
            
            _line1.hidden = YES;
            _line2.hidden = YES;
            _line3.hidden = YES;
            _line4.hidden = YES;
            
            _secondLbl.textColor = RGB(152, 152, 152);
            _thirdLbl.textColor = _secondLbl.textColor;
            break;
        case BatarDetailCancelStyle:
            
            _cancelImgView1.hidden = NO;
            _cancelImgView2.hidden = YES;
            _secondImgView.image = [UIImage imageNamed:@"process_nor"];
            _thirdImgView.image = [UIImage imageNamed:@"process_nor"];
            
            _line1.hidden = NO;
            _line2.hidden = YES;
            _line3.hidden = YES;
            _line4.hidden = YES;
            
            _secondLbl.textColor = RGB(152, 152, 152);
            _thirdLbl.textColor = _secondLbl.textColor;
            
            break;
        case BatarWaitConfirmStyle:
            
            _cancelImgView1.hidden = YES;
            _cancelImgView2.hidden = YES;
            _secondImgView.image = [UIImage imageNamed:@"process_sel"];
            _thirdImgView.image = [UIImage imageNamed:@"process_nor"];
            
            _line1.hidden = YES;
            _line2.hidden = NO;
            _line3.hidden = YES;
            _line4.hidden = YES;
            
            _secondLbl.textColor = [UIColor blackColor];
            _thirdLbl.textColor = RGB(152, 152, 152);
            
            break;
        case BatarWaitConfirmCancelStyle:
            
            _cancelImgView1.hidden = YES;
            _cancelImgView2.hidden = NO;
            _secondImgView.image = [UIImage imageNamed:@"process_sel"];
            _thirdImgView.image = [UIImage imageNamed:@"process_nor"];
            
            _line1.hidden = YES;
            _line2.hidden = YES;
            _line3.hidden = NO;
            _line4.hidden = YES;
            
            _thirdLbl.textColor = RGB(152, 152, 152);

            break;
        case BatarConfirmStyle:
            
            _cancelImgView1.hidden = YES;
            _cancelImgView2.hidden = YES;
            _secondImgView.image = [UIImage imageNamed:@"process_sel"];
            _thirdImgView.image = [UIImage imageNamed:@"process_sel"];
            
            _line1.hidden = YES;
            _line2.hidden = YES;
            _line3.hidden = YES;
            _line4.hidden = NO;
            
            _thirdLbl.textColor = [UIColor blackColor];
            
            break;
            case batarConfirmCancelStyle:
            
            _cancelImgView1.hidden = YES;
            _cancelImgView2.hidden = YES;
            _secondImgView.image = [UIImage imageNamed:@"process_sel"];
            _thirdImgView.image = [UIImage imageNamed:@"process_sel"];
            
            _line1.hidden = YES;
            _line2.hidden = YES;
            _line3.hidden = YES;
            _line4.hidden = NO;
            
            _thirdLbl.text = @"已取消";
            _thirdLbl.textColor = [UIColor blackColor];
            break;
        default:
            break;
    }
}


@end
