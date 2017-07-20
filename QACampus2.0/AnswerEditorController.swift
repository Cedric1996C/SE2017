import UIKit
import Alamofire
import SwiftyJSON

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
    
    override func supportRichText() -> Bool {
        return true //支持富文本吗
    }
    
    override func doneClicked() {
        super.doneClicked()
        let detailText:String = (detailView?.text)!
        let length:Int = detailText.length
        let index_length:Int = min(length,50)
        let index = detailText.index(detailText.startIndex, offsetBy: index_length)
        let describtion = detailText.substring(to: index)
        
        let userDefault = UserDefaults.standard
        let detailData = NSKeyedArchiver.archivedData(withRootObject: detailView?.attributedText as Any)
        
        let headers:HTTPHeaders = [
            "Authorization": userAuthorization,
            "uid": String(User.localUserId!)
        ]
        
        let parameters:Parameters = [
            "details":describtion,
            "answer":describtion
        ]
        
        Alamofire.request("https://\(root):8443/qa-service/questions/\(Question.question_id)/answers",method: .post, parameters:parameters,headers:headers).responseJSON { response in
            debugPrint(response)
            if response.result.value != nil {
                // response serialization result
                var json = JSON(response.result.value!)
                print(json)
                Question.question_id = json.int!
            }
            
            let path:String = "quesiotn/\(Question.question_id)/\(User.localUserId!)/answer"
            userDefault.set(detailData, forKey: path)
            prepareFile(path,destination: uploadRoot+path)
        }
        

    }
}
