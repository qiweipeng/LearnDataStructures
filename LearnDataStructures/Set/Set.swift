//
//  Set.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/28.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

/*
 集合协议，这里为了不和系统重名，命名为 MySet
 
 集合分为有序集合与无序集合；二分搜索树实现的集合，包括 Java 中的 TreeSet 使用红黑树实现，都是有序集合，因为这个集合中的元素是有序排列的。
 但是很多时候可能使用集合不会使用到集合到有序性，那么性能更好的无序集合就更适合。这里使用链表实现的集合虽然也是无序的，但是性能不好，但是如果使用哈希表实现，性能就很好了。
 */
public protocol MySet {
    associatedtype Element
    
    var isEmpty: Bool { get }
    var count: Int { get }
    
    func insert(_ newMember: Element)
    func remove(_ member: Element)
    
    func contains(_ member: Element) -> Bool
}

/*
 链表实现的集合。
 
 各个操作时间复杂度：
 func insert(_ newMember: Element)              O(n)
 func remove(_ member: Element)                 O(n)
 func contains(_ member: Element) -> Bool       O(n)
 
 
 对于链表来说，由于没有索引，删除指定元素和查询指定元素都需要遍历，复杂度为 O(n)，添加元素操作由于要判重，也需要进行一次遍历，所以复杂度也是 O(n)。
 */
public struct LinkedListSet<Element: Equatable>: MySet {
    
    private let linkedList = LinkedList<Element>()
    
    public var isEmpty: Bool {
        return linkedList.isEmpty
    }
    
    public var count: Int {
        return linkedList.count
    }
    
    public func insert(_ newMember: Element) {
        if !linkedList.contains(newMember) {
            linkedList.insert(newMember, at: 0)
        }
    }
    
    public func remove(_ member: Element) {
        linkedList.removeAll { $0 == member }
    }
    
    public func contains(_ member: Element) -> Bool {
        return linkedList.contains(member)
    }
}

/*
 二分搜索树实现的集合。
 
 各个操作时间复杂度：                              复杂度   平均     最差
 func insert(_ newMember: Element)              O(h)  O(logn)  O(n)
 func remove(_ member: Element)                 O(h)  O(logn)  O(n)
 func contains(_ member: Element) -> Bool       O(h)  O(logn)  O(n)
 
 对于二分搜索树集合，它的增查删其实只是寻找了树的层树，我们用 h 表示
 最好的情况，也就是树是满的情况下层数和元素数的关系是 2^h - 1 = n，h = log(n + 1)    (log底是 2)
 那么最好情况的复杂度就是 O(logn) 级别的，这其实很接近 O(1) 级别，在数据量大的时候要比 O(n) 好得多
 
 但是对于二分搜索树来说，如果添加元素的时候恰好是从小到大或者相反地插入元素，这棵树就退化成链表了。
 要解决这个问题，就要使用平衡二叉树。
 
 二分搜索树实现的集合整体性能是高于链表集合的。
 */
public struct BinarySearchTreeSet<Element: Comparable>: MySet {
    
    private let binarySearchTree = BinarySearchTree<Element>()
    
    public var isEmpty: Bool {
        return binarySearchTree.isEmpty
    }
    
    public var count: Int {
        return binarySearchTree.count
    }
    
    public func insert(_ newMember: Element) {
        binarySearchTree.insert(newMember)
    }
    
    public func remove(_ member: Element) {
        binarySearchTree.remove(member)
    }
    
    public func contains(_ member: Element) -> Bool {
        binarySearchTree.contains(member)
    }
}
