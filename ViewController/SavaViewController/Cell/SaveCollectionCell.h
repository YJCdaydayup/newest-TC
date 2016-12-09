//
//  SaveCollectionCell.h
//  DianZTC
//
//  Created by 杨力 on 7/9/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBSaveModel.h"

typedef void(^ClickSelectedBtnBlock)(UIButton *button);
@interface SaveCollectionCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView * saveImgView;
@property (nonatomic,strong) UILabel * saveLabel;
@property (nonatomic,strong) UIButton * seletedBtn;
@property (nonatomic,copy) ClickSelectedBtnBlock block;
@property (nonatomic,strong) UIView * maskView;

-(void)configCellWithModel:(DBSaveModel *)model;
-(void)clickSelectedBtn:(ClickSelectedBtnBlock)block;


@end
