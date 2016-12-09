
//
//  KezhongCell.m
//  DianZTC
//
//  Created by 杨力 on 6/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "KezhongCell.h"

@implementation KezhongCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setImageView];
    }
    return self;
}

-(void)setImageView{
    
   self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 280*S6)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgView];
    
    //从文件读取数据
    NSString * plistPath = [NSString stringWithFormat:@"%@catagory.plist",LIBPATH];
    NSArray * fileArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    NSArray * titleArray = fileArray[4];
    
    //这里的按钮需要tag值从”tag ＝ 70“开始
    for(int i=0;i<titleArray.count;i++){
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(12.5*S6+i%4*BUTTONWIDTH*S6+i%4*7.5*S6, i/4*BUTTONHEIGHT*S6+i/4*7.5*S6+10*S6, BUTTONWIDTH*S6, BUTTONHEIGHT*S6);
        button.layer.cornerRadius = 3.0*S6;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:CATAGORYTEXTCOLOR forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.layer.borderColor = [BTNBORDCOLOR CGColor];
        button.layer.borderWidth = 0.6*S6;
        button.titleLabel.font = [UIFont systemFontOfSize:14*S6];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = i+70;
        
        [self.bgView addSubview:button];
    }
    
//    //在最后一个按钮上面添加textField
//    [self cofigLastButton];
    //最下面添加一根线
    UIView * bottonLineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.bgView.frame), CGRectGetWidth(self.bgView.frame), 0.6*S6)];
    bottonLineView.backgroundColor = BTNBORDCOLOR;
    [self.bgView addSubview:bottonLineView];
}

-(void)cofigLastButton{
    
    //左边输入框
    self.leftTextField = [Tools createTextFieldFrame:CGRectMake(9*S6, 7.5*S6, 61*S6, 25*S6) placeholder:nil bgImageName:@"box" leftView:nil rightView:nil isPassWord:NO];
    self.leftTextField.font = [UIFont systemFontOfSize:15*S6];
    self.leftTextField.textColor = [UIColor blackColor];
    self.leftTextField.textAlignment = NSTextAlignmentCenter;
    [self.lastButton addSubview:self.leftTextField];
    
   //中间线条
    self.max_X = CGRectGetMaxX(self.leftTextField.frame);
    self.max_Y = CGRectGetMinY(self.leftTextField.frame);
    
    UIView * midLineView = [[UIView alloc]initWithFrame:CGRectMake(self.max_X+5*S6,self.max_Y + 11*S6, 8*S6, 1.5*S6)];
    midLineView.backgroundColor = RGB_COLOR(221, 221, 221, 1);
    [self.lastButton addSubview:midLineView];
    
//    右边输入框
    self.max_X = CGRectGetMaxX(midLineView.frame);
    self.rightTextField = [Tools createTextFieldFrame:CGRectMake(self.max_X+5*S6, 7.5*S6, 61*S6, 25*S6) placeholder:nil bgImageName:@"box" leftView:nil rightView:nil isPassWord:NO];
    self.rightTextField.font = [UIFont systemFontOfSize:15*S6];
    self.rightTextField.textColor = [UIColor blackColor];
    self.rightTextField.textAlignment = NSTextAlignmentCenter;
    [self.lastButton addSubview:self.rightTextField];
    
    //最右边的“g”
    self.max_X = CGRectGetMaxX(self.rightTextField.frame);
    UILabel * daniwei = [Tools createLabelWithFrame:CGRectMake(self.max_X+5*S6, self.max_Y+3*S6, 10*S6, 18*S6) textContent:@"g" withFont:[UIFont systemFontOfSize:16*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [self.lastButton addSubview:daniwei];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
