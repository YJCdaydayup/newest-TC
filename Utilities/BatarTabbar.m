//
//  BatarTabbar.m
//  DianZTC
//
//  Created by 杨力 on 9/3/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "BatarTabbar.h"

@implementation BatarTabbar
singleM(BatarTabbar);

-(void)layoutSubviews{
    
    [super layoutSubviews];

    for(UIView * btn in self.subviews){
        
        if([btn isKindOfClass:NSClassFromString(@"UILabel")]) {
            [self insertSubview:btn atIndex:5];
        };
    }
}
@end
