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

#define REQUEST_TOKEN_URL   @"https://open.t.qq.com/cgi-bin/request_token"
#define ACCESS_TOKEN_URL    @"https://open.t.qq.com/cgi-bin/access_token"

#define VERIFY_URL          @"http://open.t.qq.com/cgi-bin/authorize"

@interface WeiboEngine (Private)

- (void)getAccessTokenWithHandledURL:(NSString *)urlString;

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
        _multiParts = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addMultiPartData:(NSData*)data withName:(NSString*)name {
    [_multiParts setObject:data forKey:name];    
}

- (void)performRequestWithHandler:(RequestHandler)handler {

    NSString *HTTPMethod = @"GET";
    switch (_requestMethod) {
        case RequestMethodGET:
            HTTPMethod = @"GET";
            break;
        case RequestMethodPOST:
            HTTPMethod = @"POST";
            break;            
        case RequestMethodDELETE:
            HTTPMethod = @"DELETE";
            break;            
        default:
            HTTPMethod = @"GET";
            break;
    }
    
    OAuthURLRequest *request = [OAuthURLRequest requestWithURL:[_URL absoluteString] parameters:_parameters HTTPMethod:HTTPMethod files:_multiParts session:self.session];
    
    if ([self.session isSessionValid]) {
        if (request) {
            [RSimpleConnection sendAsynchronousRequest:request queue:_operationQueue completionHandler:^(NSData *data,NSURLResponse *response, NSError *error) {
                handler(data,(NSHTTPURLResponse *)response,error); 
            }];            
        }
    } else {
        [self authorizeWithBlock:^(NSString *result) {
            if (request) {
                [RSimpleConnection sendAsynchronousRequest:request queue:_operationQueue completionHandler:^(NSData *data,NSURLResponse *response, NSError *error) {
                    handler(data,(NSHTTPURLResponse *)response,error); 
                }];            
            }
        }];
    }
}
         
- (void)authorizeWithBlock:(void(^)(NSString *))resultBlock {
    [self.session logOut];
    OAuthURLRequest *request = [OAuthURLRequest requestWithURL:REQUEST_TOKEN_URL callBackURL:@"QWeibo://qq.com" parameters:nil HTTPMethod:@"GET" session:self.session];
    
    [RSimpleConnection sendAsynchronousRequest:request queue:_operationQueue completionHandler:^(NSData *data,NSURLResponse *response, NSError *error) {
        if (data) {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"---- %@",responseString);
            
            NSDictionary *pairs = [NSDictionary oauthTokenPairsFromResponse:responseString];
            self.session.tokenKey = [pairs objectForKey:@"oauth_token"];
            self.session.tokenSecret = [pairs objectForKey:@"oauth_token_secret"];
            
            NSString *authorizeURLString = [VERIFY_URL stringByAppendingFormat:@"?%@",responseString];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authorizeURLString]];
            
            [responseString release];
            
            Block_release(accessTokenHandler);
            accessTokenHandler = Block_copy(resultBlock);
            
        }
    }];
    
}

- (void)getAccessTokenWithHandledURL:(NSString *)urlString {
    
    NSDictionary *pairs = [NSDictionary oauthTokenPairsFromResponse:urlString];
    self.session.verify = [pairs objectForKey:@"oauth_verifier"];

    OAuthURLRequest *request = [OAuthURLRequest requestWithURL:ACCESS_TOKEN_URL verify:self.session.verify parameters:nil HTTPMethod:@"GET" session:self.session];

    self.session.tokenKey = nil;
    self.session.tokenSecret = nil;
    
    [RSimpleConnection sendAsynchronousRequest:request queue:_operationQueue completionHandler:^(NSData *data,NSURLResponse *response,  NSError *error) {
        if (data) {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"---- %@",responseString);
            
            NSDictionary *pairs = [NSDictionary oauthTokenPairsFromResponse:responseString];
            self.session.tokenKey = [pairs objectForKey:@"oauth_token"];
            self.session.tokenSecret = [pairs objectForKey:@"oauth_token_secret"];
            self.session.username = [pairs objectForKey:@"name"];

            accessTokenHandler(responseString);
            
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
    [_multiParts release];
    Block_release(accessTokenHandler);
    [super dealloc];
}

@end
