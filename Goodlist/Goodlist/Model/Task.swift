//
//  Task.swift
//  Goodlist
//
//  Created by Oleg Krikun on 21.05.2021.
//

struct Task {
    let title: String
    let priority: Priority
}

enum Priority: Int {
    case high
    case medium
    case low
}
