//
//  ThemeModel.h
//  DianZTC
//
//  Created by 杨力 on 25/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "JSONModel.h"

@interface ThemeModel : JSONModel
//
//[
// {
//     "context" : [
//                  {
//                      "image" : "160722170051928_3974346_1426551981202_mthumb.jpg",
//                      "name" : "手镯",
//                      "number" : "N10N20N30N40N5-N60N5/N8"
//                  }
//                  ],
//     "theme" : "张靓颖主题"
// }
// ]

@property (nonatomic,strong) NSMutableArray * context;
@property (nonatomic,copy) NSString * theme;


@end
