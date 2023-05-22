import CoreData

func createFetchedResultsController<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>, sortDescriptors: [NSSortDescriptor]? = nil, sectionNameKeyPath: String? = nil, cacheName: String? = nil) -> NSFetchedResultsController<T> {
    let context = CoreDataStack.shared.context
    fetchRequest.sortDescriptors = sortDescriptors
    let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
    return frc
}
