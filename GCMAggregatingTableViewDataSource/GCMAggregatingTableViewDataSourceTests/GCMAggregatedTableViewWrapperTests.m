//
//  GCMAggregatedTableViewWrapperTests.m
//  GameChanger
//
//  Created by Tom Leach on 2/12/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import <Kiwi.h>
#import "GCMAggregatedTableViewWrapper.h"


SPEC_BEGIN(GCMAggregatedTableViewWrapperTests)

describe(@"GCMAggregatedTableViewWrapper", ^{
  __block GCMAggregatedTableViewWrapper *wrapper;
  __block UITableView *tableView;
  __block UITableView *innerTableView;
  beforeEach(^{
    wrapper = [GCMAggregatedTableViewWrapper wrapper];
    tableView = (UITableView *)wrapper;
    innerTableView = [UITableView mock];
    [wrapper configureWithTableView:innerTableView andOffset:2];
  });
  it(@"offsets index path arguments", ^{
    [[innerTableView should] receive:@selector(cellForRowAtIndexPath:)
                           andReturn:[UITableViewCell mock]
                       withArguments:[NSIndexPath indexPathForItem:6 inSection:3]];
    [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:6 inSection:1]];
  });
  it(@"offsets index path return values", ^{
    UITableViewCell *cell = [UITableViewCell mock];
    [[innerTableView should] receive:@selector(indexPathForCell:)
                           andReturn:[NSIndexPath indexPathForItem:3 inSection:4]
                       withArguments:cell];
    [[[tableView indexPathForCell:cell] should] equal:[NSIndexPath indexPathForItem:3 inSection:2]];
  });
  it(@"offsets section integer arguments", ^{
    [[innerTableView should] receive:@selector(headerViewForSection:)
                           andReturn:[UITableViewHeaderFooterView mock]
                       withArguments:theValue(4)];
    [tableView headerViewForSection:2];
  });
  it(@"offsets index path array arguments", ^{
    NSArray *indexPaths = @[[NSIndexPath indexPathForItem:6 inSection:3],
                            [NSIndexPath indexPathForItem:3 inSection:4]];
    NSArray *expectedIndexPaths = @[[NSIndexPath indexPathForItem:6 inSection:5],
                                    [NSIndexPath indexPathForItem:3 inSection:6]];
    [[innerTableView should] receive:@selector(deleteRowsAtIndexPaths:withRowAnimation:)
                       withArguments:expectedIndexPaths,theValue(UITableViewRowAnimationBottom)];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
  });
  it(@"offsets index set arguments", ^{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:2];
    NSIndexSet *expectedIndexSet = [NSIndexSet indexSetWithIndex:4];
    [[innerTableView should] receive:@selector(deleteSections:withRowAnimation:)
                       withArguments:expectedIndexSet,theValue(UITableViewRowAnimationBottom)];
    [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationBottom];
  });
});

SPEC_END
