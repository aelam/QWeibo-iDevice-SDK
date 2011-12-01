//
//  BlockWebView.h
//  QWeibo
//
//  Created by Ryan Wang on 11-11-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RequestHandler)(UIWebView *webView,NSURLRequest *shouldStartLoadRequest,BOOL didStartLoad,BOOL didFinishLoad, NSError *failLoadError);

@interface BlockWebView : UIWebView<UIWebViewDelegate>

@property (nonatomic,copy) RequestHandler handler;

- (void)performRequest:(NSURLRequest*)request requestHandler:(RequestHandler)handler;

@end
