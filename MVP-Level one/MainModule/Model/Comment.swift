//
//  Person.swift
//  MVP-Level one
//
//  Created by Виталий Емельянов on 19.11.2021.
//

import Foundation

struct Comment: Codable {
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}
