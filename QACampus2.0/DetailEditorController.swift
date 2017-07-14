import UIKit

class DetailEditorController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
    
    var detailView: UITextView? = nil
    
    var detailViewPlaceholder: String = "详细描述你的问题"
    var detailViewNotEdited: Bool = true
    
    var isAnswer: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        setDetailViewReference()
        setDetailViewInfo()
        setType()
        
        detailView!.delegate = self
        
        detailViewNotEdited = true
        
        configKeyboardEvent()
        configDetailViewKeyboard()
        adjustAppearance()
    }
    
    // TO BE OVERRIDDEN
    func setDetailViewReference() {
        preconditionFailure()
    }
    
    // TO BE OVERRIDDEN
    func setDetailViewInfo() {
        preconditionFailure()
    }
    
    // TO BE OVERRIDDEN
    func setType() {
        preconditionFailure()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if detailViewNotEdited {
            textView.text = ""
            detailViewNotEdited = false
            detailView!.textColor = UIColor.black
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if detailView!.text.length == 0 {
            putDetailViewPlaceholder()
        }
        return true
    }
    
    func adjustAppearance() {
        putDetailViewPlaceholder()
    }
    
    func putDetailViewPlaceholder() {
        detailViewNotEdited = true
        detailView!.text = detailViewPlaceholder
        detailView!.textColor = UIColor.lightGray
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func configKeyboardEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func configDetailViewKeyboard() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissDetailViewKeyboard)),
        ]
        toolBar.sizeToFit()
        detailView!.inputAccessoryView = toolBar
    }
    
    func dismissDetailViewKeyboard() {
        detailView!.resignFirstResponder()
        if detailView!.text.isEmpty {
            putDetailViewPlaceholder()
        }
    }
    
    func keyboardDidShow(aNotification: NSNotification) {
        let info = aNotification.userInfo
        let infoNSValue = info![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let kbSize = infoNSValue.cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        detailView!.contentInset = contentInsets
        detailView!.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillHide(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        detailView!.contentInset = contentInsets
        detailView!.scrollIndicatorInsets = contentInsets
    }
    
}

