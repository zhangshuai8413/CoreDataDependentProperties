#import "Invoice.h"

#import "Person.h"

@implementation Invoice 

@dynamic alreadyPaid;
@dynamic invoiceSum;
@dynamic invoiceNumber;
@dynamic customer;
@dynamic discount;

+(NSArray*) keyPathsForValuesAffectingDerivedDiscount
{
	return [NSArray arrayWithObjects:@"customer.standardDiscount", nil];
}

+(NSArray*) keyPathsForValuesAffectingDiscountedInvoiceSum
{
	return [NSArray arrayWithObjects:@"discount", @"invoiceSum", nil];
}

+(Invoice*) insertNewInvoiceWithCustomer:(Person*) newCustomer inManagedObjectContext:(NSManagedObjectContext*) context
{
	if (newCustomer == nil)
		[NSException raise:@"Customer required" format:@"insertNewInvoice failed because of missing customer"];
	
	Invoice *newInvoice = [NSEntityDescription insertNewObjectForEntityForName:@"Invoice"
														  inManagedObjectContext:context];
	newInvoice.customer = newCustomer;
	newInvoice.discount = newCustomer.standardDiscount;
	return newInvoice;
}

-(void) updateDerivedDiscountForChange:(NSDictionary *)change
{
	//transient property undo gets handeled by undomanager
	//do nothing in this case!
	if ([self.managedObjectContext.undoManager isUndoing]
		||[self.managedObjectContext.undoManager isRedoing])
	{
		return;
	}

    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
	id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    
    // do not process if value did not change
    // this observing might be triggered while merging contexts
	if ([oldValue isEqual:newValue])
    {
        return;
    }

    
	//NSLog(@"<%p %@> update discount", self, [self className]);	
	if (!self.alreadyPaid.boolValue
		&& self.discount.doubleValue != self.customer.standardDiscount.doubleValue)
	{
		self.discount = self.customer.standardDiscount;
	}
}

- (NSNumber*) discountedInvoiceSum
{
	double sum = self.invoiceSum.doubleValue;
	double discount = self.discount.doubleValue;
	return [NSNumber numberWithDouble:sum - sum*discount];
}

- (void)prepareForDeletion
{
    NSLog(@"prepareForDeletion %p %@", self, self.className);
}

//-(void) stopObserving
//{
//    NSLog(@"stopObserving %p", self);
//    [super stopObserving];
//}
//
//-(void) startObserving
//{
//    NSLog(@"startObserving %p", self);
//    [super startObserving];
//}

//- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
//{
//    if (observer == self
////        && [[observer className] isEqualToString:@"Invoice"]
//        )
//    {
//        NSLog(@"invoice addObserver: <%p, %@> forKeyPath: %@", observer, [observer className], keyPath);
//        NSLog(@"context: %@", context);
//    }
//    [super addObserver:observer forKeyPath:keyPath options:options context:context];
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    NSLog(@"=======================================================");
//    NSLog(@"observe: keyPath: %@ - object: %p %@", keyPath, object, [object className]);
//    NSLog(@"context: %@", context);
//    NSLog(@"=======================================================");
//    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//}

@end
