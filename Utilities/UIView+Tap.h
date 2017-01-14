//
//  UIView+Tap.h
//  tap
//
//  Created by 杨力 on 14/1/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapGestureBlock)();

static TapGestureBlock blockParam;

@interface UIView (Tap)

-(void)addTapGestureCallback:(TapGestureBlock)block;

@end
