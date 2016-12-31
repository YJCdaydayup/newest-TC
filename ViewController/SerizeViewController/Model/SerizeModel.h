//
//  SerizeModel.h
//  DianZTC
//
//  Created by 杨力 on 23/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "JSONModel.h"

@interface SerizeModel : JSONModel

//{
//    "imgs" : [
//              {
//                  "imgs" : "160719154801786_fdf02dc36bd618fc357cb99f4fb34c40.jpg",
//                  "index" : 1
//              },
//              {
//                  "imgs" : "160719154801758_1466581217913552.jpg",
//                  "index" : 2
//              },
//              {
//                  "imgs" : "160719164558544_44 (1).jpg",
//                  "index" : 3
//              },
//              {
//                  "imgs" : "160719164558540_43J58PICsB4_1024.jpg",
//                  "index" : 4
//              }
//              ],
//    "name" : "芭莎系列",
//    "seriesindex" : 1
//},

@property (nonatomic,copy) NSMutableArray * imgs;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * seriesid;


@end
