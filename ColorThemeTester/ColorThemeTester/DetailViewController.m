//
//  DetailViewController.m
//  KulerTester
//
//  Created by Kishore Kumar on 21/6/13.
//  Copyright (c) 2013 @KishoreK. All rights reserved.
//

#import "DetailViewController.h"
#import "KulerObject.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setTintColor:self.kuler.color1];
    [self.view setBackgroundColor:self.kuler.color2];
    [self.toolbar setTintColor:self.kuler.color5];
    [[[self.toolbar items] objectAtIndex:0] setTintColor:self.kuler.color2];
    [self.label setTextColor:self.kuler.color3];
    [self.button setBackgroundColor:self.kuler.color4];
    
    self.label.text = self.kuler.title;
    self.button.layer.cornerRadius = 6;    
    [self.button addTarget:self action:@selector(emailImage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage *) screenshotIt{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(window.bounds.size);
    
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)emailImage
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Kuler Color pattern!"];
    NSString *emailBody = @"Check this out!<br/><br/>";
    emailBody = [NSString stringWithFormat:@"%@ Color 1=%@<br/>Color 2=%@<br/>Color 3=%@<br/>Color 4=%@<br/>Color 5=%@<br/>",emailBody,self.kuler.color1,self.kuler.color2,self.kuler.color3,self.kuler.color4,self.kuler.color1];
    [picker setMessageBody:emailBody isHTML:YES];
    NSData *data = UIImagePNGRepresentation([self screenshotIt]);
    [picker addAttachmentData:data mimeType:@"image/png" fileName:@"KulerImage"];
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
