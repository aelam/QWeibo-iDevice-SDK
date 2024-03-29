//
//  QOAuthSession.h
//  QWeiboSDK4iOS
//
//  Created on 11-1-12.
//  
//

#import <Foundation/Foundation.h>

@interface QOAuthSession : NSObject {

}

@property (nonatomic, readonly)NSString *identifier;

@property (nonatomic, readonly) NSString *consumerKey;
@property (nonatomic, readonly) NSString *consumerSecret;
@property (nonatomic, copy) NSString *tokenKey;
@property (nonatomic, copy) NSString *tokenSecret;
@property (nonatomic, copy) NSString *verify;
@property (nonatomic, copy) NSString *callbackUrl;
@property (nonatomic, copy) NSString *username;


+ (QOAuthSession *)defaultQOAuthSession;

- (id)initWithIdentifier:(NSString *)identifier;

- (BOOL)isSessionValid;
- (void)logOut;


/*
 * Get the URL based on the specified key.
 * 
 * param url
 *            The full url that needs to be signed including its non OAuth
 *            url parameters
 * param httpMethod
 *            The http method used. Must be a valid HTTP method verb
 *            (POST,GET,PUT, etc)
 * param customKey
 *            The consumer key
 * param customSecrect
 *            The consumer seceret
 * param tokenKey
 *            The token, if available. If not available pass null or an
 *            empty string
 * param tokenSecrect
 *            The token secret, if available. If not available pass null or
 *            an empty string
 * param verify
 *            The oAauth Verifier.
 * param callbackUrl
 *            The OAuth Callback URL(You should encode this url if it
 *            contains some unreserved characters).
 * param parameters
 * param queryString
 * 
 */

- (NSString *)getOauthUrl:(NSString *)aUrl 
			   httpMethod:(NSString *)aMethod 
				   verify:(NSString *)aVerify 
			  callbackUrl:(NSString *)aCallbackUrl 
			   parameters:(NSDictionary *)aParameters 
			  queryString:(NSString **)aQueryString;


@end
