//
//  File.swift
//  ConteraCompanyTask
//
//  Created by Student P_08 on 11/08/19.
//  Copyright © 2019 felix. All rights reserved.
//

import Foundation
class DBWrapper
{
    static let sharedObj = DBWrapper()
    var schduleArrayData = [String]()
    var RoomScheduleArray = [String]()
    var DayScheduleArray = [String]()
    var TimeScheduleArray = [String]()
    var ApplianceScheduelArray = [String]()
    
    func getDataBasePath()->String
    {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = dir.first!
        return path+"/myDatabase.sqlite"
    }
    
    //SELECT QUERY START
    func selectAllTask(query:String)
    {
        var dB:OpaquePointer?
        var stmt:OpaquePointer?
        
        schduleArrayData = [String]()
        RoomScheduleArray = [String]()
        DayScheduleArray = [String]()
        TimeScheduleArray = [String]()
        ApplianceScheduelArray = [String]()

        
        
        let dbPath = getDataBasePath()
        if(sqlite3_open(dbPath, &dB)==SQLITE_OK)
        {
            if(sqlite3_prepare_v2(dB!, query, -1, &stmt, nil)==SQLITE_OK)
            {
                while(sqlite3_step(stmt!)==SQLITE_ROW)
                {
                    let sdn = sqlite3_column_text(stmt!, 0)
                    let schedule_name = String(cString: sdn!)
                    let rn = sqlite3_column_text(stmt!, 1)
                    let room_name = String(cString: rn!)
                    let apn = sqlite3_column_text(stmt!, 2)
                    let appliance_name = String(cString: apn!)
                    let tm = sqlite3_column_text(stmt!, 3)
                    let times = String(cString: tm!)
                    let dy = sqlite3_column_text(stmt!, 4)
                    let day = String(cString: dy!)
                    schduleArrayData.append(schedule_name)
                    RoomScheduleArray.append(room_name)
                    ApplianceScheduelArray.append(appliance_name)
                    TimeScheduleArray.append(times)
                    DayScheduleArray.append(day)
                }
            }
            else
            {
                print("Error in prepare statement:\(sqlite3_errmsg(stmt!))")
            }
        }
        else
        {
            print("Error in opening database:\(sqlite3_errmsg(stmt!))")
        }
    }
    //SELECT QUERY END
    
    func executeQuery(query:String)-> Bool
    {
        var success = false
        var dB:OpaquePointer?
        var stmt:OpaquePointer?
        let dbPath = getDataBasePath()
        if(sqlite3_open(dbPath, &dB)==SQLITE_OK)
        {
            if(sqlite3_prepare_v2(dB!, query, -1, &stmt, nil)==SQLITE_OK)
            {
                 if(sqlite3_step(stmt!)==SQLITE_DONE)
                 {
                    success = true
                    sqlite3_close(dB!)
                    sqlite3_finalize(stmt!)
                }
            }
            else
            {
                print("Error in prepare statement:\(sqlite3_errmsg(stmt!))")
            }
        }
        else
        {
            print("Error in opening database:\(sqlite3_errmsg(stmt!))")
        }
        return success
    }
    
    
    //TABLE CREATION START
    func createTable()
    {
        let create = "create table if not exists Schedule(Schedule_Name text,Room_Name text,Appliance_Name text,Time text,Day text)"
        let isSuccess = executeQuery(query: create)
        if isSuccess
        {
            print("Table Creation:Successss")
        }
    }
    //TABLE CREATION END
    
}
