import UIKit
import Alamofire
import SwiftyJSON


class TitleDetailEditorController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var titleView: UITextField? = nil
    var detailView: UITextView? = nil
    
    var detailViewPlaceholder: String = "详细描述你的问题"
    var detailViewNotEdited: Bool = true
    
    var isQuestion: Bool = true
    var detailDataEncoded: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authentication()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        setTitleViewAndDetailViewReference()
        setDetailViewInfo()
        setType()
        
        titleView!.delegate = self
        detailView!.delegate = self
        
        detailViewNotEdited = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        configKeyboardEvent()
        configDetailViewKeyboard()
        configNavigationBar()
        adjustAppearance()
    }
    
    func configNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"完成",style: .plain, target: self, action: #selector(doneClicked))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"返回", style: .plain, target:self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem?.tintColor = iconColor
        self.navigationItem.rightBarButtonItem?.tintColor = iconColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func doneClicked() {
        
        let detailData = NSKeyedArchiver.archivedData(withRootObject: detailView?.attributedText as Any)
        detailDataEncoded = detailData.base64EncodedString()
//        let titleText:String = (titleView?.text)!
//        let detailText:String = (detailView?.text)!
//        
//        let length:Int = detailText.length
//        let index_length:Int = min(length,50)
//        let index = detailText.index(detailText.startIndex, offsetBy: index_length)
//        let describtion = detailText.substring(to: index)
//        print(describtion)
//        
//        let userDefault = UserDefaults.standard
//        let detailData = NSKeyedArchiver.archivedData(withRootObject: detailView?.attributedText as Any)
//     
//        let headers:HTTPHeaders = [
//            "Authorization": userAuthorization
//        ]
//        let parameters:Parameters = [
//            "que": titleText,
//            "des": detailText,
//            "asker": User.localUserId,
//            "money": 0,
//            "studio": LocalStudio.id
//        ]
//        
//        Alamofire.request("https://\(root):8443/qa-service/questions",method: .post, parameters:parameters,headers:headers).responseJSON { response in
//            debugPrint(response)
//            if response.result.value != nil {
//                // response serialization result
//                var json = JSON(response.result.value!)
//                print(json)
//                Question.ask_id = json.int!
//            }
//            
//            let path:String = "quesiotn/\(Question.ask_id)/\(User.localUserId!)"
//            userDefault.set(detailData, forKey: path)
//            prepareFile(path,destination: uploadRoot+path)
//        }

    }
    
    func cancel () {
        self.dismiss(animated: true, completion: nil)
    }
    
    func upload() {
        
        let headers:HTTPHeaders = [
           "Authorization":userAuthorization
        ]
        
        Alamofire.request("https://\(root):8443/register",method: .post, headers:headers).responseString { response in
            
        }
    }
    
    // TO BE OVERRIDDEN
    func setTitleViewAndDetailViewReference() {
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
    
    func adjustAppearance() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: titleView!.frame.height))
        titleView!.leftView = paddingView
        titleView!.leftViewMode = .always
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
            UIBarButtonItem(image: #imageLiteral(resourceName: "image"), style: .plain, target: self, action: #selector(addImage)),
            UIBarButtonItem(image: #imageLiteral(resourceName: "camera"), style: .plain, target: self, action: #selector(addPhoto)),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissDetailViewKeyboard)),
        ]
        toolBar.sizeToFit()
        detailView!.inputAccessoryView = toolBar
    }
    
    func addPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func addImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let attachment = ImageAttachment()
            attachment.image = pickedImage
            let attrString = NSAttributedString(attachment: attachment)
            detailView!.textStorage.insert(attrString, at: detailView!.selectedRange.location)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func dismissDetailViewKeyboard() {
        detailView!.resignFirstResponder()
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
    
    func addVoice () {
        
    }
    
}

