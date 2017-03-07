

//
//  FinalOrderCell.m
//  DianZTC
//
//  Created by 杨力 on 11/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "FinalOrderCell.h"
#import "NetManager.h"

@implementation FinalOrderCell

- (void)awakeFromNib {
    // Initialization code
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
    
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(17.5*S6, CGRectGetMaxY(lineView.frame)+10*S6, 110*S6, 82.5*S6)];
    imgView.layer.borderWidth = 2.5*S6;
    imgView.layer.borderColor = [CELLBGCOLOR CGColor];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imgView];
    
    nameLabel = [Tools createLabelWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+17.5*S6, CGRectGetMinY(imgView.frame)+1.5*S6, 200, 14*S6) textContent:nil withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:nameLabel];
    
    self.numberLabel = [Tools createLabelWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame)+15*S6, 200, 14*S6) textContent:nil withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.numberLabel];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+10*S6, Wscreen, 0.5*S6)];
    lineView1.backgroundColor = BOARDCOLOR;
    [self.contentView addSubview:lineView1];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(Wscreen-50*S6, 0, 0.5*S6, 103.5*S6)];
    line.backgroundColor = BOARDCOLOR;
    [self.contentView addSubview:line];
    
    UIButton * detail_btn = [Tools createNormalButtonWithFrame:CGRectMake(Wscreen-50*S6, 0, 50*S6, 103.5*S6) textContent:@"详情" withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:detail_btn];
    [detail_btn addTarget:self action:@selector(getDetailInfo) forControlEvents:UIControlEventTouchUpInside];
}

-(void)getDetailInfo{
    
//  NSLog(@"%@",self.model.note);
    NSString * noteStr;
    NSMutableArray * messageArray;
    if(self.model.note != nil){
        noteStr = self.model.note;
        NSData * data = [noteStr dataUsingEncoding:NSUTF8StringEncoding];
        messageArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //    NSLog(@"%@",messageArray);
    }else{
        NSDictionary * dict = @{@"txt":@"暂无下单信息!"};
        messageArray = [[NSMutableArray alloc]initWithObjects:dict, nil];
    }
    
    if(self.block){
        self.block(messageArray,imgView.image,self.numberLabel.text,nameLabel.text);
    }
}

-(void)configCellWithModel:(OrderCarModel *)model{
    
    self.model = model;
    nameLabel.text = model.name;
    self.numberLabel.text = model.number;
    
    //拼接ip和port
    NetManager * manager = [NetManager shareManager];
    NSString * URLstring = [NSString stringWithFormat:BANNERCONNET,[manager getIPAddress]];
    UIImage * gifImage = [UIImage imageNamed:PLACEHOLDER];
    
    NSInteger width = 110*THUMBNAILRATE;
    NSInteger height = 165/2.0*THUMBNAILRATE;
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:[Tools connectOriginImgStr:[NSString stringWithFormat:@"%@%@",URLstring,model.image] width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:gifImage];
}

-(void)clickDetailBtn:(ClickDetailBtnBlock)block{
    
    self.block = block;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
