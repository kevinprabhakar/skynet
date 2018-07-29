//
//  StylesViewController.m
//  SkyNet
//
//  Created by Kevin Prabhakar on 12/2/17.
//  Copyright © 2017 Kevin Prabhakar. All rights reserved.
//

#import "StylesViewController.h"

@interface StylesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *completionLabel;

@end

@implementation StylesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Getting Speaking Bool from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL speaking = [defaults boolForKey:@"speakingOn"];
    
    // Customizing UI components
    self.view.backgroundColor = [UIColor colorWithRed:11.0/255 green:13.0/255 blue:21.0/255 alpha:1.0];
    [_talkingSwitch setOn:speaking];
    [_completionLabel setHidden:YES];
    _completionLabel.textColor = [UIColor redColor];
}

// When speaking switch is changed, write value to NSUserDefaults
- (IBAction)changedTalkingCapability:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[sender isOn] forKey:@"speakingOn"];
    [defaults synchronize];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// If La Muse is tapped, write integer to NSUserDefaults to be validated later
- (IBAction)laMuseTapped:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:0 forKey:@"selectedStyle"];
    [defaults synchronize];
    _completionLabel.text = @"Set Style Pattern to La Muse";
    [_completionLabel setHidden:NO];
    
}

// If Scream is tapped, write integer to NSUserDefaults to be validated later
- (IBAction)screamTapped:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:1 forKey:@"selectedStyle"];
    [defaults synchronize];
    _completionLabel.text = @"Set Style Pattern to Scream";
    [_completionLabel setHidden:NO];
}

// If Rain Princess is tapped, write integer to NSUserDefaults to be validated later
- (IBAction)rainPrincessTapped:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:2 forKey:@"selectedStyle"];
    [defaults synchronize];
    _completionLabel.text = @"Set Style Pattern to Rain Princess";
    [_completionLabel setHidden:NO];
}

// If "The Great Wave off Kanagawa" is tapped, write integer to NSUserDefaults to be validated later
- (IBAction)wavesTapped:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:3 forKey:@"selectedStyle"];
    [defaults synchronize];
    _completionLabel.text = @"Set Style Pattern to Waves";
    [_completionLabel setHidden:NO];
}


@end
