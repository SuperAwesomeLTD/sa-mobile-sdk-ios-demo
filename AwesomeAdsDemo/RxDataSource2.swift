import UIKit
import RxSwift
import RxCocoa
import SAUtils

class RxDataSource2: NSObject, UITableViewDelegate, UITableViewDataSource {

    private var table: UITableView?
    private var estimatedRowHeight: CGFloat?
    private var modelToRow: [String : RxRow] = [:]
    private var clicks: [String : RxClick] = [:]
    private var data: [Any] = []
    
    override init () {
        // 
    }
    
    init (table: UITableView) {
        self.table = table
    }
    
    func bindTable (_ table: UITableView) -> RxDataSource2 {
        self.table = table
        return self
    }
    
    static func create () -> RxDataSource2 {
        return RxDataSource2 ()
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Estimate full table height
    ////////////////////////////////////////////////////////////////////////////
    
    func estimateRowHeight (_ height: CGFloat) -> RxDataSource2 {
        
        estimatedRowHeight = height
        
        if let h = estimatedRowHeight, let table = table {
            table.estimatedRowHeight = h
            table.rowHeight = UITableViewAutomaticDimension
        }
        
        return self
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Customize Row
    ////////////////////////////////////////////////////////////////////////////
        
    func customiseRow <Cell : UITableViewCell, Model> (identifier: String,
                                                       modelType: Model.Type,
                                                       cellType: Cell.Type,
                                                       cellHeight: CGFloat,
                                                       customise: @escaping (Cell, Model) -> Void ) -> RxDataSource2 {
        
        var row = RxRow()
        row.identifier = identifier
        row.height = cellHeight
        row.customise = { cell, model in
            if let c = cell as? Cell, let m = model as? Model  {
                customise (c, m)
            }
        }
        
        let key = "\(modelType)"
        modelToRow[key] = row
        
        return self
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Row Clicks
    ////////////////////////////////////////////////////////////////////////////
    
    func clickRow <Model> (withIdentifier identifier: String,
                           forModel type: Model.Type,
                           onClick action: @escaping (IndexPath, Model) -> Void) -> RxDataSource2 {
        
        var click = RxClick()
        click.identifier = identifier
        click.action = { index, model in
            if let m = model as? Model {
                action (index, m)
            }
        }
        
        let key = "\(type)"
        clicks[key] = click
        
        return self
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Final Update method
    ////////////////////////////////////////////////////////////////////////////
    
    func update (_ data: [Any])  {
        
        table?.delegate = self
        table?.dataSource = self
        
        self.data = data.filter { (element: Any) -> Bool in
            let key = "\(type(of: element))"
            return self.modelToRow[key] != nil
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
        
        if estimatedRowHeight != nil {
            return UITableViewAutomaticDimension
        }
        else {
            
            let dt = data[indexPath.row]
            let key = "\(type(of: dt))"
            let row = modelToRow [key]
            let height = row?.height ?? 44
            
            return height
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dt = data[indexPath.row]
        let key = "\(type(of: dt))"
        let row = modelToRow [key]
        
        let cellId = row?.identifier ?? ""
        let cellFunc = row?.customise
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cellFunc? (cell, dt)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dt = data[indexPath.row]
        let key = "\(type(of: dt))"
        let click = clicks[key]
        let action = click?.action
        
        action? (indexPath, dt)
        
    }
    
    
}

private struct RxRow  {
    var identifier: String?
    var height: CGFloat?
    var customise: ((UITableViewCell, Any) -> Void)?
}

private struct RxClick {
    var identifier: String?
    var action: ((IndexPath, Any) -> Void)?
}
