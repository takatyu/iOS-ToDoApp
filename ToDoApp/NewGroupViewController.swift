//
//  NewGroupViewController.swift
//  ToDoApp
//
//  Created by Hiroshi Takai on 2022/02/11.
//  Copyright © 2022 ProjectStage, Inc. All rights reserved.
//

import UIKit

class NewGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var completeButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        completeButton.isEnabled = false // comleteButton disabled
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Cancel Button
    @IBAction func cancelButtonAction(_ sender: Any) {
        print("キャンセルボタン")
        self.dismiss(animated: true, completion: nil)
    }
    
    // Complete Button
    @IBAction func addCompleteAction(_ sender: Any) {
        print("完了ボタン")
    }
}
