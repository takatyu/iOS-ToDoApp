//
//  ViewController.swift
//  ToDoApp
//
//  Created by tkMBA on 2022/01/14.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let todoKey: String = "todoList"
    // TODOリスト用
    var todoList: [String] = []
    // 簡易DB
    let userDefaults: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let storedTodoList = userDefaults.array(forKey: self.todoKey) as? [String] {
            todoList.append(contentsOf: storedTodoList)
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // ＋ボタン押下処理
    @IBAction func addButtonAction(_ sender: Any) {
        let alertControll = UIAlertController(title: "TODO追加", message: "TODOを入力してください。", preferredStyle: UIAlertController.Style.alert)
        alertControll.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,
                                     handler: {(action: UIAlertAction) in
            // OKタップ処理
            if let texteField = alertControll.textFields?[0] {
                //
                self.todoList.insert(texteField.text!, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)],
                                          with: UITableView.RowAnimation.right)
                // TODOを保存
                self.userDefaults.set(self.todoList, forKey: self.todoKey)
            }
        })
        alertControll.addAction(okAction)
        let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        alertControll.addAction(cancelButton)
        present(alertControll, animated: true, completion: nil)
    }
    
    // 全削除ボタン押下処理
    @IBAction func dellAllButtonAction(_ sender: Any) {
        print("Dellet All Button!!")
        let alertControll = UIAlertController(title: "リスト全削除", message: "リストを全て消しますがよろしいですか？", preferredStyle: UIAlertController.Style.alert)
        let cencel = UIAlertAction(title: "キャンセル",
                                   style: UIAlertAction.Style.cancel,
                                   handler: nil)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,
                                     handler: {(action: UIAlertAction) in
            self.todoList.removeAll() // リスト削除
            self.userDefaults.removeAll() // userdb削除
            self.tableView.reloadData() // tableViewをリロード
        })
        
        alertControll.addAction(okAction)
        alertControll.addAction(cencel)
        present(alertControll, animated: true, completion: nil)
    }
    
    // セルにリストを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.todoList[indexPath.row]
        return cell
    }
    
    // セルの削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            // 内容を保存
            self.userDefaults.set(todoList, forKey: self.todoKey)
        }
    }
    
    // 表示するタイミングの件数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 表示するセルの数
        return self.todoList.count
    }
    // 行を選択
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrail = indexPath.row
        print("選択業：\(selectedTrail)")
    }
    
    // セルの選択解除直後
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // 選択解除
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserDefaults {
    func removeAll() {
        dictionaryRepresentation().forEach({ removeObject(forKey: $0.key) })
    }
}
