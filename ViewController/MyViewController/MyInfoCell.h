//
//  MyInfoCell.h
//  DianZTC
//
//  Created by 杨力 on 7/9/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfoModel.h"

@interface MyInfoCell : UITableViewCell

@property (nonatomic,strong) UIImageView * infoImageView;
@property (nonatomic,strong) UILabel * infoLabel;

-(void)configCellWithModel:(MyInfoModel *)model;

@end
