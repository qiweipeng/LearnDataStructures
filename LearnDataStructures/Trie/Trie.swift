//
//  Trie.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/4/1.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

/*
 Trie
 也叫字典树、前缀树。Trie 只处理字符串。
 
 Trie 是一棵多叉树，比如要存储的字符串只包含 26 个小写字母，那么每个节点就最多包含 26 个叉。
 root
 /    /   \
 a(*) c      h
 |    |      |
 t(*) a     i(*)
 / \
 r(*) t(*)
 上面这个 Trie 一共存了 a、at、car、cat、hi 这几个单词，因为有些单词是其他单词的一部分，所以需要一个额外的布尔 isWord 来标记这个节点是否是一个单词。
 可以看到，查询的时候，不管这棵树中存多少个单词，查询的深度都是单词的长度，这就是 Trie 的优势。
 同时，Trie 查询是否有单词以某个字符串为前缀会特别方便，因此 Trie 也叫前缀树。
 
 Trie 的查询操作和其中包含多少个字符串是无关的，只和要查询的字符串长度有关。因此，如果有非常多的字符串，我们使用 Trie 进行查询效率是非常高的。
 
 这里实现的 Trie 不具有删除操作，应用中也是可以添加删除操作的。
 
 Trie 的最大局限性就是空间问题，相应的会有压缩字典树，可以把一个没有分叉的单链存储成一个节点，而不是每个字符占用一个节点。
 */
public class Trie {
    
    private class Node {
        var isTerminating = false
        var children: [Character: Node] = [:]
    }
    
    private let root: Node
    private var wordCount: Int
    
    /// 构造函数。
    public init() {
        root = Node()
        wordCount = 0
    }
    
    /// Trie 中存储的单词数量。
    public var count: Int {
        return wordCount
    }
    
    /// 插入某单词。
    /// - Parameter word: 要插入的单词。
    public func insert(_ word: String) {
        guard !word.isEmpty else {
            return
        }
        var currentNode = root
        for character in word.lowercased() {
            if let childNode = currentNode.children[character] {
                currentNode = childNode
            } else {
                currentNode.children[character] = Node()
                currentNode = currentNode.children[character]!
            }
        }
        
        guard !currentNode.isTerminating else {
            return
        }
        wordCount += 1
        currentNode.isTerminating = true
    }
    
    /// 是否包含某单词。
    /// - Parameter word: 查询的单词。
    /// - Returns: 布尔。
    public func contains(_ word: String) -> Bool {
      guard !word.isEmpty else {
        return false
      }
      var currentNode = root
      for character in word.lowercased() {
        guard let childNode = currentNode.children[character] else {
          return false
        }
        currentNode = childNode
      }
      return currentNode.isTerminating
    }
    
    /// 是否存在单词以某单词为前缀。
    /// - Parameter word: 前缀。
    /// - Returns: 布尔。
    public func isPrefix(_ word: String) -> Bool {
        guard !word.isEmpty else {
          return true
        }
        var currentNode = root
        for character in word.lowercased() {
          guard let childNode = currentNode.children[character] else {
            return false
          }
          currentNode = childNode
        }
        return true
    }
}
