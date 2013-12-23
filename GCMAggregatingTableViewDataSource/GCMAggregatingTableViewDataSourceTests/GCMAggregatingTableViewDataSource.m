#import <Kiwi.h>
#import "GCMAggregatingTableViewDataSource.h"

SPEC_BEGIN(GCMAggregatingTableViewDataSourceTests)

describe(@"a kiwi spec", ^{
  it(@"works", ^{
    [[theValue([GCMAggregatingTableViewDataSource theNumberOne]) should] equal:theValue(1)];
  });
});

SPEC_END
