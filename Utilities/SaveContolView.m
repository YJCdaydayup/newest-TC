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
    
   self.selectAllBtn = [Tools createNormalButtonWithFrame:CGRectMake(0, 0, Wscreen/2.0, 50*S6) textContent:@"全选" withFont:[UIFont systemFontOfSize:17*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [self.selectAllBtn setTitle:@"取消全选" forState:UIControlStateSelected];
    self.selectAllBtn.backgroundColor = RGB_COLOR(231, 140, 59, 1);
    [self addSubview:self.selectAllBtn];
    
    self.deleteBtn = [Tools createNormalButtonWithFrame:CGRectMake(Wscreen/2.0, 0, Wscreen/2.0, 50*S6) textContent:@"删除" withFont:[UIFont systemFontOfSize:17*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.deleteBtn];
    self.deleteBtn.backgroundColor = RGB_COLOR(78, 68, 44, 1);
    
    [self.selectAllBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)selectAction{
    
    if(self.selectAllBlock){
        self.selectAllBlock();
    }
}
-(void)removeAction{
    if(self.deleteBlock){
        self.deleteBlock();
    }
}

-(void)clickDeleteBtn:(ControlDeleteBlock)block{
    
    self.deleteBlock = block;
}
-(void)clickSelectAll:(ControlSelectAllBlock)block{
    self.selectAllBlock = block;
}

@end
