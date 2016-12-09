//
//  YLCoder2D.m
//  原生的生成二维码
//
//  Created by 杨力 on 29/9/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "YLCoder2D.h"
#import <AVFoundation/AVFoundation.h>
@interface YLCoder2D()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong) AVCaptureSession * session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer * previewLayer;

@end

@implementation YLCoder2D

//+(instancetype)shareInstance{
//    
//    static YLCoder2D * code2D = nil;
//    dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//       
//        code2D = [[YLCoder2D alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//    });
//    return code2D;
//}

-(void)createView2DCoder{
    
    self.imgView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:self.imgView];
    self.backgroundColor = [UIColor redColor];
    
    //二维码滤镜
    
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜的默认属性
    
    [filter setDefaults];
    
    //将字符串转换成NSData
    
    NSData *data=[self.urlStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //通过KVO设置滤镜inputmessage数据
    
    [filter setValue:data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    
    CIImage *outputImage=[filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    
    _imgView.image=[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:100.0];
    
    //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
    
    _imgView.layer.shadowOffset=CGSizeMake(0, 0.5);//设置阴影的偏移量
    
    _imgView.layer.shadowRadius=1;//设置阴影的半径
    
    _imgView.layer.shadowColor=[UIColor blackColor].CGColor;//设置阴影的颜色为黑色
    
    _imgView.layer.shadowOpacity=0.3;
}

//改变二维码大小

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

-(void)scan2DCoder{
    
    // 1. 实例化拍摄设备
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2. 设置输入设备
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3. 设置元数据输出
    
    // 3.1 实例化拍摄元数据输出
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 3.3 设置输出数据代理
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 4. 添加拍摄会话
    
    // 4.1 实例化拍摄会话
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // 4.2 添加会话输入
    
    [session addInput:input];
    
    // 4.3 添加会话输出
    
    [session addOutput:output];
    
    // 4.3 设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    self.session = session;
    
    // 5. 视频预览图层
    
    // 5.1 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    preview.frame = self.bounds;
    
    // 5.2 将图层插入当前视图
    
    [self.layer insertSublayer:preview atIndex:100];
    
    self.previewLayer = preview;
    
    // 6. 启动会话
    
    [_session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    // 会频繁的扫描，调用代理方法
    
    // 1. 如果扫描完成，停止会话
    
    [self.session stopRunning];
    
    // 2. 删除预览图层
    
    [self.previewLayer removeFromSuperlayer];
    
    NSLog(@"%@", metadataObjects);
    
    // 3. 设置界面显示扫描结果
    
    if (metadataObjects.count > 0)
        
    {
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
        
        NSLog(@"%@", obj.stringValue);
        
    } 
    
}

@end
