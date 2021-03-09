import 'package:http/http.dart' as http;
import 'package:soho_app/Models/responses/delete_card.dart';
import 'package:soho_app/Utils/Application.dart';

Future<DeleteCardResponse> deleteCardCall({customerId, cardId}) async {
  try {
    final response = await http.delete(
      'https://api.stripe.com/v1/customers/$customerId/sources/$cardId',
      headers: {
        'Authorization': 'Bearer ' + Application.stripeSecretKey,
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      return deleteCardResponseFromJson(response.body);
    } else {
      return deleteCardResponseFromJson(response.statusCode.toString());
    }
  } catch (e) {
    return deleteCardResponseFromJson('error');
  }
}
