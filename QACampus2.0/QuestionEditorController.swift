import UIKit

class QuestionEditorController: TitleDetailEditorController {
    
    @IBOutlet weak var titleViewRef: UITextField!
    @IBOutlet weak var detailViewRef: UITextView!
    
    override func setTitleViewAndDetailViewReference() {
        self.titleView = titleViewRef
        self.detailView = detailViewRef
    }
    
    override func setDetailViewInfo() {
        self.detailViewPlaceholder = "详细描述你的问题"
    }
    
    override func setType() {
        self.isQuestion = true
    }
    
}
