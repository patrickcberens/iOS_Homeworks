//
//  GameplayLayer.m
//  SpaceViking
//
//  Created by default on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameplayLayer.h"

@implementation GameplayLayer

-(void)initJoystickAndButtons{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CGRect joyStickBaseDimensions = CGRectMake(0, 0, 128.0f, 128.0f);
    CGRect jumpButtonDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
    CGRect attackButtonDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
    CGPoint joystickBasePosition;
    CGPoint jumpButtonPosition;
    CGPoint attackButtonPosition;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){   //iPad 3.2 or later
        joystickBasePosition = ccp(screenSize.width * 0.0625f, screenSize.height * 0.052f);
        jumpButtonPosition = ccp(screenSize.width * 0.946f, screenSize.height * 0.052f);
        attackButtonPosition = ccp(screenSize.width * 0.947f, screenSize.height * 0.169);
    }
    else{
        joystickBasePosition = ccp(screenSize.width * 0.07f, screenSize.height * 0.11f);
        jumpButtonPosition = ccp(screenSize.width * 0.93f, screenSize.height * 0.11f);
        attackButtonPosition = ccp(screenSize.width * 0.93f, screenSize.height * 0.35f);
    }
    
    SneakyJoystickSkinnedBase * joystickBase = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    joystickBase.position = joystickBasePosition;
    joystickBase.backgroundSprite = [CCSprite spriteWithFile:@"dpadDown.png"];
    joystickBase.thumbSprite = [CCSprite spriteWithFile:@"joystickDown.png"];
    joystickBase.joystick = [[SneakyJoystick alloc] initWithRect:joyStickBaseDimensions];
    leftJoystick = [joystickBase.joystick retain];
    [self addChild:joystickBase];
    
    SneakyButtonSkinnedBase *jumpButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];        
    jumpButtonBase.position = jumpButtonPosition;                
    jumpButtonBase.defaultSprite = 
    [CCSprite spriteWithFile:@"jumpUp.png"];                     
    jumpButtonBase.activatedSprite = 
    [CCSprite spriteWithFile:@"jumpDown.png"];                   
    jumpButtonBase.pressSprite = 
    [CCSprite spriteWithFile:@"jumpDown.png"];                   
    jumpButtonBase.button = [[SneakyButton alloc] initWithRect:jumpButtonDimensions]; 
    jumpButton = [jumpButtonBase.button retain];                 
    jumpButton.isToggleable = NO;                                
    [self addChild:jumpButtonBase];                              
    
    SneakyButtonSkinnedBase *attackButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];          
    attackButtonBase.position = attackButtonPosition;            
    attackButtonBase.defaultSprite = [CCSprite spriteWithFile:@"handUp.png"];                                  
    attackButtonBase.activatedSprite = [CCSprite spriteWithFile:@"handDown.png"];                             
    attackButtonBase.pressSprite = [CCSprite spriteWithFile:@"handDown.png"];                                  
    attackButtonBase.button = [[SneakyButton alloc] initWithRect:attackButtonDimensions];                           
    attackButton = [attackButtonBase.button retain];             
    attackButton.isToggleable = NO;                              
    [self addChild:attackButtonBase];                            
}

-(void)applyToJoystick:(SneakyJoystick *)aJoystick toNode:(CCNode *)tempNode forTimeDelay:(float)deltaTime{
    CGPoint scaledVelocity = ccpMult(aJoystick.velocity, 1024.0f);
    CGPoint newPosition = ccp(tempNode.position.x + scaledVelocity.x * deltaTime,
                              tempNode.position.y + scaledVelocity.y * deltaTime);
    
    [tempNode setPosition:newPosition];
    
    if(jumpButton.active == YES)
        CCLOG(@"Jump button is pressed.");
    if(attackButton.active == YES)
        CCLOG(@"Attack button is pressed.");
}

-(void)update:(ccTime)deltaTime{
    [self applyToJoystick:leftJoystick toNode:vikingSprite forTimeDelay:deltaTime];
}

-(id)init{
    self = [super init];
    if(self != nil){
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        self.isTouchEnabled = YES;  //Enable Touches
        
        //vikingSprite = [CCSprite spriteWithFile:@"sv_anim_1.png"];    //old way: before batch
        CCSpriteBatchNode *chapter2BatchNode;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"scene1atlas.plist"];
            chapter2BatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene1atlas.png"];
        }
        else{
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"scene1atlasiphone.plist"];
            chapter2BatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene1atlasiphone.png"];
        }
        vikingSprite = [CCSprite spriteWithSpriteFrameName:@"sv_anim_1.png"];
        
        [chapter2BatchNode addChild:vikingSprite];
        [self addChild:chapter2BatchNode];
        
                                 
        [vikingSprite setPosition:CGPointMake(screenSize.width/2, screenSize.height*0.17f)];
        //[self addChild:vikingSprite]; //old way before batch
        
        if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){   //Not iPad, so scale vikingSprite down
            [vikingSprite setScaleX:screenSize.width/1024.0f];
            [vikingSprite setScaleY:screenSize.height/768.0f];
        }
    }
    
    [self initJoystickAndButtons];
    [self scheduleUpdate];      //update ever position every time renders based upon joystick
    
    return self;         
}
@end
