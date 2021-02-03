import Cocoa

class SearchField: NSSearchField {

    var shouldAnimate = false {
        willSet(value) {
            if value {
                progressIndicator.startAnimation(nil)
            } else {
                progressIndicator.stopAnimation(nil)
            }
        }
    }

    private let progressIndicator = NSProgressIndicator.makeCustom()

    init() {
        super.init(frame: .zero)
        addSubview(progressIndicator)
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        let offset = rectForCancelButton(whenCentered: false).width + 16
        let constraints = [
            progressIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset),
            progressIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func rectForSearchText(whenCentered isCentered: Bool) -> NSRect {
        let o = super.rectForSearchText(whenCentered: false)
        let offset = progressIndicator.bounds.width + 8
        return NSRect(x: o.origin.x, y: o.origin.y, width: o.size.width - offset, height: o.size.height)
    }
}
