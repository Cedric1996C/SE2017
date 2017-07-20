import UIKit
import Alamofire
import SwiftyJSON

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
        
        let headers:HTTPHeaders = [
            "Authorization": userAuthorization,
        ]
        
        let parameters:Parameters = [
            "content":detailText,
            "wid": String(User.localUserId)
        ]
        
        Alamofire.request("https://\(root):8443/topic-service/topic/\(TopicDetail.id)/comment",method: .post, parameters:parameters,headers:headers).responseJSON { response in
            debugPrint(response)
        }
      

    }
}
