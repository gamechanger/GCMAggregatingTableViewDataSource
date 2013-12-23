//
//  GCMAggregatedTableViewWrapper.m
//  GameChanger
//
//  Created by Tom Leach on 6/12/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import "GCMAggregatedTableViewWrapper.h"

#pragma mark offsetters

@protocol GCMArgumentOffsetter <NSObject>
+ (void)applyOffset:(NSInteger)offset
         toArgument:(NSInteger)argIndex
       onInvocation:(NSInvocation *)invocation;
@end

@protocol GCMReturnValueOffsetter <NSObject>
+ (void)applyOffset:(NSInteger)offset toReturnValueOnInvocation:(NSInvocation *)invocation;
@end

@interface GCMIndexPathOffsetter : NSObject<GCMArgumentOffsetter,GCMReturnValueOffsetter>
@end

@implementation GCMIndexPathOffsetter
+ (void)applyOffset:(NSInteger)offset
         toArgument:(NSInteger)argIndex
       onInvocation:(NSInvocation *)invocation {
  NSInteger actualIndex = argIndex + 2; // first two args are str and cmp
  __unsafe_unretained NSIndexPath *indexPath;
  [invocation getArgument:&indexPath atIndex:actualIndex];
  NSIndexPath *offsetIndexPath = [NSIndexPath indexPathForItem:indexPath.item
                                                     inSection:indexPath.section + offset];
  [invocation setArgument:&offsetIndexPath atIndex:actualIndex];
}
+ (void)applyOffset:(NSInteger)offset toReturnValueOnInvocation:(NSInvocation *)invocation {
  __unsafe_unretained NSIndexPath *indexPath;
  [invocation getReturnValue:&indexPath];
  NSIndexPath *offsetIndexPath = [NSIndexPath indexPathForItem:indexPath.item
                                                     inSection:indexPath.section - offset];
  [invocation setReturnValue:&offsetIndexPath];
}
@end


@interface GCMIntegerOffsetter : NSObject<GCMArgumentOffsetter>
@end

@implementation GCMIntegerOffsetter
+ (void)applyOffset:(NSInteger)offset
         toArgument:(NSInteger)argIndex
       onInvocation:(NSInvocation *)invocation {
  NSInteger actualIndex = argIndex + 2; // first two args are str and cmp
  NSInteger integer;
  [invocation getArgument:&integer atIndex:actualIndex];
  NSInteger offsetInteger = integer + offset;
  [invocation setArgument:&offsetInteger atIndex:actualIndex];
}
@end


@interface GCMIndexPathArrayOffsetter : NSObject<GCMArgumentOffsetter,GCMReturnValueOffsetter>
@end

@implementation GCMIndexPathArrayOffsetter
+ (void)applyOffset:(NSInteger)offset
         toArgument:(NSInteger)argIndex
       onInvocation:(NSInvocation *)invocation {
  NSInteger actualIndex = argIndex + 2; // first two args are str and cmp
  __unsafe_unretained NSArray *indexPaths;
  [invocation getArgument:&indexPaths atIndex:actualIndex];
  NSMutableArray *offsetIndexPaths = [[NSMutableArray alloc] initWithCapacity:indexPaths.count];
  for (NSIndexPath *indexPath in indexPaths) {
    [offsetIndexPaths addObject:[NSIndexPath indexPathForItem:indexPath.item
                                                    inSection:indexPath.section + offset]];
  }
  NSArray *finalArray = [NSArray arrayWithArray:offsetIndexPaths];
  [invocation setArgument:&finalArray atIndex:actualIndex];
}
+ (void)applyOffset:(NSInteger)offset toReturnValueOnInvocation:(NSInvocation *)invocation {
  __unsafe_unretained NSArray *indexPaths;
  [invocation getReturnValue:&indexPaths];
  NSMutableArray *offsetIndexPaths = [[NSMutableArray alloc] initWithCapacity:indexPaths.count];
  for (NSIndexPath *indexPath in indexPaths) {
    [offsetIndexPaths addObject:[NSIndexPath indexPathForItem:indexPath.item
                                                    inSection:indexPath.section - offset]];
  }
  NSArray *finalArray = [NSArray arrayWithArray:offsetIndexPaths];
  [invocation setReturnValue:&finalArray];
}
@end


@interface GCMIndexSetOffsetter : NSObject<GCMArgumentOffsetter>
@end

@implementation GCMIndexSetOffsetter
+ (void)applyOffset:(NSInteger)offset
         toArgument:(NSInteger)argIndex
       onInvocation:(NSInvocation *)invocation {
  NSInteger actualIndex = argIndex + 2; // first two args are str and cmp
  __unsafe_unretained NSIndexSet *indexSet;
  [invocation getArgument:&indexSet atIndex:actualIndex];
  NSMutableIndexSet *offsetIndexSet = [[NSMutableIndexSet alloc] init];
  [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    [offsetIndexSet addIndex:idx + offset];
  }];
  NSIndexSet *finalIndexSet = [[NSIndexSet alloc] initWithIndexSet:offsetIndexSet];
  [invocation retainArguments]; // the way we init the index set means no autorelease
  [invocation setArgument:&finalIndexSet atIndex:actualIndex];
}
@end

#pragma mark mapping classes

@interface GCMArgumentOffsetMapping : NSObject
@property (nonatomic, assign, readonly) NSInteger argIndex;
@property (nonatomic, strong, readonly) Class<GCMArgumentOffsetter> offsetter;
+ (GCMArgumentOffsetMapping *)forArg:(NSInteger)arg offsetter:(Class<GCMArgumentOffsetter>)offsetter;
- (id)initWithIndex:(NSInteger)argIndex andOffsetter:(Class<GCMArgumentOffsetter>)offsetter;
- (void)applyOffset:(NSInteger)offset toInvocation:(NSInvocation *)invocation;
@end

@implementation GCMArgumentOffsetMapping
+ ( GCMArgumentOffsetMapping *)forArg:(NSInteger)arg offsetter:(Class<GCMArgumentOffsetter>)offsetter {
  return [[GCMArgumentOffsetMapping alloc] initWithIndex:arg andOffsetter:offsetter];
}

-(id)initWithIndex:(NSInteger)argIndex andOffsetter:(Class<GCMArgumentOffsetter>)offsetter {
  self = [super init];
  if (self) {
    _argIndex = argIndex;
    _offsetter = offsetter;
  }
  return self;
}

- (void)applyOffset:(NSInteger)offset toInvocation:(NSInvocation *)invocation {
  [self.offsetter applyOffset:offset toArgument:self.argIndex onInvocation:invocation];
}
@end

@interface GCMReturnValueOffsetMapping : NSObject
@property (nonatomic, strong, readonly) Class<GCMReturnValueOffsetter> offsetter;

+ (GCMReturnValueOffsetMapping *)forOffsetter:(Class<GCMReturnValueOffsetter>)offsetter;
- (id)initWithOffsetter:(Class<GCMReturnValueOffsetter>)offsetter;
- (void)applyOffset:(NSInteger)offset toInvocation:(NSInvocation *)invocation;
@end

@implementation GCMReturnValueOffsetMapping
+ (GCMReturnValueOffsetMapping *)forOffsetter:(Class<GCMReturnValueOffsetter>)offsetter {
  return [[GCMReturnValueOffsetMapping alloc] initWithOffsetter:offsetter];
}

- (id)initWithOffsetter:(Class<GCMReturnValueOffsetter>)offsetter {
  self = [super init];
  if (self) {
    _offsetter = offsetter;
  }
  return self;
}

- (void)applyOffset:(NSInteger)offset toInvocation:(NSInvocation *)invocation {
  [self.offsetter applyOffset:offset toReturnValueOnInvocation:invocation];
}
@end

#pragma mark wrapper

@interface GCMAggregatedTableViewWrapper  ()
@property (nonatomic, strong) UITableView *innerTableView;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong) NSDictionary *mappings;
@property (nonatomic, strong) NSDictionary *returnMappings;
@end

@implementation GCMAggregatedTableViewWrapper

+ (id)wrapper {
  return [[GCMAggregatedTableViewWrapper alloc] init];
}

- (id)init {
  self = [super init];
  if (self) {
    _mappings = @{
      @"cellForRowAtIndexPath:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIndexPathOffsetter class]]],
      @"deleteRowsAtIndexPaths:withRowAnimation:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIndexPathArrayOffsetter class]]],
      @"headerViewForSection:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIntegerOffsetter class]]],
      @"deleteSections:withRowAnimation:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIndexSetOffsetter class]]],
      @"dequeueReusableCellWithIdentifier:forIndexPath:": @[
          [GCMArgumentOffsetMapping forArg:1 offsetter:[GCMIndexPathOffsetter class]]],
      @"deselectRowAtIndexPath:animated:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIndexPathOffsetter class]]],
      @"footerViewForSection:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIntegerOffsetter class]]],
      @"headerViewForSection:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIntegerOffsetter class]]],
      @"insertRowsAtIndexPaths:withRowAnimation:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIndexPathOffsetter class]]],
      @"insertSections:withRowAnimation:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIndexSetOffsetter class]]],
      @"moveRowAtIndexPath:toIndexPath:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIndexPathOffsetter class]],
          [GCMArgumentOffsetMapping forArg:1 offsetter:[GCMIndexPathOffsetter class]]],
      @"moveSection:toSection:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIntegerOffsetter class]],
          [GCMArgumentOffsetMapping forArg:1 offsetter:[GCMIntegerOffsetter class]]],
      @"numberOfRowsInSection:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIntegerOffsetter class]]],
      @"rectForFooterInSection:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIntegerOffsetter class]]],
      @"rectForHeaderInSection:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIntegerOffsetter class]]],
      @"rectForRowAtIndexPath:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIndexPathOffsetter class]]],
      @"rectForSection:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIntegerOffsetter class]]],
      @"reloadRowsAtIndexPaths:withRowAnimation:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIndexPathArrayOffsetter class]]],
      @"reloadSections:withRowAnimation:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIndexSetOffsetter class]]],
      @"scrollToRowAtIndexPath:atScrollPosition:animated:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIndexPathOffsetter class]]],
      @"selectRowAtIndexPath:animated:scrollPosition:": @[
          [GCMArgumentOffsetMapping forArg:0 offsetter:[GCMIndexPathOffsetter class]]]
      };
    
    _returnMappings = @{
      @"indexPathForCell:": [GCMReturnValueOffsetMapping forOffsetter:[GCMIndexPathOffsetter class]],
      @"indexPathForRowAtPoint:": [GCMReturnValueOffsetMapping forOffsetter:[GCMIndexPathOffsetter class]],
      @"indexPathForSelectedRow:": [GCMReturnValueOffsetMapping forOffsetter:[GCMIndexPathOffsetter class]],
      @"indexPathsForRowsInRect:": [GCMReturnValueOffsetMapping forOffsetter:[GCMIndexPathArrayOffsetter class]],
      @"indexPathsForSelectedRows:": [GCMReturnValueOffsetMapping forOffsetter:[GCMIndexPathArrayOffsetter class]],
      @"indexPathsForVisibleRows:": [GCMReturnValueOffsetMapping forOffsetter:[GCMIndexPathArrayOffsetter class]]
      };
  }
  return self;
}

- (BOOL)isKindOfClass:(Class)aClass {
  return aClass == [UITableView class];
}

- (BOOL)isMemberOfClass:(Class)aClass {
  return [self isKindOfClass:aClass];
}

- (void)configureWithTableView:(UITableView *)tableView andOffset:(NSInteger)offset {
  self.innerTableView = tableView;
  self.offset = offset;
}

- (NSUInteger)hash {
  return [self.innerTableView hash];
}

- (BOOL)isEqual:(id)object {
  return [self.innerTableView isEqual:object];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
  return [self.innerTableView respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  return [self.innerTableView methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
  NSString *selectorString = NSStringFromSelector(anInvocation.selector);
  
  // perform any offsetting of arguments
  if (self.mappings[selectorString]) {
    for ( GCMArgumentOffsetMapping *mapping in self.mappings[selectorString]) {
      [mapping applyOffset:self.offset toInvocation:anInvocation];
    }
  }

  // forward the invocation
  [anInvocation invokeWithTarget:self.innerTableView];
  
  // offset the return value if appropriate
  if (self.returnMappings[selectorString]) {
    [self.returnMappings[selectorString] applyOffset:self.offset
                                        toInvocation:anInvocation];
  }
}

@end
