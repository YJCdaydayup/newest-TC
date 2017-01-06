//
//  ProductCell.h
//  DianZTC
//
//  Created by 杨力 on 5/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BatarCommandSubModel.h"

typedef void(^ClickImageBlock)(NSInteger index);

@interface ProductCell : UITableViewCell

//适配工具
@property (nonatomic,assign) CGFloat max_X;
@property (nonatomic,assign) CGFloat max_Y;

@property (nonatomic,copy) ClickImageBlock block;
@property (nonatomic,strong) UIView * bgVc;

-(void)configCellWithArray:(NSArray *)dataArray;
-(void)clickImageForDetai:(ClickImageBlock)block;
-(void)setImageView:(NSMutableArray *)imgArray;

@end
