//
//  UIAlertControllerHelpers.swift
//
//  Created by Sirichai Monhom on 11/14/18.
//

import UIKit
import PromiseKit

extension UIAlertController {
    
    enum BasicAction {
        case cancel, ok, confirm
        
        func `do`(callback: @escaping () -> Void) -> UIAlertAction {
            switch self {
            case .cancel:
                return UIAlertAction(title: "ALERT_CANCEL_BUTTON".localized, style: .cancel) { (_) in
                    callback()
                }
            case .confirm:
                return UIAlertAction(title: "ALERT_CONFIRM_BUTTON".localized, style: .default) { (_) in
                    callback()
                }
            case .ok:
                return UIAlertAction(title: "ALERT_OK_BUTTON".localized, style: .default) { (_) in
                    callback()
                }
            }
        }
    }
    
    static func informAndWait(title:String? = nil, message:String, on:UIViewController) -> Promise<Void> {
        return wrap { (cb: @escaping () -> Void) in
            self.inform(title:title, message: message, on: on, done: cb)
        }
    }
    
    static func inform(title:String? = nil, message:String, on:UIViewController, done: (() -> Void)? = nil) {
        let ctrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ctrl.addAction(BasicAction.ok.do {
            done?()
        })
        on.present(ctrl, animated: true, completion: nil)
    }

    static func confirm(message:String, on:UIViewController) -> Promise<Bool> {
        return wrap { (done: @escaping (Bool) -> Void) in
            let ctrl = UIAlertController(title: "", message: message, preferredStyle: .alert)
            ctrl.addAction(BasicAction.cancel.do {
                done(false)
            })
            ctrl.addAction(BasicAction.confirm.do {
                done(true)
            })
            
            on.present(ctrl, animated: true, completion: nil)
        }
    }
    
}


extension Error {
    
    func alert(on:UIViewController) {
        UIAlertController.inform(title: "ERROR_REPORT_ALERT_TITLE".localized, message: self.localizedDescription, on: on)
    }
    
    func alertInform(vc:UIViewController, handler: @escaping (() -> Void)) {
        UIAlertController.informAndWait(message: self.localizedDescription, on: vc).then(on: .main) {  (_) -> Void in
            handler()
            }
            .catch { (e) in
                // never happen.
        }
    }
}
