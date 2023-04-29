import UIKit

private struct Constants {
    static let labelPadding: CGFloat = 8.0
    static let detailLabelFont = UIFont.systemFont(ofSize: 14.0)
    static let detailLabelTextColor = UIColor.gray
    static let labelTextAlignment = NSTextAlignment.center
}

class NameDetailCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = Constants.labelTextAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.detailLabelFont
        label.textColor = Constants.detailLabelTextColor
        label.textAlignment = Constants.labelTextAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        detailLabel.text = ""
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.labelPadding),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.labelPadding),
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.labelPadding),
            detailLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor)
        ])
    }
}

extension NameDetailCell: ConfigurableViewProtocol {
    typealias ConfigurationModel = NameDetailCellModel
    func configure(with model: ConfigurationModel) {
        nameLabel.text = model.name
        detailLabel.text = model.detail
    }
}
