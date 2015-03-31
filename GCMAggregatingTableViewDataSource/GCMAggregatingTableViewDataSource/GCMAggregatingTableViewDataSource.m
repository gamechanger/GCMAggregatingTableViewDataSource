//
//  GCMAggregatingTableViewDataSource.m
//  GameChanger
//
//  Created by Tom Leach on 2/12/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import "GCMAggregatingTableViewDataSource.h"
#import "GCMAggregatedTableViewWrapper.h"

static NSString *const kGCTableViewMapDataSourceKey = @"dataSourceKey";
static NSString *const kGCTableViewMapIndexKey = @"indexKey";

@interface GCMAggregatingTableViewDataSource ()
@property (nonatomic, strong) GCMAggregatedTableViewWrapper *tableViewWrapper;
@property (nonatomic, strong) NSMutableOrderedSet *childDataSources;
@property (nonatomic, strong) NSMapTable *tableViewMap;
@end

@implementation GCMAggregatingTableViewDataSource

#pragma mark property getters

- (NSMutableOrderedSet *)childDataSources {
  if (!_childDataSources) {
    _childDataSources = [[NSMutableOrderedSet alloc] init];
  }
  return _childDataSources;
}

- (GCMAggregatedTableViewWrapper *)tableViewWrapper {
  if (!_tableViewWrapper) {
    _tableViewWrapper = [GCMAggregatedTableViewWrapper wrapper];
  }
  return _tableViewWrapper;
}

- (NSMapTable *)tableViewMap {
  if ( ! _tableViewMap ) {
    _tableViewMap = [NSMapTable mapTableWithKeyOptions:NSMapTableObjectPointerPersonality
                                          valueOptions:NSMapTableObjectPointerPersonality];
  }
  return _tableViewMap;
}

#pragma mark wrapping

- (id)wrapTableView:(UITableView *)tableView forOffset:(NSInteger)offset {
  [self.tableViewWrapper configureWithTableView:tableView andOffset:offset];
  return self.tableViewWrapper;
}

#pragma mark child registration

- (void)addChildDataSource:(id<UITableViewDataSource>)childDataSource {
  [self.childDataSources addObject:childDataSource];
}

- (void)addChildDataSource:(id<UITableViewDataSource>)childDataSource afterDataSource:(id<UITableViewDataSource>)precedingDataSource{
  if ([self.childDataSources containsObject:precedingDataSource]) {
    NSInteger index = [self.childDataSources indexOfObject:precedingDataSource];
    [self.childDataSources insertObject:childDataSource atIndex:index + 1];
  }
}

- (void)removeChildDataSource:(id<UITableViewDataSource>)childDataSource {
  if ([self.childDataSources containsObject:childDataSource]) {
    [self.childDataSources removeObject:childDataSource];
  }
}

#pragma mark child datasource offset helpers

// TODO: Can other offset helper methods use this on this?
- (void)withDataSourcesForTableView:(UITableView *)tableView
                       performBlock:(void (^)(UITableView *wrappedTableView,
                                              id<UITableViewDataSource> childDataSource))block {
  NSInteger offset = 0;
  for (id<UITableViewDataSource> childDataSource in self.childDataSources) {
    block([self wrapTableView:tableView forOffset:offset], childDataSource);
    offset += [childDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] ?
    [childDataSource numberOfSectionsInTableView:tableView] : 1;
  }
}

/*
 Locates the appropriate child datasource for the given section and passes it
 and the relative section index to the given block.
 */
- (id)withDataSourceForTableView:(UITableView *)tableView
                         section:(NSInteger)section
                    performBlock:(id (^)(UITableView *wrappedTableView,
                                         id<UITableViewDataSource> childDataSource,
                                         NSInteger relativeSection))block {
  if ( section == NSNotFound ) {
    return nil;
  }
  NSInteger offset = 0;
  for (id<UITableViewDataSource> childDataSource in self.childDataSources) {
    NSInteger dataSourceSectionCount = [childDataSource
                                        respondsToSelector:@selector(numberOfSectionsInTableView:)] ? [childDataSource numberOfSectionsInTableView:tableView] : 1;
    if (section - offset < dataSourceSectionCount) {
      return block([self wrapTableView:tableView forOffset:offset],
                   childDataSource,
                   section - offset);
    }
    offset += dataSourceSectionCount;
  }
  @throw [NSException exceptionWithName:@"OutOfRange"
                                 reason:@"Requested section does not exist"
                               userInfo:nil];
}

- (id)withDataSourceForTableView:(UITableView *)tableView
                       indexPath:(NSIndexPath *)indexPath
                    performBlock:(id (^)(UITableView *wrappedTableView,
                                         id<UITableViewDataSource> childDataSource,
                                         NSIndexPath *relativeIndexPath))block {
  return [self withDataSourceForTableView:tableView
                                  section:indexPath.section
                             performBlock:^id(UITableView *wrappedTableView,
                                              id<UITableViewDataSource> childDataSource,
                                              NSInteger relativeSection) {
                               return block(wrappedTableView,
                                            childDataSource,
                                            [NSIndexPath indexPathForItem:indexPath.
                                             item inSection:relativeSection]);
                             }];
}

#pragma mark selector response handling

- (BOOL)allChildrenRespondToSelector:(SEL)aSelector {
  for (id<UITableViewDelegate> childDelegate in self.childDataSources) {
    if (![childDelegate respondsToSelector:aSelector]) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
  if (aSelector == @selector(tableView:heightForRowAtIndexPath:) ||
      aSelector == @selector(tableView:titleForHeaderInSection:) ||
      aSelector == @selector(tableView:titleForFooterInSection:) ||
      aSelector == @selector(tableView:viewForHeaderInSection:) ||
      aSelector == @selector(tableView:heightForHeaderInSection:) ||
      aSelector == @selector(tableView:viewForFooterInSection:) ||
      aSelector == @selector(tableView:heightForFooterInSection:) ||
      aSelector == @selector(tableView:estimatedHeightForHeaderInSection:) ||
      aSelector == @selector(tableView:estimatedHeightForFooterInSection:) ||
      aSelector == @selector(tableView:estimatedHeightForRowAtIndexPath:)) {
    return [self allChildrenRespondToSelector:aSelector];
  }
  return [super respondsToSelector:aSelector];
}


#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self withDataSourceForTableView:tableView
                                indexPath:indexPath
                             performBlock:^id(UITableView *wrappedTableView,
                                              id<UITableViewDataSource> childDataSource,
                                              NSIndexPath *relativeIndexPath) {
                               return [childDataSource tableView:wrappedTableView
                                           cellForRowAtIndexPath:relativeIndexPath];
                             }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSNumber *sum = [self withDataSourceForTableView:tableView
                                           section:section
                                      performBlock:^id(UITableView *wrappedTableView,
                                                       id<UITableViewDataSource> childDataSource,
                                                       NSInteger relativeSection) {
                                        return [NSNumber numberWithInteger:
                                                [childDataSource tableView:wrappedTableView
                                                     numberOfRowsInSection:relativeSection]];
                                      }];
  return sum.integerValue;
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  __block NSInteger sum = 0;
  [self withDataSourcesForTableView:tableView
                       performBlock:^(UITableView *wrappedTableView,
                                      id<UITableViewDataSource> childDataSource) {
                         if ([childDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
                           sum += [childDataSource numberOfSectionsInTableView:wrappedTableView];
                         } else {
                           sum++;
                         }
                       }];
  return sum;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  NSMutableArray *all = [[NSMutableArray alloc] init];
  [self withDataSourcesForTableView:tableView
                       performBlock:^(UITableView *wrappedTableView,
                                      id<UITableViewDataSource> childDataSource) {
                         if ([childDataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
                           [all addObjectsFromArray:[childDataSource sectionIndexTitlesForTableView:wrappedTableView]];
                         }
                       }];
  return [NSArray arrayWithArray:all];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  NSInteger titleOffset = 0;
  NSInteger sectionOffset = 0;
  for (id<UITableViewDataSource> childDataSource in self.childDataSources) {
    UITableView *wrappedTableView = [self wrapTableView:tableView forOffset:sectionOffset];
    NSArray *indexTitles = [childDataSource sectionIndexTitlesForTableView:wrappedTableView];
    if (titleOffset + indexTitles.count > index) {
      NSInteger relativeSection = [childDataSource tableView:wrappedTableView
                                 sectionForSectionIndexTitle:title
                                                     atIndex:index - titleOffset];
      return relativeSection + sectionOffset;
    } else {
      titleOffset += indexTitles.count;
      sectionOffset += [childDataSource numberOfSectionsInTableView:wrappedTableView];
    }
  }
  @throw [NSException exceptionWithName:@"OutOfRange"
                                 reason:@"Requested index title does not exist"
                               userInfo:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
  return [self withDataSourceForTableView:tableView
                                  section:section
                             performBlock:^id(UITableView *wrappedTableView,
                                              id<UITableViewDataSource> childDataSource,
                                              NSInteger relativeSection) {
                               if ([childDataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
                                 return [childDataSource tableView:wrappedTableView
                                           titleForFooterInSection:relativeSection];
                               }
                               return nil;
                             }];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [self withDataSourceForTableView:tableView
                                  section:section
                             performBlock:^id(UITableView *wrappedTableView,
                                              id<UITableViewDataSource> childDataSource,
                                              NSInteger relativeSection) {
                               if ([childDataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
                                 return [childDataSource tableView:wrappedTableView
                                           titleForHeaderInSection:relativeSection];
                               }
                               return nil;
                             }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  NSNumber *result = [self withDataSourceForTableView:tableView
                                            indexPath:indexPath
                                         performBlock:^id(UITableView *wrappedTableView,
                                                          id<UITableViewDataSource> childDataSource,
                                                          NSIndexPath *relativeIndexPath) {
                                           if ([childDataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
                                             return [NSNumber numberWithBool:
                                                     [childDataSource tableView:wrappedTableView
                                                          canEditRowAtIndexPath:relativeIndexPath]];
                                           }
                                           return NO;
                                         }];
  return result.boolValue;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  [self withDataSourceForTableView:tableView
                         indexPath:indexPath
                      performBlock:^id(UITableView *wrappedTableView,
                                       id<UITableViewDataSource> childDataSource,
                                       NSIndexPath *relativeIndexPath) {
                        [childDataSource tableView:wrappedTableView
                                commitEditingStyle:editingStyle
                                 forRowAtIndexPath:relativeIndexPath];
                        return nil;
                      }];
}

#pragma mark child delegate offset helpers

- (id)withDelegateForTableView:(UITableView *)tableView
                       section:(NSInteger)section
                  performBlock:(id (^)(UITableView *wrappedTableView,
                                       id<UITableViewDelegate> childDelegate,
                                       NSInteger relativeSection))block {
  return [self withDataSourceForTableView:tableView
                                  section:section
                             performBlock:^id(UITableView *wrappedTableView,
                                              id<UITableViewDataSource> childDataSource,
                                              NSInteger relativeSection) {
                               if ([childDataSource conformsToProtocol:@protocol(UITableViewDelegate)]) {
                                 return block(wrappedTableView,
                                              (id<UITableViewDelegate>)childDataSource,
                                              relativeSection);
                               }
                               return nil;
                             }];
}

- (id)withDelegateForTableView:(UITableView *)tableView
                     indexPath:(NSIndexPath *)indexPath
                  performBlock:(id (^)(UITableView *wrappedTableView,
                                       id<UITableViewDelegate> childDelegate,
                                       NSIndexPath *relativeIndexPath))block {
  return [self withDelegateForTableView:tableView
                                section:indexPath.section
                           performBlock:^id(UITableView *wrappedTableView,
                                            id<UITableViewDelegate> childDelegate,
                                            NSInteger relativeSection) {
                             return block(wrappedTableView,
                                          childDelegate,
                                          [NSIndexPath indexPathForItem:indexPath.item
                                                              inSection:relativeSection]);
                           }];
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  [self withDelegateForTableView:tableView
                       indexPath:indexPath
                    performBlock:^id(UITableView *wrappedTableView,
                                     id<UITableViewDelegate> childDelegate,
                                     NSIndexPath *relativeIndexPath) {
                      if ([childDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]) {
                        [childDelegate tableView:wrappedTableView
        accessoryButtonTappedForRowWithIndexPath:relativeIndexPath];
                      }
                      return nil;
                    }];
}

- (BOOL)tableView:(UITableView *)tableView
 canPerformAction:(SEL)action
forRowAtIndexPath:(NSIndexPath *)indexPath
       withSender:(id)sender {
  NSNumber *result = [self withDelegateForTableView:tableView
                                          indexPath:indexPath
                                       performBlock:^id(UITableView *wrappedTableView,
                                                        id<UITableViewDelegate> childDelegate,
                                                        NSIndexPath *relativeIndexPath) {
                                         if ([childDelegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)]) {
                                           return [NSNumber numberWithBool:[childDelegate tableView:wrappedTableView canPerformAction:action forRowAtIndexPath:relativeIndexPath withSender:sender]];
                                         }
                                         return @NO;
                                       }];
  return result.boolValue;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self withDelegateForTableView:tableView
                       indexPath:indexPath
                    performBlock:^id(UITableView *wrappedTableView,
                                     id<UITableViewDelegate> childDelegate,
                                     NSIndexPath *relativeIndexPath) {
                      if ([childDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
                        [childDelegate tableView:wrappedTableView
                       didDeselectRowAtIndexPath:relativeIndexPath];
                      }
                      return nil;
                    }];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  id<UITableViewDataSource, UITableViewDelegate> childDataSource = [self.tableViewMap objectForKey:cell][kGCTableViewMapDataSourceKey];
  if ( ! childDataSource ) {
    NSLog(@"No entry for cell in table view map");
  }
  NSIndexPath *ip = [self.tableViewMap objectForKey:cell][kGCTableViewMapIndexKey];
  if ( [childDataSource respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)] ) {
    [childDataSource tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:ip];
  }
  [self.tableViewMap removeObjectForKey:cell];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
  id<UITableViewDataSource, UITableViewDelegate> childDataSource = [self.tableViewMap objectForKey:view][kGCTableViewMapDataSourceKey];
  if ( ! childDataSource ) {
    NSLog(@"No entry for view in table view map");
  }
  NSInteger relativeSection = [[self.tableViewMap objectForKey:view][kGCTableViewMapIndexKey] integerValue];
  if ( [childDataSource respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)] ) {
    [childDataSource tableView:tableView didEndDisplayingFooterView:view forSection:relativeSection];
  }
  [self.tableViewMap removeObjectForKey:view];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
  id<UITableViewDataSource, UITableViewDelegate> childDataSource = [self.tableViewMap objectForKey:view][kGCTableViewMapDataSourceKey];
  if ( ! childDataSource ) {
    NSLog(@"No entry for view in table view map");
  }
  NSInteger relativeSection = [[self.tableViewMap objectForKey:view][kGCTableViewMapIndexKey] integerValue];
  if ( [childDataSource respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)] ) {
    [childDataSource tableView:tableView didEndDisplayingHeaderView:view forSection:relativeSection];
  }
  [self.tableViewMap removeObjectForKey:view];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
  [self withDelegateForTableView:tableView
                       indexPath:indexPath
                    performBlock:^id(UITableView *wrappedTableView,
                                     id<UITableViewDelegate> childDelegate,
                                     NSIndexPath *relativeIndexPath) {
                      if ([childDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]) {
                        [childDelegate tableView:wrappedTableView
                     didEndEditingRowAtIndexPath:relativeIndexPath];
                      }
                      return nil;
                    }];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  [self withDelegateForTableView:tableView
                       indexPath:indexPath
                    performBlock:^id(UITableView *wrappedTableView,
                                     id<UITableViewDelegate> childDelegate,
                                     NSIndexPath *relativeIndexPath) {
                      if ([childDelegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)]) {
                        [childDelegate tableView:wrappedTableView
                      didHighlightRowAtIndexPath:relativeIndexPath];
                      }
                      return nil;
                    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self withDelegateForTableView:tableView
                       indexPath:indexPath
                    performBlock:^id(UITableView *wrappedTableView,
                                     id<UITableViewDelegate> childDelegate,
                                     NSIndexPath *relativeIndexPath) {
                      if ([childDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
                        [childDelegate tableView:wrappedTableView
                         didSelectRowAtIndexPath:relativeIndexPath];
                      }
                      return nil;
                    }];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  [self withDelegateForTableView:tableView
                       indexPath:indexPath
                    performBlock:^id(UITableView *wrappedTableView,
                                     id<UITableViewDelegate> childDelegate,
                                     NSIndexPath *relativeIndexPath) {
                      if ([childDelegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)]) {
                        [childDelegate tableView:wrappedTableView didUnhighlightRowAtIndexPath:relativeIndexPath];
                      }
                      return nil;
                    }];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSNumber *result = [self withDelegateForTableView:tableView indexPath:indexPath performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSIndexPath *relativeIndexPath) {
    if ([childDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
      return [NSNumber numberWithInteger:[childDelegate tableView:wrappedTableView editingStyleForRowAtIndexPath:relativeIndexPath]];
    }
    return [NSNumber numberWithInteger:UITableViewCellEditingStyleNone];
  }];
  return result.integerValue;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
  NSNumber *result = [self withDelegateForTableView:tableView section:section performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSInteger relativeSection) {
    if ([childDelegate respondsToSelector:@selector(tableView:estimatedHeightForFooterInSection:)]) {
      return [NSNumber numberWithFloat:[childDelegate tableView:wrappedTableView estimatedHeightForFooterInSection:relativeSection]];
    }
    return [NSNumber numberWithFloat:UITableViewAutomaticDimension];
  }];
  return result.floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
  NSNumber *result = [self withDelegateForTableView:tableView section:section performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSInteger relativeSection) {
    if ([childDelegate respondsToSelector:@selector(tableView:estimatedHeightForHeaderInSection:)]) {
      return [NSNumber numberWithFloat:[childDelegate tableView:wrappedTableView estimatedHeightForHeaderInSection:relativeSection]];
    }
    return [NSNumber numberWithFloat:UITableViewAutomaticDimension];
  }];
  return result.floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSNumber *result = [self withDelegateForTableView:tableView indexPath:indexPath performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSIndexPath *relativeIndexPath) {
    if ([childDelegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)]) {
      return [NSNumber numberWithFloat:[childDelegate tableView:wrappedTableView estimatedHeightForRowAtIndexPath:relativeIndexPath]];
    }
    return [NSNumber numberWithFloat:UITableViewAutomaticDimension];
  }];
  return result.floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  NSNumber *result = [self withDelegateForTableView:tableView section:section performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSInteger relativeSection) {
    if ([childDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
      return [NSNumber numberWithFloat:[childDelegate tableView:wrappedTableView heightForFooterInSection:relativeSection]];
    }
    return [NSNumber numberWithFloat:UITableViewAutomaticDimension];
  }];
  return result.floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  NSNumber *result = [self withDelegateForTableView:tableView section:section performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSInteger relativeSection) {
    if ([childDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
      return [NSNumber numberWithFloat:[childDelegate tableView:wrappedTableView heightForHeaderInSection:relativeSection]];
    }
    return [NSNumber numberWithFloat:UITableViewAutomaticDimension];
  }];
  return result.floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSNumber *result = [self withDelegateForTableView:tableView
                                          indexPath:indexPath
                                       performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate,
                                                        NSIndexPath *relativeIndexPath) {
                                         return [NSNumber numberWithFloat:
                                                 [childDelegate tableView:wrappedTableView
                                                  heightForRowAtIndexPath:relativeIndexPath]];
                                       }];
  return result.floatValue;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSNumber *result = [self withDelegateForTableView:tableView indexPath:indexPath performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSIndexPath *relativeIndexPath) {
    if ([childDelegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)]) {
      return [NSNumber numberWithInteger:[childDelegate tableView:wrappedTableView indentationLevelForRowAtIndexPath:relativeIndexPath]];
    }
    return nil;
  }];
  return result.integerValue;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  NSNumber *result = [self withDelegateForTableView:tableView indexPath:indexPath performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSIndexPath *relativeIndexPath) {
    if ([childDelegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)]) {
      return [NSNumber numberWithBool:[childDelegate tableView:wrappedTableView shouldHighlightRowAtIndexPath:relativeIndexPath]];
    }
    return @YES;
  }];
  return result.boolValue;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
  NSNumber *result = [self withDelegateForTableView:tableView indexPath:indexPath performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSIndexPath *relativeIndexPath) {
    if ([childDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]) {
      return [NSNumber numberWithBool:[childDelegate tableView:wrappedTableView shouldIndentWhileEditingRowAtIndexPath:relativeIndexPath]];
    }
    return @YES;
  }];
  return result.boolValue;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSNumber *result = [self withDelegateForTableView:tableView indexPath:indexPath performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSIndexPath *relativeIndexPath) {
    if ([childDelegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)]) {
      return [NSNumber numberWithBool:[childDelegate tableView:wrappedTableView shouldShowMenuForRowAtIndexPath:relativeIndexPath]];
    }
    return @NO;
  }];
  return result.boolValue;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
  [self withDelegateForTableView:tableView indexPath:indexPath performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSIndexPath *relativeIndexPath) {
    if ([childDelegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)]) {
      [childDelegate tableView:wrappedTableView performAction:action forRowAtIndexPath:relativeIndexPath withSender:sender];
    }
    return nil;
  }];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self withDelegateForTableView:tableView indexPath:indexPath performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSIndexPath *relativeIndexPath) {
    if ([childDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
      return [childDelegate tableView:wrappedTableView titleForDeleteConfirmationButtonForRowAtIndexPath:relativeIndexPath];
    }
    return nil;
  }];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  return [self withDelegateForTableView:tableView section:section performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSInteger relativeSection) {
    if ([childDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
      return [childDelegate tableView:wrappedTableView viewForFooterInSection:relativeSection];
    }
    return nil;
  }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  return [self withDelegateForTableView:tableView section:section performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSInteger relativeSection) {
    if ([childDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
      return [childDelegate tableView:wrappedTableView viewForHeaderInSection:relativeSection];
    }
    return nil;
  }];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
  [self withDelegateForTableView:tableView indexPath:indexPath performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSIndexPath *relativeIndexPath) {
    if ([childDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)]) {
      [childDelegate tableView:wrappedTableView willBeginEditingRowAtIndexPath:relativeIndexPath];
    }
    return nil;
  }];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self withDelegateForTableView:tableView indexPath:indexPath performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSIndexPath *relativeIndexPath) {
    if ([childDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
      NSIndexPath *retPath = [childDelegate tableView:wrappedTableView
                           willDeselectRowAtIndexPath:relativeIndexPath];
      return [NSIndexPath indexPathForItem:retPath.item
                                 inSection:retPath.section + (indexPath.section - relativeIndexPath.section)];
    }
    return indexPath;
  }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  __weak GCMAggregatingTableViewDataSource *wSelf = self;
  [self withDelegateForTableView:tableView indexPath:indexPath performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSIndexPath *relativeIndexPath) {
    [wSelf.tableViewMap setObject:@{kGCTableViewMapDataSourceKey : childDelegate,
                                    kGCTableViewMapIndexKey : relativeIndexPath}
                           forKey:cell];
    
    if ([childDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
      [childDelegate tableView:wrappedTableView willDisplayCell:cell forRowAtIndexPath:relativeIndexPath];
    }
    return nil;
  }];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
  __weak GCMAggregatingTableViewDataSource *wSelf = self;
  [self withDelegateForTableView:tableView section:section performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSInteger relativeSection) {
    [wSelf.tableViewMap setObject:@{kGCTableViewMapDataSourceKey : childDelegate,
                                    kGCTableViewMapIndexKey : @(relativeSection)}
                           forKey:view];
    if ([childDelegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]) {
      [childDelegate tableView:wrappedTableView willDisplayFooterView:view forSection:relativeSection];
    }
    return nil;
  }];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
  __weak GCMAggregatingTableViewDataSource *wSelf = self;
  [self withDelegateForTableView:tableView section:section performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSInteger relativeSection) {
    [wSelf.tableViewMap setObject:@{kGCTableViewMapDataSourceKey : childDelegate,
                                    kGCTableViewMapIndexKey : @(relativeSection)}
                           forKey:view];
    if ([childDelegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
      [childDelegate tableView:wrappedTableView willDisplayHeaderView:view forSection:relativeSection];
    }
    return nil;
  }];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self withDelegateForTableView:tableView indexPath:indexPath performBlock:^id(UITableView *wrappedTableView, id<UITableViewDelegate> childDelegate, NSIndexPath *relativeIndexPath) {
    if ([childDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
      NSIndexPath *retPath = [childDelegate tableView:wrappedTableView
                             willSelectRowAtIndexPath:relativeIndexPath];
      if ( ! retPath ) {
        return nil;
      }
      return [NSIndexPath indexPathForItem:retPath.item
                                 inSection:retPath.section + (indexPath.section - relativeIndexPath.section)];
    }
    return indexPath;
  }];
}


@end
