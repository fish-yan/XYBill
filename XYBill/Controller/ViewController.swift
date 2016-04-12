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
    @IBOutlet weak var XJLab: UILabel!
    @IBOutlet weak var ZFBLab: UILabel!
    @IBOutlet weak var YHKlab: UILabel!
    @IBOutlet weak var remainMoneyLab: UILabel!
    @IBOutlet weak var inMoneyLab: UILabel!
    @IBOutlet weak var outMoneyLab: UILabel!
    
    var dataArray: NSMutableArray!
    var offsetY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataArray = NSMutableArray()
        readDataSource()
    }
    
    func readDataSource() {
        dataArray = DataHelper.shareDataHelper().queryAllModel()
        var inMoney: CGFloat = 0
        var outMoney: CGFloat = 0
        var inYHKMoney: CGFloat = 0
        var inZFBMoney: CGFloat = 0
        var inXJMoney: CGFloat = 0
        var outYHKMoney: CGFloat = 0
        var outZFBMoney: CGFloat = 0
        var outXJMoney: CGFloat = 0
        for mod in dataArray {
            let model = mod as! Model
            if model.inAndOut == "收入" {
                inMoney += CGFloat((model.money as NSString).floatValue)
                if model.account == "银行卡" {
                    inYHKMoney += CGFloat((model.money as NSString).floatValue)
                }else if(model.account == "支付宝"){
                    inZFBMoney += CGFloat((model.money as NSString).floatValue)
                }else{
                    inXJMoney += CGFloat((model.money as NSString).floatValue)
                }
            }else{
                outMoney += CGFloat((model.money as NSString).floatValue)
                if model.account == "银行卡" {
                    outYHKMoney += CGFloat((model.money as NSString).floatValue)
                }else if(model.account == "支付宝"){
                    outZFBMoney += CGFloat((model.money as NSString).floatValue)
                }else{
                    outXJMoney += CGFloat((model.money as NSString).floatValue)
                }
            }
        }
        
        inMoneyLab.text = "\(inMoney)"
        outMoneyLab.text = "\(outMoney)"
        remainMoneyLab.text = "\(inMoney - outMoney)"
        
        YHKlab.text = "\(inYHKMoney - outYHKMoney)"
        ZFBLab.text = "\(inZFBMoney - outZFBMoney)"
        XJLab.text = "\(inXJMoney - outXJMoney)"
        
        tableView.reloadData()
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
        readDataSource()
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath) as! ListCell
        let model = dataArray[indexPath.row] as! Model
        cell.titleLab.text = "\(model.inAndOut)   \(model.date)   \(model.type)   \(model.money)   \(model.account)"
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

