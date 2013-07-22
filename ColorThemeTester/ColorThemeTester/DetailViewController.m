//
//  DetailViewController.m
//  KulerTester
//
//  Created by Kishore Kumar on 21/6/13.
//  Copyright (c) 2013 @KishoreK. All rights reserved.
//

#import "DetailViewController.h"
#import "ColourThemeObject.h"
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
    
    [self.navigationController.navigationBar setTintColor:self.colorObject.color1];
    [self.view setBackgroundColor:self.colorObject.color2];
    [self.toolbar setTintColor:self.colorObject.color5];
    [[[self.toolbar items] objectAtIndex:0] setTintColor:self.colorObject.color2];
    [self.label setTextColor:self.colorObject.color3];
    [self.button setBackgroundColor:self.colorObject.color4];
    
    self.label.text = self.colorObject.title;
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
    NSString *emailBody = nil;
    
    if (self.colorObject.url==nil) {
        [picker setSubject:@"Kuler Color pattern!"];
        emailBody = @"Check this out!<br/><br/>";
    } else {
        [picker setSubject:@"COLOURlovers Color pattern!"];
        emailBody = [NSString stringWithFormat:@"Check this out!<br/><br/><a href=\"%@\">%@</a><br/><br/>",self.colorObject.url,self.colorObject.url];
    }
    
    emailBody = [NSString stringWithFormat:@"%@ Color 1=%@<br/>Color 2=%@<br/>Color 3=%@<br/>Color 4=%@<br/>Color 5=%@<br/>",emailBody,self.colorObject.color1,self.colorObject.color2,self.colorObject.color3,self.colorObject.color4,self.colorObject.color1];
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
