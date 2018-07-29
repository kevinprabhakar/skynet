//
//  ClassifyResultsTableViewController.m
//  SkyNet
//
//  Created by Kevin Prabhakar on 12/3/17.
//  Copyright © 2017 Kevin Prabhakar. All rights reserved.
//

#import "ClassifyResultsTableViewController.h"

@interface ClassifyResultsTableViewController ()

@property(strong, nonatomic) NSArray* orderedKeys;
@property(strong, nonatomic) NSDictionary* dictFromFile;

@end

@implementation ClassifyResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Init'ing array for table cells
    _captionsArray = [[NSMutableArray alloc]init];
    _confidenceArray = [[NSMutableArray alloc]init];
    
    // Reading dict from File Path
    _dictFromFile = [NSDictionary dictionaryWithContentsOfFile:_dictPath];
    

    // Ordering keys by value (Confidence)
    _orderedKeys = [_dictFromFile keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj2 compare:obj1];
    }];
 

    // Adding objects to array by ordered key
    for(id key in _orderedKeys){
        [_captionsArray addObject:key];
        [_confidenceArray addObject:_dictFromFile[key]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Number of captions
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_captionsArray count];
}

// Instantiating table view cell with appropriate title and subtitle
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confidenceResult" forIndexPath:indexPath];
    
    NSString *subtitle = [[NSString alloc] initWithFormat:@"Confidence: %@", _dictFromFile[_orderedKeys[indexPath.row]]];

    cell.userInteractionEnabled = YES;
    cell.detailTextLabel.enabled = YES;
    cell.textLabel.enabled = YES;

    cell.detailTextLabel.text = subtitle;
    cell.textLabel.text = [[NSString alloc]initWithFormat:@"%@",_orderedKeys[indexPath.row]];

    return cell;
}


@end
