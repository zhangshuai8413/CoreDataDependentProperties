#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <Foundation/Foundation.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#import "LPManagedObject.h"

@interface LPManagedObject(ObservationInfo)

// returns an array of properties with dependency information
+(NSArray*) propertiesWithDependencyInformation;

// returns an array of observation infos for the given property
+(NSArray*) observerInformationForProperty:(NSString*) propertyName withEntityDescription:(NSEntityDescription*) entityDescription;

@end

@interface NSObject (LPManagedObjectExtension)

// check if class is inherited from basClass
+(BOOL) isInheritedFromClass:(Class) baseClass;

@end
