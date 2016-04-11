//
//  DataHelper.swift
//  XYBill
//
//  Created by 薛焱 on 16/3/9.
//  Copyright © 2016年 薛焱. All rights reserved.
//

import UIKit

class DataHelper: NSObject {
    var XYBill: FMDatabase!
    
    class func shareDataHelper() -> DataHelper{
        let dataHelper = DataHelper()
        return dataHelper
    }
    //创建地址
    func creatPath() -> String {
        let path: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        return path.stringByAppendingString("/XYBill.sqilte")
    }
    
    //创建
    func creatModelList(){
        let path = creatPath()
        XYBill = FMDatabase(path: path)
        XYBill.open()
        do{
           try XYBill.executeUpdate("create table if not exists XYBill(number integer primary key autoincrement, id text, account text, money text, date text, type text, inAndOut text)", values: nil)
        }catch let error as NSError {
            print(error.description)
        }
        
        
    }
    //插入
    func insertModel(model: Model){
        do{
            print(model.id, model.account, model.money, model.date, model.type, model.inAndOut)
            try XYBill.executeUpdate("insert into XYBill(id)value(?)", values: [model.id])
        }catch let error as NSError{
            print(error.description)
        }
        
        
    }
    //删除
    func deleteModel(model: Model){
        do{
            try XYBill.executeUpdate("delete from XYBill where id = ?", values: [model.id])
        }catch let error as NSError {
            print(error.description)
        }
    }
    //查询
    func queryAllModel() -> NSMutableArray{
        let array = NSMutableArray()
        do{
            let set: FMResultSet = try XYBill.executeQuery("select * from XYBill", values: nil)
            
            while set.next() {
                let model = Model()
                model.id = set.stringForColumn("id")
                model.account = set.stringForColumn("account")
                model.date = set.stringForColumn("date")
                model.money = set.stringForColumn("money")
                model.inAndOut = set.stringForColumn("inAndOut")
                model.type = set.stringForColumn("type")
                array.addObject(model)
            }
            
        }catch let error as NSError{
            print(error.description)
        }
        
        
       return array
    }
    //修改
    func changeModel(model: Model){
        
    }
}
