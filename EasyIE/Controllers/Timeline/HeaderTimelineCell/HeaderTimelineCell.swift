//
//  HeaderTimelineCell.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 11.10.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import UIKit

class HeaderTimelineCell: UITableViewCell {

	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var background: UIVisualEffectView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
//        // Initialization code
//		// Init a UIVisualEffectView which going to do the blur for us
//		let blurView = UIVisualEffectView()
//		// Make its frame equal the main view frame so that every pixel is under blurred
//		blurView.frame = contentView.frame
//		// Choose the style of the blur effect to regular.
//		// You can choose dark, light, or extraLight if you wants
//		blurView.effect = UIBlurEffect(style: .regular)
//		// Now add the blur view to the main view
//		contentView.addSubview(blurView)
		background.effect = UIBlurEffect(style: .regular)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
