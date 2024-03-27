//
//  DataViewController.swift
//  MyContactList
//
//  Created by Manuel Guevara Reyes on 3/26/24.
//

import UIKit

protocol DateControllerDelegate: AnyObject {
    func dateChanged(date: Date)
}

class DataViewController: UIViewController {
    @IBOutlet weak var dtpDate: UIDatePicker!
    
    weak var delegate: DateControllerDelegate? 

    override func viewDidLoad() {
        super.viewDidLoad()

        let saveButton: UIBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save,
                        target: self,
                        action: #selector(saveDate))
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = "Pick Birthdate"
    }
    
    @objc func saveDate() {
        self.delegate?.dateChanged(date: dtpDate.date)
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
