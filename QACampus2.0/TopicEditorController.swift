import UIKit

class TopicEditorController: TitleDetailEditorController {
    
    @IBOutlet weak var titleViewRef: UITextField!
    @IBOutlet weak var detailViewRef: UITextView!
    
    override func setTitleViewAndDetailViewReference() {
        self.titleView = titleViewRef
        self.detailView = detailViewRef
    }
    
    override func setDetailViewInfo() {
        self.detailViewPlaceholder = "详细阐述你的话题"
    }
    
    override func setType() {
        self.isQuestion = false
    }
    
}
