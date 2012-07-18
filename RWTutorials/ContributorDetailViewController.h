//
//  ContributorDetailViewController.h
//  RWTutorials
//
//  Created by Martijn De Vos on 17-07-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contributor.h"

@interface ContributorDetailViewController : UIViewController

@property (nonatomic, strong) Contributor *contributor;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end
