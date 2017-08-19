import UIKit
import RxSugar
import RxSwift

class BubbleView: UIButton {
    private let name = UILabel()
    private let time = UILabel()
    private let eventDescription = UILabel()
    private let directions = UIButton()
    private var contentHidden = true
    
    func updateEvent() {
        contentHidden = false
        setNeedsLayout()
    }
    
    let selectDirection: Observable<Void>
    
    var event: Event? {
        didSet {
            name.text = event?.name
            eventDescription.text = event?.description
            if let start = event?.startTime, let end = event?.endTime {
                time.text = "\(start) - \(end)"
            }
            isUserInteractionEnabled = true
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        selectDirection = directions.rxs.tap
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = UIColor(hue: CGFloat(arc4random_uniform(100))/100.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        addShadow(withRadius: 8)
        styleLabels(labels: [name, eventDescription, time])
        name.font = UIFont.systemFont(ofSize: 22)
        addSubview(name)
        time.font = UIFont.systemFont(ofSize: 18)
        addSubview(time)
        eventDescription.font = UIFont.systemFont(ofSize: 16)
        eventDescription.numberOfLines = 4
        addSubview(eventDescription)
        directions.layer.borderWidth = 1
        directions.layer.borderColor = UIColor.white.cgColor
        directions.setTitle("Directions", for: .normal)
        directions.setTitleColor(.white, for: .normal)
        addSubview(directions)
    }
    
    private func styleLabels(labels: [UILabel]) {
        labels.forEach {
            $0.adjustsFontSizeToFitWidth = true
            $0.textColor = .white
            $0.textAlignment = .center
            $0.numberOfLines = 3
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        time.isHidden = contentHidden
        eventDescription.isHidden = contentHidden || eventDescription.text == ""
        directions.isHidden = contentHidden
        layer.cornerRadius = bounds.width/2
        let contentArea = bounds.insetBy(dx: Padding.small, dy: Padding.small)
        let nameSize = name.sizeThatFits(contentArea.size)
        let timeSize = time.sizeThatFits(contentArea.size)
        let descriptionSize = eventDescription.isHidden ? CGSize.zero : eventDescription.sizeThatFits(contentArea.size)
//        let directionSize = CGSize(width: 88, height: 88)
        let directionSize = directions.sizeThatFits(contentArea.size)
        let totalHeight = contentHidden ? nameSize.height : nameSize.height + Padding.large + timeSize.height + Padding.large + descriptionSize.height + Padding.large + directionSize.height
        name.frame = CGRect(x: contentArea.midX - nameSize.width/2, y: contentArea.midY - totalHeight/2, size: nameSize)
        time.frame = CGRect(x: contentArea.midX - timeSize.width/2, y: name.frame.maxY + Padding.large, size: timeSize)
        eventDescription.frame = CGRect(x: contentArea.midX - descriptionSize.width/2, y: time.frame.maxY + Padding.large, size: descriptionSize)
        directions.frame = CGRect(x: contentArea.midX - directionSize.width/2, y: eventDescription.frame.maxY + Padding.large, width: directionSize.width + Padding.small, height: directionSize.height)
    }
    
    private func addShadow(withRadius radius: CGFloat) {
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.75
        layer.shadowRadius = radius
    }
}