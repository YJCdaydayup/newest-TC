//
//  BatarIndicatorView.h
//  DianZTC
//
//  Created by 杨力 on 20/3/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BatarIndicatorView : UIImageView

+(void)showIndicatorWithTitle:(NSString *)title imageName:(NSString *)imgName inView:(UIView *)bgView hide:(BOOL)hide;

@end
