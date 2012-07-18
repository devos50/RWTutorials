//
//  ContributorDetailViewController.m
//  RWTutorials
//
//  Created by Martijn De Vos on 17-07-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContributorDetailViewController.h"

@interface ContributorDetailViewController ()

@end

@implementation ContributorDetailViewController

@synthesize contributor;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = contributor.name;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:contributor.url]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
