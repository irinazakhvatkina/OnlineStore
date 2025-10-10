import UIKit
import SnapKit

class TrapezoidImageView: UIView {
    private let imageView = UIImageView()

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let width = bounds.width
        let height = bounds.height

        // Параметры
        let cornerRadius: CGFloat = 36.0
        let bottomSlantOffset: CGFloat = 40.0
        let path = UIBezierPath()

        // 1. начало и верхний левый угол
        path.move(to: CGPoint(x: cornerRadius, y: 0))

        // 2. верхний край
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))

        // 3. скругление в верхнем правом углу
        path.addQuadCurve(to: CGPoint(x: width, y: cornerRadius),
                          controlPoint: CGPoint(x: width, y: 0))

        // 4. правый вертикальный край
        let rightSlantStart = CGPoint(x: width, y: height - bottomSlantOffset - cornerRadius)
        path.addLine(to: rightSlantStart)
        
        // 5.правую вертикаль с диагональю - начало диагонали
        let rightSlantPoint = CGPoint(x: width - cornerRadius, y: height - bottomSlantOffset)
        path.addQuadCurve(to: rightSlantPoint,
                          controlPoint: CGPoint(x: width, y: height - bottomSlantOffset))

        // 6. диагональ
        let leftSlantPoint = CGPoint(x: cornerRadius, y: height)
        path.addLine(to: leftSlantPoint)

        // 7. конец левой вертикали
        path.addQuadCurve(to: CGPoint(x: 0, y: height - cornerRadius),
                          controlPoint: CGPoint(x: 0, y: height))

        // 8. левый вертикальный край
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))

        // 9. скругление в верхнем левом углу
        path.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0),
                          controlPoint: CGPoint(x: 0, y: 0))

        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        imageView.layer.mask = maskLayer
    }
}
