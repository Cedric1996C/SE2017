import UIKit
import Alamofire
import SwiftyJSON

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
    
    override func supportRichText() -> Bool {
        return true //支持富文本吗
    }
    
    override func setType() {
        self.isQuestion = false
    }
    
    override func doneClicked() {
        super.doneClicked()
        let titleText:String = (titleView?.text)!
        let detailText:String = (detailView?.text)!
        
        let length:Int = detailText.length
        let index_length:Int = min(length,50)
        let index = detailText.index(detailText.startIndex, offsetBy: index_length)
        let describtion = detailText.substring(to: index)
        
        let userDefault = UserDefaults.standard
        let detailData = NSKeyedArchiver.archivedData(withRootObject: detailView?.attributedText as Any)
        
        let headers:HTTPHeaders = [
            "Authorization": userAuthorization
        ]
        let parameters:Parameters = [
            "title": titleText,
            "brief": describtion,
            "write_id": User.localUserId,
            "content": detailText,
            "sid": LocalStudio.id
        ]
        
        Alamofire.request("https://\(root):8443/topic-service/topic",method: .post, parameters:parameters,headers:headers).responseJSON { response in
            debugPrint(response)
            if response.result.value != nil {
                // response serialization result
                var json = JSON(response.result.value!)
                print(json)
                Question.ask_id = json.intValue
            }
            
            let path:String = "topic/\(Question.ask_id)/\(User.localUserId!)"
            userDefault.set(detailData, forKey: path)
            prepareFile(path,destination: uploadRoot+path)
        }

    }
    
}
