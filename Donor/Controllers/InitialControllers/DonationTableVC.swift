//
//  DonationTableVC.swift

import UIKit
import FirebaseAuth
import Firebase
class DonationTableVC: UITableViewController {
    
    private var donationArray = [Donation]()
    private let firebaseService = FirebaseService()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Список записей донора"
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self!.loadData()
        }
    }
    
    private func loadData() {
        firebaseService.fetchDonations { [weak self] (donationArray)  in
            self!.donationArray = donationArray
            DispatchQueue.main.async {
                self!.tableView.reloadData()
            }
        }
            
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donationArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let donation = donationArray[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.textLabel?.text = "\(donation.name ?? "noone"): \(donation.place ?? "nowhere")"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let newDate = formatter.string(from: donation.date!)
        cell.detailTextLabel?.text = "\(newDate)"

        return cell
    }

}
