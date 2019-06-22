//
//  clashOfClans.swift
//  demo
//
//  Created by Chun yu Tung on 2019/4/22.
//  Copyright © 2019 Chun yu Tung. All rights reserved.
//

import Foundation

struct PlayerDetail: Decodable {
    var tag: String?
    var name: String?
    var expLevel: Int?
    var trophies: Int?
    var donations: Int?
    var donationsReceived: Int?
    var league: League?
    var troops: [Item]?
    var heroes: [Item]?
    var spells: [Item]?
    
}

struct Item: Decodable {
    var name: String = ""
    var level: Int = 0
    var maxLevel: Int = 0
    var village: String = ""
}

struct League: Decodable {
    var iconUrls: UrlContainer = UrlContainer()
}

struct UrlContainer: Decodable {
    var small: String = ""
    var tiny: String = ""
    var medium: String = ""
}

//extension PlayerDetail {
//
//    enum PlayerDetailCodingKeys: String, CodingKey {
//        case tag
//        case name
//        case expLevel
//        case trophies
//        case donations
//        case donationsReceived
//        case league
//        case heroes
//        case troops
//        case spells
//    }
//
//    enum ItemCodingKeys: String, CodingKey {
//        case name
//        case level
//        case maxLevel
//        case village
//    }
//
//    enum LeagueCodingKeys: String, CodingKey {
//        case id
//        case name
//        case iconUrls
//    }
//
//    enum UrlContainerCodingKeys: String, CodingKey {
//        case small
//        case large
//        case medium
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: PlayerDetailCodingKeys.self)
//
//        tag = try container.decode(String.self, forKey: .tag)
//        name = try container.decode(String.self, forKey: .name)
//        expLevel = try container.decode(Int.self, forKey: .expLevel)
//        trophies = try container.decode(Int.self, forKey: .trophies)
//        donations = try container.decode(Int.self, forKey: .donations)
//        donationsReceived = try container.decode(Int.self, forKey: .donationsReceived)
//
//        heroes = try container.decode([Item].self, forKey: .heroes)
//        troops = try container.decode([Item].self, forKey: .troops)
//        spells = try container.decode([Item].self, forKey: .spells)
//
//        league = try container.decode(League.self, forKey: .league)
//
//    }
//}

