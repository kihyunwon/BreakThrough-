//
//  StageLayer.m
//  BreakThrough!
//
//  Created by Ki Hyun Won & Sol Park on 11/9/13.
//
//

#import "StageLayer.h"
#import "Level1.h"
#import "MenuLayer.h"
#import "Level2.h"/*
#import "Level3.h"
#import "Level4.h"
#import "Level5.h"
#import "Level6.h"
#import "Level7.h"
#import "Level8.h"
#import "Level9.h"
#import "Level10.h"
*/
CCSprite *bg;
CCMenu *menu;
CCSprite *hearts;
NSMutableArray* heartArray;
int heartIndex;
float timeLeft;
CCMenu *previous;

@implementation StageLayer

-(id) init
{
	if( (self=[super init] )) {
        
        //initiailize background for stage selection
        bg = [CCSprite spriteWithFile: @"brickbg1.png"];
        bg.position = ccp( 240, 160 );
        [self addChild:bg];
        
        
        
        //initialize button to return to main menu
        CCMenuItemImage *back = [CCMenuItemImage itemWithNormalImage:@"arrow.png"
                                      selectedImage:@"arrow.png"
                                             target:self
                                           selector:@selector(chooseLevel:)];
        back.tag = 0;
        previous =[CCMenu menuWithItems:(CCMenuItem *) back, nil];
        previous.position = ccp(30, 280);
        [self addChild:previous];
        
        //initialize heart array
        heartIndex = 5;
        heartArray = [[NSMutableArray arrayWithCapacity:heartIndex]init];
        for(int i=0;i<heartIndex;i++)
        {
            CCSprite * heart = [CCSprite spriteWithFile:@"heart.png"];
            [heart setPosition:ccp(350+ 28*i,280)];
            [self addChild:heart];
            [heartArray addObject:heart];
        }
        //refill heart every five minutes
        timeLeft = 300.0f;
        [self performSelector: @selector(updateHeart:) withObject:nil afterDelay:300.0f];
        [self schedule:@selector(updateTimeLeft:) interval:1.0f];

        
        //initialize menu for stage selection
        menu = [CCMenu menuWithItems:nil];
        menu.position = ccp( 105, 85 );
        for (int i = 1; i <= 2; i++) {
            
            CCMenuItemImage *item = [CCMenuItemImage itemWithNormalImage:[NSString stringWithFormat:@"level%dbutton.png", i]
                                          selectedImage:[NSString stringWithFormat:@"level%dbutton.png", i]
                                                 target:self
                                               selector:@selector(chooseLevel:)];
            item.tag = i;
            [menu addChild:item];
        }
        [menu alignItemsVerticallyWithPadding:1.0];
        [self addChild:menu];
        
        
        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"wanted.plist"];
        //Load in the spritesheet, if retina Kobold2D will automatically use bearframes-hd.png
        
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"wanted.png"];
        
        [self addChild:spriteSheet];
        
        //Define the frames based on the plist - note that for this to work, the original files must be in the format bear1, bear2, bear3 etc...
        
        //When it comes time to get art for your own original game, makegameswith.us will give you spritesheets that follow this convention, <spritename>1 <spritename>2 <spritename>3 etc...
        
        tauntingFrames = [NSMutableArray array];
        
        for(int i = 1; i <= 2; ++i)
        {
            [tauntingFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"wanted%d.png", i]]];
        }
        
        //Initialize the bear with the first frame you loaded from your spritesheet, bear1
        
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"wanted1.png"];
        
        sprite.anchorPoint = CGPointZero;
        sprite.position = ccp( 35, 145 );
        
        //Create an animation from the set of frames you created earlier
        
        CCAnimation *taunting = [CCAnimation animationWithFrames: tauntingFrames delay:0.5f];
        
        //Create an action with the animation that can then be assigned to a sprite
        
        taunt = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:taunting restoreOriginalFrame:NO]];
        
        //tell the bear to run the taunting action
        [sprite runAction:taunt];
        
        [self addChild:sprite z:0];
        self.touchEnabled = YES;
    }
	return self;
}

- (void)updateTimeLeft:(ccTime)dt {
    timeLeft--;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    for(int i=0;i<heartIndex;i++)
    {
        CCSprite *heart = [heartArray objectAtIndex:i];
        if(CGRectContainsPoint([heart boundingBox], location)){
            [self heartDisplay];
        }
    }
}

-(void) heartDisplay
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time to Heart" message:[NSString stringWithFormat:@"%.02f minutes left \n Heart Left: %d", timeLeft/60, heartIndex] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [[CCDirector sharedDirector] pause];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [[CCDirector sharedDirector] resume];
}

-(void)loseHeart
{
    if(heartIndex <= 5 && heartIndex > 0){
        heartIndex--;
        CCSprite *heart = [heartArray objectAtIndex:heartIndex];
        [heart setVisible:NO];
    }
}


-(void) updateHeart : (CCMenuItem  *) menuItem
{
    if(heartIndex <= 4 && heartIndex >= 0){
        heartIndex++;
        CCSprite *heart = [heartArray objectAtIndex:heartIndex - 1];
        [heart setVisible:YES];
    }
}

-(void) noHeart
{
    CCLabelTTF* label = [CCLabelTTF labelWithString:@"No More Heartㅜ.ㅜ" fontName:@"Marker Felt" fontSize:40];
    CGSize s = [CCDirector sharedDirector].winSize;
    label.position = ccp(s.width/2.0f, 150);
    [self addChild: label z: 1001];
    id scoreAction = [CCSequence actions:
                     [CCSpawn actions:
                     [CCScaleBy actionWithDuration:0.4 scale:2.0],
                     [CCEaseIn actionWithAction:[CCFadeOut actionWithDuration:0.4] rate:2], nil],
                     [CCCallBlock actionWithBlock:^{
                     [self removeChild:label cleanup:YES];}],nil];
    [label runAction:scoreAction];
}

-(void) dealloc
{
#ifndef KK_ARC_ENABLED
	// don't forget to call "super dealloc"
	[super dealloc];
#endif // KK_ARC_ENABLED
}


- (void) chooseLevel: (CCMenuItem  *) menuItem
{
    int level = menuItem.tag;
    if(level >= 1 && level <= 10){
        if(heartIndex == 0 ){
            [self noHeart];
            return;
        }
       [self loseHeart];
    }
    switch(level){
        case 1:{
            Level1* level1 = [[Level1 alloc] init];
            level1.parent = self;
            [[CCDirector sharedDirector] pushScene: [CCTransitionFade transitionWithDuration:0.5f scene:(CCScene*) level1]];
            break;}
        case 2:{
            Level2* level2 = [[Level2 alloc] init];
            level2.parent = self;
            [[CCDirector sharedDirector] pushScene: [CCTransitionFade transitionWithDuration:0.5f scene:(CCScene*) level2]];
            break;}/*
        case 3:
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:(CCScene*)[[Level3 alloc] init]]];
            break;
        case 4:
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:(CCScene*)[[Level4 alloc] init]]];
            break;
        case 5:
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:(CCScene*)[[Level5 alloc] init]]];
            break;
        case 6:
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:(CCScene*)[[Level6 alloc] init]]];
            break;
        case 7:
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:(CCScene*)[[Level7 alloc] init]]];
            break;
        case 8:
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:(CCScene*)[[Level8 alloc] init]]];
            break;
        case 9:
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:(CCScene*)[[Level9 alloc] init]]];
            break;
        case 10:
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:(CCScene*)[[Level10 alloc] init]]];
            break;*/
        default:
            [[CCDirector sharedDirector] pushScene: [CCTransitionFade transitionWithDuration:0.5f scene:(CCScene*)self.parent]];
            break;
    }
}
@end