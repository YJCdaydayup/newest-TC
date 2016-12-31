//
//  ScanHistoryCell.m
//  DianZTC
//
//  Created by 杨力 on 30/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "ScanHistoryCell.h"

@implementation ScanHistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self createView];
    }
    return self;
}

-(void)createView{
    
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10*S6, 7.5*S6, 75*S6, 55*S6)];
    self.imgView.layer.borderWidth = 2.5*S6;
    self.imgView.layer.borderColor = [CELLBGCOLOR CGColor];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imgView];
    
    self.name = [Tools createLabelWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame)+20*S6, 28*S6, 55*S6, 14*S6) textContent:nil withFont:[UIFont systemFontOfSize:14*S6] textColor:CATAGORYTEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.name];
    
    self.number = [Tools createLabelWithFrame:CGRectMake(CGRectGetMaxX(self.name.frame)+20*S6, 28*S6, 150*S6, 14*S6) textContent:nil withFont:[UIFont systemFontOfSize:14*S6] textColor:CATAGORYTEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.number];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 69*S6, Wscreen, 1*S6)];
    line.backgroundColor = CELLBGCOLOR;
    [self.contentView addSubview:line];
}

-(CGFloat)getWidth:(NSString *)text{
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,14*S6) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*S6]} context:nil].size;
    return size.width;
}

-(void)setModel:(DBSaveModel *)model{
    
    self.imgView.image = [UIImage imageWithData:model.img];
    self.number.text = model.number;
    self.name.text = model.name;
    
    self.name.width = [self getWidth:model.name];
    self.number.x = CGRectGetMaxX(self.name.frame)+20*S6;
}

@end
