import UIKit

class CommentEditorController: DetailEditorController {
    
    @IBOutlet weak var detailViewRef: UITextView!
    
    override func setDetailViewReference() {
        self.detailView = detailViewRef
    }
    
    override func setDetailViewInfo() {
        self.detailViewPlaceholder = "撰写评论"
    }
    
    override func setType() {
        self.isAnswer = true
    }
    
    override func doneClicked() {
        super.doneClicked()
    }
}
