

//
//  MySelectedOrderCell.m
//  DianZTC
//
//  Created by 杨力 on 2/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "MySelectedOrderCell.h"
#import "NetManager.h"

@implementation MySelectedOrderCell

- (void)awakeFromNib {
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self createView];
    }
    return self;
}

-(void)createView{
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 0*S6)];
    lineView.backgroundColor = BOARDCOLOR;
    [self.contentView addSubview:lineView];
    
    UIView * btnView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 42*S6, 103.5*S6)];
//    btnView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:btnView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTheBtn)];
    [btnView addGestureRecognizer:tap];
    
    self.select_btn = [Tools createButtonNormalImage:@"no_select" selectedImage:@"select" tag:1 addTarget:self action:@selector(selectBtn:)];
    self.select_btn.frame = CGRectMake(12.5*S6, CGRectGetMaxY(lineView.frame)+43*S6, 16*S6, 16*S6);
    [self.contentView addSubview:self.select_btn];
    
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.select_btn.frame)+17.5*S6, CGRectGetMaxY(lineView.frame)+10*S6, 110*S6, 82.5*S6)];
    imgView.layer.borderWidth = 2.5*S6;
    imgView.layer.borderColor = [CELLBGCOLOR CGColor];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imgView];
    
    nameLabel = [Tools createLabelWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+17.5*S6, CGRectGetMinY(imgView.frame)+1.5*S6, 200, 14*S6) textContent:nil withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:nameLabel];
    
    self.numberLabel = [Tools createLabelWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame)+15*S6, 200, 14*S6) textContent:nil withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.numberLabel];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+10*S6, Wscreen, 1*S6)];
    lineView1.backgroundColor = BOARDCOLOR;
    [self.contentView addSubview:lineView1];
}

-(void)selectBtn:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    if(self.block){
        self.block(btn);
    }
}

-(void)selectTheBtn{
    
    self.select_btn.selected = !self.select_btn.selected;
    if(self.block){
        self.block(self.select_btn);
    }
}

-(void)clickSelectedOrderBlock:(ClickSelectedOrderBlock)block{
    
    self.block = block;
}

-(void)configCellWithModel:(DBSaveModel *)model{
    
    if(model.selected){
        self.select_btn.selected = YES;
    }else{
        self.select_btn.selected = NO;
    }
    
    nameLabel.text = model.name;
    self.numberLabel.text = model.number;
    
    //拼接ip和port
//    NetManager * manager = [NetManager shareManager];
//    NSString * URLstring = [NSString stringWithFormat:BANNERCONNET,[manager getIPAddress]];
//    UIImage * gifImage = [UIImage imageNamed:PLACEHOLDER];
//    
//    NSInteger width = 110*THUMBNAILRATE;
//    NSInteger height = 165/2.0*THUMBNAILRATE;
    
    imgView.image = [UIImage imageWithData:model.img];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
