//
//  InterfaceController.swift
//  intelliQ WatchKit Extension
//
//  Created by Markus Petrykowski on 14.06.15.
//  Copyright (c) 2015 Markus Petrykowski. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    var isLoading = false,
        qProvider = QProvider()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadTableData(){
        
        if !isLoading {
            postProvider.getPosts(offset, limit: limit, sources: sources, sort: sort) { (posts) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.posts.extend(posts)
                    
                    //                    var allPosts = 0
                    //                    for postArray in self.posts {
                    //                        allPosts += postArray.count
                    //                    }
                    
                    self.tableView.setNumberOfRows(self.posts.count, withRowType: "postItem")
                    
                    //                    for postArray in self.posts {
                    for (index, post) in enumerate(self.posts) {
                        if let row = self.tableView.rowControllerAtIndex(index) as? postListItem {
                            row.postTitle.setText(post.title)
                            row.postContent.setText(post.text)
                            
                        }
                    }
                    //                    }
                    
                    self.offset += self.limit
                    self.isLoading = false
                    
                })
            }
        }
    }


}
