class ApiURLs {
//    public static final String MAIN_URL = "http://202.52.240.148:8092/sbcb/api/";///test
  static final String mainUrl =
      "http://117.121.237.226:86/sbcb/api/"; // production

  static final String trackCar = "http://117.121.237.226:8086"; // production
  // static final String trackCar = "http://192.168.0.100:8082"; // test

  // static final String trackCar = "http://117.121.237.226:9100";
  //http://http://117.121.237.226:9100/?id=9843441329&timestamp=1614161659&lat=27.72889394&lon=85.34593&speed=21.598265842758178&bearing=0.0&altitude=126.80527222&accuracy=0.0&batt=45.0&mock=true

  // for ads
  static final String adsPrefixUrl = mainUrl;

  static final String adsList = adsPrefixUrl + 'get_ads';
  static final String searchAd =
      adsPrefixUrl + 'ads/search?keyword='; //param keyword
  static final String imgDwnPrefix =
      'http://117.121.237.226:86/sbcb/' + 'public/storage/';

  static final String driverRatingDisplay = mainUrl + "taxi/rating_display";

  static final String registerUrl = mainUrl + "register";
  static final String loginUrl = mainUrl + "login";
  static final String taxiLists = mainUrl + "taxi/lists";
  static final String transactionLists = mainUrl + "transaction/list";
  //  static final String NEWS_URL = mainUrl + "get_news";
  static final String requestList = mainUrl + "get_request";
  static final String updateRequest = mainUrl + "update_request";
  static final String passengerDetails = mainUrl + "app_user";
  static final String approval = mainUrl + "check_approval";
  static final String referApp = mainUrl + "refer";
  //  static final String APP_VERSION_URL = mainUrl + "app/version";

  static final String customerImage = "http://202.52.240.149/letzgo_api_v2/";
//     static final String CUSTOMER_IMAGE = "http://202.52.240.149:85/letzgo_api//";

  // call server
  static final String _callServerUrl =
      'http://202.52.240.148:8092/callserver/api/';
  static final String getServerNum =
      _callServerUrl + 'get_server_number?client_id=1';

  static final String callServerUrl =
      'http://202.52.240.149:82/callserver/public/api/phone_verification/';
}
