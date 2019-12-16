//
//  Question.swift
//  LabQuestions
//
//  Created by Kelby Mittan on 12/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation


struct Question: Decodable {
    let id: String
    let createdAt: String
    let name: String
    let avatar: String
    let title: String
    let description: String
    let labName: String
}
