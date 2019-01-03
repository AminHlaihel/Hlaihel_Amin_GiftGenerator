//
//  customalertdelegate.swift
//  Hlaihel_Amin_GiftGenerator
//
//  Created by Amin Hlaihel on 03/01/2019.
//  Copyright © 2019 IF26. All rights reserved.
//

import Foundation
protocol CustomAlertViewDelegate: class {
    func randomButtonTapped()
    func cancelButtonTapped()
    func pickButtonTapped()
}
