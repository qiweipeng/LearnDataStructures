//
//  SegmentTree.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/31.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

/*
 SegmentTree
 经典面试问题，一面墙，每次可以在其中一端区间进行染色，染色可以覆盖之前的染色，若干次染色后，问某个区间内有几种颜色？

 可以使用数组解决这个问题，只需要遍历指定区间，复杂度为 O(n)
 而如果使用线段树解决，复杂度为 O(logn)

        使用数组实现   使用线段树
 更新     O(n)       O(logn)
 查询     O(n)       O(logn)


 对于线段树，不考虑添加和删除操作，线段树解决的问题，区间本身是固定的
 假定研究的问题是数组区间求和，数组共 8 个元素，则构造的线段树
                     A[0...7]
                   /          \
           A[0...3]             A[4...7]
          /     \               /       \
   A[0...1]    A[2...3]    A[4...5]    A[6...7]
    /    \       /   \      /     \      /    \
  A[0]  A[1]   A[2] A[3]  A[4]  A[5]   A[6]   A[7]

 根节点存储全部区间的和，A[0...3]存储前半段的和，以此类推。

 如果数组是 10 个元素，线段树则表示为
                     A[0...9]
                   /          \
           A[0...4]             A[5...9]
          /     \               /       \
   A[0...1]    A[2...4]    A[5...6]    A[7...9]
    /    \       /   \      /     \      /    \
  A[0]  A[1]   A[2] A[3,4] A[5]  A[6]  A[7]   A[8,9]
                     /  \                     /    \
                  A[3] A[4]                 A[8]  A[9]

 线段树不是满二叉树，更不是完全二叉树。
 线段树是一棵平衡二叉树。所谓平衡二叉树，是指一棵树最大深度和最小深度之差最多为 1。
 所以堆也是平衡二叉树，完全二叉树就一定是平衡二叉树。但是二分搜索树就不一定是平衡二叉树。
 平衡二叉树一定不会退化成链表。
 平衡二叉树可以近似看作一个满二叉树，也可以使用数组表示。

 对于线段树来说，如果使用数组来表示，如果区间有n个元素，那么数组需要4n的空间来存储。对于线段树我们不考虑添加元素，即区间固定。
 所以创建线段树复杂度为O(n)，准确的讲是O(4n)

 我们这里实现的线段树只能实现单个元素更新，没有实现区间更新。比如说，我们希望区间 [2,5]中所有元素 +3，在线段树中，需要将这个叶子节点以及他们的父节点都进行更新，复杂度会变为O(n)级别，比较慢。一个方式是进行懒惰更新，lazy更新，我们只把线段树中具体到相应区间的节点进行更新，其下面的子节点先不进行更新，而使用一个lazy数组记录未更新的内容，之后如果进行查询时先查找lazy数组看是否有未更新的内容，如果有再更新一下。

 线段树不仅仅适用于一维，二维甚至三维的区间问题都可以使用线段树解决。
*/
public class SegmentTree<T> {

    private var value: T
    private var function: (T, T) -> T
    private var leftBound: Int
    private var rightBound: Int
    private var leftChild: SegmentTree<T>?
    private var rightChild: SegmentTree<T>?

    private init(array: [T], leftBound: Int, rightBound: Int, function: @escaping (T, T) -> T) {
        self.leftBound = leftBound
        self.rightBound = rightBound
        self.function = function

        if leftBound == rightBound {
            value = array[leftBound]
        } else {
            let middle = (leftBound + rightBound) / 2
            leftChild = SegmentTree<T>(array: array, leftBound: leftBound, rightBound: middle, function: function)
            rightChild = SegmentTree<T>(array: array, leftBound: middle+1, rightBound: rightBound, function: function)
            value = function(leftChild!.value, rightChild!.value)
        }
    }
    
    /// 构造函数。
    /// - Parameters:
    ///   - array: 传入的数组。
    ///   - function: 融合器。
    public convenience init(array: [T], function: @escaping (T, T) -> T) {
        self.init(array: array, leftBound: 0, rightBound: array.count-1, function: function)
    }
    
    /// 区间查询。
    /// - Parameters:
    ///   - leftBound: 左边界。
    ///   - rightBound: 右边界。
    /// - Returns: 这个区间计算的值。
    public func query(leftBound: Int, rightBound: Int) -> T {
        if self.leftBound == leftBound && self.rightBound == rightBound {
            return self.value
        }

        guard let leftChild = leftChild else { fatalError("leftChild should not be nil") }
        guard let rightChild = rightChild else { fatalError("rightChild should not be nil") }

        if leftChild.rightBound < leftBound {
            return rightChild.query(leftBound: leftBound, rightBound: rightBound)
        } else if rightChild.leftBound > rightBound {
            return leftChild.query(leftBound: leftBound, rightBound: rightBound)
        } else {
            let leftResult = leftChild.query(leftBound: leftBound, rightBound: leftChild.rightBound)
            let rightResult = rightChild.query(leftBound:rightChild.leftBound, rightBound: rightBound)
            return function(leftResult, rightResult)
        }
    }
    
    /// 单点替换某个区间中某个元素，更新线段树。
    /// - Parameters:
    ///   - index: 元素的索引。
    ///   - item: 新值。
    public func replaceItem(at index: Int, withItem item: T) {
        if leftBound == rightBound {
            value = item
        } else if let leftChild = leftChild, let rightChild = rightChild {
            if leftChild.rightBound >= index {
                leftChild.replaceItem(at: index, withItem: item)
            } else {
                rightChild.replaceItem(at: index, withItem: item)
            }
            value = function(leftChild.value, rightChild.value)
        }
    }
}
