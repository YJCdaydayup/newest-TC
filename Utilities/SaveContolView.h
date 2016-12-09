//
//  SaveContolView.h
//  DianZTC
//
//  Created by 杨力 on 7/9/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ControlDeleteBlock)();
typedef void(^ControlCancelBlock)();
@interface SaveContolView : UIView

@property (nonatomic,copy) ControlDeleteBlock deleteBlock;
@property (nonatomic,copy) ControlCancelBlock cancelBlock;
@property (nonatomic,strong) UIButton * deleteBtn;
@property (nonatomic,strong) UIButton * cancelBtn;

-(void)clickDeleteBtn:(ControlDeleteBlock)block;
-(void)clickCancelBtn:(ControlCancelBlock)block;

@end
