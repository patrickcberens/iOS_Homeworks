//
//  HW1ViewController.m
//  HW1
//
//  Created by Patrick Berens on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HW1ViewController.h"

@implementation HW1ViewController
@synthesize nameTextField = _nameTextField;
@synthesize nameLabel = _nameLabel;
@synthesize builtInFirstView;
@synthesize builtInSecondView;
@synthesize userName = _userName;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setBuiltInFirstView:nil];
    [self setBuiltInSecondView:nil];
    [self setNameTextField:nil];
    [self setNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)outputHelloToLabel{
    self.userName = self.nameTextField.text;
    
    NSString *nameString = self.userName;
    if([nameString length] == 0)
        nameString = @"World";
    NSString *greeting = [[NSString alloc] initWithFormat:@"Hello, %@!", nameString];
    self.nameLabel.text = greeting;
}

- (IBAction)changeGreeting:(id)sender {
    [self outputHelloToLabel];
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField{
    if(theTextField == self.nameTextField){
        [theTextField resignFirstResponder];
        [self outputHelloToLabel];
    }
    return YES;
}
@end
