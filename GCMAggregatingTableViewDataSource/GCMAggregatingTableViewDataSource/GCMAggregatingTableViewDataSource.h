//
//  GCMAggregatingTableViewDataSource.h
//  GameChanger
//
//  Created by Tom Leach on 2/12/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Aggregating Data Source

 @discussion
 Implementation of UITableViewDataSource which allows multiple child
 UITableViewDataSource implementations to be composed together and presented
 to a UITableView as if they were a single data source.

 Useful in situations where you want a single table view to present content
 from multiple sources and you want to keep the logic for those data sources
 separate.

 Wraps up the logic to dispatch a given protocol method call to the appropriate
 child datasource as well as offsetting passed/returned section indexes and
 aggregating results across child data source methods.
 **/
@interface GCMAggregatingTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

/**
 Registers a given UITableViewDataSource as a child data source.

 The order in which child data sources affects the order in which their content
 is presented.

 @param childDataSource The child datasource to be registered
 **/
- (void) addChildDataSource:(id<UITableViewDataSource, UITableViewDelegate>)childDataSource;

/**
 Registers a given UITableViewDataSource as a child data source, inserting it after the given dataSource.


 @param childDataSource The child datasource to be registered
 **/
- (void)addChildDataSource:(id<UITableViewDataSource>)childDataSource afterDataSource:(id<UITableViewDataSource>)precedingDataSource;

/**
 Removes a given UITableViewDataSource as a child data source, if it has been registered.

 @param childDataSource The child datasource to be removed
 **/
- (void) removeChildDataSource:(id<UITableViewDataSource, UITableViewDelegate>)childDataSource;

@end
