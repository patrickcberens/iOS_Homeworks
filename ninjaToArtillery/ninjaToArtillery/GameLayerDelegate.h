//
//  FireDelegate.h
//  ninjaToArtillery
//
//  Created by default on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol GameLayerDelegate <NSObject>

//Protocol responsible for sending messages to GameplayLayer
//--Acts as a controller for the turret and enemy
//--Tells layer when to remove or add children to the scene
//--Tells layer when to add or remove an enemy from the array
@required
-(void)addChild:(CCNode*)node z:(NSInteger)z;
-(void)removeChild:(CCNode*)node cleanup:(BOOL)cleanup;
-(void)addEnemy:(CCNode*)node;
-(void)removeEnemy:(CCNode*)node;
@end
