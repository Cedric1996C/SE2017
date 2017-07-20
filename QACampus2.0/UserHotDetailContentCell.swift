import UIKit
import Alamofire
import SwiftyJSON

class UserHotDetailContentCell: UITableViewCell {
    
    var controller: UserHotDetailViewController? = nil
    
    var userId: Int = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var askerButton: UIButton!
    
    @IBAction func toUserPage(_ sender: Any) {
        // TODO: segue to user page
    }
    
    @IBAction func likePressed(_ sender: Any) {
        controller?.like(Detail.questionId)
    }
    
    @IBAction func commentPressed(_ sender: Any) {
        // TODO: comment
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
