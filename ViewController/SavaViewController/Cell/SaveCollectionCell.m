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

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self createView];
    }
    return self;
}

-(void)createView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.saveImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110*S6, 82.5*S6)];
    //self.saveImgView.backgroundColor = [UIColor yellowColor];
    self.saveImgView.layer.borderWidth = 1;
    self.saveImgView.layer.borderColor = [BTNBORDCOLOR CGColor];
    [self.contentView addSubview:self.saveImgView];
    
    self.maskView = [[UIView alloc]initWithFrame:self.saveImgView.frame];
    self.maskView.backgroundColor = RGB_COLOR(255, 255, 255, 0.5);
    self.maskView.hidden = YES;
    [self.contentView addSubview:self.maskView];
    
    self.saveLabel = [Tools createLabelWithFrame:CGRectMake(0, 90*S6, 110*S6, 14*S6) textContent:nil withFont:[UIFont systemFontOfSize:14*S6] textColor:TEXTCOLOR textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.saveLabel];
    
    self.seletedBtn = [Tools createButtonNormalImage:@"save_unselected" selectedImage:@"save_selected" tag:0 addTarget:self action:@selector(seletedAction:)];
    self.seletedBtn.frame = CGRectMake(95*S6, 135/2.0*S6, 15*S6, 15*S6);
    if([kUserDefaults objectForKey:SHOWSAVEBUTTON]){
        self.seletedBtn.hidden = NO;
//                NSLog(@"显示");
    }else{
//                NSLog(@"不显示");
        self.seletedBtn.hidden = YES;
    }
    [self.contentView addSubview:self.seletedBtn];
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
    
//    NSLog(@"%@",model.name);
    self.saveImgView.image = [UIImage imageWithData:model.img];
    self.saveImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.saveImgView.clipsToBounds = YES;
    self.saveLabel.text = model.name;
}

@end
