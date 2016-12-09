//
//  SerizeCell.h
//  DianZTC
//
//  Created by 杨力 on 5/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickBlock)(NSInteger index);

@interface SerizeCell : UITableViewCell<UIScrollViewDelegate>{
    
    UIScrollView * horisonScrollView;
    UIImageView * leftImg;
    UIImageView * rightImg;
    NSMutableArray * modelArr;
}

@property (nonatomic,copy) ClickBlock block;

//适配工具
@property (nonatomic,assign) CGFloat max_X;
@property (nonatomic,assign) CGFloat max_Y;

-(void)clickImageWithBlock:(ClickBlock)block;
-(void)setImageViewWithArray:(NSMutableArray *)modelArray;
@end
