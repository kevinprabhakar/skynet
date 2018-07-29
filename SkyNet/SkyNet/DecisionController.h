//
//  DecisionController.h
//  SkyNet
//
//  Created by Kevin Prabhakar on 12/2/17.
//  Copyright © 2017 Kevin Prabhakar. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DecisionController : UIViewController

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) UIImage* chosenImage;
@property (strong, nonatomic) NSString* outputURL;

@property (weak, nonatomic) IBOutlet UIButton *mergeButton;
@property (weak, nonatomic) IBOutlet UIButton *classifyButton;
@property (strong, nonatomic) NSMutableDictionary* classifications;



@end
