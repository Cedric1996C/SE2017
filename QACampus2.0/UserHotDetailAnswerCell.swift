import UIKit

class UserHotDetailAnswerCell: UITableViewCell {
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answererButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
