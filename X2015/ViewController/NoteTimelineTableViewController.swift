//
//  NoteTimelineTableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData

class NoteTimelineTableViewController: UITableViewController, ManagedObjectContextSettable {
    
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultController: NSFetchedResultsController!
    
    /*
    * workaround for http://stackoverflow.com/questions/34694178/using-3d-touch-with-storyboards-peek-and-pop
    */
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: Note.entityName)
        fetchRequest.sortDescriptors = Note.defaultSortDescriptors
        
        fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultController.delegate = self
        self.tableView.backgroundView = EmptyNoteWelcomeView.instantiateFromNib()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        try! self.fetchedResultController.performFetch()
        self.updateWelcomeViewVisibility()
        super.viewWillDisappear(animated)
    }
    
}

extension NoteTimelineTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].objects?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(NoteTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? NoteTableViewCell else {
            fatalError("Wrong table view cell type")
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? NoteTableViewCell else {
            fatalError("Wrong table view cell type")
        }
        
        cell.configure(NoteAt(indexPath))
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
}

extension NoteTimelineTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            break
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
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
        self.updateWelcomeViewVisibility()
        self.tableView.endUpdates()
    }
    
}

extension NoteTimelineTableViewController {
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .Default, title: "Delete", handler: { [unowned self](action, indexPath) -> Void in
            self.managedObjectContext.performChanges({ [unowned self] () -> () in
                self.managedObjectContext.deleteObject(self.NoteAt(indexPath))
                })
            })]
    }
    
}

extension NoteTimelineTableViewController {
    
    func NoteAt(indexPath: NSIndexPath) -> Note {
        guard let Note = fetchedResultController.objectAtIndexPath(indexPath) as? Note else {
            fatalError("Can't find Note object at indexPath \(indexPath)")
        }
        return Note
    }
    
}

extension NoteTimelineTableViewController {
    
    func updateWelcomeViewVisibility() {
        if self.fetchedResultController.fetchedObjects?.count == 0 {
            self.tableView.backgroundView?.hidden = false
        }else {
            self.tableView.backgroundView?.hidden = true
        }
    }
    
}


/*
 * workaround for http://stackoverflow.com/questions/34694178/using-3d-touch-with-storyboards-peek-and-pop
 */
extension NoteTimelineTableViewController {
 
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        self.selectedIndexPath = indexPath
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = nil
    }

}


extension NoteTimelineTableViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let identifier = segue.identifier else {
            fatalError("No segue identifier found")
        }
        
        switch identifier {
        case NoteEditViewController.SegueIdentifier.Edit.identifier():
            guard
                let vc = segue.destinationViewController as? NoteEditViewController,
                let selectedIndexPath = self.selectedIndexPath else {
                    fatalError("Wrong edit-viewcontroller")
            }
            
            vc.managedObjectContext = self.managedObjectContext
            vc.setup(self.NoteAt(selectedIndexPath), managedObjectContext: self.managedObjectContext)
            break
        case NoteEditViewController.SegueIdentifier.Create.identifier():
            guard let vc = segue.destinationViewController as? NoteEditViewController else {
                fatalError("Wrong edit-viewcontroller")
            }
            vc.setup(managedObjectContext)
            break
        default:
            break
        }
    }
    
}

final class NoteTableViewCell: UITableViewCell, ConfigureableCell {
    
    static var reuseIdentifier: String! {
        return "NoteTableViewCell"
    }
    
    func configure(note: Note) {
        self.textLabel!.text = note.title
        self.detailTextLabel!.text = note.preview
    }
    
}
