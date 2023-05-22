import UIKit

func createSearchBar(placeholder: String) -> UISearchBar {
    let searchBar = UISearchBar()
    searchBar.placeholder = placeholder
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    return searchBar
}
