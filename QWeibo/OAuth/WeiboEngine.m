//
//  WeiboEngine.m
//  QWeibo
//
//  Created by Ryan Wang on 11-11-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "WeiboEngine.h"
#import "OAuthURLRequest.h"
#import "RSimpleConnection.h"
#import "NSDictionary+Response.h"

#define REQUEST_TOKEN_URL @"https://open.t.qq.com/cgi-bin/request_token"
#define ACCESS_TOKEN_URL  @"https://open.t.qq.com/cgi-bin/access_token"

#define VERIFY_URL @"http://open.t.qq.com/cgi-bin/authorize"

@interface WeiboEngine (Private)

//- (void)

@end

@implementation WeiboEngine

@synthesize session = _session;
@synthesize URL = _URL;
@synthesize parameters = _parameters;
@synthesize requestMethod = _requestMethod;


- (BOOL)handleOpenURL:(NSURL *)url {
    if ([[[url scheme] uppercaseString] isEqualToString:@"QWEIBO"]) {
        NSLog(@"%@",url);
        
        [self getAccessTokenWithHandledURL:[url query]];
        return YES;
    }    
    return NO;
}

- (id)initWithURL:(NSURL *)url parameters:(NSDictionary *)parameters requestMethod:(RequestMethod)requestMethod {
    if (self = [super init]) {
        _URL = [url retain];
        _parameters = [parameters retain];
        _requestMethod = requestMethod;
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)addMultiPartData:(NSData*)data withName:(NSString*)name type:(NSString*)type {
    
}


- (void)performRequestWithHandler:(RequestHandler)handler {
    
}



- (NSString *)getReqeuestTokenURL {
    NSLog(@"000000 : %@",self.session);
    [self.session logOut];
    OAuthURLRequest *request = [OAuthURLRequest requestWithURL:REQUEST_TOKEN_URL callBackURL:@"QWeibo://baidu.com" parameters:nil HTTPMethod:@"GET" session:self.session];

    [RSimpleConnection sendAsynchronousRequest:request queue:_operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data) {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"---- %@",responseString);
            
            NSDictionary *pairs = [NSDictionary oauthTokenPairsFromResponse:responseString];
            self.session.tokenKey = [pairs objectForKey:@"oauth_token"];
            self.session.tokenSecret = [pairs objectForKey:@"oauth_token_secret"];

            NSString *authorizeURLString = [VERIFY_URL stringByAppendingFormat:@"?%@",responseString];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authorizeURLString]];
            
            [responseString release];
        }
    }];
    
    
    return [request URL];
}

- (void)getAccessTokenWithHandledURL:(NSString *)urlString {
    
    NSDictionary *pairs = [NSDictionary oauthTokenPairsFromResponse:urlString];
    self.session.verify = [pairs objectForKey:@"oauth_verifier"];

    OAuthURLRequest *request = [OAuthURLRequest requestWithURL:ACCESS_TOKEN_URL verify:self.session.verify parameters:nil HTTPMethod:@"GET" session:self.session];

    [RSimpleConnection sendAsynchronousRequest:request queue:_operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data) {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"---- %@",responseString);
            
            NSDictionary *pairs = [NSDictionary oauthTokenPairsFromResponse:responseString];
            self.session.tokenKey = [pairs objectForKey:@"oauth_token"];
            self.session.tokenSecret = [pairs objectForKey:@"oauth_token_secret"];
            self.session.username = [pairs objectForKey:@"name"];
            
            [responseString release];
        }
    }];

    

}

- (QOAuthSession *)session {
    if (_session == nil) {
        _session = [[QOAuthSession defaultQOAuthSession] retain];
    }
    return _session;
}

- (void)dealloc {
    [_session release];
    [_URL release];
    [_parameters release];
    [_operationQueue release];
    [super dealloc];
}

@end
