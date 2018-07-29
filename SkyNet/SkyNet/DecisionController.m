//
//  DecisionController.m
//  SkyNet
//
//  Created by Kevin Prabhakar on 12/2/17.
//  Copyright © 2017 Kevin Prabhakar. All rights reserved.
//

#import "DecisionController.h"
#import "AFNetworking.h"
#import <Photos/Photos.h>
#import "MergeResultsController.h"
#import "ClassifyResultsTableViewController.h"
#import "imagePickerController.h"

@interface DecisionController ()


@end

@implementation DecisionController

// API Key
NSString* API_Key = @"6279d655-ab5e-4c1e-aca0-7a6b519f7a21";

//Retrieve stored image path from documents
- (NSString*)LoadImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      @"tempPic.png"];
    return path;
}

// Send API Call to Merge Image and Perform Segue to display result
-(IBAction)mergeImage:(id)sender{
    // Setting Config for POST request
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfig.timeoutIntervalForRequest = 600.0;
    sessionConfig.timeoutIntervalForResource = 600.0;
    
    // Getting selected style to merge image with from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger style = [defaults integerForKey:@"selectedStyle"];
    
    NSString* styleChoice = @"";
    
    switch (style) {
        case 0:
            styleChoice = @"la-muse.ckpt";
            break;
        case 1:
            styleChoice = @"scream.ckpt";
            break;
        case 2:
            styleChoice = @"rain-princess.ckpt";
            break;
        case 3:
            styleChoice = @"wave.ckpt";
            break;
        default:
            styleChoice = @"la-muse.ckpt";
            break;
    }
    NSData *styleData = [styleChoice dataUsingEncoding:NSUTF8StringEncoding];
    NSString* imagePath = [self LoadImage];

    //Instantiate HTTP Request
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"https://api.deepai.org/api/fast-style-transfer" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:imagePath] name:@"image" fileName:@"tempPic.png"mimeType:@"image/png" error:nil];

        [formData appendPartWithFormData:styleData name:@"style"];
        
        
    } error:nil];
    [request addValue:API_Key forHTTPHeaderField:@"api-key"];
    
    
    //Priming HTTP Request
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfig];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          // Updating Progress bar asynchronously
                          _progressBar.progress = uploadProgress.fractionCompleted;
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      // Creating Alert Controller to inform of No Wifi
                      
                      if (error) {
                          UIAlertController * alert = [UIAlertController
                                                       alertControllerWithTitle:@"Error"
                                                       message:@"No Internet Connection Detected. Please connect to the internet."
                                                       preferredStyle:UIAlertControllerStyleAlert];
                          
                          
                          UIAlertAction* cancelButton = [UIAlertAction
                                                         actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                         }];
                          [alert addAction:cancelButton];
                          [self presentViewController:alert animated:YES completion:nil];
                      } else {
                          //Sending Output URL to results screen
                          _outputURL = responseObject[@"output_url"];
                          
                          [self performSegueWithIdentifier:@"ToResultsSegue" sender:self];
                          
                          [_progressBar setHidden:YES];
                      }
                  }];
    [_progressBar setHidden:NO];
    BOOL speaking = [defaults boolForKey:@"speakingOn"];
    
    if (speaking){
        [imagePickerController PlayAIQuote:@"Merging Image"];
    }
    [uploadTask resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Creating progress bar view view
    _progressBar.progressViewStyle = UIProgressViewStyleBar;
    [self.view addSubview:_progressBar];
    [_progressBar setHidden:YES];
    
    // Init'ing dictionary for classifications
    _classifications = [[NSMutableDictionary alloc]init];
    
    //Customizing UI Components
    self.mergeButton.backgroundColor = [UIColor redColor];
    self.classifyButton.backgroundColor = [UIColor redColor];;
    [self.mergeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.classifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    self.view.backgroundColor = [UIColor colorWithRed:11.0/255 green:13.0/255 blue:21.0/255 alpha:1.0];
    
    self.mergeButton.layer.cornerRadius = 10; // this value vary as per your desire
    
    self.classifyButton.layer.cornerRadius = 10;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ClassifyImage:(UIButton *)sender {
    // Creating config for HTTP Request
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfig.timeoutIntervalForRequest = 600.0;
    sessionConfig.timeoutIntervalForResource = 600.0;
    
    NSString* imagePath = [self LoadImage];
    
    // Instantiating HTTP Request
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"https://api.deepai.org/api/densecap" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
         [formData appendPartWithFileURL:[NSURL fileURLWithPath:imagePath] name:@"image" fileName:@"tempPic.png"mimeType:@"image/png" error:nil];
        
    } error:nil];
    [request addValue:API_Key forHTTPHeaderField:@"Api-Key"];
    
    // Creating AFURLSession Manager
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfig];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          // Updating progress bar asynchronously
                          _progressBar.progress = uploadProgress.fractionCompleted;

                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          // Alert controller in case of no wifi
                          UIAlertController * alert = [UIAlertController
                                                       alertControllerWithTitle:@"Error"
                                                       message:@"No Internet Connection Detected. Please connect to the internet."
                                                       preferredStyle:UIAlertControllerStyleAlert];
                          
                          
                          UIAlertAction* cancelButton = [UIAlertAction
                                                     actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                     }];
                          [alert addAction:cancelButton];
                          [self presentViewController:alert animated:YES completion:nil];
                      } else {
                          // Writing classifications to dictionary to be saved to documents
                          for (int i=0;i<[responseObject[@"output"][@"captions"] count];i++){
                              NSString* key = responseObject[@"output"][@"captions"][i][@"caption"];
                              double confidence = [responseObject[@"output"][@"captions"][i][@"confidence"] doubleValue];
                              NSNumber *tempNumber = [[NSNumber alloc] initWithDouble:confidence];
                              if ([key length] > 0){
                                  _classifications[key] = tempNumber;
                              }
                          }
                          
                          
                          // Writing dictionary to documents
                          NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                               NSUserDomainMask, YES);
                          
                          if ([paths count] > 0)
                          {
                              NSString* dictPath = [[paths objectAtIndex:0]
                                          stringByAppendingPathComponent:@"classifyResults.out"];
                              
                              _outputURL = dictPath;
                            [_classifications writeToFile:dictPath atomically:NO];
                          }
                          
                          [self performSegueWithIdentifier:@"ToClassifyResults" sender:self];
                          
                          [_progressBar setHidden:YES];

                      }
                  }];
    [_progressBar setHidden:NO];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL speaking = [defaults boolForKey:@"speakingOn"];
    
    if (speaking){
        [imagePickerController PlayAIQuote:@"Classifying Image"];
    }
    [uploadTask resume];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ToResultsSegue"])
    {
        MergeResultsController *vc = [segue destinationViewController];
        
        [vc setURLString:_outputURL];
        
    }
    if ([[segue identifier] isEqualToString:@"ToClassifyResults"])
    {
        ClassifyResultsTableViewController *vc = [segue destinationViewController];
        
        [vc setDictPath:_outputURL];
        
    }
    
}



@end
