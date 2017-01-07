//
//  ScanHistoryCell.m
//  DianZTC
//
//  Created by 杨力 on 30/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "ScanHistoryCell.h"
#import "NetManager.h"

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
    
    self.name = [Tools createLabelWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame)+20*S6, 17*S6, 55*S6, 14*S6) textContent:nil withFont:[UIFont systemFontOfSize:14*S6] textColor:CATAGORYTEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.name];
    
    self.number = [Tools createLabelWithFrame:CGRectMake(CGRectGetMaxX(self.name.frame)+20*S6, 17*S6, 150*S6, 14*S6) textContent:nil withFont:[UIFont systemFontOfSize:14*S6] textColor:CATAGORYTEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.number];
    
    self.date = [Tools createLabelWithFrame:CGRectMake(CGRectGetMinX(self.name.frame), CGRectGetMaxY(self.name.frame)+10*S6, Wscreen, 12*S6) textContent:nil withFont:[UIFont systemFontOfSize:12*S6] textColor:BatarPlaceTextCol textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.date];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 69*S6, Wscreen, 1*S6)];
    line.backgroundColor = CELLBGCOLOR;
    [self.contentView addSubview:line];
}

-(CGFloat)getWidth:(NSString *)text{
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,14*S6) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*S6]} context:nil].size;
    return size.width;
}

-(void)setModel:(DBSaveModel *)model{
    
    /*
     @property (nonatomic,copy) NSString * number;
     @property (nonatomic,strong) id img;
     @property (nonatomic,copy) NSString * name;
     @property (nonatomic,copy) NSString * date;
     @property (nonatomic,copy) NSString * type;
     @property (nonatomic,copy) NSString * searchType;
     */
    // 保存的img的格式:model.img = http://192.168.21.158:8888/photo-album/image/161108150641668_4ebc0d4af0259834378a82faefd0999b.jpg
    
    NSInteger width = 75*THUMBNAILRATE;
    NSInteger height = 55*THUMBNAILRATE;
    UIImage * gifImage;
    if([model.type isEqualToString:CodeTypeQRCode]){
        //二维码
        gifImage = [UIImage imageNamed:@"erweima"];
    }else if([model.type isEqualToString:CodeTypeBarCode]){
        //条形码
        gifImage = [UIImage imageNamed:@"tiaoma"];
    }else{
        //错误码
        gifImage = [UIImage imageNamed:@"tiaoma"];
    }
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[Tools connectOriginImgStr:[NSString stringWithFormat:@"%@",model.img] width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:gifImage];
    
    if([model.searchType isEqualToString:CodeTypeAccurary]){
        //精确
        self.number.text = model.number;
        self.name.text = model.name;
        self.date.text = model.date;
        self.name.width = [self getWidth:model.name];
        self.number.x = CGRectGetMaxX(self.name.frame)+20*S6;
    }else if ([model.searchType isEqualToString:CodeTypeInaccurary]){
        //模糊
        self.name.text = model.number;
        self.name.width = Wscreen;
        self.date.text = model.date;
    }else{
        //不存在
        self.name.text = @"未发现对应产品";
        self.number.text = model.number;
        self.date.text = model.date;
        self.name.width = [self getWidth:self.name.text];
        self.number.x = CGRectGetMaxX(self.name.frame)+20*S6;
    }
    
//    if(model.name.length==0){
//        self.name.text = model.number;
//        self.name.width = Wscreen;
//        self.date.text = model.date;
//    }else{
//        self.number.text = model.number;
//        self.name.text = model.name;
//        self.date.text = model.date;
//        self.name.width = [self getWidth:model.name];
//        self.number.x = CGRectGetMaxX(self.name.frame)+20*S6;
//    }
}

@end
