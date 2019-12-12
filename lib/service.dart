import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceHttpTest {
  printing(String someText) {
    return someText;
  }

  Future fetchSolde() async {
    final response = await http.get('http://10.0.2.2:3001/solde/request');

    if (response.statusCode == 200) {
      if (response.body == 'not find') {
        print('ok');
      } else {
        return (json.decode(response.body)['solde']);
        // setState(() {
        //   showLoader = false;
        //   solde = json.decode(response.body)['solde'];
        // });
      }
    } else {
      throw Exception('Failed to load post');
    }
  }
}
