//
//  SearchCatagoryModel.h
//  DianZTC
//
//  Created by 杨力 on 23/7/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "JSONModel.h"

@interface SearchCatagoryModel : JSONModel
//[
// {
//     "categoryindex" : 1,
//     "context" : [
//                  {
//                      "img" : "160723083349811_ad631b4424280f6edad3a7f386b4281f.jpg",
//                      "number" : "N10N20N30N40N5-N60N1/N8"
//                  },
//                  {
//                      "img" : "160723100027641_Chrysanthemum.jpg",
//                      "number" : "N10N60N30N40N5-N60N1/N8"
//                  },
//                  {
//                      "img" : "160723095634268_79f0f736afc37931c5d295c0efc4b74542a911a4.jpg",
//                      "number" : "N10N30N30N40N5-N60N1/N8"
//                  }
//                  ]
// }
// ]

@property (nonatomic,copy) NSString * categoryindex;
@property (nonatomic,strong) NSMutableArray * context;
@end
