//
//  CategoryList.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/15.
//
/*
 TableViewで並び順番を保持するために必要
 これがないと、TableViewの並べ替えが実現できない
 */

import RealmSwift
import Foundation

public class CategoryList: Object {

    var list = List<Category>()

}
