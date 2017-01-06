//
//  SingleCollectionViewCell.h
//  DianZTC
//
//  Created by 杨力 on 6/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommandImageModel.h"

typedef void(^ClickImageBlock)(NSString * number);

@interface SingleCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView * showImageView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * numberLabel;


@property (nonatomic,copy) ClickImageBlock block;

@property (nonatomic,copy) NSString * number;

-(void)clickImageView:(ClickImageBlock)block;
-(void)configCell:(id)model;

@end
