//
//  YLFinalOrderView.h
//  DianZTC
//
//  Created by 杨力 on 11/11/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BottomBtnBlock)(NSInteger tag);
@interface YLFinalOrderView : UIView

@property (nonatomic,copy) BottomBtnBlock block;

-(void)clickBottomBtn:(BottomBtnBlock)block;
@end
