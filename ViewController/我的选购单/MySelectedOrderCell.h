//
//  MySelectedOrderCell.h
//  DianZTC
//
//  Created by 杨力 on 2/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCarModel.h"

typedef void(^ClickSelectedOrderBlock)(UIButton * btn);

@interface MySelectedOrderCell : UITableViewCell{
    
    UIImageView * imgView;
    UILabel * nameLabel;
    
}

@property (nonatomic,copy) ClickSelectedOrderBlock block;
@property (nonatomic,strong) UIButton * select_btn;
@property (nonatomic,strong) UILabel * numberLabel;

-(void)configCellWithModel:(OrderCarModel *)model;

-(void)clickSelectedOrderBlock:(ClickSelectedOrderBlock)block;

@end
