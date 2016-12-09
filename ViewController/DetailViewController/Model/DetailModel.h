//
//  DetailModel.h
//  DianZTC
//
//  Created by 杨力 on 22/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "JSONModel.h"

@interface DetailModel : JSONModel

//    "category" : 2,
//    "craft" : 2,
//    "crowd" : 2,
//    "imgs" : [
//              {
//                  "img" : "160714170146231_Jellyfish.jpg",
//                  "index" : 2
//              },
//              {
//                  "img" : "160714170146236_ad631b4424280f6edad3a7f386b4281f.jpg",
//                  "index" : 1
//              }
//              ],
//    "material" : 2,
//    "shapes" : 2,
//    "size" : 2,
//    "weight" : 2

@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * category;
@property (nonatomic,copy) NSString * craft;
@property (nonatomic,copy) NSString * crowd;
@property (nonatomic,copy) NSMutableArray * imgs;
@property (nonatomic,copy) NSString * material;
@property (nonatomic,copy) NSString * shapes;
@property (nonatomic,copy) NSString * size;
@property (nonatomic,copy) NSString * number;
@property (nonatomic,copy) NSString * weight;
@property (nonatomic,copy) NSString * description;

@end
