//
//  BatarShapeController.h
//  DianZTC
//
//  Created by 杨力 on 3/1/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "RootViewController.h"

@interface BatarShapeController : RootViewController

@property (nonatomic,assign) CGPoint currentPoint;
@property (nonatomic,strong) NSMutableArray * initialDataArray;
@property (nonatomic,strong) NSString * param;

@end
