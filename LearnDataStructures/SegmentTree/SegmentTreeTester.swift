//
//  SegmentTreeTester.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/31.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

class SegmentTreeTester {
    
    let nums = [3, -2, 5, 0, 1, 11, -5]
    
    func test1() {
        let segmentTree = SegmentTree<Int>(array: nums, function: +)
        segmentTree.replaceItem(at: 2, withItem: -5)
        let query = segmentTree.query(leftBound: 1, rightBound: 5)
        
        print(query)
    }
}
