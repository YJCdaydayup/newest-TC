//
//  BTDetailSubModel.h
//  DianZTC
//
//  Created by 杨力 on 3/3/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "JSONModel.h"
@protocol BTDetailSubModel <NSObject>

@end

@interface BTDetailSubModel : JSONModel


/** shipment_Ring */
@property (nonatomic,copy) NSString * shipment_Ring;

/** shipment_boresize */
@property (nonatomic,copy) NSString * shipment_boresize;

/** shipment_breadth */
@property (nonatomic,copy) NSString * shipment_breadth;

/** shipment_long */
@property (nonatomic,copy) NSString * shipment_long;

/** shipment_number */
@property (nonatomic,copy) NSString * shipment_number;

/** shipment_printfont */
@property (nonatomic,copy) NSString * shipment_printfont;

/** shipment_pro_weight */
@property (nonatomic,copy) NSString * shipment_pro_weight;

/** shipment_weight */
@property (nonatomic,copy) NSString * shipment_weight;

@property (nonatomic,strong) NSString * shipment_facewidth;

@property (nonatomic,strong) NSString * shipment_lwh;

@property (nonatomic,strong) NSString * shipment_height;



@end
