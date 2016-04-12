//
//  AddBillViewController.swift
//  XYBill
//
//  Created by 薛焱 on 16/3/3.
//  Copyright © 2016年 薛焱. All rights reserved.
//

import UIKit

class AddBillViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var inAndOutButton: UIButton!
    @IBOutlet weak var accountPacker: UIPickerView!
    @IBOutlet weak var datePacker: UIDatePicker!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var datePickerBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var PickerViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var dataPickerView: UIView!
    @IBOutlet weak var accountPickerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var moenyTF: UITextField!
    @IBOutlet weak var alertTopMargin: NSLayoutConstraint!
    var margin:CGFloat = -250
    var alertMargin: CGFloat = 100
    var cellView: Cell!
    var pickerArray: [String]!
    var accountStr: String!
    var money: CGFloat = 0
    var currentDate: String!
    var type: String = ""
    var userInfo: NSUserDefaults!
    var dataArray:NSMutableArray!
    
    override func viewDidAppear(animated: Bool) {
        var indexPath:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        if userInfo.integerForKey("indexPath") != 0 {
            indexPath = NSIndexPath(forRow: userInfo.integerForKey("indexPath"), inSection:0 )
        }
        collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerArray = ["现金","支付宝","银行卡"]
        accountStr = "现金"
        userInfo = NSUserDefaults.standardUserDefaults()
        readDataSource()
        
        moenyTF.delegate = self
        moenyTF.becomeFirstResponder()
        commitButtonAction(UIButton())
        NSNotificationCenter.defaultCenter().addObserver(self, selector:
            (#selector(AddBillViewController.changeFrame(_:))), name: UIKeyboardWillChangeFrameNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func readDataSource() {
        dataArray = userInfo.objectForKey("userInfo")?.mutableCopy() as! NSMutableArray
        collectionView.reloadData()
    }
    
    @IBAction func inAndOutButton(sender: UIButton) {
        if sender.titleLabel!.text == "收入" {
            sender.setTitle("支出", forState: .Normal)
        }else{
            sender.setTitle("收入", forState: .Normal)
        }
    }
    
    func changeFrame(sender: NSNotification) {
        bottomMargin.constant = UIScreen.mainScreen().bounds.size.height - sender.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue.origin.y + 1
        UIView.animateWithDuration(NSTimeInterval(sender.userInfo![UIKeyboardAnimationDurationUserInfoKey]! as! NSNumber)) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    //添加新类型
    @IBAction func cancleBtnAction(sender: UIButton) {
        hiddenAlertView()
    }
    @IBAction func commitBtnAction(sender: UIButton) {
        if typeTF.text != nil {
            dataArray.addObject(typeTF.text!)
            userInfo.setObject(dataArray, forKey: "userInfo")
            readDataSource()
        }
        hiddenAlertView()
    }
    //Picker View
    @IBAction func dataPickerAction(sender: AnyObject) {
        view.endEditing(true)
        datePickerBottomMargin.constant = 0
        UIView.animateWithDuration(0.3) { () -> Void in
            self.maskView.alpha = 0.5
            self.dataPickerView.layoutIfNeeded()
        }
    }
    
    @IBAction func accountPickerAction(sender: AnyObject) {
        view.endEditing(true)
        PickerViewBottomMargin.constant = 0
        UIView.animateWithDuration(0.3) { () -> Void in
            self.maskView.alpha = 0.5
            self.accountPickerView.layoutIfNeeded()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        cancleButtonAction(UIButton())
        hiddenAlertView()
    }
    
    @IBAction func cancleButtonAction(sender: AnyObject) {
        datePickerBottomMargin.constant = margin
        PickerViewBottomMargin.constant = margin
        UIView.animateWithDuration(0.3) { () -> Void in
            self.maskView.alpha = 0
            self.dataPickerView.layoutIfNeeded()
            self.accountPickerView.layoutIfNeeded()
        }
        moenyTF.becomeFirstResponder()
    }
    @IBAction func commitButtonAction(sender: AnyObject) {
        let selectDate = datePacker.date
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM月dd日HH时"
        let dateStr = formatter.stringFromDate(selectDate)
        timeButton.setTitle(dateStr, forState: .Normal)
        cancleButtonAction(sender)
    }
    
    @IBAction func accountCommitButtonAction(sender: UIButton) {
        accountButton.setTitle(accountStr, forState: .Normal)
        cancleButtonAction(sender)
    }
    //MARK: - UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerArray[row]
    }
    //MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        accountStr = pickerArray[row]
    }
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize    {
        return CGSize(width: 60, height: 40)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    //MARK: - UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count + 1;
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BillTypeCell", forIndexPath: indexPath) as! BillTypeCell
        if indexPath.row == dataArray.count {
            cell.title.text = "+"
        }else{
            cell.title.text = dataArray[indexPath.row] as? String
        }
        return cell
    }
    //MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == dataArray.count {
            showAlertView()
            return
        }else{
            if cellView != nil{
                cellView.removeFromSuperview()
            }
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BillTypeCell
            cellView = NSBundle.mainBundle().loadNibNamed("Cell", owner: self, options: nil).last as! Cell
            cellView.frame = cell.frame
            cellView.title.text = cell.title.text
            self.collectionView.addSubview(cellView)
            type = cell.title.text!
            userInfo.setInteger(indexPath.row, forKey: "indexPath")
        }
    }
    
    func showAlertView() {
        alertTopMargin.constant = alertMargin
        view.endEditing(true)
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .TransitionNone, animations: {
            self.view.layoutIfNeeded()
            self.maskView.alpha = 0.5
            }, completion: nil)
    }
    func hiddenAlertView() {
        alertTopMargin.constant = -100
        view.endEditing(true)
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .TransitionNone, animations: {
            self.view.layoutIfNeeded()
            self.maskView.alpha = 0
            }, completion: nil)
        moenyTF.becomeFirstResponder()
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.performSegueWithIdentifier("back", sender: nil)
        return true
    }
    
    @IBAction func commiteItemAction(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("back", sender: nil)
    }
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let array = DataHelper.shareDataHelper().queryAllModel()
        var i:NSInteger
        if array.count == 0 {
            i = 0
        }else{
            let mod = array.lastObject as! Model
            i = NSInteger(mod.id)!
            i += 1
        }
        
        let model = Model()
        model.id = "\(i)"
        model.account = accountButton.titleLabel?.text
        model.type = type
        model.money = moenyTF.text
        model.date = timeButton.titleLabel?.text
        model.inAndOut = inAndOutButton.titleLabel?.text
        if moenyTF.text != "" {
            DataHelper.shareDataHelper().insertModel(model)
        }
    }
    

}
