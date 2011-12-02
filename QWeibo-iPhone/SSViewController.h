//
//  SSViewController.h
//  QWeibo-iPhone
//
//  Created by Ryan Wang on 11-11-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboEngine;

@interface SSViewController : UIViewController

@property (nonatomic ,retain) WeiboEngine *engine;


- (IBAction)authorizeDefault:(id)sender;
- (IBAction)authorizeNewOne:(id)sender;

- (IBAction)printDefault:(id)sender;
- (IBAction)printTheNewOne:(id)sender;

@end
