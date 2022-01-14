//
//  ViewController.swift
//  ToDoApp
//
//  Created by tkMBA on 2022/01/14.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var todoList: [String] = ["TestTODO"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
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
            }
        })
        alertControll.addAction(okAction)
        let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        alertControll.addAction(cancelButton)
        present(alertControll, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.todoList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 表示するセルの数
        return self.todoList.count
    }
}

