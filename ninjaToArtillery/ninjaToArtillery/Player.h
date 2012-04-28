//
//  Player.h
//  ninjaToArtillery
//
//  Created by default on 4/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Turret.h"

@interface Player : Turret {

}

-(void)fireProjectile:(CGPoint)touchLocation;
@end
