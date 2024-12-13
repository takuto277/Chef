//
//  DBModel.swift
//  Chef
//
//  Created by 小野拓人 on 2024/12/13.
//

import SwiftData

protocol DBModel: PersistentModel {
    var id: Int { get set }
    var createTime: String { get set }
    var updateTime: String { get set }
}
