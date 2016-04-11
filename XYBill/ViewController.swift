//
//  ViewController.swift
//  XYBill
//
//  Created by 薛焱 on 16/3/3.
//  Copyright © 2016年 薛焱. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet var pan: UIPanGestureRecognizer!
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var dataArray: NSMutableArray!
    var offsetY:CGFloat = 0
    var model: Model!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataArray = NSMutableArray()
        readDataSource()
    }
    
    func readDataSource() {
        dataArray = DataHelper.shareDataHelper().queryAllModel()
    }
    
    @IBAction func panAction(sender: UIPanGestureRecognizer) {
        
        if sender.state == .Changed {
            let constant = self.topMargin.constant
            print(sender.translationInView(sender.view).y)
            self.topMargin.constant = constant + sender.translationInView(self.headerView).y
            if self.topMargin.constant > 100 {
                self.topMargin.constant = 100
            }
        }
        if sender.state == .Ended {
            if self.topMargin.constant < 50 {
                self.topMargin.constant = 0
            }else{
                self.topMargin.constant = 100
            }
            
        }
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutIfNeeded()
        }
        sender.setTranslation(CGPoint(), inView: sender.view)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func unwindToViewController(sender: UIStoryboardSegue){
        dataArray = DataHelper.shareDataHelper().queryAllModel()
        tableView.reloadData()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let model = dataArray[indexPath.row] as! Model
        cell.textLabel?.text = "\(model.inAndOut)   \(model.date)   \(model.type)   \(model.money)   \(model.account)"
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -50 {
            self.topMargin.constant = 100
        }
        if scrollView.contentOffset.y > 0 && offsetY < scrollView.contentOffset.y {
            self.topMargin.constant = 0

        }
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutIfNeeded()
        }
        offsetY = scrollView.contentOffset.y
    }
}

