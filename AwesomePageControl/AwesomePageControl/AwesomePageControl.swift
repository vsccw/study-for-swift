//
//  AwesomePageControl.swift
//  AwesomePageControl
//
//  Created by 程庆春 on 2016/12/25.
//  Copyright © 2016年 Qiun Cheng. All rights reserved.
//

import UIKit

class AwesomePageControl: UIControl {

    open var numberOfPages: Int = 0 // default is 0

    open var currentPage: Int = 0 // default is 0. value pinned to 0..numberOfPages-1


    open var hidesForSinglePage: Bool = false // hide the the indicator if there is only one page. default is NO

    open var pageIndicatorTintColor: UIColor?

    open var currentPageIndicatorTintColor: UIColor?

}
