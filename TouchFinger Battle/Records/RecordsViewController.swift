//
//  RecordsViewController.swift
//  TouchFinger Battle
//
//  Created by Moin Janjua on 09/02/2025.
//

import UIKit

class RecordsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var tv: UITableView!

    var records = [recordsList]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set table view delegate and data source
        tv.delegate = self
        tv.dataSource = self

        loadRecords()
    }


    func loadRecords() {
        records.removeAll() // Clear existing records before loading new ones

        if let savedData = UserDefaults.standard.data(forKey: "winners"),
           let decodedRecords = try? JSONDecoder().decode([recordsList].self, from: savedData) {
            records = decodedRecords
        }

        // Check if there are no records
        if records.isEmpty {
            noDataLabel.isHidden = false
            tv.isHidden = true
        } else {
            noDataLabel.isHidden = true
            tv.isHidden = false
        }

        tv.reloadData()
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the record from the array
            records.remove(at: indexPath.row)
            
            // Encode the updated records list and save to UserDefaults
            if let encodedData = try? JSONEncoder().encode(records) {
                UserDefaults.standard.set(encodedData, forKey: "winners")
            }

            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)

            // Show "no data" label if records are empty
            if records.isEmpty {
                noDataLabel.isHidden = false
                tv.isHidden = true
            }
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecordsTableViewCell else {
            return UITableViewCell()
        }

        let record = records[indexPath.row]
        cell.namelb.text = record.FlipName
        cell.datelb.text = record.date
        cell.winnerlb.text = record.WinnerName

        if record.FlipName == "CoinFLip" {
            if record.WinnerName == "head" {
                cell.colourView.image = UIImage(named: "head")
            } else {
                cell.colourView.image = UIImage(named: "tail")
            }
        } else {
            // Instead of color, show an image
            if let winnerImage = UIImage(named: record.colourName) {
                cell.colourView.image = winnerImage
            } else {
                cell.colourView.image = UIImage(named: "default") // Fallback image if not found
            }
        }
        
        return cell
    }

   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }

    func getColor(from colorName: String) -> UIColor {
        let colorMap: [String: UIColor] = [
            "Teal": .systemTeal,
            "Indigo": .systemIndigo,
            "Pink": .systemPink,
            "Brown": .systemBrown,
            "Gray": .systemGray,
            "Mint": .systemTeal, // Replacing systemMint with systemTeal as an alternative
            "Sky Blue": .cyan, // Replacing systemCyan with cyan
            "Gold": .systemYellow
        ]
        return colorMap[colorName] ?? .black
    }


   
    @IBAction func btnBackPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeAll(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "winners")
        records.removeAll()
        if records.isEmpty {
            noDataLabel.isHidden = false
            tv.isHidden = true
        } else {
            noDataLabel.isHidden = true
            tv.isHidden = false
        }

        tv.reloadData()
    }
}


class RecordsTableViewCell: UITableViewCell {

    @IBOutlet weak var namelb:UILabel!
    @IBOutlet weak var winnerlb:UILabel!
    @IBOutlet weak var datelb:UILabel!
    @IBOutlet weak var colourView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colourView.layer.cornerRadius = colourView.frame.height / 2
        colourView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
