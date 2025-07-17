import 'dart:convert';
import 'package:http/http.dart' as http;

class CoinbasePaymentService {
  final String _apiKey = 'YOUR_COINBASE_COMMERCE_API_KEY';
  final String _apiUrl = 'https://api.commerce.coinbase.com/charges';

  Future<Map<String, dynamic>> createCharge(double amount) async {
    final headers = {
      'Content-Type': 'application/json',
      'X-CC-Api-Key': _apiKey,
      'X-CC-Version': '2018-03-22', // Current API version
    };

    final body = jsonEncode({
      'name': 'Payment for Product',
      'description': 'This is a description of the item.',
      'pricing_type': 'fixed_price',
      'local_price': {
        'amount': amount.toString(),
        'currency': 'USD',
      },
      'metadata': {
        'customer_id': '1234',
        'customer_name': 'John Doe',
      },
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: body,
      );
      print("payment response : ${response.body}");
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data; // Successful response
      } else {
        throw Exception('Failed to create charge: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getCharge(String chargeId) async {
    final headers = {
      'Content-Type': 'application/json',
      'X-CC-Api-Key': _apiKey,
      'X-CC-Version': '2018-03-22', // Current API version
    };

    try {
      final response = await http.get(
        Uri.parse('$_apiUrl/$chargeId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // Successful response
      } else {
        throw Exception('Failed to get charge: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
