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
    @IBOutlet weak var dataTopMargin: NSLayoutConstraint!
    @IBOutlet weak var accountTopMargin: NSLayoutConstraint!
    @IBOutlet weak var dataPickerView: UIView!
    @IBOutlet weak var accountPickerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var moenyTF: UITextField!
    var cellView: Cell!
    var pickerArray: [String]!
    var accountStr: String!
    var money: CGFloat!
    var currentDate: String!
    var type: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerArray = ["现金","支付宝","银行卡"]
        accountStr = "现金"
        moenyTF.delegate = self
        moenyTF.becomeFirstResponder()
        commitButtonAction(UIButton())
        NSNotificationCenter.defaultCenter().addObserver(self, selector:
            ("changeFrame:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        // Do any additional setup after loading the view.
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

    @IBAction func dataPickerAction(sender: AnyObject) {
        
        view.endEditing(true)
        dataTopMargin.constant = 182
        UIView.animateWithDuration(0.3) { () -> Void in
            self.dataPickerView.alpha = 1
            self.dataPickerView.layoutIfNeeded()
        }
    }
    
    @IBAction func accountPickerAction(sender: AnyObject) {
        view.endEditing(true)
        accountTopMargin.constant = 182
        UIView.animateWithDuration(0.3) { () -> Void in
            self.accountPickerView.alpha = 1
            self.accountPickerView.layoutIfNeeded()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        cancleButtonAction(UIButton())
    }
    
    
    
    @IBAction func cancleButtonAction(sender: AnyObject) {
        dataTopMargin.constant = UIScreen.mainScreen().bounds.size.height
        accountTopMargin.constant = UIScreen.mainScreen().bounds.size.height
        UIView.animateWithDuration(0.3) { () -> Void in
            self.dataPickerView.alpha = 0
            self.accountPickerView.alpha = 0
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
        return 10;
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BillTypeCell", forIndexPath: indexPath) as! BillTypeCell
        return cell
    }
    //MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if cellView != nil{
            cellView.removeFromSuperview()
        }
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BillTypeCell
        cellView = NSBundle.mainBundle().loadNibNamed("Cell", owner: self, options: nil).last as! Cell
        cellView.frame = cell.frame
        cellView.title.text = cell.title.text
        self.collectionView.addSubview(cellView)
        type = cell.title.text
    }
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.performSegueWithIdentifier("back", sender: nil)
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let VC = segue.destinationViewController as! ViewController
        let model = Model()
        model.account = accountButton.titleLabel?.text
        model.type = type
        model.money = CGFloat((moenyTF.text! as NSString).floatValue)
        model.date = timeButton.titleLabel?.text
        model.inAndOut = inAndOutButton.titleLabel?.text
        VC.model = model
    }
    

}
