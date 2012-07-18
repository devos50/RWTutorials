//
//  TutorialsTableViewController.m
//  RWTutorials
//
//  Created by Martijn De Vos on 16-07-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialsTableViewController.h"
#import "TFHpple.h"
#import "Tutorial.h"
#import "TutorialDetailViewController.h"
#import "MBProgressHUD.h"

@interface TutorialsTableViewController ()
{
    NSMutableArray *sectionTitles;
    NSMutableArray *tutorials;
    BOOL isInitialized;
}

@end

@implementation TutorialsTableViewController

-(void) loadTutorialsAndSections
{
    NSURL *tutorialsURL = [NSURL URLWithString:@"http://raywenderlich.com/tutorials"];
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsURL];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    NSString *xpath = @"//div[@class='entry']";
    NSArray *divNode = [tutorialsParser searchWithXPathQuery:xpath];
    
    TFHppleElement *div = [divNode objectAtIndex:0];
    for(TFHppleElement *element in div.children)
    {
        if([element.tagName isEqualToString:@"h3"])
        {
            [sectionTitles addObject:[[element firstChild] content]];
        }
        else if([element.tagName isEqualToString:@"ul"])
        {
            NSMutableArray *newTutorials = [[NSMutableArray alloc] init];
            for(TFHppleElement *ulChild in element.children)
            {
                if([ulChild.tagName isEqualToString:@"li"])
                {
                    Tutorial *newTutorial = [[Tutorial alloc] init];
                    newTutorial.url = [[ulChild firstChild] objectForKey:@"href"];
                    newTutorial.title = [[[ulChild firstChild] firstChild] content];
                    [newTutorials addObject:newTutorial];
                }
            }
            [tutorials addObject:newTutorials];
        }
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
    tutorials = [[NSMutableArray alloc] init];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    hud.labelText = @"Loading tutorials";

    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!isInitialized)
    {
        [self loadTutorialsAndSections];
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        isInitialized = YES;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionTitles objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if(sectionTitles.count == 0) return 0;
    return sectionTitles.count - 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[tutorials objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TutorialCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Tutorial *tutorial = [[tutorials objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UILabel *titleLabel = (UILabel *) [cell viewWithTag:1];
    
    titleLabel.text = tutorial.title;
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TutorialDetailViewController *destinationController = (TutorialDetailViewController *) segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    destinationController.tutorial = [[tutorials objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ...
}

@end
