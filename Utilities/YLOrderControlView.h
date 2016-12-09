//
//  YLOrderControlView.h
//  DianZTC
//
//  Created by 杨力 on 31/10/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BottomBtnBlock)(NSInteger tag);

@interface YLOrderControlView : UIView

@property (nonatomic,copy) BottomBtnBlock block;

-(void)clickBottomBtn:(BottomBtnBlock)block;

@end
