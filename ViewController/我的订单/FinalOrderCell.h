//
//  FinalOrderCell.h
//  DianZTC
//
//  Created by 杨力 on 11/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCarModel.h"

typedef void(^ClickDetailBtnBlock)(NSMutableArray * OrderMessage,UIImage * img,NSString * number,NSString * name);

@interface FinalOrderCell : UITableViewCell{
    
    UIImageView * imgView;
    UILabel * nameLabel;
}

@property (nonatomic,strong) UILabel * numberLabel;
@property (nonatomic,copy) ClickDetailBtnBlock block;
@property (nonatomic,strong) OrderCarModel * model;

-(void)configCellWithModel:(OrderCarModel *)model;
-(void)clickDetailBtn:(ClickDetailBtnBlock)block;

@end