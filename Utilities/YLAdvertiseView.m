//
//  YLAdvertiseView.m
//  DianZTC
//
//  Created by 杨力 on 15/2/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "YLAdvertiseView.h"
#import "NSTimer+Net.h"

@implementation YLAdvertiseView

-(instancetype)initWithTime:(CGFloat)showTime{
    
    if(self = [super init]){
        
        self.showTime = showTime;
        
        [self createView];
    }
    return self;
}

-(void)createView{
    
}


@end
