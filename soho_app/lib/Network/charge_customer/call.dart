import 'package:http/http.dart' as http;
import 'package:soho_app/Models/requests/charge_customer.dart';
import 'package:soho_app/Models/responses/charge_customer.dart';
import 'package:soho_app/Utils/Application.dart';

Future<ChargeCustomerResponse> chargeCustomerCall({ChargeCustomerRequest request}) async {
  try {
    final response = await http.post(
      'https://api.stripe.com/v1/charges',
      headers: {
        'Authorization': 'Bearer ' + Application.stripeSecretKey,
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: chargeCustomerRequestToMap(request),
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      return chargeCustomerResponseFromJson(response.body);
    } else {
      return chargeCustomerResponseFromJson(response.statusCode.toString());
    }
  } catch (e) {
    return chargeCustomerResponseFromJson('error');
  }
}
