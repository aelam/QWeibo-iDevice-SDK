//
//  WeiboEngine.h
//  QWeibo
//
//  Created by Ryan Wang on 11-11-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QOAuthSession.h"
#import <UIKit/UIKit.h>

enum RequestMethod {
    RequestMethodGET,
    RequestMethodPOST,
    RequestMethodDELETE
};

typedef enum RequestMethod RequestMethod; 

typedef void(^RequestHandler)(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error);


@interface WeiboEngine : NSObject {
    NSOperationQueue    *_operationQueue;
    NSMutableArray      *_multiParts;
    
//    void(^RequestHandler)(UIWebView *webView,NSURLRequest *shouldStartLoadRequest);
    void (^AuthorizeHandler)(NSString *test);
}

@property (nonatomic, retain) QOAuthSession *session;

// The request URL
@property (nonatomic, readonly) RequestMethod requestMethod;

// The request URL
@property (nonatomic, readonly) NSURL *URL;

// The parameters 
@property (nonatomic, readonly) NSDictionary *parameters;

//- (id)initWithQOAuthSession:(QOAuthSession*)auth;

- (id)initWithURL:(NSURL *)url parameters:(NSDictionary *)parameters requestMethod:(RequestMethod)requestMethod;


- (void)addMultiPartData:(NSData*)data withName:(NSString*)name type:(NSString*)type; 

- (void)performRequestWithHandler:(RequestHandler)handler;

- (BOOL)handleOpenURL:(NSURL *)url;

// test
- (void)authorizeWithBlock:(void(^)(NSString *))resultBlock;


@end
