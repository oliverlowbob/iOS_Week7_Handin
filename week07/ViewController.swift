//
//  ViewController.swift
//  week07
//
//  Created by admin on 14/02/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var showArray: UITableView!
    @IBOutlet weak var savedText: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        showArray.dataSource = self
        showArray.delegate = self
        showArray.backgroundColor = UIColor.white

        
    }
    
    var theText = ""
    var someStrings = [String]()
    var currentIndex = -1


   //delete function, swipe on the item to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        self.someStrings.remove(at: indexPath.row)
        self.showArray.deleteRows(at: [indexPath], with: .automatic)
      }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }


    @IBAction func loadButton(_ sender: Any) {
        var tempStr = readStringFromFile(fileName: "output.txt")
        someStrings = tempStr.components(separatedBy: "\n")
        showArray.reloadData()
        
        

    }
    
    func readStringFromFile(fileName:String) -> String {
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let string = try String(contentsOf: filePath, encoding: .utf8)
            return string
        } catch  {
            print("error while reading file " + fileName)
        }
        return "empty"
    }
    
    @IBAction func saveButton(_ sender: Any) {
        theText = savedText.text!
        if currentIndex > -1 {
            someStrings[currentIndex] = theText
            showArray.reloadData()
            savedText.text = ""
            currentIndex = -1
        }
        else{
            someStrings.append(theText)
        }
        showArray.reloadData()
        let filename = getDocumentsDirectory().appendingPathComponent("output.txt")
        //parse array to string with new lines
        let str = someStrings.joined(separator:"\n")
        do {
            try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("error")
        }
        savedText.text = ""
        print(str)
    }
    
 

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return someStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
        cell?.textLabel?.text = someStrings[indexPath.row]
        cell?.backgroundColor = UIColor.white
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        savedText.text = someStrings[indexPath.row]
        currentIndex = indexPath.row
        
    }
    
}
