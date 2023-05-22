import UIKit

func createTableView(cellIdentifier: String) -> UITableView {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    return tableView
}
