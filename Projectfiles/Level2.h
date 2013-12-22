//
//  Level2.h
//  BreakThrough!
//
//  Created by Ki Hyun Won & Sol Park on 12/4/13.
//
//

#import "CCLayer.h"
#import "Fist.h"

@interface Level2 : CCLayer
{
    CCSprite *bg, *npc, *cop, *tem;
    CCMenu *menu;
    int timeToPlay;
    int playtime;
    int score;
    int copCount;
    CCLabelTTF *prepareLabel;
    CCLabelTTF *timeoutLabel;
    CCLabelTTF *playtimeLabel;
    CCLabelTTF *scoreLabel;
    BOOL win;
    BOOL enableItem;
    BOOL caught;
    int ammo;
    
    //variables for sprite
    Fist* ddol;
    int glassCount;
    NSMutableArray* glassArray;
    NSMutableArray* itemArray;
    NSMutableArray * _monsters;
    NSMutableArray * _projectiles;
}

@end
