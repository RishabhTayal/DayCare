//
//  DCDailyReportViewController.swift
//  DayCare
//
//  Created by Tayal, Rishabh on 3/27/16.
//  Copyright © 2016 Tayal, Rishabh. All rights reserved.
//

import UIKit
import XLForm

class DCSubmitRoutineViewController: XLFormViewController {
    
    private struct Tags {
        static let Feeding = "feeding"
        static let Napped = "napped"
        static let Diaparing = "diaparing"
    }
    
    var child: DCChild!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = child.name
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(cancelTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(doneTapped(_:)))
    }
    
    func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doneTapped(sender: AnyObject) {
        
        let reportObj = DCRoutine()
        reportObj.child = child
        reportObj.diaparing = NSDate()
        reportObj.date = NSDate()
        reportObj.saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
            ServiceCaller.sendPush("New Routine", completion: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func initialForm() {
        
        let form: XLFormDescriptor
        var section: XLFormSectionDescriptor
        var row: XLFormRowDescriptor
        
        form = XLFormDescriptor()
        form.addAsteriskToRequiredRowsTitle = true
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Feeding time")
        form.addFormSection(section)
        
        // Feeding
        row = XLFormRowDescriptor(tag: Tags.Feeding, rowType: XLFormRowDescriptorTypeTimeInline, title: "Feeding")
        row.value = NSDate()
        row.required = true
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Napped")
        form.addFormSection(section)
        
        //Napped
        row = XLFormRowDescriptor(tag: Tags.Napped, rowType: XLFormRowDescriptorTypeTimeInline, title: "Napped")
        row.value = NSDate()
        row.required = false
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Diaparing")
        form.addFormSection(section)
        
        //Diaparing
        row = XLFormRowDescriptor(tag: Tags.Diaparing, rowType: XLFormRowDescriptorTypeTimeInline, title: "Diaparing")
        row.value = NSDate()
        row.required = false
        section.addFormRow(row)
        
        self.form = form
    }
}