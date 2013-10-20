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
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"SelectedCategories" ofType:@"plist"];
        sections = [NSArray arrayWithContentsOfFile:path];
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
            [categories addObject:category];
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
    self.navigationItem.title = @"Type de lieu";
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
    NSString* fId = [[sections objectAtIndex:[indexPath indexAtPosition:0]] objectAtIndex:[indexPath indexAtPosition:1]+1];
    NSDictionary* category = [self categoryForId:fId];
    cell.textLabel.text = [category objectForKey:@"name"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)[sections objectAtIndex:section]).count - 1;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
   willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //TODO : select category at indexPath.row
    NSString* fId = [[sections objectAtIndex:[indexPath indexAtPosition:0]] objectAtIndex:[indexPath indexAtPosition:1]+1];
    NSDictionary* category = [self categoryForId:fId];
    NSLog(@"selected category %@, id %@", [category objectForKey:@"name"], [category objectForKey:@"id"]);
    
    VenueListMapViewController* vc = [[VenueListMapViewController alloc] initWithNibName:@"VenueListMapViewController" bundle:nil];
    vc.category = category;
    [self.navigationController pushViewController:vc animated:YES];
    return indexPath;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* fId = [[sections objectAtIndex:section] objectAtIndex:0];
    NSDictionary* category = [self categoryForId:fId];
    return category != nil ? [category objectForKey:@"name"] : fId;
}

- (NSDictionary*) categoryForId:(NSString*)fID
{
    for(NSDictionary* category in categories)
    {
        if([[category objectForKey:@"id"] isEqualToString:fID])
        {
            return category;
        }
    }
    return nil;
}

@end
