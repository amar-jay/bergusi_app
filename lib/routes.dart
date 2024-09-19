import 'package:flutter/material.dart';
import 'package:bergusi/drone_control.dart';
import 'package:bergusi/pages/auth/login_page.dart';
import 'package:bergusi/pages/auth/password_recovery_page.dart';
import 'package:bergusi/pages/auth/signup_page.dart';
import 'package:bergusi/pages/drone_status/drone_status_page.dart';
import 'package:bergusi/pages/drone_status/drone_telemetry_page.dart';
import 'package:bergusi/pages/ip_address/ip_address_page.dart';
import 'package:bergusi/pages/ip_address/qr_scanner_page.dart';
import 'package:bergusi/pages/onboarding/onboarding_page.dart';

const String onboardingPageRoute = "onboarding";
const String mainPageRoute = 'main';
const String ipAddressPageRoute = "ip_address";
const String qrScannerPageRoute = "qr_scanner";
const String droneControlPageRoute = "drone_control";
const String droneTelemetryPageRoute = "drone_telemetry";
const String droneStatusPageRoute = "drone_status";
// const String droneSettingsPageRoute = "drone_settings";
// const String droneLogsPageRoute = "drone_logs"
const String notificationPermissionPageRoute = "notification_permission";
const String preferredLanuagePageRoute = "preferred_language";
const String logInPageRoute = "login";
const String signUpPageRoute = "signup";
const String profileSetupPageRoute = "profile_setup";
const String signUpVerificationPageRoute = "signup_verification";
const String passwordRecoveryPageRoute = "password_recovery";
const String verificationMethodPageRoute = "verification_method";
const String otpPageRoute = "otp";
const String newPasswordPageRoute = "new_password";
const String doneResetPasswordPageRoute = "done_reset_password";
const String termsOfServicesPageRoute = "terms_of_services";
const String noInternetPageRoute = "no_internet";
const String serverErrorPageRoute = "server_error";
const String setupFingerprintPageRoute = "setup_fingerprint";
const String setupFaceIdPageRoute = "setup_faceid";
const String productDetailsPageRoute = "product_details";
const String productReviewsPageRoute = "product_reviews";
const String addReviewsPageRoute = "add_reviews";
const String homePageRoute = "home";
const String brandPageRoute = "brand";
const String discoverWithImagePageRoute = "discover_with_image";
const String subDiscoverPageRoute = "sub_discover";
const String discoverPageRoute = "discover";
const String onSalePageRoute = "on_sale";
const String kidsPageRoute = "kids";
const String searchPageRoute = "search";
const String searchHistoryPageRoute = "search_history";
const String bookmarkPageRoute = "bookmark";
const String entryPointPageRoute = "entry_point";
const String profilePageRoute = "profile";
const String getHelpPageRoute = "get_help";
const String chatPageRoute = "chat";
const String userInfoPageRoute = "user_info";
const String currentPasswordPageRoute = "current_passowrd";
const String editUserInfoPageRoute = "edit_user_info";
const String notificationsPageRoute = "notifications";
const String noNotificationPageRoute = "no_notifications";
const String enableNotificationPageRoute = "enable_notifications";
const String notificationOptionsPageRoute = "notification_options";
const String selectLanguagePageRoute = "select_language";
const String noAddressPageRoute = "no_address";
const String addressesPageRoute = "addresses";
const String addNewAddressesPageRoute = "add_new_addresses";
const String ordersPageRoute = "orders";
const String orderProcessingPageRoute = "order_processing";
const String orderDetailsPageRoute = "order_details";
const String cancleOrderPageRoute = "cancle_order";
const String deliveredOrdersPageRoute = "delivered_orders";
const String cancledOrdersPageRoute = "cancled_orders";
const String preferencesPageRoute = "preferences";
const String emptyPaymentPageRoute = "empty_payment";
const String emptyWalletPageRoute = "empty_wallet";
const String walletPageRoute = "wallet";
const String cartPageRoute = "cart";
const String paymentMethodPageRoute = "payment_method";
const String addNewCardPageRoute = "add_new_card";
const String thanksForOrderPageRoute = "thanks_order";

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case onboardingPageRoute:
      return MaterialPageRoute(
        builder: (context) => const OnBoardingPage(),
      );
    case logInPageRoute:
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
    case ipAddressPageRoute:
      return MaterialPageRoute(
        builder: (context) => const IpAddressPage(),
      );
    case signUpPageRoute:
      return MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      );
    case qrScannerPageRoute:
      return MaterialPageRoute(
        builder: (context) => const QRScannerPage(),
      );

    case droneStatusPageRoute:
      return MaterialPageRoute(
        builder: (context) => const DroneStatusPage(),
      );
    case mainPageRoute:
    case droneControlPageRoute:
      return MaterialPageRoute(
        builder: (context) => const DroneControlPage(),
      );
    case droneTelemetryPageRoute:
      return MaterialPageRoute(
        builder: (context) =>
            const DroneTelemetryPage(droneIpAddress: "127.0.0.1"),
      );

    // case signUpVerificationPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SignUpVerificationPage(),
    //   );
    case passwordRecoveryPageRoute:
      return MaterialPageRoute(
        builder: (context) => const PasswordRecoveryPage(),
      );
    // case productDetailsPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) {
    //       bool isProductAvailable = settings.arguments as bool? ?? true;
    //       return ProductDetailsPage(isProductAvailable: isProductAvailable);
    //     },
    //   );
    // case productReviewsPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ProductReviewsPage(),
    //   );
    // case homePageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const HomePage(),
    //   );
    // case discoverPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const DiscoverPage(),
    //   );
    // case onSalePageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OnSalePage(),
    //   );
    // case kidsPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const KidsPage(),
    //   );
    // case searchPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SearchPage(),
    //   );
    // case bookmarkPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const BookmarkPage(),
    //   );
    // case entryPointPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EntryPoint(),
    //   );
    // case profilePageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ProfilePage(),
    //   );
    // case userInfoPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const UserInfoPage(),
    //   );
    // case notificationsPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const NotificationsPage(),
    //   );
    // case noNotificationPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const NoNotificationPage(),
    //   );
    // case enableNotificationPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EnableNotificationPage(),
    //   );
    // case notificationOptionsPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const NotificationOptionsPage(),
    //   );
    // case addressesPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddressesPage(),
    //   );
    // case ordersPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OrdersPage(),
    //   );
    // case preferencesPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const PreferencesPage(),
    //   );
    // case emptyWalletPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EmptyWalletPage(),
    //   );
    // case walletPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const WalletPage(),
    //   );
    // case cartPageRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CartPage(),
    //   );
    default:
      return MaterialPageRoute(
        // Make a screen for undefine
        builder: (context) => const OnBoardingPage(),
      );
  }
}
