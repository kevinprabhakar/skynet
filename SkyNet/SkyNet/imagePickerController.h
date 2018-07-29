//
//  imagePickerController.h
//  SkyNet
//
//  Created by Kevin Prabhakar on 11/27/17.
//  Copyright © 2017 Kevin Prabhakar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imagePickerController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>{

    UIImagePickerController *cameraPicker;
    UIImagePickerController *photosPicker;
}
@property (strong, atomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (strong, atomic)UIImage* chosenImage;
@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *chooseExistingButton;
@property (strong, nonatomic) NSArray* AIQuotesList;


-(IBAction)takePhoto:(id)sender;
-(IBAction)chooseSelecting:(id)sender;
+ (void)PlayAIQuote:(NSString *)quote;


@end
