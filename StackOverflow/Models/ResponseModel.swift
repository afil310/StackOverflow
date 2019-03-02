//
//  ResponseModel.swift
//  StackOverflow
//
//  Created by Andrey Filonov on 28/01/2019.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//
// API description: https://api.stackexchange.com/docs/questions
// Question type: https://api.stackexchange.com/docs/types/question
// Owner type: https://api.stackexchange.com/docs/types/shallow-user

// swiftlint:disable identifier_name
// identifier names checking is disabled as identifier are compliant with the stackexchange API response model

class Response: Codable {
    let items: [Question]
    let has_more: Bool
    let backoff: Int?
    let quota_max: Int
    let quota_remaining: Int
}

struct Question: Codable {
    let tags: [String]
    let owner: Owner?
    let is_answered: Bool
    let view_count: Int
    let answer_count: Int
    let score: Int
    let last_activity_date: Int
    let creation_date: Int
    let last_edit_date: Int?
    let question_id: Int
    let link: String
    let title: String
}

struct Owner: Codable {
    let reputation: Int?
    let user_id: Int?
    let user_type: String
    let accept_rate: Int?
    let profile_image: String?
    let display_name: String?
    let link: String?
}
