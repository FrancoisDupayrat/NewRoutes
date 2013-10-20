//
//  VenueDetailViewController.m
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "VenueDetailViewController.h"
#import <Foursquare2.h>

@interface VenueDetailViewController ()

@end

@implementation VenueDetailViewController

@synthesize fID;
@synthesize titleLabel;
@synthesize verifiedImage;
@synthesize addressLabel;
@synthesize urlButton;
@synthesize hoursLabel;
@synthesize descriptionLabel;
@synthesize photoImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        fID = nil;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Lieu";
    // Do any additional setup after loading the view from its nib.
}

- (void) setFID:(NSString *)value
{
    if(![fID isEqualToString:value])
    {
        fID = value;
        [Foursquare2 getDetailForVenue:fID callback:^(BOOL success, id result) {
            if(!success)
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Erreur"
                                                                message:@"Impossible de récupérer les informations du point d'intérêt, veuillez réessayez plus tard"
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [alert show];
                return;
            }
            NSDictionary* response = [result objectForKey:@"response"];
            NSDictionary* venue = [response objectForKey:@"venue"];
            NSLog(@"venue result : %@", venue);
            [titleLabel setText:[venue objectForKey:@"name"]];
            NSDictionary* location = [venue objectForKey:@"location"];
            if([location objectForKey:@"fuzzed"] != nil || ([location objectForKey:@"address"] == nil && [location objectForKey:@"city"] == nil))
            {
                [addressLabel setText:@"Indisponible"];
            }
            else
            {
                //Print address and city if they are available, else only one
                [addressLabel setText:[NSString stringWithFormat:@"%@%@%@",
                                       [location objectForKey:@"address"] != nil ? [location objectForKey:@"address"] : @"",
                                       [location objectForKey:@"address"] != nil && [location objectForKey:@"city"] != nil ? @", " : @"",
                                       [location objectForKey:@"city"] != nil ? [location objectForKey:@"city"] : @""]];
            }
            verifiedImage.hidden = ![[venue objectForKey:@"verified"] boolValue];
            
            [urlButton setTitle:[venue objectForKey:@"url"] != nil ? [venue objectForKey:@"url"] : @"Page Foursquare" forState:UIControlStateNormal];
            redirectUrl = [venue objectForKey:@"url"] != nil ? [venue objectForKey:@"url"] : [venue objectForKey:@"canonicalUrl"];
            
            [descriptionLabel setText:[venue objectForKey:@"description"] != nil ? [venue objectForKey:@"description"] : @"Aucune information disponible"];
            NSDictionary* hours = [venue objectForKey:@"hours"];
            [hoursLabel setText:[venue objectForKey:@"hours"] != nil ? [hours objectForKey:@"status"] : @"Heures d'ouverture inconnues"];
            //TODO : photo
        }];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openUrl:(id)sender
{
    if(redirectUrl != nil)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
