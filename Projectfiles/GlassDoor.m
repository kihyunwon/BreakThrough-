//
//  PoliceEntrance.m
//  BreakThrough!
//
//  Created by Ki Hyun Won on 11/11/13.
//
//

#import "GlassDoor.h"

@implementation GlassDoor
@synthesize health = _health;
@synthesize reborn = _reborn;
@synthesize deadOnce = _deadOnce;

+(id) createGate
{
	id myGate = [[self alloc] initWithGateImage];
    
    #ifndef KK_ARC_ENABLED
	[myGate autorelease];
    #endif // KK_ARC_ENABLED
    return myGate;
}

-(id) initWithGateImage
{
	// Loading the Entity's sprite using a file, is a ship for now but you can change this
	if ((self = [super initWithFile:@"window.png"]))
	{
        _health = 20.0f;
        _reborn = NO;
        _deadOnce = NO;
	}
	return self;
}

-(void) takeDamage : (float) damage
{
    _health -= damage;
}

@end
