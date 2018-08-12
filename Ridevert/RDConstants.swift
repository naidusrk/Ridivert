//
//  RDConstants.swift
//  Ridevert
//
//  Created by savaram, Ramakrishna on 24/07/2018.
//  Copyright © 2018 savaram, Ramakrishna. All rights reserved.
//



import Foundation



class Constants {
    
    // MARK: List of Constants
    
    static let KApp_Name = "BayBoon"
    
    static let MY_ACCOUNT = "My Profile"
    static let CHANGE_PASSWORD = "Change Password"
    static let SOCIAL_APP = "My Social Apps"
    static let MY_WATCH_LIST = "My Watch List"
    static let MY_PURCHASE_HISTORY = "My Purchase History"
    static let MY_RETURNS = "My Returns"
    static let HOW_IT_WORKS_TITLE = "How It Works"
    static let REDEEM_TITLE = "To Be Redeemed"
    static let SIGN_OUT = "Sign Out"
    
    
    static let Categories = "Categories"
    static let Deal_Type = "Deal Type"
    static let Price = "Price"
    static let Date = "Date"
    
    static let Product = "Product"
    static let Services = "Service"
    
    static let Today_Only = "Today Only"
    static let Last_Two_Days = "Last Two Days"
    static let Last_One_Week = "Last One Week"
    static let Last_One_Month = "Last One Month"
    static let Last_One_Year = "Last One Year"
    
    static let price10 = "$ 0.00  -  $10.00"
    static let price25 = "$ 10.00  -  $25.00"
    static let price50 = "$ 25.00  -  $50.00"
    static let price100 = "$ 50.00  -  $100.00"
    static let price200 = "$ 100.00  -  $200.00"
    static let price500 = "$ 200.00  -  $500.00"
    static let price1000 = "$ 500.00  -  $1000.00"
    
    static let kChangePasswordHelpText = "Please enter Password between 6 and 16 characters"
    static let kChangePasswordCapital = "capital letter"
    static let kChangePasswordSmallText = "small letter"
    static let kChangePasswordSpecialText = "special characters"
    static let kChangePasswordnumbers = "numbers"
    
    //Network Constants
    
    //development urls
    static let kBayBoonBaseUrl = "https://test.groupzeal.com/mobile-rest/"
    
    
    static let kSignIn_Method = "signin"
    static let kSignUp_Method = "signup"
    static let kForgotPassword_Method = "account/reset_password_link/"
    static let kChangePassword_Method = "account/change"
    static let kResendLink_Method = "account/resend_link/"
    static let kMetaData_Method = "metadata"
    
    static let kSocialLogin_Method = "social/login"
    static let kSocialConnect_Method = "social/connect"
    static let kSocialDisconnect_Method = "social/disconnect"
    
    static let kRecommendedDeals_Method = "recommended"
    static let kWhatsNewDeals_Method = "whats_new"
    static let kTrendingDeals_Method = "trending"
    static let kMostViewedDeals_Method = "most_viewed_deals"
    static let kRecentlyViewedDeals_Method = "recently_viewed_deals"
    
    //Filter page
    static let kGet_All_Category = "category" //all category
    static let kSave_Filters = "save_filters?" //apply all filters
    static let kFilter_KeywordSearch = "deal/searchdeal?"
    
    static let kGetDeal_Names = "deal/deal_names" //autosuggestion
    static let kDeal_KeywordSearch = "deal/search" //selecting autosuggested deal
    
    
    static let kSave_Search = "deal/savesearch"
    static let kGetSaved_Search_Method = "deal/getsavedsearch"
    
    
    static let KMyProfile_Method = "account/myaccount/"
    static let KUpdateProfile_Method = "account/update_profile"
    static let kUpdateBillingPage_Method = "account/updatebilling"
    static let kUpdateShippingPage_Method = "account/updateshipping"
    static let kVerifyAddressPage_Method = "account/verify_address"
    
    static let kCard_BuyNow_Method = "checkout/creditcard"
    static let kPayPal_BuyNow = "checkout/paypal/buynow"
    static let kPayPal_JoinNow = "checkout/paypal/joingroup"
    static let kCalculateShiping = "account/calculate_shipping"
    
    static let kReview_Method = "reviews/all/"
    static let kReview_Verify_Method = "review/verify"
    static let kPostReview_Method = "review/post"
    
    static let kPaymentHistory_Method = "purchase_history/"  //purchase_history/groupzeal23@gmail.com/1/Product
    static let kCancelPurchase_Method = "account/cancel"
    
    static let kAddWatch_Method = "account/watchlist/add"
    static let kGetWatch_Method = "account/watchlist/all/"
    static let kRemoveWatch_Method = "account/watchlist/delete/"
    
    static let kRedeem_Method = "account/redeem_services/"
    static let kRedeemed_Method = "account/redeemed"
    static let kAuthcode_MainBranch_Method  = "account/redeem/false"
    static let kAuthcode_Branch_Method = "account/redeem/true?"
    static let kBuisinessBranches_Method = "account/branches/"
    
    static let kMyReturns_Method = "my_returns/"
    static let kCheckReturn_Status_Method = "verify_return_status"
    static let kIntiateReturn_Method = "return"
    
    
    static let kContactUs_Method = "contact_us"
    
    static let KEmailBody = "http://test.groupzeal.com/consumer/index?dealId=%"
    
    static let kSave_Device = "app_details/save"
    
    //FOR PRODUCTION COMMENT ABOVE AND UNCOMMENT THE BELOW
    
    /*
     static let kBayBoonBaseUrl = ""
     static let kResendLink_Method= "https://www.bayboon.com/mobile/resend_link"
     static let KImageBaseUrl = "https://www.bayboon.com/mobile"
     static let kHomePage_Method = "https://www.bayboon.com/mobile/home?"
     static let kSignIn_Method = "https://www.bayboon.com/mobile/signin"
     static let kSignUp_Method = "https://www.bayboon.com/mobile/signup"
     static let kForgotPassword_Method = "https://www.bayboon.com/mobile/reset"
     static let kChangePassword_Method = "https://www.bayboon.com/mobile/change"
     static let KMyProfile_Method = "https://www.bayboon.com/mobile/update"
     static let kUpdateBillingPage_Method = "https://www.bayboon.com/mobile/updatebilling"
     static let kUpdateShippingPage_Method = "https://www.bayboon.com/mobile/updateshipping"
     
     //Verify Address For Service deal
     static let kVerifyAddressPage_Method = "https://www.bayboon.com/mobile/verifyaddress"
     //Verify Address For Product deal
     static let kVerifyShippingPage_Method = "https://www.bayboon.com/mobile/verifyshipping"
     
     static let kProductOnly_Method = "https://www.bayboon.com/mobile/searchproduct?"
     static let kServiceOnly_Method = "https://www.bayboon.com/mobile/searchservice?"
     static let kBestDeal_Method = "https://www.bayboon.com/mobile/searchbest?"
     
     static let kCard_BuyNow_Method = "https://www.bayboon.com/mobile/cardbuynow"
     static let kPurchaseProduct_Method = "https://www.bayboon.com/mobile/buynow/paypal"
     static let kPurchaseJoinGroup_ProductPageUrl = "https://www.bayboon.com/mobile/joingroup/paypal"
     
     static let kProductOnly_CustomUrl = "https://www.bayboon.com/mobile/searchbykeyword?"
     static let kBest_CustomUrl = "https://www.bayboon.com/mobile/searchbestcustom?"
     static let kServiceOnly_CustomUrl = "https://www.bayboon.com/mobile/searchservicecustom?"
     
     static let kContactUs_Method = "https://www.bayboon.com/mobile/contactus"
     static let kReview_Method = "https://www.bayboon.com/mobile/reviewall"
     static let kPostReview_Method = "https://www.bayboon.com/mobile/postreview"
     static let kPaymentHistory_Method= "https://www.bayboon.com/mobile/purchasehistory"
     static let kAddWatch_Method= "https://www.bayboon.com/mobile/addwatch"
     static let kGetWatch_Method= "https://www.bayboon.com/mobile/getwatch"
     static let kRemoveWatch_Method= "https://www.bayboon.com/mobile/remove_watch"
     static let kCancelPurchase_Method= "https://www.bayboon.com/mobile/cancelpurchase"
     static let kCalculateTax_Method= "https://www.bayboon.com/mobile/calculate_shipping?"
     static let kFindPurchaseByUser_Method= "https://www.bayboon.com/mobile/find_purchased_by_user"
     static let kGetReturn_Method= "https://www.bayboon.com/mobile/return"
     static let kPostReturn_Method= "https://www.bayboon.com/mobile/return/initiate"
     static let kMyReturns_Method= "https://www.bayboon.com/mobile/my_returns"
     static let kVerifyZip = "https://www.bayboon.com/mobile/verify_zip"
     static let kCalculateShiping = "https://www.bayboon.com/mobile/calculate_shipping"
     static let KEmailBody= "https://www.bayboon.com/consumer/description.html?dealId=%"
     
     */
    //social urls
    static let kFacebook_Method = "https://www.facebook.com/pages/Bayboon/372560309595464"
    static let kLinkedIn_Method = "https://www.linkedin.com/company/bayboon"
    static let kTwitter_Method = "https://twitter.com/baybooninc"
    static let kGoogle_Method = "https://plus.google.com/100174928931081805874/about"
    
    static let kFB_ClientId = "810969912333123"
    static let kFB_ClientSecret = "27cc72207b118380c13926f14a6d0a6c"
    static let kFB_AppName = "groupzeal_"
    
    static let kLinkedIn_ClientId = "75f3efrngjkgz7"
    static let kLinkedIn_ClientSecret = "wBPNdNBeQRQnwX0U"
    
    static let kGP_ClientId = "700900169764-t9peg880icbrcp6c7kg7or8662rrfr5r.apps.googleusercontent.com"
    //"839678050144-r3a97m0kova2ge0pi6ssd4v1vn98u9c7.apps.googleusercontent.com"
    
    static let kGP_ClientSecret = "pAFijnCdX93zCuEG6f0zp_Ha"
    //"AIzaSyC2Ww90tGQ8GKu1hIVxdvpnXiPyj_RiZtU"
    //
    
    //twitter.consumerKey=3lm5PdoUwi727pv5yS5h5pyzb
    //twitter.consumerSecret=0Dl3cQbndFps3fQKN3iKowJ0jjUh8D3pCQsQ5U3bQPaUKlC9XD
    
    //Screen Views for Google Analytics
    static let SPLASH_SCREEN = "WELCOME SCREEN"
    static let MAIN_SCREEN_SIGNIN = "SIGNIN"
    static let MAIN_SCREEN_SIGNUP = "SIGNUP"
    static let MAIN_SCREEN_FORGOT = "FORGOT PASSWORD"
    static let HOME_SCREEN = "HOME SCREEN"
    static let PRODUCT_SEARCH = "PRODUCT SCREEN"
    static let SERVICE_SEARCH = "SERVICE SCREEN"
    static let BEST_SEARCH = "BEST DEALS SCREEN"
    static let FAQ_SCREEN = "FAQ SCREEN"
    static let HOW_IT_WORKS = "HOW IT WORKS SCREEN"
    static let HELP_SCREEN = "HELP SCREEN"
    static let CONTACT_US = "CONTACT US SCREEN"
    static let EDIT_PROFILE = "EDIT MY PROFILE SCREEN"
    static let CHANGE_PASSWORD_SCREEN = "CHANGE PASSWORD SCREEN"
    static let PURCHASE_HISTORY = "PURCHASE HISTORY SCREEN"
    static let MY_WATCH = "MY WATCHLIST SCREEN"
    static let MY_RETURNS_SCREEN = "MY RETURNS SCREEN"
    static let MY_RETURNS_INITIATE = "RETURN INITIATE"
    static let CHECKOUT_ONE = "PRE-CHECKOUT-1-PRODUCT BILLING SCREEN"
    static let CHECKOUT_TWO = "PRE-CHECKOUT-2-SHIPPING SCREEN"
    static let CHECKOUT_THREE = "CHECKOUT-3-PAYMENT SCREEN"
    static let CONFIRMATION_SCREEN = "PURCHASE CONFIRMATION SCREEN"
    static let REVIEW_SCREEN = "SHOW REVIEW SCREEN"
    static let RATING_SCREEN = "ADD RATING SCREEN"
    
    //Event Actions for Google Analytics
    static let  SIGN_IN_ACTION = "SIGN IN SUBMIT"
    static let  SIGN_UP_ACTION = "SIGN UP SUBMIT"
    static let  FORGOT_ACTION = "FORGOT PASSWORD SEND"
    static let  PAYPAL_ACTION = "PAYPAL"
    static let  CREDITCARD_ACTION = "CREDIT CARD"
    static let  BUY_NOW = "BUY NOW"
    static let  JOIN_NOW = "JOIN GROUP"
    static let  HOME_PRODUCT_LIST = "HOME:PRODUCT LIST"
    static let  CHANGE_PASSWORD_EVENT = "CHANGE PASSWORD"
    static let  CONTACT_ACTION = "CONTACT SUBMIT"
    static let  PRE_CHECKOUT_ONE = "PRODUCT BILLING"
    static let  PRE_CHECKOUT_TWO = "SHIPPING"
    static let  WATCHLIST_DELETE = "WATCHLIST DELETE"
    static let  HOME_WATCH_LIST = "HOME:WATCH LIST"
    static let  EDIT_PROFILE_EVENT = "EDIT PROFILE UPDATE"
    static let  ADD_RATING = "ADD RATING SUBMIT"
    static let  SEARCHING = "SEARCHING" //need
    static let  SEARCH_LIST = "SEARCH LIST" //need
    static let  RETURN_INITIATED = "RETURN INITIATE"
    static let  CANCEL_PRODUCT = "CANCEL PRODUCT" //need
    
    //Event Categories for Google Analytics
    static let   PURCHASE = "PURCHASE"
    static let   RATING_EVENT_CATEGORY = "RATING"
    static let   DELETE = "DELETE"
    static let   UPDATE = "UPDATE"
    static let   RETURN_INITIATED_EVENT_CATEGORY = "RETURN INITIATED"
    static let   CONTACT_EVENT_CATEGORY = "CONTACT"
    static let   SUBMIT = "SUBMIT"
    static let   RETURN_EVENT_CATEGORY = "RETURN"
    static let   CANCEL = "CANCEL"
    static let   ADD_WATCH = "ADD TO WATCHLIST" //
    static let   SEARCH = "SEARCH"//need
    
    static let KUserInfo = "userInfoDataKey"
    static let KSelectedDealDomain = "dealDomain"
    static let KBuyType = "buytype"
    static let KProductDealDomain = "productDealDomain"
    static let KSimilarItems = "similarItems"
    static let KDealID = "dealId"
    static let KShippingAddress = "shippingAddress"
    static let KDealHeading = "dealHeading"
    static let KDealQuantity = "dealQuantity"
    static let KDealPrice = "dealPrice"
    static let KDealSubTotal = "dealSubTotal"
    static let KDealCategory = "category"
    static let KPaymentResponse = "paymentResponse"
    
    static let KPaypalSandboxKey = "AXCwcBzNa1YekCLM6aiuYM7mC1D8tfSUI4po3rw0mOMkS1wL3KMvgjh3LmKQa3Qpu-tbSkR9SLDeq2Ym"
    static let kPaypalProductionKey = "ATe6O5ANB4Pvzi1rVNRe-UhzhcjgTcik5cUYl5iOCptALthlSzBcuUago6ZN78OnKV4uzBthEPjBMuND"
    
}
