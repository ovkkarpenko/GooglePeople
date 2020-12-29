//
//  ContactTableViewCell.swift
//  GooglePeople
//
//  Created by Oleksandr Karpenko on 29.12.2020.
//

import UIKit
import SnapKit

class ContactTableViewCell: UITableViewCell {

    static let cellIdentifier = "ContactCell"
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let image = UIImage(named: "empty-image")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private let padding: CGFloat = 20
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        addSubview(profileImageView)
        addSubview(fullNameLabel)
        addSubview(emailLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(padding-10)
            make.left.equalTo(snp.left).offset(padding)
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(padding-10)
            make.left.equalTo(profileImageView.snp.right).offset(padding-10)
            make.right.equalTo(snp.right).offset(-padding)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom).offset(3)
            make.left.equalTo(profileImageView.snp.right).offset(padding-10)
        }
    }
    
    func config(contact: ContactModel) {
        fullNameLabel.text = contact.fullName
        emailLabel.text = contact.email
        profileImageView.imageFromUrl(ServerConfig.contactProfileImage(contactId: contact.id).url())
    }
}
