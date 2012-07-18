//
//  TutorialDetailViewController.h
//  RWTutorials
//
//  Created by Martijn De Vos on 17-07-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tutorial.h"

@interface TutorialDetailViewController : UIViewController

@property (nonatomic, strong) Tutorial *tutorial;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end
