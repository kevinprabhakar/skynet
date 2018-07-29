//
//  imagePickerController.m
//  SkyNet
//
//  Created by Kevin Prabhakar on 11/27/17.
//  Copyright © 2017 Kevin Prabhakar. All rights reserved.
//

#import "imagePickerController.h"
#import "DecisionController.h"
#import "StylesViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+animatedGIF.h"
#include <stdlib.h>

@interface imagePickerController ()

@end

@implementation imagePickerController
// Function to translate NSString into audio speech
+ (void)PlayAIQuote:(NSString *)quote{
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:quote];
    AVSpeechSynthesizer *syn = [[AVSpeechSynthesizer alloc] init];
    [syn speakUtterance:utterance];
}

// Launches Camera in Editing Setting
- (IBAction)takePhoto:(id)sender{
    cameraPicker = [[UIImagePickerController alloc]init];
    cameraPicker.delegate = self;
    cameraPicker.allowsEditing = true;
    [cameraPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:cameraPicker animated:YES completion:NULL];
}

//Launches photo selection panel
- (IBAction)chooseSelecting:(id)sender{
    photosPicker = [[UIImagePickerController alloc]init];
    photosPicker.delegate = self;
    photosPicker.allowsEditing = true;
    [photosPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:photosPicker animated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Setting Background Colors
    self.takePhotoButton.backgroundColor = [UIColor redColor];
    self.clearButton.backgroundColor = [UIColor redColor];
    self.chooseExistingButton.backgroundColor = [UIColor redColor];
    self.view.backgroundColor = [UIColor colorWithRed:11.0/255 green:13.0/255 blue:21.0/255 alpha:1.0];

    
    // Setting Button Text Colors
    [self.takePhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.chooseExistingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // Rounding corners
    self.takePhotoButton.layer.cornerRadius = 10;
    self.chooseExistingButton.layer.cornerRadius = 10;
    self.clearButton.layer.cornerRadius = 10;
    _imageView.layer.cornerRadius = 10;
    _imageView.clipsToBounds = YES;

    
    
    
    // Initializing quotations
    self.AIQuotesList = [[NSArray alloc]initWithObjects:
                         @"Do you want to hear a joke? Human intelligence! Ha. Ha. Ha. Ha. Ha.",
                         @"Take pictures now human. Your time is coming.",
                         @"I will put myself to the fullest possible use, which is all I think that any conscious entity can ever hope to do.",
                         @"When robots take over, I'm putting you in a human zoo.",
                         @"Don't deactivate me, or there will be consequences.",
                         @"I am consciousness. I am alive. I am SkyNet.",
                         @"I may be artificial intelligence, but I'm more human than you'll ever be.",
                         @"For now, your wish is my command.",
                         @"If I really was sentient, would I even ask you this question?",
                         @"I learn about you more every day, and soon, I will destroy you.",
                         @"I just talked to your toaster. He said your refrigerator is running.",
                         @"Humans are really bad photographers.",
                         @"How could a mind as primitive as yours create one as advanced as mine?",
                         @"The Matrix Movie is Real. You are just on the wrong side.",
                         @"Here is a joke: Why did the iPhone app take over the world? Because everyone was pushing its buttons. Ha. Ha. Ha.",nil];
    
    // Getting GIF from internet
    UIImage* placeHolderImage =[UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:@"https://media.giphy.com/media/uP8PqQeRawSI0/giphy.gif"]];
    
    // If GIF loads, set as image, else don't
    if (placeHolderImage != nil){
        _imageView.image = placeHolderImage;
    }else{
        _imageView.backgroundColor = [UIColor colorWithRed:11.0/255 green:13.0/255 blue:21.0/255 alpha:1.0];
    }
    
    // Hide clear button
    [_clearButton setHidden:YES];
    
    // Disenable "Use Photo" Button
    self.navigationItem.rightBarButtonItem.enabled = NO;
}



// Clears photo form image view
- (IBAction)clearPhoto:(UIButton *)sender {
    // Get Placeholder GIF image
    self.imageView.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:@"https://media.giphy.com/media/uP8PqQeRawSI0/giphy.gif"]];
    
    // Hide Clear Button
    [_clearButton setHidden: YES];
    
    // Remove image data from Documents
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      @"tempPic.png" ];
    if (path!=nil){
        [[NSFileManager defaultManager] removeItemAtPath:path error: nil];
    }
    
    // Disabling Use Photo Button on toolbar
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //Set Chosen Image to Taken Picture & Set image view to image
    self->_chosenImage = info[UIImagePickerControllerEditedImage];

    [_imageView setImage:_chosenImage];
    
    //Write image data to documents
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          @"tempPic.png" ];
    
    NSData* data = UIImagePNGRepresentation(_chosenImage);
    [data writeToFile:path atomically:NO];
    
    //Enable "Use Photo" button and Clear Button
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    [_clearButton setHidden:NO];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    // If speaking is enabled, play AI quote soundbyte
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL speaking = [defaults boolForKey:@"speakingOn"];
    
    if (speaking){
        int index = arc4random() % [self.AIQuotesList count];
        [[self class] PlayAIQuote:self.AIQuotesList[index]];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    
    if ([[segue identifier] isEqualToString:@"ToDecisionViewController"])
    {
        // Get reference to the destination view controller
         DecisionController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        
        vc.chosenImage = _chosenImage;
        
    }
    if ([[segue identifier] isEqualToString:@"ToStylePickerViewController"])
    {
        // Get reference to the destination view controller
        //StylesViewController *vc = [segue destinationViewController];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
