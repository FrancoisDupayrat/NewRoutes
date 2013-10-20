//
//  CategoryListViewController.h
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedVenuesListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView* tableView;
    UINavigationItem* navTitle;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UINavigationItem* navTitle;

@end
