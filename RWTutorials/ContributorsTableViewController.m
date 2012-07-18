//
//  ContributorsTableViewController.m
//  RWTutorials
//
//  Created by Martijn De Vos on 16-07-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContributorsTableViewController.h"
#import "Contributor.h"
#import "TFHpple.h"
#import "AsynchronousImageView.h"
#import "ContributorDetailViewController.h"
#import "MBProgressHUD.h"

@interface ContributorsTableViewController ()
{
    NSMutableArray *sectionTitles;
    NSMutableArray *contributors;
    int sectionCounter;
    BOOL isInitialized;
}

@end

@implementation ContributorsTableViewController

-(Contributor *) analyzeContributor:(TFHppleElement *)element currentContributor:(Contributor *)contributor
{
    if([element.tagName isEqualToString:@"a"])
    {
        contributor.url = [element objectForKey:@"href"];
    }
    else if([element.tagName isEqualToString:@"img"])
    {
        contributor.imageUrl = [element objectForKey:@"src"];
    }
    else if([element.tagName isEqualToString:@"p"])
    {
        contributor.name = element.firstChild.content;
    }
    
    // recursion
    for(TFHppleElement *child in element.children)
    {
        [self analyzeContributor:child currentContributor:contributor];
    }
    return contributor;
}

-(void) analyzeElement:(TFHppleElement *)element
{
    //get section titles
    if([element.tagName isEqualToString:@"h4"])
    {
        [sectionTitles addObject:[[element firstChild] content]];
        sectionCounter++;
        NSMutableArray *contributorsArray = [[NSMutableArray alloc] init];
        [contributors addObject:contributorsArray];
    }
    else if([element.tagName isEqualToString:@"a"])
    {
        Contributor *contributor = [[Contributor alloc] init];
        contributor = [self analyzeContributor:element currentContributor:contributor];
        [[contributors objectAtIndex:sectionCounter] addObject:contributor];
    }
    
    // recursion
    for(TFHppleElement *child in element.children)
    {
        [self analyzeElement:child];
    }
}

-(void) loadContributors
{
    NSURL *contributorsURL = [NSURL URLWithString:@"http://raywenderlich.com/"];
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:contributorsURL];
    
    TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    NSString *xpath = @"//div[@id='contributors']";
    NSArray *h4Node = [contributorsParser searchWithXPathQuery:xpath];
    
    sectionCounter = -1;
    
    for(TFHppleElement *element in h4Node)
    {
        [self analyzeElement:element];
    }
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sectionTitles = [[NSMutableArray alloc] init];
    contributors = [[NSMutableArray alloc] init];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    hud.labelText = @"Loading contributors";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!isInitialized)
    {
        [self loadContributors];
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        isInitialized = YES;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ContributorDetailViewController *destinationController = (ContributorDetailViewController *) segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    destinationController.contributor = [[contributors objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

#pragma mark - Table view data source

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionTitles objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[contributors objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContributorsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Contributor *contributor = [[contributors objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UILabel *label = (UILabel *) [cell viewWithTag:1];
    label.text = contributor.name;
    
    AsynchronousImageView *imageView = (AsynchronousImageView *) [cell viewWithTag:2];
    [imageView loadImageFromURLString:contributor.imageUrl withStorage:YES];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ...
}

@end
