import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:soho_app/Models/responses/get_all_cards.dart';
import 'package:soho_app/Utils/Application.dart';

Future<GetAllCardsResponse> getAllCardsCall({customerId}) async {
  try {
    final response = await http.get(
      'https://api.stripe.com/v1/customers/$customerId/sources',
      headers: {
        'Authorization': 'Bearer ' + Application.stripeSecretKey,
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      return getAllCardsResponseFromJson(utf8.decode(response.bodyBytes));
    } else {
      return getAllCardsResponseFromJson(response.statusCode.toString());
    }
  } catch (e) {
    return getAllCardsResponseFromJson('error');
  }
}
