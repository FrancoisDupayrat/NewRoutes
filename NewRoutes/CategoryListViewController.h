//
//  CategoryListViewController.h
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView* tableView;
    NSMutableArray* categories;
    UINavigationItem* navTitle;
    NSArray* sections;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UINavigationItem* navTitle;

@end
