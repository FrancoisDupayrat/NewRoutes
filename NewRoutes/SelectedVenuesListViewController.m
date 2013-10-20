//
//  CategoryListViewController.m
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "SelectedVenuesListViewController.h"
#import "VenuesManager.h"
#import "VenueDetailViewController.h"

@interface SelectedVenuesListViewController ()

@end

@implementation SelectedVenuesListViewController

@synthesize tableView;
@synthesize navTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Lieux sélectionnés";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableViewParam cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableViewParam dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
        
    }
    NSDictionary* venue = [[VenuesManager sharedManager] venueAtIndex:indexPath.row];
    
    cell.textLabel.text = [venue objectForKey:@"name"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[VenuesManager sharedManager] count];
}

- (NSIndexPath *)tableView:(UITableView *)tableView
   willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary* venue = [[VenuesManager sharedManager] venueAtIndex:indexPath.row];
    
    VenueDetailViewController* vc = [[VenueDetailViewController alloc] initWithNibName:@"VenueDetailViewController" bundle:nil];
    [vc setFID:[venue objectForKey:@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
    return indexPath;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

@end
