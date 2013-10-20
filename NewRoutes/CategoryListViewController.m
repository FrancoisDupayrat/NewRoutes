//
//  CategoryListViewController.m
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "CategoryListViewController.h"
#import "VenueListMapViewController.h"

@interface CategoryListViewController ()

@end

@implementation CategoryListViewController

@synthesize tableView;
@synthesize navTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        categories = [NSMutableArray new];
        NSArray* baseCategories =  [[NSUserDefaults standardUserDefaults] objectForKey:@"categories"];
        [self addCategoriesFrom:baseCategories];
    }
    return self;
}

- (void)addCategoriesFrom:(NSArray*)baseCategories
{
    for(NSDictionary* category in baseCategories)
    {
        NSArray* subCategories = [category objectForKey:@"categories"];
        if(subCategories != nil)
        {
            [self addCategoriesFrom:subCategories];
        }
        else
        {
            [categories addObject:category];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    cell.textLabel.text = [[categories objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return categories.count;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
   willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //TODO : select category at indexPath.row
    NSDictionary* category = [categories objectAtIndex:indexPath.row];
    NSLog(@"selected category %@, id %@", [category objectForKey:@"name"], [category objectForKey:@"id"]);
    
    VenueListMapViewController* vc = [[VenueListMapViewController alloc] initWithNibName:@"VenueListMapViewController" bundle:nil];
    vc.category = category;
    [self.navigationController pushViewController:vc animated:YES];
    return indexPath;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //TODO : list according parent category
    return @"A proximité";
}

@end
