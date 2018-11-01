//
//  ViewController.swift
//  textFieldAdjustWithSoftKeyboard
//
//  Created by Jack Wong on 2018/06/28.
//  Copyright © 2018 Jack Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBC: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerGestureRecognizer()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        txtName.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    private func registerGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(tap)
    }
    @objc private func endEditing() {
        self.view.endEditing(true)
    }
    
    @objc private func keyBoardWillShow(notification: Notification) {
      //  adjustHeight(show: true, notification: notification)
        if let userInfo = notification.userInfo as? Dictionary<String,AnyObject> {
            let frame = userInfo[UIKeyboardFrameEndUserInfoKey]
            let keyBoardRect = frame?.cgRectValue
            let keyBoardHeight = keyBoardRect?.height
            self.txtBC.constant = keyBoardHeight!
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyBoardWillHide(notification: Notification) {
       adjustHeight(show: false, notification: notification)
    }
    
    private func adjustHeight(show: Bool, notification: Notification) {
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        // 3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 4
        let changeInHeight = (keyboardFrame.height * (show ? 1 : -1))
        //5
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.txtBC.constant += changeInHeight
        })
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
