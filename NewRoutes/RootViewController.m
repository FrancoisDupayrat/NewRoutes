//
//  RootViewController.m
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "RootViewController.h"
#import "LocationManager.h"
#import <Foursquare2.h>
#import "AppDelegate.h"
#import "CategoryListViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startSelection:(id)sender
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"categories"] == nil)
    {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] performFoursquareChecks];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Veuillez patienter"
                                                        message:@"Veuillez patienter pendant la récupération de données sur Foursquare"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [alert show];
        return;
    }
    if([[LocationManager sharedManager] checkLocationValid])
    {
        CategoryListViewController* vc = [[CategoryListViewController alloc] initWithNibName:@"CategoryListViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
