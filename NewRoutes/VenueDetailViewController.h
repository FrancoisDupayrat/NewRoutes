//
//  VenueDetailViewController.h
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenueLocation.h"

@interface VenueDetailViewController : UIViewController <UIAlertViewDelegate>
{
    NSString* fID;
    UILabel* titleLabel;
    UIImageView* verifiedImage;
    UILabel* descriptionLabel;
    UIButton* urlButton;
    UILabel* hoursLabel;
    UIImageView* photoImage;
    UILabel* addressLabel;
    
    NSString* redirectUrl;
}

@property (nonatomic, retain) NSString* fID;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UIImageView* verifiedImage;
@property (nonatomic, retain) IBOutlet UILabel* descriptionLabel;
@property (nonatomic, retain) IBOutlet UIButton* urlButton;
@property (nonatomic, retain) IBOutlet UILabel* hoursLabel;
@property (nonatomic, retain) IBOutlet UIImageView* photoImage;
@property (nonatomic, retain) IBOutlet UILabel* addressLabel;

- (IBAction)openUrl:(id)sender;

@end
