//
//  HW1FirstView.m
//  HW1
//
//  Created by Patrick Berens on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HW1FirstView.h"

@implementation HW1FirstView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib
{
   UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
   label.text = @"Full credit";
   label.backgroundColor = [UIColor clearColor];
   [self addSubview:label];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
