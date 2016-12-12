//
//  RxDataSource2.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 09/12/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SAUtils

class RxDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var table: UITableView?
    var data: [Any] = []
    var estimatedRowHeight: CGFloat?
    fileprivate var viewModelToRxRow: [String : RxDataRow] = [:]
    fileprivate var clickMap: [String : (IndexPath, Any)->()] = [:]
    
    init (table: UITableView) {
        super.init()
        self.table = table
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Main class methods
    ////////////////////////////////////////////////////////////////////////////
    
    static func bindTable (_ table: UITableView) -> RxDataSource {
        return RxDataSource (table: table)
    }
    
    func estimateRowHeight (_ height: CGFloat) -> RxDataSource {
        
        estimatedRowHeight = height
        
        if let h = estimatedRowHeight, let table = table {
            table.estimatedRowHeight = h
            table.rowHeight = UITableViewAutomaticDimension
        }
        
        return self
    }
    
    func customiseRow (cellIdentifier: String,
                       cellType: Any.Type,
                       customise: @escaping (Any, UITableViewCell) -> ()) -> RxDataSource {
    
        return customiseRow(cellIdentifier: cellIdentifier,
                            cellType: cellType,
                            cellHeight: estimatedRowHeight ?? 44,
                            cellClass: nil,
                            customise: customise)
    }
    
    func customiseRow (cellIdentifier: String,
                       cellType: Any.Type,
                       cellHeight: CGFloat,
                       customise: @escaping (Any, UITableViewCell) -> ()) -> RxDataSource {
        
        return customiseRow(cellIdentifier: cellIdentifier,
                            cellType: cellType,
                            cellHeight: cellHeight,
                            cellClass: nil,
                            customise: customise)
    }
    
    func customiseRow (cellIdentifier: String,
                       cellType: Any.Type,
                       cellClass: AnyClass?,
                       customise: @escaping (Any, UITableViewCell) -> ()) -> RxDataSource {
        
        return customiseRow(cellIdentifier: cellIdentifier,
                            cellType: cellType,
                            cellHeight: estimatedRowHeight ?? 44,
                            cellClass: cellClass,
                            customise: customise)
    }
    
    func customiseRow (cellIdentifier: String,
                       cellType: Any.Type,
                       cellHeight: CGFloat,
                       cellClass: AnyClass?,
                       customise: @escaping (Any, UITableViewCell) -> ()) -> RxDataSource {
    
        if let cl = cellClass {
            table?.register(cl, forCellReuseIdentifier: cellIdentifier)
        }
        
        let row = RxDataRow(cellIdentifier: cellIdentifier, cellHeight: cellHeight, customise: customise)
        let key = "\(cellType)"
        viewModelToRxRow[key] = row
        
        return self
    }
    
    func clickRow (cellIdentifier: String,
                   click: @escaping (IndexPath, Any) -> ()) -> RxDataSource {
        
        clickMap[cellIdentifier] = click
        
        return self
    }
    
    func update (_ data: [Any]) -> Void {
        
        table?.delegate = self
        table?.dataSource = self
        
        self.data = data.filter { (element: Any) -> Bool in
            let key = "\(type(of: element))"
            return self.viewModelToRxRow[key] != nil
        }
        
        self.table?.reloadData()
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Table View Delegate & Data Source
    ////////////////////////////////////////////////////////////////////////////
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dt = data[indexPath.row]
        let key = "\(type(of: dt))"
        let row = viewModelToRxRow [key]
        let height = row?.cellHeight ?? 0
        
        return height
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dt = data[indexPath.row]
        let key = "\(type(of: dt))"
        let row = viewModelToRxRow [key]
        
        let cellId = row?.cellIdentifier ?? ""
        let cellFunc = row?.customise
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cellFunc? (dt, cell)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dt = data[indexPath.row]
        let key = "\(type(of: dt))"
        let row = viewModelToRxRow [key]
        
        let cellID = row?.cellIdentifier ?? ""
        let clickFunc = clickMap[cellID]
        
        clickFunc? (indexPath, dt)
        
    }
}

private struct RxDataRow {
    public var cellIdentifier: String
    public var cellHeight: CGFloat
    public var customise: ((Any, UITableViewCell) -> ())
}
