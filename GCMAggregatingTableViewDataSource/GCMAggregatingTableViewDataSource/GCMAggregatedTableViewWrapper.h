//
//  GCMAggregatedTableViewWrapper.h
//  GameChanger
//
//  Created by Tom Leach on 6/12/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCMAggregatedTableViewWrapper : NSObject

+ (id)wrapper;
- (void)configureWithTableView:(UITableView *)tableView andOffset:(NSInteger)offset;

@end
