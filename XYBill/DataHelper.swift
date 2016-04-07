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
        XYBill.executeUpdate(<#T##sql: String!##String!#>, withVAList: <#T##CVaListPointer#>)
    }
    //插入
    func indertModel(model: Model){
        
    }
    //删除
    func deleteModel(model: Model){
        
    }
    //查询
    func queryAllModel(){
        
    }
    //修改
    func changeModel(model: Model){
        
    }
}
