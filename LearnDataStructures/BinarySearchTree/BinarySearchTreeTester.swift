//
//  BinarySearchTreeTester.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/28.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

class BinarySearchTreeTester {
    
    func test1() {
        let bst = BinarySearchTree<Int>()
        print("二分搜索树元素为空吗？ \(bst.isEmpty)")
        for _ in 0..<19 {
            bst.insert(Int(arc4random()%100))
        }
        bst.insert(50)
        
        print("二分搜索树元素为空吗？ \(bst.isEmpty)")
        print(bst)
        print("二分搜索树元素数量：\(bst.count)")
        
        print("-----层序遍历-----")
        bst.traverseLevelOrder { (value) in
            print(value)
        }
        
        print("-----前序遍历-----")
        bst.traversePreOrder { (value) in
            print(value)
        }
        
        print("-----中序遍历-----")
        bst.traverseInOrder { (value) in
            print(value)
        }
        print("-----后序遍历-----")
        bst.traversePostOrder { (value) in
            print(value)
        }
        
        print(bst.contains(12))
        print(bst.contains(50))
        
        print("最小元素值：\(bst.minimum())")
        print("最大元素值：\(bst.maximum())")
        
        bst.remove(50)
        print(bst)
    }
}
