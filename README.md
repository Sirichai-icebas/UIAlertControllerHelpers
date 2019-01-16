# UIAlertControllerHelpers

example1 :  UIAlertController with callback 
//Code
UIAlertController.informAndWait(message: self.localizedDescription, on: vc).then(on: .main) {  (_) -> Void in
            handler()
            // Call callback
            }
            .catch { (e) in
                 // Do something
        }
        
        
        
   example2 :  Error Extension in case error 
   // Code
   .catch { (error) in
                    error.alertInform(vc: self, handler: {
                        // Do something
                    })
