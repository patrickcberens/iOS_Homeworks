//
//  Enemy.h
//  ninjaToArtillery
//
//  Created by default on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameLayerDelegate.h"
#import "Character.h"


@interface Enemy : Character
{
    CCSprite *_enemy;
    
    int minMoveDuration;
    int maxMoveDuration;
    
    id <GameLayerDelegate> gameLayerDelegate;
}
@property (retain) id gameLayerDelegate;

-(id)initEnemyWithFilename:(NSString*)filename;   //custom init method

@end
