//
//  NGAddTableViewController.swift
//  ToDoApp
//
//  Created by Hiroshi Takai on 2022/02/12.
//  Copyright © 2022 ProjectStage, Inc. All rights reserved.
//

import UIKit

class NewGroupAddTVController: UITableViewController {
    
    
    @IBOutlet weak var compleateButton: UIBarButtonItem!
        
    @IBOutlet weak var addTextFiled: UITextField!
    
    // color Cell
    @IBOutlet weak var colorCell: UITableViewCell!
    // color Cell SubView
    @IBOutlet weak var cellView: UIView!
    
    let x:Double = 9.0
    let y:Double = 10.0
    var cellWidth: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //self.initRoundCorners()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.initRoundCorners()
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func completButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Color Button Settings
    private func initRoundCorners() {
//        print("cellViewheigth: \(self.cellView.frame.height)")
//        print("cellW: \(Double(self.cellView.frame.width))")
        // ( フレームの幅 - ( 間隔 * 7個 ) ) = 四角形の合計 / 6個 = 1つの四角形サイズ
        let cw = ( Double(self.cellView.frame.width) - ( self.x * 7.0 ) ) / 6.0
        print("cw: \(cw)")
        var interval = self.x
        // 6個の丸ボタンを作る
        for i in 1...6 {
            if (i != 1) {
                interval = interval + self.x
             }
//            print("index: \(i)  interval: \(interval)")
            // ベースの丸
            let baseCircle = UIView()
            baseCircle.frame = CGRect(x: interval, y: self.y, width: cw, height: cw)
            baseCircle.layer.masksToBounds = true
            baseCircle.layer.cornerRadius = cw / 2
            baseCircle.layer.backgroundColor = UIColor.gray.cgColor
            
            // 2個目中の丸
            let inCw = cw - 6.0
            let innerCircle = UIView()
            innerCircle.frame = CGRect(x: 3.0, y: 3.0, width: inCw, height: inCw)
            innerCircle.layer.masksToBounds = true
            innerCircle.layer.cornerRadius = inCw / 2
            // ダークモード判定
            if (UITraitCollection.current.userInterfaceStyle == .dark) {
                // ベースの丸と2個目の丸・色設定
//                baseCircle.layer.backgroundColor = UIColor.systemGray5.cgColor
                innerCircle.layer.backgroundColor = UIColor.systemGray5.cgColor
            } else {
                // ベースの丸と2個目の丸・色設定
//                baseCircle.layer.backgroundColor = UIColor.white.cgColor
                innerCircle.layer.backgroundColor = UIColor.white.cgColor
            }
            
            // 1個目中の丸ボタン
//            let btCw = inCw - 4.0
//            let button = UIButton()
//            button.frame = CGRect(x: 2.0, y: 2.0, width: btCw, height: btCw)
//            button.layer.masksToBounds = true
//            button.layer.cornerRadius = btCw / 2
//            button.layer.backgroundColor = UIColor.green.cgColor
//            innerCircle.addSubview(button)
            
            baseCircle.addSubview(innerCircle)
            cellView.addSubview(baseCircle)
            interval = interval + cw
        }
        
        let yy = (self.y * 2) + cw
        interval = self.x
        // 2段目のボタン
        for i in 1...6 {
            if (i != 1) {
                interval = interval + self.x
             }
//            print("index: \(i)  interval: \(interval)")
            let baseCircle = UIView()
            baseCircle.frame = CGRect(x: interval, y: yy, width: cw, height: cw)
            baseCircle.layer.masksToBounds = true
            baseCircle.layer.cornerRadius = cw / 2
            baseCircle.layer.backgroundColor = UIColor.clear.cgColor
            cellView.addSubview(baseCircle)
            interval = interval + cw
        }

        let height = (cw * 2) + (self.y * 3)
        print("height: \(height)")
        self.colorCell.frame.size.height = height
    }
}
