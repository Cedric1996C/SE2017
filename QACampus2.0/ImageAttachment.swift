import UIKit

class ImageAttachment: NSTextAttachment {
    
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        guard let image = self.image else {
            return CGRect.zero
        }
        let width = textContainer!.size.width - 2 * textContainer!.lineFragmentPadding
        let height = width * (image.size.height / image.size.width)
        return CGRect(x: 0, y: 0, width: width, height: height)
    }
    
}
