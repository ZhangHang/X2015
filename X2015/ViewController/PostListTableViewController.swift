//
//  PostListTableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData

class PostListTableViewController: UITableViewController, ManagedObjectContextSettable {
    
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: Post.entityName)
        fetchRequest.sortDescriptors = Post.defaultSortDescriptors
        
        fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultController.delegate = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        try! self.fetchedResultController.performFetch()
        super.viewWillDisappear(animated)
    }
}

extension PostListTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections![section].objects?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(PostListTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? PostListTableViewCell else {
            fatalError("Wrong table view cell type")
        }
        
        cell.configure(postAt(indexPath))
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
}

extension PostListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            break
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            break
        case .Move:
            self.tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
            break
        case .Update:
            self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            break
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
}

extension PostListTableViewController {
    
    func postAt(indexPath: NSIndexPath) -> Post {
        guard let post = fetchedResultController.objectAtIndexPath(indexPath) as? Post else {
            fatalError("Can't find post object at indexPath \(indexPath)")
        }
        return post
    }
    
}

extension PostListTableViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let vc = segue.destinationViewController as? PostEditViewController else {
            fatalError("Wrong edit-viewcontroller")
        }
        guard let selectedIndexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("No selected indexPath")
        }
        
        vc.post = postAt(selectedIndexPath)
    }

}

final class PostListTableViewCell: UITableViewCell, ConfigureableCell {
    
    static var reuseIdentifier: String! {
        return "PostListTableViewCell"
    }
    
    
    func configure(post: Post) {
        self.textLabel!.text = post.title
        self.detailTextLabel!.text = post.content
    }
    
}

