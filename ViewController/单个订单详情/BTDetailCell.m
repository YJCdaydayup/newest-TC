//
//  BTDetailCell.m
//  DianZTC
//
//  Created by 杨力 on 1/3/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "BTDetailCell.h"
#import "BTDetailModel.h"
#import <UIImageView+WebCache.h>

#define itemWidth  (Wscreen-24.5*S6)/3.0
#define itemHeight 35.0*S6

@interface BTDetailCell(){
    
    UIScrollView * _bgScrollView;
}
@end

@implementation BTDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self createView];
    }
    return self;
}

-(void)createView{
    
    //    self.backgroundColor = [UIColor greenColor];
}

-(void)setModel:(BTDetailModel *)model{
    
    for(UIView * subView in self.subviews){
        [subView removeFromSuperview];
    }
    
    UILabel * lastLbl;
    for(int i=0;i<model.details.count;i++){
        BTDetailSubModel * subModel = model.details[i];
        NSArray * contentArray = @[subModel.shipment_pro_weight,subModel.shipment_pro_weight,subModel.shipment_number];
        for(int j=0;j<3;j++){
            UILabel * nameLbl = [Tools createLabelWithFrame:CGRectMake(24.5*S6+itemWidth*j, itemHeight*i, itemWidth+0.8*S6, 35*S6+0.8*S6) textContent:contentArray[j] withFont:[UIFont systemFontOfSize:12*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
            nameLbl.layer.borderColor = [BOARDCOLOR CGColor];
            nameLbl.layer.borderWidth = 0.8*S6;
            if(j==2){
                lastLbl = nameLbl;
            }
            [self addSubview:nameLbl];
        }
    }
    
    UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lastLbl.frame)-0.8*S6, 24.5*S6, 0.8*S6)];
    bottomLine.backgroundColor = BOARDCOLOR;
    [self addSubview:bottomLine];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
