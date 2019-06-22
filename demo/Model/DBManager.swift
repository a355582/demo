//
//  DBManager.swift
//  demo
//
//  Created by Chun yu Tung on 2019/5/8.
//  Copyright © 2019 Chun yu Tung. All rights reserved.
//

import Foundation
import SQLite

class DBManager {
    
    var database: Connection!
    
    let playersTable = Table("players")
    
    let player_tag = Expression<String>("player_tag")
    let player_data = Expression<Data>("player_data")
    let player_lastUpdateDate = Expression<Date>("player_lastUpdateDate")
    
    func getConnection() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            print(documentDirectory)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")

            database = try Connection(fileUrl.path)
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        let createPlayerTable = self.playersTable.create(ifNotExists: true) { (table) in
            table.column(self.player_tag, primaryKey: true)
            table.column(self.player_data)
            table.column(self.player_lastUpdateDate)
        }
        do {
            try self.database.run(createPlayerTable)
        } catch {
            print(error)
        }
    }
    
    
    
    func updateDownloadedDataToDatabase(tag: String, data: Data) {
        let date = Date()
        do {
            try database.transaction {
                let filteredTable = playersTable.filter(player_tag == tag)
                if try database.run(filteredTable.update(player_data <- data,
                                                         player_lastUpdateDate <- date)) > 0 {
                    print("update success")
                } else {
                    let rowid = try database.run(playersTable.insert(player_tag <- tag,
                                                                     player_data <- data,
                                                                     player_lastUpdateDate <- date))
                    print("insert id: \(rowid)")
                }
            }
        } catch {
            print("transactionError:\(error)")
        }
    }
    
    func getLastUpdateDate(tag: String) -> Date? {
        var date: Date! = nil
        
        do {
            let playerTable = playersTable.filter(player_tag == tag)
            let players = try self.database.prepare(playerTable)
            
            for player in players {
                date = try player.get(player_lastUpdateDate)
                print("Load Date Successed")
            }
        } catch {
            print("getLastUpdateDateError!")
            print(error)
        }
        
        return date
    }
    
    func loadDataToPlayer(tag: String) -> Data {
        var data = Data()
        
        do {
            let playerTable = playersTable.filter(player_tag == tag)
            let players = try self.database.prepare(playerTable)
            for player in players {
                data = try player.get(player_data)
                
                print("Load Data Successed")
            }
        } catch {
            print("Load Error:\(error)")
        }
        return data
    }

    func deleteTable() {
        do {
            try self.database.run(playersTable.drop(ifExists: true))
        } catch {
            print(error)
        }
    }
    
    
    
}


