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
            "Authorization": userAuthorization
        ]
        let parameters:Parameters = [
            "qid": detailText,
            "detail":"",
            "answer":""
        ]
        
        Alamofire.request("https://\(root):8443/qa-service/questions/\(Question.ask_id)/answers",method: .post, parameters:parameters,headers:headers).responseJSON { response in
            debugPrint(response)
            if response.result.value != nil {
                // response serialization result
                var json = JSON(response.result.value!)
                print(json)
                Question.ask_id = json.int!
            }
            
            let path:String = "quesiotn/\(Question.ask_id)/\(User.localUserId!)"
            userDefault.set(detailData, forKey: path)
            prepareFile(path,destination: uploadRoot+path)
        }
        

    }
}
