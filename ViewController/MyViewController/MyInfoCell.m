//
//  MyInfoCell.m
//  DianZTC
//
//  Created by 杨力 on 7/9/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "MyInfoCell.h"

@implementation MyInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self createView];
    }
    return self;
}

-(void)createView{
    
    self.infoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(35/2.0*S6, 20*S6, 43/2.0*S6, 45/2.0*S6)];
    [self.contentView addSubview:self.infoImageView];
    
    self.infoLabel = [Tools createLabelWithFrame:CGRectMake(CGRectGetMaxX(self.infoImageView.frame)+15*S6, 25*S6, 200, 16*S6) textContent:nil withFont:[UIFont systemFontOfSize:16*S6] textColor:RGB_COLOR(51, 51, 51, 1) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.infoLabel];
}

-(void)configCellWithModel:(MyInfoModel *)model{
    
    self.infoImageView.image = [UIImage imageNamed:model.imageName];
    self.infoLabel.text = model.itemName;
}

@end
