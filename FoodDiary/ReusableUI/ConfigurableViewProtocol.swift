import Foundation

protocol ConfigurableViewProtocol: AnyObject {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}
