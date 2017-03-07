//
//  BatarProcessView.h
//  进度
//
//  Created by 杨力 on 6/3/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum:NSInteger{
    BatarWaitDetailStyle,
    BatarDetailCancelStyle,
    BatarWaitConfirmStyle,
    BatarWaitConfirmCancelStyle,
    BatarConfirmStyle,
    batarConfirmCancelStyle
}ProcessStyle;

@interface BatarProcessView : UIView

-(void)changeProgress:(ProcessStyle)style;

@end
