import 'package:flutter/material.dart';
import 'package:support_app/screens/dashboard/dashboard.dart';
import 'package:support_app/screens/eCatalogue/ECatalogue.dart';
import 'package:support_app/screens/forget/forget.dart';
import 'package:support_app/screens/history/new_tickets.dart';
import 'package:support_app/screens/login/login.dart';
import 'package:support_app/screens/product/product.dart';
import 'package:support_app/screens/product/product_details.dart';
import 'package:support_app/screens/profile/profile.dart';
import 'package:support_app/screens/signup/signup.dart';
import 'package:support_app/screens/stores/stores.dart';
import 'package:support_app/screens/tickets/active_ticket.dart';
import 'package:support_app/screens/tickets/add_issue_ticket.dart';
import 'package:support_app/screens/tickets/add_tickets.dart';
import 'package:support_app/screens/tickets/new_ticket.dart';
import 'package:support_app/screens/tickets/rejected_ticket.dart';
import 'package:support_app/screens/tickets/resolverd_ticket.dart';
import 'package:support_app/service_provider/active_task/active_task.dart';
import 'package:support_app/service_provider/dashbord_service_provider/dashboard.dart';
import 'package:support_app/service_provider/payment/add_apyment_invoice/add_payment.dart';
import 'package:support_app/service_provider/payment/all_payments_card/payment_card.dart';
import 'package:support_app/service_provider/payment/approved_payment/approved_payment.dart';
import 'package:support_app/service_provider/payment/done_payment/done_payment.dart';
import 'package:support_app/service_provider/payment/panding_payment/panding_payment.dart';
import 'package:support_app/service_provider/payment/request_paymenrt_list/request_payment_list.dart';
import 'package:support_app/service_provider/rejected_task/rejected_task.dart';
import 'package:support_app/service_provider/resolved_task/resolved_task.dart';
import 'package:support_app/service_provider/sp_profile/profile_sp.dart';
import 'package:support_app/service_provider/total_task/total_task.dart';

Map<String, WidgetBuilder> routes = {
  Dashboard.routeName:   (context)    => const Dashboard(),
  Product.routeName:     (context)    => const Product(),
  ECatalogue.routeName:  (context)    => const ECatalogue(),
  Stores.routeName:      (context)    => const Stores(),
  History.routeName:     (context)    => const History(),
  Ticket.routeName:      (context)    => const Ticket(),
  Profile.routeName:     (context)    => const Profile(),
  Login.routeName:       (context)    => const Login(),
  Forget.routeName:      (context)    => const Forget(),
  Signup.routeName:      (context)    => const Signup(),
  AddTicket.routeName:   (context)    => const AddTicket(),
  ProductDetails.routeName:   (context)    => const ProductDetails(),
  TicketIssue.routeName:   (context)    => const TicketIssue(),
  ActiveTicket.routeName: (context)   => const ActiveTicket(),
  ResolvedTicket.routeName: (context)   => const ResolvedTicket(),
  RejectedTicket.routeName: (context)   => const RejectedTicket(),
  SpDashboard.routeName : (context)     => const SpDashboard(),
  SpProfile.routeName : (context)     => const SpProfile(),
  ActiveTask.routeName : (context)     => const ActiveTask(),
  TotalTask.routeName : (context)     => const TotalTask(),
  // TaskDetails.routeName : (context)     => const TaskDetails(),
  ResolvedTask.routeName : (context)     => const ResolvedTask(),
  RejectedTask.routeName : (context)     => const RejectedTask(),
  RequestPayment.routeName : (context)     => const RequestPayment(),
  AddPayment.routeName : (context)     => const AddPayment(),
  RequestPayment.routeName : (context)     => const RequestPayment(),
  RequestPaymentPaymentList.routeName : (context)     => const RequestPaymentPaymentList(),
  PendingPayment.routeName : (context)     => const PendingPayment(),
  ApprovedPayment.routeName : (context)     => const ApprovedPayment(),
  DonePayment.routeName : (context)     => const DonePayment(),
};