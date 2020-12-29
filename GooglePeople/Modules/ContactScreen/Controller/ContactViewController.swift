//
//  ContactViewController.swift
//  GooglePeople
//
//  Created by Oleksandr Karpenko on 29.12.2020.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

class ContactViewController: UIViewController {
    
    var contacts: [ContactModel] = []
    var contactsBuffer: [ContactModel] = []
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Search"
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        return tableView
    }()
    
    private let loaderView: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .pacman, color: FontColorHelper.second.color())
        return view
    }()
    
    private let padding: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        GoogleApiService.shared.getContacts { [weak self] contacts in
            self?.contacts.append(contentsOf: contacts)
            self?.contactsBuffer.append(contentsOf: contacts)
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
            self?.loaderView.stopAnimating()
        }
    }
    
    deinit {
        removeKeyboardObservation()
    }
    
    func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        view.addSubview(loaderView)
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(padding)
            make.left.equalTo(view.snp.left).offset(padding)
            make.right.equalTo(view.snp.right).offset(-padding)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(padding)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        loaderView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        view.backgroundColor = .clear
        loaderView.startAnimating()
        setKeyboardObserver()
    }
    
    private func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObservation() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
    
        tableView.snp.updateConstraints { make in
            make.bottom.equalTo(-keyboardSize.height)
        }
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.snp.updateConstraints { make in
            make.bottom.equalTo(0)
        }

        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc private func textFieldValueChanged() {
        guard let searchText = searchTextField.text else { return }
        
        contacts = contactsBuffer
        if !searchText.isEmpty {
            contacts.removeAll { !$0.fullName.contains(searchText) && !$0.email.contains(searchText) }
        }
        tableView.reloadData()
    }
}

extension ContactViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.cellIdentifier) as! ContactTableViewCell
        cell.config(contact: contacts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
