//
//  ViewController.swift
//  ToDoApp
//
//  Created by Hiroshi Takai on 2022/01/16.
//  Copyright © 2022 ProjectStage, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    let todoKey: String = "todoList"
    let indentCell: String = "tableCell"
    let onImage: UIImage = UIImage(systemName: "circle.inset.filled")!
    let offImage: UIImage = UIImage(systemName: "circle")!
    // TODOリスト用
    var todoList: [TodoStruct] = [TodoStruct]()
    // 簡易DB
    let userDefaults: UserDefaults = UserDefaults.standard
    
    // 初期表示処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let saveDate = self.userDefaults.data(forKey: self.todoKey) {
            let jsonDecode = JSONDecoder()
            if let dataList = try? jsonDecode.decode([TodoStruct].self, from: saveDate) {
                self.todoList = dataList
            }
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // self.tableView.allowsSelection = false // 選択不可
        // 左にチェックボックスを設定
//        self.tableView.allowsMultipleSelectionDuringEditing = true
//        self.tableView.setEditing(true, animated: false)
    }
    
    // ＋ボタン押下処理
    @IBAction func addButtonAction(_ sender: Any) {
        let alertControll = UIAlertController(title: "TODO追加",
                                              message: "TODOを入力してください。",
                                              preferredStyle: UIAlertController.Style.alert)
        alertControll.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,
                                     handler: {(action: UIAlertAction) in
            // OKタップ処理
            guard let textFields = alertControll.textFields else { return }
            if let texteField = textFields[0].text!.isEmpty ? nil : textFields[0].text {
                let todoStruct = TodoStruct(text: texteField, imageFlg: false)
                self.todoList.insert(todoStruct, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)],
                                          with: UITableView.RowAnimation.right)
                // TODOを保存
                self.save(object: self.todoList, key: self.todoKey)
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
                                     handler: { (action: UIAlertAction) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: self.indentCell, for: indexPath)
        // 指定行のcell.contentView.subviewsを全て削除
        cell.contentView.subviews.forEach({
            $0.removeFromSuperview()
        })
        let todo = self.todoList[indexPath.row]
        return self.setTableCell(cell, todo, indexPath)
    }
    
    // 表示するタイミングの件数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 表示するセルの数
        // print("numberOfRowsInSection cell count: \(self.todoList.count)")
        return self.todoList.count
    }

    // セル左から右へスワイプ 1-1
    // Inherited from UITableViewDelegate
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let closeAction = UIContextualAction(style: .normal,
                                             title:  "Edit",
                                             handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            // アラート・編集画面表示
            let alertControll = UIAlertController(title: "TODO編集",
                                                  message: "TODOを入力してください。",
                                                  preferredStyle: UIAlertController.Style.alert)
            alertControll.addTextField {(textFiled: UITextField) in
                textFiled.text = self.todoList[indexPath.row].text
            }
            let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
            let okAction = UIAlertAction(title: "OK",
                                         style: UIAlertAction.Style.default,
                                         handler: {(action: UIAlertAction) in
                // OKタップ処理
                guard let textFields = alertControll.textFields else { return }
                if let texteField = textFields[0].text!.isEmpty ? nil : textFields[0].text {
                    // セルをリロード
                    self.todoList[indexPath.row].text = texteField
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    // TODOを保存
                    self.save(object: self.todoList, key: self.todoKey)
                }
            })
            
            alertControll.addAction(okAction)
            alertControll.addAction(cancelButton)
            self.present(alertControll, animated: true, completion: nil)
            success(true)

        })
        closeAction.image = UIImage(systemName: "square.and.pencil")
        closeAction.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [closeAction])
    }

    // セル右から左へスワイプ
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive,
                                        title: "削除",
                                        handler: { ( _, _, handler) in
            //処理
            self.todoList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            // TODOを保存
            self.save(object: self.todoList, key: self.todoKey)
            handler(true)
        })
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false) // セル選択無効
        self.todoList[indexPath.row].imageFlg = true // todoボタンON
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        print("選択行更新 \(indexPath.row)")
    }
    
    // UserDefaultsにData型で保存
    private func save<T: Encodable>(object: T, key: String) {
        let jsonEcode = JSONEncoder()
        guard let data = try? jsonEcode.encode(object) else {
            return
        }
        self.userDefaults.set(data, forKey: key)
    }
    
    private func setTableCell(_ cell: UITableViewCell, _ todo: TodoStruct, _ indexPath: IndexPath ) -> UITableViewCell {
        let width = cell.contentView.frame.width
        let height = cell.contentView.frame.height
        print("cellForRowAt whidth: \(width)  height: \(height)")
        print("imgFlg: \(todo.imageFlg)")
        
        let imgView = UIImageView(image: todo.imageFlg ? self.onImage : self.offImage)
        imgView.contentMode = .scaleAspectFit
        let cgrec: CGRect = CGRect(x: 10.0, y:(13.0 / 2), width: 40.0, height: (height - 13.0))
        imgView.frame = cgrec
        imgView.tag = 1
        cell.contentView.addSubview(imgView)
        
        let label = UILabel()
        label.frame = CGRect(x: 50.0, y: 0, width: width - 50.0, height: height)
        label.numberOfLines = 0
        label.tag = 2
        label.text = todo.text
        cell.contentView.addSubview(label)
        return cell
    }
    
    // imageTapp
//    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
//        print("タップ")
//        let touch = sender.location(in: self.tableView)
//        if let indexPath = self.tableView.indexPathForRow(at: touch){
//            let cell = self.tableView.dequeueReusableCell(withIdentifier: self.indentCell, for: indexPath)
//            let img = cell.imageView?.image
//            print("\(img)")
//        }
//    }
}

extension UserDefaults {
    func removeAll() {
        dictionaryRepresentation().forEach({ removeObject(forKey: $0.key) })
    }
}

/** TODO構造体 */
struct TodoStruct: Codable {
    var text: String = ""
    var imageFlg: Bool = false
}
