//
//  Friend.swift
//  Kiss
//
//  Created by thieblin on 3/14/15.
//  Copyright (c) 2015 actimust. All rights reserved.
//

import Foundation

class Friend {
    var name = ""
    var id = ""
    var lastSend = 0;
    var countOut = 0;
    
    init(name: String, id: String, lastSend: Int, countOut: Int){
        self.name = name
        self.id = id
        self.lastSend = lastSend
        self.countOut = countOut
    }
    
    init(){
        
    }
    
    class func orderByCount(var friends: [Friend]) -> [Friend] {
        let length = friends.count
        if(length==1) { return friends }
        
        let lLength = length / 2;
        let rLength = length - lLength
        var left: [Friend] = [Friend](count: lLength, repeatedValue: Friend())
        var right: [Friend] = [Friend](count: rLength, repeatedValue: Friend())
        
        for index in 0...lLength-1 {
            left[index] = friends[index]
            right[index] = friends[lLength + index]
        }
        
        if length % 2 == 1 { right[rLength-1] = friends[length-1] }
        
        if lLength > 1 { left = orderByCount(left) }
        if rLength > 1 { right = orderByCount(right) }
        
        var l = 0
        var r = 0
        
        for index in 0...length-1 {
            if l < lLength && (r >= rLength || (right[r].countOut <= left[l].countOut)){
                friends[index] = left[l++]
            }
            else{
                friends[index] = right[r++]
            }
        }
        return friends
    }
    
    
}