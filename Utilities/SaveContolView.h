//
//  SaveContolView.h
//  DianZTC
//
//  Created by 杨力 on 7/9/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ControlSelectAllBlock)();
typedef void(^ControlDeleteBlock)();
@interface SaveContolView : UIView

@property (nonatomic,copy) ControlSelectAllBlock selectAllBlock;
@property (nonatomic,copy) ControlDeleteBlock deleteBlock;
@property (nonatomic,strong) UIButton * selectAllBtn;
@property (nonatomic,strong) UIButton * deleteBtn;

-(void)clickSelectAll:(ControlSelectAllBlock)block;
-(void)clickDeleteBtn:(ControlDeleteBlock)block;

@end
