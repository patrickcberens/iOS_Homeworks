//
//  HW1ViewController.h
//  HW1
//
//  Created by Patrick Berens on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HW1FirstView;
@class HW1SecondView;

@interface HW1ViewController : UIViewController{
    NSString *userName;
}
@property (nonatomic, copy) NSString *userName;

//Two Views which are both custom subclasses of UIView
@property (strong, nonatomic) IBOutlet HW1FirstView *builtInFirstView;
@property (strong, nonatomic) IBOutlet HW1SecondView *builtInSecondView;

//Button for TouchUpInside Event, helps with hello world stuff below
- (IBAction)changeGreeting:(id)sender;

//Text and Label for hello world
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
