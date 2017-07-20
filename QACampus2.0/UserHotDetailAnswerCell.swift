import UIKit

class UserHotDetailAnswerCell: UITableViewCell {
    
    var userId: Int = 0
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answererButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func toUserPage(_ sender: Any) {
        // TODO: segue to user page
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
