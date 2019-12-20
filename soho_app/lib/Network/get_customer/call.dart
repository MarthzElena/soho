import 'package:http/http.dart' as http;
import 'package:soho_app/Models/responses/get_customer.dart';
import 'package:soho_app/Utils/Application.dart';

Future<GetCustomerResponse> getCustomerCall({customerId}) async {
  try {
    final response = await http.get(
      'https://api.stripe.com/v1/customers/$customerId',
      headers: {
        'Authorization': 'Bearer ' + Application.stripeSecretKey,
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
       return getCustomerResponseFromJson(response.body);
    } else {
      return getCustomerResponseFromJson(response.statusCode.toString());
    }
  } catch (e) {
    return getCustomerResponseFromJson('error');
  }
}
