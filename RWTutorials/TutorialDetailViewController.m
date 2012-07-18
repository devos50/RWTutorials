//
//  TutorialDetailViewController.m
//  RWTutorials
//
//  Created by Martijn De Vos on 17-07-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialDetailViewController.h"
#import "TFHpple.h"
#import "AsynchronousImageView.h"
#import "MBProgressHUD.h"

@interface TutorialDetailViewController ()
{
    NSString *text;
    NSMutableArray *textArray;
    int currentHeight;
}

@end

@implementation TutorialDetailViewController

@synthesize tutorial;
@synthesize scrollView;

-(NSString *) analyzeElementWithText:(TFHppleElement *)element
{
    NSString *elemText = @"";
    if([element.tagName isEqualToString:@"text"])
    {
        if(element.content) elemText = element.content;
    }
    
    for(TFHppleElement *child in element.children)
    {
        elemText = [elemText stringByAppendingFormat:@"%@",[self analyzeElementWithText:child]];
    }
    
    return elemText;
}

-(void) analyzeElement:(TFHppleElement *)element
{
    if([element.tagName isEqualToString:@"p"])
    {
        NSString *elemText = [self analyzeElementWithText:element];
        
        // make a label
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentHeight, 300, 0)];
        textLabel.lineBreakMode = UILineBreakModeWordWrap;
        textLabel.numberOfLines = 0;
        textLabel.text = elemText;
        textLabel.font = [UIFont systemFontOfSize:15.0f];
        [textLabel sizeToFit];
        currentHeight += textLabel.frame.size.height + 10;
        [self.scrollView addSubview:textLabel];
    }
    else if([element.tagName isEqualToString:@"h2"])
    {
        NSString *elemText = [self analyzeElementWithText:element];
        
        // make a label
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentHeight, 300, 0)];
        textLabel.lineBreakMode = UILineBreakModeWordWrap;
        textLabel.numberOfLines = 0;
        textLabel.text = elemText;
        textLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        textLabel.textColor = [UIColor colorWithRed:0.0f green:104.0f/255.0f blue:55.0f/255.0f alpha:1.0f];
        [textLabel sizeToFit];
        currentHeight += textLabel.frame.size.height + 10;
        [self.scrollView addSubview:textLabel];
    }
    else if([element.tagName isEqualToString:@"img"])
    {
        NSString *urlString = [element objectForKey:@"src"];
        AsynchronousImageView *imageView = [[AsynchronousImageView alloc] initWithFrame:CGRectMake(0, currentHeight, 320, 170)];
        [imageView loadImageFromURLString:urlString withStorage:YES];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        currentHeight += imageView.frame.size.height + 10;
        [self.scrollView addSubview:imageView];
    }
    else if([element.tagName isEqualToString:@"div"] && [[element objectForKey:@"class"] isEqualToString:@"wp_codebox"])
    {
        NSString *elemText = [self analyzeElementWithText:element];
        // make a label
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentHeight, 300, 0)];
        textLabel.lineBreakMode = UILineBreakModeWordWrap;
        textLabel.numberOfLines = 0;
        textLabel.text = elemText;
        textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        textLabel.textColor = [UIColor colorWithRed:0.0f green:104.0f/255.0f blue:55.0f/255.0f alpha:1.0f];
        [textLabel sizeToFit];
        
        currentHeight += textLabel.frame.size.height + 10;
        [self.scrollView addSubview:textLabel];
    }
    
    for(TFHppleElement *child in element.children)
    {
        [self analyzeElement:child];
    }
}

-(void) loadTutorial
{
    NSURL *tutorialURL = [NSURL URLWithString:tutorial.url];
    NSData *tutorialHtmlData = [NSData dataWithContentsOfURL:tutorialURL];
    NSLog(@"url: %@",tutorial.url);
    
    TFHpple *tutorialParser = [TFHpple hppleWithHTMLData:tutorialHtmlData];
    
    NSString *xpath = @"//div[@class='entry']";
    NSArray *divNode = [tutorialParser searchWithXPathQuery:xpath];
    
    TFHppleElement *div = [divNode objectAtIndex:0];
    for(TFHppleElement *element in div.children)
    {
        [self analyzeElement:element];
    }
    [scrollView setContentSize:CGSizeMake(320, currentHeight)];
}

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
    text = @"";
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading tutorial";
    
    // setup navigation bar
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 320, 30)];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    [label setFont:[UIFont boldSystemFontOfSize:12.0]];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:tutorial.title];
    self.navigationItem.titleView = label;
    
    textArray = [[NSMutableArray alloc] init];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadTutorial];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
