//
//  Chainsaw.m
//  BreakThrough!
//
//  Created by Ki Hyun Won on 11/11/13.
//
//

#import "Chainsaw.h"

@implementation Chainsaw
@synthesize hitpoints = _hitpoints;
@synthesize steel = _steel;

+(id) createWeapon
{
	id myWeapon = [[self alloc] initWithWeaponImage];
    
    #ifndef KK_ARC_ENABLED
	[myWeapon autorelease];
    #endif // KK_ARC_ENABLED
    return myWeapon;
}

-(id) initWithWeaponImage
{
	// Loading the Entity's sprite using a file, is a ship for now but you can change this
	if ((self = [super initWithFile:@"Chainsaw.png"]))
	{
        _hitpoints = 10.0f;
        _steel = YES;
	}
	return self;
}

-(void) hitAction
{
}

@end
