//
//  EditProfileTableViewCell.swift
//  Favr
//
//  Created by Aniket Gupta on 08/11/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import UIKit
import NotificationCenter
import Firebase

protocol EditProfileTableViewCellDelegate: AnyObject {
    func editProfileTableViewCell(_ cell: EditProfileTableViewCell, didUpdateField updatedModel: EditProfileFormModel)
}

class EditProfileTableViewCell: UITableViewCell, UITextFieldDelegate {

    static let identifier = "EditProfileTableViewCell"

    public weak var delegate: EditProfileTableViewCellDelegate?

    private var model: EditProfileFormModel?

    private let formLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private let field: UITextField = {
        let field = UITextField()
        field.returnKeyType = .done
        return field
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true

        backgroundColor = .systemGroupedBackground
        contentView.addSubview(formLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(field)
        field.delegate = self
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    public func configure(with model: EditProfileFormModel) {
//        self.model = model
//        infoLabel.font = UIFont(name: "Montserrat", size: 15)
//        formLabel.text = model.label
//        formLabel.font = UIFont(name: "Montserrat", size: 15)
//        field.placeholder = model.placeholder
//        field.text = model.value
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return
//        }
//
//        let ref = Database.database().reference().child(DatabaseManager.safeEmail(emailAddress: email))
//
//        ref.child(model.label).observeSingleEvent(of: .value, with: { [weak self]
//            snapshot in
//            let newInfo = snapshot.value as? String
//            self?.infoLabel.text = newInfo
//        })
//
//        if model.label == "Name" {
//            formLabel.textColor = .secondaryLabel
//            infoLabel.textColor = .secondaryLabel
//        }
//
//        if model.label == "Status" {
//            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
//        else {
//        separatorInset = UIEdgeInsets(top: 0, left: 130, bottom: 0, right: 0)
//        }
//    }
//
//    func didSelect(indexPath: NSIndexPath) {
//            // perform some actions here
//        if model?.label == "Name" {
//            NotificationCenter.default.post(name: NSNotification.Name("pushProfileName"), object: nil)
//        }
//        else if model?.label == "Display Name" {
//            NotificationCenter.default.post(name: NSNotification.Name("pushProfileDisplayName"), object: nil)
//        }
//        else if model?.label == "Status" {
//            NotificationCenter.default.post(name: NSNotification.Name("pushProfileStatus"), object: nil)
//        }
//    }

    override func prepareForReuse() {
        super.prepareForReuse()
        formLabel.text = nil
        infoLabel.text = nil
        field.placeholder = nil
        field.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        formLabel.frame = CGRect(x: 5,
                                 y: 0,
                                 width: contentView.width/3,
                                 height: contentView.height)

        infoLabel.frame = CGRect(x: formLabel.right + 5,
                             y: 0,
                             width: contentView.width-10-formLabel.width,
                             height: contentView.height)

//        field.frame = CGRect(x: formLabel.right + 5,
//                             y: 0,
//                             width: contentView.width-10-formLabel.width,
//                             height: contentView.height)

    }

    // MARK:- Field

//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        model?.value = textField.text
//        guard let model = model else {
//            return true
//        }
//        delegate?.editProfileTableViewCell(self, didUpdateField: model)
//        textField.resignFirstResponder()
//        return true
//    }

}
