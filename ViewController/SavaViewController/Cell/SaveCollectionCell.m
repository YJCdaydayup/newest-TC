//
//  SaveCollectionCell.m
//  DianZTC
//
//  Created by 杨力 on 7/9/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "SaveCollectionCell.h"
#import "NetManager.h"

@implementation SaveCollectionCell

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showSelectBtn) name:SaveCellEditNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideSelectBtn) name:SaveCellCancelEditNotification object:nil];
        
        [self createView];
    }
    return self;
}

-(void)showSelectBtn{
    
    self.seletedBtn.hidden = NO;
    self.saveImgView.userInteractionEnabled = YES;
}

-(void)hideSelectBtn{
    
    self.seletedBtn.hidden = YES;
    self.maskView.hidden = YES;
    self.saveImgView.userInteractionEnabled = NO;
}

-(void)createView{
    
    self.backgroundColor = [UIColor whiteColor];
    self.saveImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110*S6, 82.5*S6)];
    self.saveImgView.layer.borderWidth = 1;
    self.saveImgView.layer.borderColor = [BTNBORDCOLOR CGColor];
    [self.contentView addSubview:self.saveImgView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectBtn)];
    [self.saveImgView addGestureRecognizer:tap];
    
    self.maskView = [[UIView alloc]initWithFrame:self.saveImgView.frame];
    self.maskView.backgroundColor = RGB_COLOR(255, 255, 255, 0.5);
    self.maskView.hidden = YES;
    [self.contentView addSubview:self.maskView];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectBtn)];
    self.maskView.userInteractionEnabled = YES;
    [self.maskView addGestureRecognizer:tap1];
    
    self.saveLabel = [Tools createLabelWithFrame:CGRectMake(0, 90*S6, 110*S6, 14*S6) textContent:nil withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.saveLabel];
    
    self.seletedBtn = [Tools createButtonNormalImage:@"save_unselected" selectedImage:@"save_selected" tag:0 addTarget:self action:@selector(seletedAction:)];
    self.seletedBtn.frame = CGRectMake(95*S6, 135/2.0*S6, 15*S6, 15*S6);
    self.seletedBtn.hidden = YES;
    [self.contentView addSubview:self.seletedBtn];
}

-(void)selectBtn{
    
    if(self.block){
        self.block(self.seletedBtn);
    }
}

-(void)seletedAction:(UIButton *)btn{
    
    if(self.block){
        self.block(btn);
    }
}

-(void)clickSelectedBtn:(ClickSelectedBtnBlock)block{
    
    self.block = block;
}

-(void)configCellWithModel:(DBSaveModel *)model{
    
//    CGFloat width = 110*S6;
//    CGFloat height = 82.5*S6;
    
    NetManager * manager = [NetManager shareManager];
    NSString * URLstring = [NSString stringWithFormat:BANNERCONNET,[manager getIPAddress]];
    URLstring = [NSString stringWithFormat:@"%@%@",URLstring,model.image];
    
    if(CUSTOMERID){
//        [self.saveImgView sd_setImageWithURL:[NSURL URLWithString:[Tools connectOriginImgStr:URLstring width:GETSTRING(width) height:GETSTRING(height)]] placeholderImage:[UIImage imageNamed:PLACEHOLDER]];
        [self.saveImgView sd_setImageWithURL:[NSURL URLWithString:URLstring] placeholderImage:[UIImage imageNamed:PLACEHOLDER]];
    }else{
        self.saveImgView.image = [UIImage imageWithData:model.img];
    }
    self.saveImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.saveImgView.clipsToBounds = YES;
    self.saveLabel.text = model.name;
    if(model.selected){
        self.seletedBtn.selected = YES;
        self.maskView.hidden = NO;
    }else{
        self.seletedBtn.selected = NO;
        self.maskView.hidden = YES;
    }
}

@end
