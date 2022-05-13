//
//  contents.swift
//  simulationNotion
//
//  Created by Ashin Wang on 2022/5/6.
//

import Foundation


struct toDoitem: Codable {
    var titleText: String
    var description: String
    var isCheck: Bool
    
 
    static func saveToDoitem(_ todoList: [toDoitem]){
        //編碼
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(todoList) else {return}
        //存擋
        let userDefault = UserDefaults.standard
        userDefault.set(data, forKey: "toDoitem")
    }
    
    static func laodtoDoitem() ->[toDoitem]? {
        //讀取
        let userDefault = UserDefaults.standard
        guard let data = userDefault.data(forKey: "toDoitem") else {return nil}
        //解碼
        let decoder = JSONDecoder()
        return try? decoder.decode([toDoitem].self, from: data)
    }
}
