//
//  BlockWebView.m
//  QWeibo
//
//  Created by Ryan Wang on 11-11-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "BlockWebView.h"

@implementation BlockWebView

@synthesize handler = _handler;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
    }
    return self;
}

- (void)performRequest:(NSURLRequest*)request requestHandler:(RequestHandler)handler {
    [self loadRequest:request];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (_handler) {
        _handler(self,nil,YES,NO,nil);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (_handler) {
        _handler(self,nil,NO,YES,nil);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (_handler) {
        _handler(self,nil,NO,NO,error);
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (_handler) {
        _handler(self,request,NO,NO,nil);
    }  
    return YES;
}


- (void)dealloc {
    Block_release(_handler);
    [super dealloc];
}

@end
