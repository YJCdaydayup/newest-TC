//
//  WebViewController.m
//  DianZTC
//
//  Created by 杨力 on 29/10/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "WebViewController.h"
#import "AppDelegate.h"

@interface WebViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView * webView;
@property (nonatomic,strong) UIButton * returnBtn;
@property (nonatomic,strong) UILabel * titlelabel;

@end

@implementation WebViewController

-(void)viewWillDisappear:(BOOL)animated{
    
    self.returnBtn.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    self.returnBtn.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    [self createUI];
    
    NSURL * url = [NSURL URLWithString:self.urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, Wscreen, Hscreen-NAV_BAR_HEIGHT)];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

-(void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = TABLEVIEWCOLOR;
    
    //导航条设置
    self.returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.returnBtn setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    if(IS_IPHONE == IS_IPHONE_6||IS_IPHONE == IS_IPHONE_6P){
        
        self.returnBtn.frame = CGRectMake(31/2.0*S6, 22/2*S6, 49/2.0*S6, 22.5*S6);
    }else{
        self.returnBtn.frame = CGRectMake(31/2.0*S6, 22/2*S6, 49/2.0*S6, 22.5*S6);
    }
    
    //导航条标题
    self.titlelabel = [Tools createLabelWithFrame:CGRectMake(15,8,Wscreen-30, 20*S6) textContent:nil withFont:[UIFont systemFontOfSize:17*S6] textColor:RGB_COLOR(0, 0, 0, 1) textAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = self.titlelabel;
    
    [self.navigationController.navigationBar addSubview:self.returnBtn];
    [self.returnBtn addTarget:self action:@selector(backForward) forControlEvents:UIControlEventTouchUpInside];
}

-(void)backForward{
    
    [self dismissViewControllerAnimated:YES completion:NO];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
    NSString * title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
    self.titlelabel.text = title;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
