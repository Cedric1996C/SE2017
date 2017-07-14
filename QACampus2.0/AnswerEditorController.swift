import UIKit

class AnswerEditorController: DetailEditorController {
    
    @IBOutlet weak var detailViewRef: UITextView!

    override func setDetailViewReference() {
        self.detailView = detailViewRef
    }
    
    override func setDetailViewInfo() {
        self.detailViewPlaceholder = "撰写你的回答"
    }
    
    override func setType() {
        self.isAnswer = true
    }

}
