//
//  BinarySearchTree.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/28.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

/*
关于二叉树：
二叉树名词：左孩子、右孩子、左子树、右子树、父亲节点、叶子节点
二叉树具有唯一根节点。
每个节点最多有两个孩子节点；每个节点最多有一个父亲节点。
二叉树具有天然递归性，左子树、右子树都是一个二叉树。
二叉树不一定是满的，空也是一个二叉树。

BST 即 Binary Search Tree 二分搜索树

二分搜索树特点：
首先是一棵二叉树；
二分搜索树每一个节点的值都大于其左子树中所有节点的值，都小于其右子树中所有节点的值。
所存储的元素必须具有可比较性。
二分搜索树不具备自平衡性，要保持其平衡性，新插入元素要是随机的而非排序后的。
 
我们实现的这个二分搜索树不包含重复元素。
*/
public final class BinarySearchTree<T: Comparable> {
    
    /// 节点类。
    private class Node: CustomStringConvertible {
        
        var value: T
        var left: Node?
        var right: Node?
        
        init(value: T) {
            self.value = value
        }
        var description: String {
            var s = ""
            if let left = left {
                s += "(" + left.description + ") <- "
            }
            s += "\(value)"
            if let right = right {
                s += " -> (" + right.description + ")"
            }
            return s
        }
    }
    
    /// 根节点。
    private var root: Node?
    /// 节点数量。
    private var size: Int = 0
    
    /// 二分搜索树是否为空。
    public var isEmpty: Bool {
        return size == 0
    }
    
    /// 元素的数量。
    public var count: Int {
        return size
    }
    
    /// 添加新元素。
    /// - Parameter value: 新元素。
    public func insert(_ value: T) {
        root = insert(value, to: root)
    }
    
    /// 插入元素函数的递归函数。
    private func insert(_ value: T, to node: Node?) -> Node {
        guard let node = node else {
            size += 1
            return Node(value: value)
        }
        
        if node.value > value {
            node.left = insert(value, to: node.left)
        } else if node.value < value {
            node.right = insert(value, to: node.right)
        }
        
        return node
    }
    
    /// 是否包含某元素。
    /// - Parameter value: 指定的元素。
    public func contains(_ value: T) -> Bool {
        return contains(value, in: root)
    }
    
    /// 包含函数的递归函数。
    private func contains(_ value: T, in node: Node?) -> Bool {
        guard let node = node else {
            return false
        }
        
        if node.value == value {
            return true
        } else if node.value > value {
            return contains(value, in: node.left)
        } else {
            return contains(value, in: node.right)
        }
    }
    
    /// 前序遍历。
    /// - Parameter process: 对于每个元素的操作。
    public func traversePreOrder(process: (T) -> Void) {
        traversePreOrder(process: process, from: root)
    }
    
    /// 前序遍历的递归函数。
    private func traversePreOrder(process: (T) -> Void, from node: Node?) {
        guard let node = node else {
            return
        }
        
        process(node.value)
        traversePreOrder(process: process, from: node.left)
        traversePreOrder(process: process, from: node.right)
    }
    
    /// 中序遍历。
    /// - Parameter process: 对于每个元素的操作。
    public func traverseInOrder(process: (T) -> Void) {
        traverseInOrder(process: process, from: root)
    }
    
    /// 中序遍历的递归函数。
    private func traverseInOrder(process: (T) -> Void, from node: Node?) {
        guard let node = node else {
            return
        }
        
        traverseInOrder(process: process, from: node.left)
        process(node.value)
        traverseInOrder(process: process, from: node.right)
    }
    
    /// 后序遍历。
    /// - Parameter process: 对于每个元素的操作。
    public func traversePostOrder(process: (T) -> Void) {
        traversePostOrder(process: process, from: root)
    }
    
    /// 后序遍历的递归函数。
    private func traversePostOrder(process: (T) -> Void, from node: Node?) {
        guard let node = node else {
            return
        }
        
        traversePostOrder(process: process, from: node.left)
        traversePostOrder(process: process, from: node.right)
        process(node.value)
    }
    
    /// 层序遍历。
    /// - Parameter process: 对每个元素的操作。
    public func traverseLevelOrder(process: (T) -> Void) {
        var queue = LazyQueue<Node>()
        guard let root = root else { return }
        queue.enqueue(root)
        
        while let node = queue.dequeue() {
            process(node.value)
            
            if let left = node.left {
                queue.enqueue(left)
            }
            
            if let right = node.right {
                queue.enqueue(right)
            }
        }
    }
    
    /// 最小元素。
    public func minimum() -> T {
        assert(root != nil, "Binary search tree is empty.")
        
        return minimum(root!).value
    }
    
    /// 最小元素的递归函数。
    private func minimum(_ node: Node) -> Node {
        guard let left = node.left else {
            return node
        }
        
        return minimum(left)
    }
    
    /// 最大元素。
    public func maximum() -> T {
        assert(root != nil, "Binary search tree is empty.")
        
        return maximum(root!).value
    }
    
    /// 最大元素的递归函数。
    private func maximum(_ node: Node) -> Node {
        guard let right = node.right else {
            return node
        }
        
        return maximum(right)
    }
    
    /// 删除最小元素。
    @discardableResult
    public func removeMinimum() -> T {
        let min = minimum()
        root = removeMinimum(from: root!)
        
        return min
    }
    
    /// 删除最小元素的递归函数。
    private func removeMinimum(from node: Node) -> Node? {
        
        if node.left == nil {
            let right = node.right
            node.right = nil
            size -= 1
            return right
        }

        node.left = removeMinimum(from: node.left!)
        return node
    }
    
    /// 删除最大元素。
    @discardableResult
    public func removeMaximum() -> T {
        let max = maximum()
        root = removeMaximum(from: root!)
        
        return max
    }
    
    /// 删除最大元素的递归函数。
    private func removeMaximum(from node: Node) -> Node? {
        
        if node.right == nil {
            let left = node.left
            node.left = nil
            size -= 1
            return left
        }

        node.right = removeMaximum(from: node.right!)
        return node
    }
    
    /// 删除指定元素。
    /// - Parameter value: 指定的元素。
    public func remove(_ value: T) {
        root = remove(value, from: root)
    }
    
    /// 删除指定元素的递归函数。
    private func remove(_ value: T, from node: Node?) -> Node? {
        guard let node = node else {
            return nil
        }
        // value 和 node 节点的值做比较，如果较小就去左子树寻找，如果较大就去右子树寻找
        if value < node.value {
            node.left = remove(value, from: node.left)
            return node
        } else if value > node.value {
            node.right = remove(value, from: node.right)
            return node
        } else {
            // value 正好等于 node 节点的值
            
            // 待删除节点右子树为空
            if node.left == nil {
                let right = node.right
                node.right = nil
                size -= 1
                return right
            }
            
            // 待删除节点右子树为空
            if node.right == nil {
                let left = node.left
                node.left = nil
                size -= 1
                return left
            }
            
            // 待删除节点左右子树均不为空
            // 找到比待删除节点大的最小节点，即待删除节点右子树的最小节点
            // 用这个节点顶替待删除节点的位置。
            let successor = minimum(node.right!)
            successor.right = removeMinimum(from: node.right!)
            successor.left = node.left
            node.left = nil
            node.right = nil
            
            return successor
        }
    }
}

extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
        
        guard let root = root else {
            return "nil"
        }
        
        return root.description
    }
}
