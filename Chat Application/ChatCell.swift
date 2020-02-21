//
//  ChatCell.swift
//  Chat Application
//
//  Created by Hisham Teima on 2/12/20.
//  Copyright © 2020 Hisham Teima. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    //To Seperate Sender And Reciver
    enum bubbleType {
        case incoming
        case outgoing
    }

    @IBOutlet weak var ChatStackView: UIStackView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var ChatTextView: UITextView!
    @IBOutlet weak var ChatTextBubble: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // To Make Corner Radius
        ChatTextBubble.layer.cornerRadius = 6
        
        // Initialization code
    }
    
    func setMessgeData (messege : Message)
    {
        UserNameLabel.text = messege.SenderName
        ChatTextView.text = messege.MessageText
    }
    
    func setbubbleType (type:bubbleType)
    {
        if (type == .incoming)
        {
            ChatStackView.alignment = .leading
            ChatTextBubble.backgroundColor = #colorLiteral(red: 0.1149274295, green: 0.2283219418, blue: 0.3391299175, alpha: 1)
            ChatTextView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        else if (type == .outgoing)
        {
            ChatStackView.alignment = .trailing
            ChatTextBubble.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            ChatTextView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
