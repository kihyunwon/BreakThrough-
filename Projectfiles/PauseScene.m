//
//  PauseScene.m
//  BreakThrough!
//
//  Created by Ki Hyun Won on 11/18/13.
//
//
#import "StageLayer.h"
#import "PauseScene.h"

@implementation PauseScene


+(id) createPause : (NSString*) string : (int) score : (NSString*) paused
{
	id pause = [[self alloc] initWithString:string:score:paused];
    #ifndef KK_ARC_ENABLED
	[pause autorelease];
    #endif // KK_ARC_ENABLED
    return pause;
}

-(id)initWithString : (NSString*) string : (int) score : (NSString*) paused
{
    if( (self=[super init] )) {

        CCLabelTTF *label = [CCLabelTTF labelWithString:string
                                               fontName:@"Courier New"
                                               fontSize:30];
        label.position = ccp(240,190);
        [self addChild: label];
        [CCMenuItemFont setFontName:@"Courier New"];
        [CCMenuItemFont setFontSize:20];
        
        CCMenuItem *Score= [CCMenuItemFont itemWithString:[NSString stringWithFormat:@"Score: %d", score]
                                                   target:self
                                                 selector:@selector(nothing :)];
        CCMenuItem *Resume;
        if(paused == NULL){
            Resume= [CCMenuItemFont itemWithString:@"Resume"
                                            target:self
                                          selector:@selector(resume:)];
        }else{
            Resume= [CCMenuItemFont itemWithString:paused
                                            target:self
                                          selector:@selector(nothing:)];
        }
        
        CCMenuItem *Quit = [CCMenuItemFont itemWithString:@"Quit Game"
                                                   target:self selector:@selector(GoToStage:)];
        
        CCMenu *menu= [CCMenu menuWithItems: Score, Resume, Quit, nil];
        menu.position = ccp(240, 120);
        [menu alignItemsVerticallyWithPadding:12.5f];
        
        [self addChild:menu];
        
    }
    return self;
}

+(id) scene{
    CCScene *scene=[CCScene node];
    
    PauseScene *layer = [PauseScene node];
    
    [scene addChild: layer];
    
    return scene;
}

-(void) resume: (id) sender {
    
    [[CCDirector sharedDirector] popScene];
}

-(void) nothing: (id) sender {
}

-(void) GoToStage: (id) sender {
    StageLayer* stage = (StageLayer*) self.parent.parent;
    [[CCDirector sharedDirector] sendCleanupToScene];
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene: (CCScene*)stage]];
}
@end
