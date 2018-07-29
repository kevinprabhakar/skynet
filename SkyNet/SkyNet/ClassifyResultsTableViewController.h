//
//  ClassifyResultsTableViewController.h
//  SkyNet
//
//  Created by Kevin Prabhakar on 12/3/17.
//  Copyright © 2017 Kevin Prabhakar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassifyResultsTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray* captionsArray;
@property (strong, nonatomic) NSMutableArray* confidenceArray;

@property(strong, atomic) NSString* dictPath;

@end
