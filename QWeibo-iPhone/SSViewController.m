//
//  SSViewController.m
//  QWeibo-iPhone
//
//  Created by Ryan Wang on 11-11-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SSViewController.h"
#import "WeiboEngine.h"
#import "QOAuthSession.h"
#import <YAJL/YAJL.h>

@implementation SSViewController

@synthesize engine;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

}


- (IBAction)authorizeDefault:(id)sender {
	NSString *url = @"http://open.t.qq.com/api/statuses/home_timeline";

    [engine release];
    engine = [[WeiboEngine alloc] initWithURL:[NSURL URLWithString:url] parameters:nil requestMethod:RequestMethodGET];        
    
    [engine performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        id json = [responseData yajl_JSON];
        NSLog(@"-----> %@",json);
    }];
    
}

- (IBAction)postAction:(id)sender {
    NSString *postURL = @"http://open.t.qq.com/api/t/add";
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"json",@"format",
                               @"hahha",@"content",
                               @"127.0.0.1",@"clientip",
                               nil];
    
    [engine release];
    engine = [[WeiboEngine alloc] initWithURL:[NSURL URLWithString:postURL] parameters:paramters requestMethod:RequestMethodPOST];        
    
    [engine performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        id json = [responseData yajl_JSON];
        NSLog(@"-----> %@",json);
    }];

}

- (IBAction)authorizeNewOne:(id)sender {

    [engine release];
    engine = [[WeiboEngine alloc] initWithURL:nil parameters:nil requestMethod:RequestMethodGET];        

    QOAuthSession *session = [[QOAuthSession alloc] initWithIdentifier:@"com.ryan.another"];
    engine.session = session;
    [session release];
    NSString *reqeuestTokenURL = [engine getReqeuestTokenURL];

}

- (IBAction)printDefault:(id)sender {
    if (engine == nil) {
        engine = [[WeiboEngine alloc] initWithURL:nil parameters:nil requestMethod:RequestMethodGET];        
    }
    QOAuthSession *session = engine.session;
    NSLog(@"------------------------------------------------");
    NSLog(@"username = %@",session.username);
    NSLog(@"tokenKey = %@",session.tokenKey);
    NSLog(@"tokenSecret = %@",session.tokenSecret);
    NSLog(@"------------------------------------------------");
}

- (IBAction)printTheNewOne:(id)sender {

    QOAuthSession *session = [[QOAuthSession alloc] initWithIdentifier:@"com.ryan.another"];
    NSLog(@"------------------------------------------------");
    NSLog(@"username = %@",session.username);
    NSLog(@"tokenKey = %@",session.tokenKey);
    NSLog(@"tokenSecret = %@",session.tokenSecret);
    NSLog(@"------------------------------------------------");

}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
