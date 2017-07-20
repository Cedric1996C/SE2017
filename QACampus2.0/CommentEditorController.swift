import UIKit

class CommentEditorController: DetailEditorController {
    
    @IBOutlet weak var detailViewRef: UITextView!
    
    override func supportRichText() -> Bool {
        return true //支持富文本吗
    }
    
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
        let detailText = detailViewRef.text
        let topicId = TopicDetail.id //不知道这个变量有没有设置过
    }
}
