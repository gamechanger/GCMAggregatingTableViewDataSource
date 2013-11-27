#import <Kiwi.h>
#import "GCMTemplateProject.h"

SPEC_BEGIN(GCMTemplateProjectTests)

describe(@"a kiwi spec", ^{
  it(@"works", ^{
    [[theValue([GCMTemplateProject theNumberOne]) should] equal:theValue(1)];
  });
});

SPEC_END