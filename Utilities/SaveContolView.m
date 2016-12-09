//
//  SaveContolView.m
//  DianZTC
//
//  Created by 杨力 on 7/9/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "SaveContolView.h"

@implementation SaveContolView

-(instancetype)init{
    
    if(self = [super init]){
        [self createView];
        self.hidden = YES;
    }
    return self;
}

-(void)createView{

    self.frame = CGRectMake(0, Hscreen-50*S6, Wscreen, 50*S6);
    
   self.deleteBtn = [Tools createNormalButtonWithFrame:CGRectMake(0, 0, Wscreen/2.0, 50*S6) textContent:@"全选" withFont:[UIFont systemFontOfSize:17*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [self.deleteBtn setTitle:@"取消全选" forState:UIControlStateSelected];
    self.deleteBtn.backgroundColor = RGB_COLOR(231, 140, 59, 1);
    [self addSubview:self.deleteBtn];
    
    self.cancelBtn = [Tools createNormalButtonWithFrame:CGRectMake(Wscreen/2.0, 0, Wscreen/2.0, 50*S6) textContent:@"删除" withFont:[UIFont systemFontOfSize:17*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.cancelBtn];
    self.cancelBtn.backgroundColor = RGB_COLOR(78, 68, 44, 1);
    
    [self.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)deleteAction{
    
    if(self.deleteBlock){
        self.deleteBlock();
    }
}
-(void)cancelAction{
    if(self.cancelBlock){
        self.cancelBlock();
    }
}

-(void)clickCancelBtn:(ControlDeleteBlock)block{
    
    self.cancelBlock = block;
}
-(void)clickDeleteBtn:(ControlDeleteBlock)block{
    self.deleteBlock = block;
}

@end
