//
//  Fist.m
//  BreakThrough!
//
//  Created by Ki Hyun Won on 11/18/13.
//
//

#import "Fist.h"

@implementation Fist
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
	if ((self = [super initWithFile:@"ddol.png"]))
	{
        _hitpoints = 5.0f;
        _steel = NO;
        
	}
	return self;
}
-(void) hitAction
{
    
}
@end