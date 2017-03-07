
//
//  WaixingCell.m
//  DianZTC
//
//  Created by 杨力 on 6/5/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "WaixingCell.h"

@implementation WaixingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setImageView];
    }
    return self;
}

-(void)setImageView{
    
    //从文件读取数据
    NSString * plistPath = [NSString stringWithFormat:@"%@catagory.plist",LIBPATH];
    NSArray * fileArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
        NSArray * titleArray = fileArray[3];
    
   self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Wscreen, 90*titleArray.count*S6)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgView];
    
    //这里的按钮需要tag值从”tag ＝ 50“开始
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
        
        button.tag = i + 50;
        [self.bgView addSubview:button];
    }
    //最下面添加一根线
    UIView * bottonLineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.bgView.frame), CGRectGetWidth(self.bgView.frame), 0.6*S6)];
    bottonLineView.backgroundColor = BTNBORDCOLOR;
    [self.bgView addSubview:bottonLineView];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
