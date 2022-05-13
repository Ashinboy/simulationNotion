//
//  notionContentTableViewController.swift
//  simulationNotion
//
//  Created by Ashin Wang on 2022/5/6.
//

import UIKit

private var identifier = "notionContentTableViewController"

class NotionContentTableViewController: UITableViewController, UISearchResultsUpdating{
    
    
    var todoItems = [toDoitem]()
    {
        didSet{
            toDoitem.saveToDoitem(todoItems)
        }
    }

    
    //當cell有了物件後才會觸發的功能
    lazy var filteredToDoList = todoItems
    var selectIndexPath: IndexPath?
    var isCheckStatus = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loadToDo = toDoitem.laodtoDoitem(){
            self.todoItems = loadToDo
        }
        
        let searchController = UISearchController()
        //將tableViewController設為searchController的searchResultUpdater
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        print("check!!!!",todoItems)
    }
    
    @IBAction func unwindTonotionContentTableViewController(_ unwindSegue: UIStoryboardSegue ) {
        
        if let source = unwindSegue.source as? addTableViewController,
           let todo = source.todo{
            
            //修改
            if let indexPath = selectIndexPath {
                //由於struct是valueType的緣故要在把資料存回陣列
                filteredToDoList[indexPath.row] = todo
                tableView.reloadRows(at: [indexPath], with: .automatic)
                selectIndexPath = nil
                
                print("check修改",indexPath)
            }else{
                //新增
                todoItems.insert(todo, at: 0)
                filteredToDoList = todoItems
                let newIndexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
                
                print("check新增",newIndexPath)
            }
           
            print("checkAllList",filteredToDoList)
            
            //todoItems.insert(todoSource, at: 0)
            // //動畫版本
            //let indexPath = IndexPath(row: 0, section: 0)
            //tableView.insertRows(at: [indexPath], with: .automatic)
            
            //一般版本
            //tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //右滑編輯設定
        
        selectIndexPath = indexPath
        let editAction = UIContextualAction(style: .normal, title: "Edit") { action, view, completionhadler in
            
            let todoInfo = self.filteredToDoList[indexPath.row]
            
            self.performSegue(withIdentifier: "showDetail", sender: todoInfo)
            
            completionhadler(true)
        }
        //初始 UISwipeActionsConfiguration 並回傳
        return UISwipeActionsConfiguration(actions: [editAction])
        
        
    }
    
    //    @available(iOS 11.0, *)
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
           searchText.isEmpty == false{
            filteredToDoList = todoItems.filter({ toDoList in toDoList.titleText.localizedStandardContains(searchText)
            })
        }else{
            filteredToDoList = todoItems
        }
        tableView.reloadData()
    }
    
    
    //刪除功能
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        filteredToDoList.remove(at: indexPath.row)
        todoItems.remove(at: indexPath.row)
        //特別注意刪除後with要改成numberOfRows(inSection)回傳cell要是東西刪除後的數量
        //有動畫的版本
        tableView.deleteRows(at: [indexPath], with: .automatic)
        //無動畫直接reloadData
        
        print("check delete",indexPath)
    }
    
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 1
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredToDoList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        let attritubeString = NSMutableAttributedString(string: filteredToDoList[indexPath.row].titleText)
        let row = indexPath.row
//        cell.textLabel?.text = todoItems[indexPath.row].titleText
        
        if todoItems[row].isCheck{
            cell.accessoryType = .checkmark
            attritubeString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, attritubeString.length))
        }else{
            cell.accessoryType = .none
        }
        
        cell.textLabel?.attributedText = attritubeString
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        todoItems[indexPath.row].isCheck = !todoItems[indexPath.row].isCheck
        tableView.reloadData()
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? addTableViewController,
           let sender = sender as? toDoitem  {
            controller.todo = sender
        }
    }
}
