//
//  UnionFind.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/4/1.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

/*
 并查集是孩子指向父亲，可以高效处理连接问题 Connectivity Problem
 并查集可以非常快判断网络中节点间的连接状态
 并查集也是数学中集合类的很好实现，高效查两个集合的并
 
 并查集也不考虑添加和删除元素，只考虑当下的元素进行并或者查的操作
 
     0 1 2 3 4 5 6 7 8 9
 id  0 1 0 1 0 1 0 1 0 1
 
 表示 0 2 4 6 8 在一个集合中，1 3 5 7 9 在另一个集合中
 */
public struct UnionFind<T: Hashable> {
  private var index = [T: Int]()
  private var parent = [Int]()
  private var size = [Int]()

  public init() {}

  public mutating func addSetWith(_ element: T) {
    index[element] = parent.count
    parent.append(parent.count)
    size.append(1)
  }

  /// Path Compression.
  private mutating func setByIndex(_ index: Int) -> Int {
    if index != parent[index] {
      parent[index] = setByIndex(parent[index])
    }
    return parent[index]
  }

  public mutating func setOf(_ element: T) -> Int? {
    if let indexOfElement = index[element] {
      return setByIndex(indexOfElement)
    } else {
      return nil
    }
  }

  public mutating func unionSetsContaining(_ firstElement: T, and secondElement: T) {
    if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
      if firstSet != secondSet {
        if size[firstSet] < size[secondSet] {
          parent[firstSet] = secondSet
          size[secondSet] += size[firstSet]
        } else {
          parent[secondSet] = firstSet
          size[firstSet] += size[secondSet]
        }
      }
    }
  }

  public mutating func inSameSet(_ firstElement: T, and secondElement: T) -> Bool {
    if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
      return firstSet == secondSet
    } else {
      return false
    }
  }
}
