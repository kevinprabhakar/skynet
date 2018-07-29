//
//  MergeResultsController.m
//  SkyNet
//
//  Created by Kevin Prabhakar on 12/2/17.
//  Copyright © 2017 Kevin Prabhakar. All rights reserved.
//

#import "MergeResultsController.h"
#import "UIImageView+AFNetworking.h"

@interface MergeResultsController ()
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation MergeResultsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Customizing save button.
    [_saveButton setEnabled:NO];
    [_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _saveButton.backgroundColor = [UIColor redColor];
    _saveButton.layer.cornerRadius = 10;
    
    // Customizing background volor
    self.view.backgroundColor = [UIColor colorWithRed:11.0/255 green:13.0/255 blue:21.0/255 alpha:1.0];
    
    // Set imageview to result image
    [self.imageView setImageWithURL:[NSURL URLWithString:_URLString] placeholderImage:[UIImage imageNamed:@"Loading"]];
    
    // If imageview image isn't same as loading image, set save button
    if (_imageView.image != [UIImage imageNamed:@"Loading"]){
        [_saveButton setEnabled:YES];
    }
    
}

- (IBAction)savePhoto:(id)sender{
    // Save Photo to Album
    UIImageWriteToSavedPhotosAlbum(_imageView.image,
                                   nil,
                                   nil,
                                   nil);
    
    // Disable save button
    [_saveButton setEnabled:NO];
    _saveButton.backgroundColor = [UIColor grayColor];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
