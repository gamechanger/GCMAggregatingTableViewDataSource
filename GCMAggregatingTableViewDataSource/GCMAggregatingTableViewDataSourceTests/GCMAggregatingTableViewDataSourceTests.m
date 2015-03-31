//
//  GCMAggregatingTableViewDataSourceTests.m
//  GameChanger
//
//  Created by Tom Leach on 2/12/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import <Kiwi.h>
#import "GCMAggregatingTableViewDataSource.h"

// Lets us create mocks which implement both protocols
@protocol UITableViewDataSourceAndDelegate <UITableViewDataSource, UITableViewDelegate>
@end


// Fakes out a data source which only implements the required methods of UITableViewDataSource
@interface GCMinimalDataSource : NSObject <UITableViewDataSourceAndDelegate>
@end
@implementation GCMinimalDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}
@end

SPEC_BEGIN(GCMAggregatingTableViewDataSourceTests)

describe(@"GCMAggregatingTableViewDataSource", ^{
  __block GCMAggregatingTableViewDataSource *aggregatingDataSource;
  __block UITableView *tableView;
  beforeEach(^{
    aggregatingDataSource = [[GCMAggregatingTableViewDataSource alloc] init];
    tableView = [UITableView mock];
  });
  it(@"conforms to UITableViewDataSource", ^{
    [[aggregatingDataSource should] conformToProtocol:@protocol(UITableViewDataSource)];
  });
  it(@"conforms to UITableViewDelegate", ^{
    [[aggregatingDataSource should] conformToProtocol:@protocol(UITableViewDelegate)];
  });
  it(@"doesn't support moving cells", ^{
    [[aggregatingDataSource shouldNot] respondToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)];
    [[aggregatingDataSource shouldNot] respondToSelector:@selector(tableView:canMoveRowAtIndexPath:)];
    [[aggregatingDataSource shouldNot] respondToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)];
  });
  context(@"empty", ^{
    it(@"reports zero sections", ^{
      [[theValue([aggregatingDataSource numberOfSectionsInTableView:tableView]) should] equal:theValue(0)];
    });
    it(@"raises an exception if numberOfRowsInSection is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView numberOfRowsInSection:0];
      }) should] raise];
    });
    it(@"raises an exception if a cell is requested", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView
                   cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0
                                                             inSection:0]];
      }) should] raise];
    });
    it(@"returns an empty array of section index titles", ^{
      [[[aggregatingDataSource sectionIndexTitlesForTableView:tableView] should] beEmpty];
    });
    it(@"raises an exception if tableView:sectionForSectionIndexTitle:atIndex", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView
             sectionForSectionIndexTitle:@"thing"
                                 atIndex:1];
      }) should] raise];
    });
    it(@"raises an exception if tableView:titleForHeaderInSection: is called", ^{
      theBlock(^{
        [aggregatingDataSource tableView:tableView
                 titleForHeaderInSection:0];
        
      });
    });
    it(@"raises an exception if tableView:titleForFooterInSection: is called", ^{
      theBlock(^{
        [aggregatingDataSource tableView:tableView
                   titleForFooterInSection:0];
        
      });
    });
    it(@"raises an exception if tableView:commitEditingStyle:forRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView
                      commitEditingStyle:UITableViewCellEditingStyleDelete
                       forRowAtIndexPath:[NSIndexPath indexPathForItem:0
                                                             inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:canEditRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView
                   canEditRowAtIndexPath:[NSIndexPath indexPathForItem:0
                                                             inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:canEditRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView
                   canEditRowAtIndexPath:[NSIndexPath indexPathForItem:0
                                                             inSection:0]];
      }) should] raise];
    });
    
    
    // Delegate
    
    it(@"raises an exception if tableView:heightForRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:estimatedHeightForRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView estimatedHeightForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:indentationLevelForRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:willDisplayCell:forRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView willDisplayCell:[UITableViewCell mock] forRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:accessoryButtonTappedForRowWithIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView accessoryButtonTappedForRowWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:willSelectRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView willSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:didSelectRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:willDeselectRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView willDeselectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:didDeselectRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:viewForHeaderInSection: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView viewForHeaderInSection:0];
      }) should] raise];
    });
    it(@"raises an exception if tableView:viewForFooterInSection: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView viewForFooterInSection:0];
      }) should] raise];
    });
    it(@"raises an exception if tableView:heightForHeaderInSection: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView heightForHeaderInSection:0];
      }) should] raise];
    });
    it(@"raises an exception if tableView:estimatedHeightForHeaderInSection: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView estimatedHeightForHeaderInSection:0];
      }) should] raise];
    });
    it(@"raises an exception if tableView:heightForFooterInSection: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView heightForFooterInSection:0];
      }) should] raise];
    });
    it(@"raises an exception if tableView:estimatedHeightForFooterInSection: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView estimatedHeightForFooterInSection:0];
      }) should] raise];
    });
    it(@"raises an exception if tableView:willDisplayHeaderView:forSection: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView willDisplayHeaderView:[UITableViewHeaderFooterView mock] forSection:0];
      }) should] raise];
    });
    it(@"raises an exception if tableView:willDisplayFooterView:forSection: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView willDisplayFooterView:[UITableViewHeaderFooterView mock] forSection:0];
      }) should] raise];
    });
    it(@"raises an exception if tableView:willBeginEditingRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView willBeginEditingRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:didEndEditingRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView didEndEditingRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:editingStyleForRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView editingStyleForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:shouldIndentWhileEditingRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView shouldIndentWhileEditingRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] toProposedIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:shouldShowMenuForRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView shouldShowMenuForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:canPerformAction:forRowAtIndexPath:withSender: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView
                        canPerformAction:@selector(copy:)
                       forRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                              withSender:nil];
      }) should] raise];
    });
    it(@"raises an exception if tableView:performAction:forRowAtIndexPath:withSender: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView
                           performAction:@selector(copy:)
                       forRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                              withSender:nil];
      }) should] raise];
    });
    it(@"raises an exception if tableView:shouldHighlightRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView shouldHighlightRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:didHighlightRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView
              didHighlightRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
    it(@"raises an exception if tableView:didUnhighlightRowAtIndexPath: is called", ^{
      [[theBlock(^{
        [aggregatingDataSource tableView:tableView didUnhighlightRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
      }) should] raise];
    });
  });
  context(@"has two fully implemented data sources with multiple sections", ^{
    __block id<UITableViewDataSourceAndDelegate> childDataSourceA;
    __block id<UITableViewDataSourceAndDelegate> childDataSourceB;
    __block id childDataSourceObjA;
    __block id childDataSourceObjB;

    
    beforeEach(^{
      childDataSourceA = [KWMock mockForProtocol:@protocol(UITableViewDataSourceAndDelegate)];
      childDataSourceB = [KWMock mockForProtocol:@protocol(UITableViewDataSourceAndDelegate)];
      childDataSourceObjA = childDataSourceA;
      childDataSourceObjB = childDataSourceB;
      [childDataSourceObjA stub:@selector(numberOfSectionsInTableView:)
                      andReturn:theValue(2)];
      [childDataSourceObjA stub:@selector(sectionIndexTitlesForTableView:)
                      andReturn:@[@"apples", @"pears"]];
      [childDataSourceObjB stub:@selector(numberOfSectionsInTableView:)
                      andReturn:theValue(3)];
      [childDataSourceObjB stub:@selector(sectionIndexTitlesForTableView:)
                      andReturn:@[@"bananas", @"mangoes", @"lemons"]];
      [aggregatingDataSource addChildDataSource:childDataSourceA];
      [aggregatingDataSource addChildDataSource:childDataSourceB];
    });
    
    
    it(@"responds to all-or-nothing selectors", ^{
      [[aggregatingDataSource should] respondToSelector:@selector(tableView:heightForRowAtIndexPath:)];
    });
    
    context(@"tableView:heightForRowAtIndexPath:", ^{
      it(@"forwards to the first child", ^{
        [[childDataSourceObjA should] receive:@selector(tableView:heightForRowAtIndexPath:) andReturn:theValue(1.0f) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
        [[aggregatingDataSource should] respondToSelector:@selector(tableView:heightForRowAtIndexPath:)];
        [[theValue([aggregatingDataSource tableView:tableView
                            heightForRowAtIndexPath:[NSIndexPath indexPathForItem:3
                                                                        inSection:1]]) should] equal:theValue(1.0f)];
      });
      it(@"forwards to the second child", ^{
        [[childDataSourceObjB should] receive:@selector(tableView:heightForRowAtIndexPath:) andReturn:theValue(1.0f) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
        [[theValue([aggregatingDataSource tableView:tableView
                            heightForRowAtIndexPath:[NSIndexPath indexPathForItem:3
                                                                        inSection:2]]) should] equal:theValue(1.0f)];
      });
    });

    context(@"and one datasource removed", ^{
      beforeEach(^{
        [aggregatingDataSource removeChildDataSource:childDataSourceB];
      });
      context(@"tableView:numberOfRowsInSection:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:numberOfRowsInSection:)
                                      andReturn:theValue(5)
                                  withArguments:any(),theValue(1)];
          [[theValue([aggregatingDataSource tableView:tableView
                                numberOfRowsInSection:1]) should] equal:theValue(5)];
        });
        it(@"raises if an out of range section is provided", ^{
          [[theBlock(^{
            [aggregatingDataSource tableView:tableView numberOfRowsInSection:2];
          }) should] raise];
        });
      });
      context(@"tableView:cellForRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          UITableViewCell *cell = [UITableViewCell mock];
          [[childDataSourceObjA should] receive:@selector(tableView:cellForRowAtIndexPath:)
                                      andReturn:cell
                                  withArguments:any(),[NSIndexPath indexPathForItem:2
                                                                          inSection:1]];
          [[[aggregatingDataSource tableView:tableView
                       cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2
                                                                 inSection:1]] should] equal:cell];
        });
        it(@"throws an exception if asked for a cell which is out of range", ^{
          [[theBlock(^{
            [aggregatingDataSource tableView:tableView
                       cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2
                                                                 inSection:2]];
          }) should] raise];
          });
        });
    });
      
    context(@"and one datasource inserted into the middle", ^{
        __block id<UITableViewDataSourceAndDelegate> childDataSourceX;
        __block id childDataSourceObjX;
        beforeEach(^{
            childDataSourceX = [[GCMinimalDataSource alloc] init];
            childDataSourceObjX = childDataSourceX;
            [aggregatingDataSource addChildDataSource:childDataSourceX afterDataSource: childDataSourceObjA];
        });
        it(@"does not respond to all-or-nothing selectors", ^{
            [[aggregatingDataSource shouldNot] respondToSelector:@selector(tableView:heightForRowAtIndexPath:)];
        });
        context(@"tableView:numberOfRowsInSection:", ^{
            it(@"forwards to the first child", ^{
                [[childDataSourceObjA should] receive:@selector(tableView:numberOfRowsInSection:)
                                            andReturn:theValue(5)
                                        withArguments:any(),theValue(1)];
                [[theValue([aggregatingDataSource tableView:tableView
                                      numberOfRowsInSection:1]) should] equal:theValue(5)];
            });
            it(@"forwards calls to the second child", ^{
                [[childDataSourceObjX should] receive:@selector(tableView:numberOfRowsInSection:)
                                            andReturn:theValue(10)
                                        withArguments:any(),theValue(0)];
                [[theValue([aggregatingDataSource tableView:tableView
                                      numberOfRowsInSection:2]) should] equal:theValue(10)];
            });
            it(@"forwards calls to the third child", ^{
                [[childDataSourceObjB should] receive:@selector(tableView:numberOfRowsInSection:)
                                            andReturn:theValue(5)
                                        withArguments:any(),theValue(0)];
                [[theValue([aggregatingDataSource tableView:tableView
                                      numberOfRowsInSection:3]) should] equal:theValue(5)];
            });
            it(@"raises if an out of range section is provided", ^{
                [[theBlock(^{
                    [aggregatingDataSource tableView:tableView numberOfRowsInSection:6];
                }) should] raise];
            });
        });
        context(@"tableView:cellForRowAtIndexPath:", ^{
            it(@"forwards to the first child", ^{
                UITableViewCell *cell = [UITableViewCell mock];
                [[childDataSourceObjA should] receive:@selector(tableView:cellForRowAtIndexPath:)
                                            andReturn:cell
                                        withArguments:any(),[NSIndexPath indexPathForItem:2
                                                                                inSection:1]];
                [[[aggregatingDataSource tableView:tableView
                             cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2
                                                                       inSection:1]] should] equal:cell];
            });
            it(@"forwards to the second child", ^{
                UITableViewCell *cell = [UITableViewCell mock];
                [[childDataSourceObjX should] receive:@selector(tableView:cellForRowAtIndexPath:)
                                            andReturn:cell
                                        withArguments:any(),[NSIndexPath indexPathForItem:2
                                                                                inSection:0]];
                [[[aggregatingDataSource tableView:tableView
                             cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2
                                                                       inSection:2]] should] equal:cell];
            });
            it(@"forwards to the third child", ^{
                UITableViewCell *cell = [UITableViewCell mock];
                [[childDataSourceObjB should] receive:@selector(tableView:cellForRowAtIndexPath:)
                                            andReturn:cell
                                        withArguments:any(),[NSIndexPath indexPathForItem:2
                                                                                inSection:0]];
                [[[aggregatingDataSource tableView:tableView
                             cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2
                                                                       inSection:3]] should] equal:cell];
            });
            it(@"throws an exception if asked for a cell which is out of range", ^{
                [[theBlock(^{
                    [aggregatingDataSource tableView:tableView
                               cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2
                                                                         inSection:6]];
                }) should] raise];
            });
        });
    });
    context(@"and one datasource with only required methods implemented", ^{
      __block id<UITableViewDataSourceAndDelegate> childDataSourceC;
      __block id childDataSourceObjC;
      beforeEach(^{
        childDataSourceC = [[GCMinimalDataSource alloc] init];
        childDataSourceObjC = childDataSourceC;
        [aggregatingDataSource addChildDataSource:childDataSourceC];
      });
      it(@"does not respond to all-or-nothing selectors", ^{
        [[aggregatingDataSource shouldNot] respondToSelector:@selector(tableView:heightForRowAtIndexPath:)];
      });
      it(@"reports the number of sections in all children", ^{
        [[theValue([aggregatingDataSource numberOfSectionsInTableView:tableView]) should] equal:theValue(6)];
      });
      context(@"tableView:numberOfRowsInSection:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:numberOfRowsInSection:)
                                      andReturn:theValue(5)
                                  withArguments:any(),theValue(1)];
          [[theValue([aggregatingDataSource tableView:tableView
                                numberOfRowsInSection:1]) should] equal:theValue(5)];
        });
        it(@"forwards calls to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:numberOfRowsInSection:)
                                      andReturn:theValue(10)
                                  withArguments:any(),theValue(0)];
          [[theValue([aggregatingDataSource tableView:tableView
                                numberOfRowsInSection:2]) should] equal:theValue(10)];
        });
        it(@"raises if an out of range section is provided", ^{
          [[theBlock(^{
            [aggregatingDataSource tableView:tableView numberOfRowsInSection:6];
          }) should] raise];
        });
      });
      context(@"tableView:cellForRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          UITableViewCell *cell = [UITableViewCell mock];
          [[childDataSourceObjA should] receive:@selector(tableView:cellForRowAtIndexPath:)
                                      andReturn:cell
                                  withArguments:any(),[NSIndexPath indexPathForItem:2
                                                                          inSection:1]];
          [[[aggregatingDataSource tableView:tableView
                       cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2
                                                                 inSection:1]] should] equal:cell];
        });
        it(@"forwards to the second child", ^{
          UITableViewCell *cell = [UITableViewCell mock];
          [[childDataSourceObjB should] receive:@selector(tableView:cellForRowAtIndexPath:)
                                      andReturn:cell
                                  withArguments:any(),[NSIndexPath indexPathForItem:2
                                                                          inSection:0]];
          [[[aggregatingDataSource tableView:tableView
                       cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2
                                                                 inSection:2]] should] equal:cell];
        });
        it(@"throws an exception if asked for a cell which is out of range", ^{
          [[theBlock(^{
            [aggregatingDataSource tableView:tableView
                       cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2
                                                                 inSection:6]];
          }) should] raise];
        });
      });
      context(@"sectionIndexTitlesForTableView:", ^{
        it(@"aggregates section index titles from all children", ^{
          [[[aggregatingDataSource sectionIndexTitlesForTableView:tableView] should]
           equal:@[@"apples", @"pears", @"bananas", @"mangoes", @"lemons"]];
        });
      });
      context(@"tableView:sectionForSectionIndexTitle:atIndex", ^{
        it(@"forwards to the first child", ^{
          // TODO: We should mock out and check the tableView
          [[childDataSourceObjA should] receive:@selector(tableView:sectionForSectionIndexTitle:atIndex:)
                                      andReturn:theValue(1)
                                  withArguments:any(),@"pears",theValue(1)];
          [[theValue([aggregatingDataSource tableView:tableView
                          sectionForSectionIndexTitle:@"pears"
                                              atIndex:1]) should] equal:theValue(1)];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:sectionForSectionIndexTitle:atIndex:)
                                      andReturn:theValue(0)
                                  withArguments:any(),@"bananas",theValue(0)];
          [[theValue([aggregatingDataSource tableView:tableView
                          sectionForSectionIndexTitle:@"bananas"
                                              atIndex:2]) should] equal:theValue(2)];
        });
      });
      context(@"tableView:titleForFooterInSection", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:titleForFooterInSection:)
                                      andReturn:@"pears"
                                  withArguments:any(),theValue(1)];
          [[[aggregatingDataSource tableView:tableView
                     titleForFooterInSection:1] should] equal:@"pears"];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:titleForFooterInSection:)
                                      andReturn:@"bananas"
                                  withArguments:any(),theValue(0)];
          [[[aggregatingDataSource tableView:tableView
                     titleForFooterInSection:2] should] equal:@"bananas"];
        });
        it(@"returns a default of nil for the third child", ^{
          [[[aggregatingDataSource tableView:tableView
                     titleForFooterInSection:5] should] beNil];
        });
      });
      context(@"tableView:titleForHeaderInSection", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:titleForHeaderInSection:)
                                      andReturn:@"pears"
                                  withArguments:any(),theValue(1)];
          [[[aggregatingDataSource tableView:tableView
                     titleForHeaderInSection:1] should] equal:@"pears"];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:titleForHeaderInSection:)
                                      andReturn:@"bananas"
                                  withArguments:any(),theValue(0)];
          [[[aggregatingDataSource tableView:tableView
                     titleForHeaderInSection:2] should] equal:@"bananas"];
        });
        it(@"returns a default of nil for the third child", ^{
          [[[aggregatingDataSource tableView:tableView
                     titleForHeaderInSection:5] should] beNil];
        });
      });
      context(@"tableView:canEditRowAtPath", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:canEditRowAtIndexPath:)
                                      andReturn:theValue(NO)
                                  withArguments:any(),[NSIndexPath indexPathForItem:3
                                                                          inSection:1]];
          [[theValue([aggregatingDataSource tableView:tableView
                                canEditRowAtIndexPath:[NSIndexPath indexPathForItem:3
                                                                          inSection:1]]) should] beNo];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:canEditRowAtIndexPath:)
                                      andReturn:theValue(YES)
                                  withArguments:any(),[NSIndexPath indexPathForItem:3
                                                                          inSection:0]];
          [[theValue([aggregatingDataSource tableView:tableView
                                canEditRowAtIndexPath:[NSIndexPath indexPathForItem:3
                                                                          inSection:2]]) should] beYes];
        });
        it(@"returns a default of NO for the third child", ^{
          [[theValue([aggregatingDataSource tableView:tableView
                                canEditRowAtIndexPath:[NSIndexPath indexPathForItem:3
                                                                          inSection:5]]) should] beNo];
        });
      });
      context(@"tableView:commitEditingStyle:forRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)
                                  withArguments:any(),
                                                theValue(UITableViewCellEditingStyleDelete),
                                                [NSIndexPath indexPathForItem:3
                                                                    inSection:1]];
          [aggregatingDataSource tableView:tableView
                        commitEditingStyle:UITableViewCellEditingStyleDelete
                         forRowAtIndexPath:[NSIndexPath indexPathForItem:3
                                                               inSection:1]];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)
                                  withArguments:any(),
                                                theValue(UITableViewCellEditingStyleDelete),
                                                [NSIndexPath indexPathForItem:3
                                                                    inSection:0]];
          [aggregatingDataSource tableView:tableView
                        commitEditingStyle:UITableViewCellEditingStyleDelete
                         forRowAtIndexPath:[NSIndexPath indexPathForItem:3
                                                               inSection:2]];
        });
      });
      
      // UITableViewDelegate methods
      context(@"tableView:estimatedHeightForRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:estimatedHeightForRowAtIndexPath:) andReturn:theValue(20.0f) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [[theValue([aggregatingDataSource tableView:tableView estimatedHeightForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]]) should] equal:theValue(20.0f)];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:estimatedHeightForRowAtIndexPath:) andReturn:theValue(20.0f) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [[theValue([aggregatingDataSource tableView:tableView estimatedHeightForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]]) should] equal:theValue(20.0f)];
          
        });
        it(@"squashes call to third child", ^{
          [[theValue([aggregatingDataSource tableView:tableView estimatedHeightForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]]) should] equal:theValue(UITableViewAutomaticDimension)];
        });
      });
      context(@"tableView:indentationLevelForRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:indentationLevelForRowAtIndexPath:) andReturn:theValue(7) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [[theValue([aggregatingDataSource tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]]) should] equal:theValue(7)];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:indentationLevelForRowAtIndexPath:) andReturn:theValue(7) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [[theValue([aggregatingDataSource tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]]) should] equal:theValue(7)];
          
        });
        it(@"squashes call to third child", ^{
          [[theValue([aggregatingDataSource tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]]) should] equal:theValue(0)];
        });
      });
      context(@"tableView:willDisplayCell:forRowAtIndexPath:", ^{
        __block UITableViewCell *cell;
        beforeEach(^{
          cell = [UITableViewCell mock];
        });
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:willDisplayCell:forRowAtIndexPath:) withArguments:any(),cell,[NSIndexPath indexPathForItem:3 inSection:1]];
          [aggregatingDataSource tableView:tableView willDisplayCell:cell forRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:willDisplayCell:forRowAtIndexPath:) withArguments:any(),cell,[NSIndexPath indexPathForItem:3 inSection:0]];
          [aggregatingDataSource tableView:tableView willDisplayCell:cell forRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]];
        });
        it(@"squashes call to third child", ^{
          [aggregatingDataSource tableView:tableView willDisplayCell:cell forRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]];
        });
      });
      context(@"tableView:accessoryButtonTappedForRowWithIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [aggregatingDataSource tableView:tableView accessoryButtonTappedForRowWithIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [aggregatingDataSource tableView:tableView accessoryButtonTappedForRowWithIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]];
        });
        it(@"squashes call to third child", ^{
          [aggregatingDataSource tableView:tableView accessoryButtonTappedForRowWithIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]];
        });
      });
      context(@"tableView:willSelectRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:willSelectRowAtIndexPath:) andReturn:[NSIndexPath indexPathForItem:3 inSection:1] withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [[[aggregatingDataSource tableView:tableView willSelectRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]] should] equal:[NSIndexPath indexPathForItem:3 inSection:1]];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:willSelectRowAtIndexPath:) andReturn:[NSIndexPath indexPathForItem:3 inSection:0] withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [[[aggregatingDataSource tableView:tableView willSelectRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]] should] equal:[NSIndexPath indexPathForItem:3 inSection:2]];
        });
        it(@"returns nil when a child returns nil", ^{
          [[(id)childDataSourceB stub] tableView:any() willSelectRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
          [[[aggregatingDataSource tableView:tableView willSelectRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]] should] beNil];
        });
        it(@"squashes call to third child", ^{
          [[[aggregatingDataSource tableView:tableView willSelectRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]] should] equal:[NSIndexPath indexPathForItem:3 inSection:5]];
        });

      });
      context(@"tableView:didSelectRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:didSelectRowAtIndexPath:) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [aggregatingDataSource tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:didSelectRowAtIndexPath:) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [aggregatingDataSource tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]];
        });
        it(@"squashes call to third child", ^{
          [aggregatingDataSource tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]];
        });
      });
      context(@"tableView:willDeselectRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:willDeselectRowAtIndexPath:) andReturn:[NSIndexPath indexPathForItem:3 inSection:1] withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [[[aggregatingDataSource tableView:tableView willDeselectRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]] should] equal:[NSIndexPath indexPathForItem:3 inSection:1]];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:willDeselectRowAtIndexPath:) andReturn:[NSIndexPath indexPathForItem:3 inSection:0] withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [[[aggregatingDataSource tableView:tableView willDeselectRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]] should] equal:[NSIndexPath indexPathForItem:3 inSection:2]];
        });
        it(@"squashes call to third child", ^{
          [[[aggregatingDataSource tableView:tableView willDeselectRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]] should] equal:[NSIndexPath indexPathForItem:3 inSection:5]];
        });
      });
      context(@"tableView:didDeselectRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:didDeselectRowAtIndexPath:)
                                  withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [aggregatingDataSource tableView:tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:didDeselectRowAtIndexPath:)
                                  withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [aggregatingDataSource tableView:tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]];
          
        });
        it(@"squashes call to third child", ^{
          [aggregatingDataSource tableView:tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]];
        });
      });
      context(@"tableView:viewForHeaderInSection:", ^{
        __block UIView *view;
        beforeEach(^{
          view = [UIView mock];
        });
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:viewForHeaderInSection:) andReturn:view withArguments:any(),theValue(1)];
          [[[aggregatingDataSource tableView:tableView viewForHeaderInSection:1] should] equal:view];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:viewForHeaderInSection:) andReturn:view withArguments:any(),theValue(0)];
          [[[aggregatingDataSource tableView:tableView viewForHeaderInSection:2] should] equal:view];
        });
        it(@"squashes call to third child", ^{
          [[[aggregatingDataSource tableView:tableView viewForHeaderInSection:5] should] beNil];
        });
      });
      context(@"tableView:viewForFooterInSection:", ^{
        __block UIView *view;
        beforeEach(^{
          view = [UIView mock];
        });
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:viewForFooterInSection:) andReturn:view withArguments:any(),theValue(1)];
          [[[aggregatingDataSource tableView:tableView viewForFooterInSection:1] should] equal:view];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:viewForFooterInSection:) andReturn:view withArguments:any(),theValue(0)];
          [[[aggregatingDataSource tableView:tableView viewForFooterInSection:2] should] equal:view];
        });
        it(@"squashes call to third child", ^{
          [[[aggregatingDataSource tableView:tableView viewForFooterInSection:5] should] beNil];
        });
      });
      context(@"tableView:heightForHeaderInSection:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:heightForHeaderInSection:) andReturn:theValue(20.0f) withArguments:any(),theValue(1)];
          [[theValue([aggregatingDataSource tableView:tableView heightForHeaderInSection:1]) should] equal:theValue(20.0f)];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:heightForHeaderInSection:) andReturn:theValue(20.0f) withArguments:any(),theValue(0)];
          [[theValue([aggregatingDataSource tableView:tableView heightForHeaderInSection:2]) should] equal:theValue(20.0f)];
        });
        it(@"squashes call to third child", ^{
          [[theValue([aggregatingDataSource tableView:tableView heightForHeaderInSection:5]) should] equal:theValue(UITableViewAutomaticDimension)];
        });
      });
      context(@"tableView:estimatedHeightForHeaderInSection:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:estimatedHeightForHeaderInSection:) andReturn:theValue(20.0f) withArguments:any(),theValue(1)];
          [[theValue([aggregatingDataSource tableView:tableView estimatedHeightForHeaderInSection:1]) should] equal:theValue(20.0f)];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:estimatedHeightForHeaderInSection:) andReturn:theValue(20.0f) withArguments:any(),theValue(0)];
          [[theValue([aggregatingDataSource tableView:tableView estimatedHeightForHeaderInSection:2]) should] equal:theValue(20.0f)];
        });
        it(@"squashes call to third child", ^{
          [[theValue([aggregatingDataSource tableView:tableView estimatedHeightForHeaderInSection:5]) should] equal:theValue(UITableViewAutomaticDimension)];
        });
      });
      context(@"tableView:heightForFooterInSection:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:heightForFooterInSection:) andReturn:theValue(20.0f) withArguments:any(),theValue(1)];
          [[theValue([aggregatingDataSource tableView:tableView heightForFooterInSection:1]) should] equal:theValue(20.0f)];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:heightForFooterInSection:) andReturn:theValue(20.0f) withArguments:any(),theValue(0)];
          [[theValue([aggregatingDataSource tableView:tableView heightForFooterInSection:2]) should] equal:theValue(20.0f)];
        });
        it(@"squashes call to third child", ^{
          [[theValue([aggregatingDataSource tableView:tableView heightForFooterInSection:5]) should] equal:theValue(UITableViewAutomaticDimension)];
        });
      });
      context(@"tableView:estimatedHeightForFooterInSection:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:estimatedHeightForFooterInSection:) andReturn:theValue(20.0f) withArguments:any(),theValue(1)];
          [[theValue([aggregatingDataSource tableView:tableView estimatedHeightForFooterInSection:1]) should] equal:theValue(20.0f)];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:estimatedHeightForFooterInSection:) andReturn:theValue(20.0f) withArguments:any(),theValue(0)];
          [[theValue([aggregatingDataSource tableView:tableView estimatedHeightForFooterInSection:2]) should] equal:theValue(20.0f)];
        });
        it(@"squashes call to third child", ^{
          [[theValue([aggregatingDataSource tableView:tableView estimatedHeightForFooterInSection:5]) should] equal:theValue(UITableViewAutomaticDimension)];
        });
      });
      context(@"tableView:willDisplayHeaderView:forSection:", ^{
        __block UIView *view;
        beforeEach(^{
          view = [UIView mock];
        });
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:willDisplayHeaderView:forSection:) withArguments:any(),view,theValue(1)];
          [aggregatingDataSource tableView:tableView willDisplayHeaderView:view forSection:1];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:willDisplayHeaderView:forSection:) withArguments:any(),view,theValue(0)];
          [aggregatingDataSource tableView:tableView willDisplayHeaderView:view forSection:2];
        });
        it(@"squashes call to third child", ^{
          [aggregatingDataSource tableView:tableView willDisplayHeaderView:view forSection:5];
        });
      });
      context(@"tableView:willDisplayFooterView:forSection:", ^{
        __block UIView *view;
        beforeEach(^{
          view = [UIView mock];
        });
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:willDisplayFooterView:forSection:) withArguments:any(),view,theValue(1)];
          [aggregatingDataSource tableView:tableView willDisplayFooterView:view forSection:1];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:willDisplayFooterView:forSection:) withArguments:any(),view,theValue(0)];
          [aggregatingDataSource tableView:tableView willDisplayFooterView:view forSection:2];
        });
        it(@"squashes call to third child", ^{
          [aggregatingDataSource tableView:tableView willDisplayFooterView:view forSection:5];
        });
      });
      context(@"tableView:willBeginEditingRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:willBeginEditingRowAtIndexPath:) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [aggregatingDataSource tableView:tableView willBeginEditingRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:willBeginEditingRowAtIndexPath:) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [aggregatingDataSource tableView:tableView willBeginEditingRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]];
        });
        it(@"squashes call to third child", ^{
          [aggregatingDataSource tableView:tableView willBeginEditingRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]];
        });
      });
      context(@"tableView:didEndEditingRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:didEndEditingRowAtIndexPath:) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [aggregatingDataSource tableView:tableView didEndEditingRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:didEndEditingRowAtIndexPath:) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [aggregatingDataSource tableView:tableView didEndEditingRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]];
        });
        it(@"squashes call to third child", ^{
          [aggregatingDataSource tableView:tableView didEndEditingRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]];
        });
      });
      context(@"tableView:editingStyleForRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:editingStyleForRowAtIndexPath:) andReturn:theValue(UITableViewCellEditingStyleDelete) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [[theValue([aggregatingDataSource tableView:tableView editingStyleForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]]) should] equal:theValue(UITableViewCellEditingStyleDelete)];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:editingStyleForRowAtIndexPath:) andReturn:theValue(UITableViewCellEditingStyleDelete) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [[theValue([aggregatingDataSource tableView:tableView editingStyleForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]]) should] equal:theValue(UITableViewCellEditingStyleDelete)];
        });
        it(@"squashes call to third child", ^{
          [[theValue([aggregatingDataSource tableView:tableView editingStyleForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]]) should] equal:theValue(UITableViewCellEditingStyleNone)];
        });
      });
      context(@"tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:) andReturn:@"blah" withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [[[aggregatingDataSource tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]] should] equal:@"blah"];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:) andReturn:@"blah" withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [[[aggregatingDataSource tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]] should] equal:@"blah"];
        });
        it(@"squashes call to third child", ^{
          [[[aggregatingDataSource tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]] should] beNil];
        });
      });
      context(@"tableView:shouldIndentWhileEditingRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:) andReturn:theValue(YES) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [[theValue([aggregatingDataSource tableView:tableView shouldIndentWhileEditingRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]]) should] beYes];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:) andReturn:theValue(YES) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [[theValue([aggregatingDataSource tableView:tableView shouldIndentWhileEditingRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]]) should] beYes];
        });
        it(@"squashes call to third child", ^{
          [[theValue([aggregatingDataSource tableView:tableView shouldIndentWhileEditingRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]]) should] beYes];
        });
      });
      context(@"tableView:didEndDisplayingCell:forRowAtIndexPath:", ^{
        __block UITableViewCell *cell;
        beforeEach(^{
          cell = [UITableViewCell mock];
        });
        it(@"forwards to the first child", ^{
          [childDataSourceObjA stub:@selector(tableView:willDisplayCell:forRowAtIndexPath:)];
          [aggregatingDataSource tableView:tableView willDisplayCell:cell forRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
          
          KWCaptureSpy *spy = [childDataSourceObjA captureArgument:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:) atIndex:2];
          [aggregatingDataSource tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
          NSIndexPath *ip = (NSIndexPath *)spy.argument;
          [[ip should] equal:[NSIndexPath indexPathForRow:3 inSection:1]];
        });
        it(@"forwards to the second child", ^{
          [childDataSourceObjB stub:@selector(tableView:willDisplayCell:forRowAtIndexPath:)];
          [aggregatingDataSource tableView:tableView willDisplayCell:cell forRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]];
          
          KWCaptureSpy *spy = [childDataSourceObjB captureArgument:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:) atIndex:2];
          [aggregatingDataSource tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]];
          NSIndexPath *ip = (NSIndexPath *)spy.argument;
          [[ip should] equal:[NSIndexPath indexPathForRow:3 inSection:0]];
        });
 
      });
      context(@"tableView:didEndDisplayingHeaderView:forSection:", ^{
        __block UIView *view;
        beforeEach(^{
          view = [UIView mock];
        });
        it(@"forwards to the first child", ^{
          [childDataSourceObjA stub:@selector(tableView:willDisplayHeaderView:forSection:)];
          [aggregatingDataSource tableView:tableView willDisplayHeaderView:view forSection:1];
          
          KWCaptureSpy *spy = [childDataSourceObjA captureArgument:@selector(tableView:didEndDisplayingHeaderView:forSection:) atIndex:2];
          [aggregatingDataSource tableView:tableView didEndDisplayingHeaderView:view forSection:1];
          [[spy.argument should] equal:@1];
        });
        it(@"forwards to the second child", ^{
          [childDataSourceObjB stub:@selector(tableView:willDisplayHeaderView:forSection:)];
          [aggregatingDataSource tableView:tableView willDisplayHeaderView:view forSection:2];
          
          KWCaptureSpy *spy = [childDataSourceObjB captureArgument:@selector(tableView:didEndDisplayingHeaderView:forSection:) atIndex:2];
          [aggregatingDataSource tableView:tableView didEndDisplayingHeaderView:view forSection:2];
          [[spy.argument should] equal:@0];
        });
      });
      context(@"tableView:didEndDisplayingFooterView:forSection:", ^{
        __block UIView *view;
        beforeEach(^{
          view = [UIView mock];
        });
        it(@"forwards to the first child", ^{
          [childDataSourceObjA stub:@selector(tableView:willDisplayFooterView:forSection:)];
          [aggregatingDataSource tableView:tableView willDisplayFooterView:view forSection:1];
          
          KWCaptureSpy *spy = [childDataSourceObjA captureArgument:@selector(tableView:didEndDisplayingFooterView:forSection:) atIndex:2];
          [aggregatingDataSource tableView:tableView didEndDisplayingFooterView:view forSection:1];
          [[spy.argument should] equal:@1];
        });
        it(@"forwards to the second child", ^{
          [childDataSourceObjB stub:@selector(tableView:willDisplayFooterView:forSection:)];
          [aggregatingDataSource tableView:tableView willDisplayFooterView:view forSection:2];
          
          KWCaptureSpy *spy = [childDataSourceObjB captureArgument:@selector(tableView:didEndDisplayingFooterView:forSection:) atIndex:2];
          [aggregatingDataSource tableView:tableView didEndDisplayingFooterView:view forSection:2];
          [[spy.argument should] equal:@0];
        });
      });
      context(@"tableView:shouldShowMenuForRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:shouldShowMenuForRowAtIndexPath:) andReturn:theValue(YES) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [[theValue([aggregatingDataSource tableView:tableView shouldShowMenuForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]]) should] beYes];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:shouldShowMenuForRowAtIndexPath:) andReturn:theValue(YES) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [[theValue([aggregatingDataSource tableView:tableView shouldShowMenuForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]]) should] beYes];
        });
        it(@"squashes call to third child", ^{
          [[theValue([aggregatingDataSource tableView:tableView shouldShowMenuForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]]) should] beNo];
        });
      });
      context(@"tableView:canPerformAction:forRowAtIndexPath:withSender:", ^{
        __block id sender;
        beforeEach(^{
          sender = [KWMock mock];
        });
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:) andReturn:theValue(YES) withArguments:any(),theValue(@selector(copy:)),[NSIndexPath indexPathForItem:3 inSection:1],sender];
          [[theValue([aggregatingDataSource tableView:tableView canPerformAction:@selector(copy:) forRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1] withSender:sender]) should] beYes];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:) andReturn:theValue(YES) withArguments:any(),theValue(@selector(copy:)),[NSIndexPath indexPathForItem:3 inSection:0],sender];
          [[theValue([aggregatingDataSource tableView:tableView canPerformAction:@selector(copy:) forRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2] withSender:sender]) should] beYes];
        });
        it(@"squashes call to third child", ^{
          [[theValue([aggregatingDataSource tableView:tableView canPerformAction:@selector(copy:) forRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5] withSender:sender]) should] beNo];
        });
      });
      context(@"tableView:performAction:forRowAtIndexPath:withSender:", ^{
        __block id sender;
        beforeEach(^{
          sender = [KWMock mock];
        });
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:performAction:forRowAtIndexPath:withSender:) withArguments:any(),theValue(@selector(copy:)),[NSIndexPath indexPathForItem:3 inSection:1],sender];
          [aggregatingDataSource tableView:tableView performAction:@selector(copy:) forRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1] withSender:sender];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:performAction:forRowAtIndexPath:withSender:) withArguments:any(),theValue(@selector(copy:)),[NSIndexPath indexPathForItem:3 inSection:0],sender];
          [aggregatingDataSource tableView:tableView performAction:@selector(copy:) forRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2] withSender:sender];
          
        });
        it(@"squashes call to third child", ^{
          [aggregatingDataSource tableView:tableView performAction:@selector(copy:) forRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5] withSender:sender];
        });
      });
      context(@"tableView:shouldHighlightRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:shouldHighlightRowAtIndexPath:) andReturn:theValue(YES) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [[theValue([aggregatingDataSource tableView:tableView shouldHighlightRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]]) should] beYes];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:shouldHighlightRowAtIndexPath:) andReturn:theValue(YES) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [[theValue([aggregatingDataSource tableView:tableView shouldHighlightRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]]) should] beYes];
        });
        it(@"squashes call to third child", ^{
          [[theValue([aggregatingDataSource tableView:tableView shouldHighlightRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]]) should] beYes];
        });
      });
      context(@"tableView:didHighlightRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:didHighlightRowAtIndexPath:) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [aggregatingDataSource tableView:tableView didHighlightRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:didHighlightRowAtIndexPath:) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [aggregatingDataSource tableView:tableView didHighlightRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]];
        });
        it(@"squashes call to third child", ^{
          [aggregatingDataSource tableView:tableView didHighlightRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]];
        });
      });
      context(@"tableView:didUnhighlightRowAtIndexPath:", ^{
        it(@"forwards to the first child", ^{
          [[childDataSourceObjA should] receive:@selector(tableView:didUnhighlightRowAtIndexPath:) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:1]];
          [aggregatingDataSource tableView:tableView didUnhighlightRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]];
        });
        it(@"forwards to the second child", ^{
          [[childDataSourceObjB should] receive:@selector(tableView:didUnhighlightRowAtIndexPath:) withArguments:any(),[NSIndexPath indexPathForItem:3 inSection:0]];
          [aggregatingDataSource tableView:tableView didUnhighlightRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:2]];
        });
        it(@"squashes call to third child", ^{
          [aggregatingDataSource tableView:tableView didUnhighlightRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:5]];
        });
        it(@"squashes call to NSNotFound section", ^{
          [aggregatingDataSource tableView:tableView didUnhighlightRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:NSNotFound]];
        });
      });
    });
  });
});

SPEC_END
