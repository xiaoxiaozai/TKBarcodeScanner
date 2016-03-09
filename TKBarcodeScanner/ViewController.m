//
//  ViewController.m
//  TKBarcodeScanner
//
//  Created by 翟宇 on 16/3/9.
//  Copyright © 2016年 翟宇. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>


#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>//用于处理采集信息的代理
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Device

    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    // Input

    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];

    // Output

    _output = [[AVCaptureMetadataOutput alloc]init];

    [_output setRectOfInterest:CGRectMake((124)/SCREEN_HEIGHT,((SCREEN_WIDTH-220)/2)/SCREEN_WIDTH,220/SCREEN_HEIGHT,220/SCREEN_WIDTH)];

    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];


    NSLog(@"%f",SCREEN_WIDTH);
    NSLog(@"%f",SCREEN_HEIGHT);
    
    // Session

    _session = [[AVCaptureSession alloc]init];

    [_session setSessionPreset:AVCaptureSessionPresetHigh];

    if ([_session canAddInput:self.input]){
        [_session addInput:self.input];

    }

    if ([_session canAddOutput:self.output]){
        [_session addOutput:self.output];
    }

    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];

    // Preview

    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    
    // Start
    [_session startRunning];



    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];

    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];

    [self.view addSubview:maskView];

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(30, 100 - 64, SCREEN_WIDTH - 60, 300) cornerRadius:1] bezierPathByReversingPath]];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];

    maskLayer.path = maskPath.CGPath;

    maskView.layer.mask = maskLayer;

}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;

    if ([metadataObjects count] >0)

    {

        //停止扫描

//        [_session stopRunning];

        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        
        stringValue = metadataObject.stringValue;
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
