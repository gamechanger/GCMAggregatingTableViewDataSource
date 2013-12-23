GCMAggregatingTableViewDataSource
==================
[![Build Status](https://travis-ci.org/gamechanger/GCMAggregatingTableViewDataSource.png)](https://travis-ci.org/gamechanger/GCMAggregatingTableViewDataSource)

 Implementation of UITableViewDataSource which allows multiple child 
 UITableViewDataSource implementations to be composed together and presented
 to a UITableView as if they were a single data source.
 
 Useful in situations where you want a single table view to present content
 from multiple sources and you want to keep the logic for those data sources
 separate. 
 
 Wraps up the logic to dispatch a given protocol method call to the appropriate
 child datasource as well as offsetting passed/returned section indexes and
 aggregating results across child data source methods. 

