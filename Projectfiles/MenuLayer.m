//
//  MenuLayer.m
//  BreakThrough!
//
//  Created by Ki Hyun Won & Sol Park on 11/3/13.
//  
//

#import "MenuLayer.h"
#import "StageLayer.h"
CCSprite *bg;
CCMenu *menu;
StageLayer* stage;

@interface MenuLayer ()

@end

@implementation MenuLayer

-(id) init
{
	if( (self=[super init] )) {
        // create and initialize our seeker sprite, and add it to this layer
        bg = [CCSprite spriteWithFile: @"backgroundmain.png"];
        bg.position = ccp( 240, 160 );
        
        // create and initialize our seeker sprite, and add it to this layer
        CCSprite *pic = [CCSprite spriteWithFile: @"hallway.png"];
        pic.position = ccp( 130, 90 );
        
        
        CCMenuItemImage *menuItem1 = [CCMenuItemImage itemWithNormalImage:@"startbutton.png"
                                                            selectedImage: @"startbutton.png"
                                                                   target:self
                                                                 selector:@selector(goToStage:)];
        menuItem1.tag = 1;
        
        menu =[CCMenu menuWithItems:(CCMenuItem *) menuItem1, nil];
        menu.position = ccp(350,80);
        [self addChild:bg];
        [self addChild:pic];
        [self addChild:menu];
	}
	return self;
}



- (void) goToStage: (CCMenuItem  *) menuItem
{
    if(stage == NULL){
        stage = [[StageLayer alloc] init];
        stage.parent = self;
    }
	[[CCDirector sharedDirector] pushScene: [CCTransitionFade transitionWithDuration:0.5f scene:(CCScene*) stage]];
}

-(void) dealloc
{
	
#ifndef KK_ARC_ENABLED
	// don't forget to call "super dealloc"
	[super dealloc];
#endif // KK_ARC_ENABLED
}

@end