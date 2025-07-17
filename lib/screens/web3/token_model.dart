// class TokenModel {
//   final String name;
//   final String networkName;
//   final String networkRpcUrl;
//   final String symbol;
//   final String address;
//   final double balance;

//   TokenModel({
//     required this.name,
//     required this.networkName,
//     required this.networkRpcUrl,
//     required this.symbol,
//     required this.address,
//     required this.balance,
//   });

//   // Convert a TokenModel into a Map. The keys must correspond to the names of the columns in your database.
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'networkName': networkName,
//       'networkRpcUrl': networkRpcUrl,
//       'symbol': symbol,
//       'address': address,
//       'balance': balance,
//     };
//   }

//   // Factory constructor to create a TokenModel instance from a Map.
//   factory TokenModel.fromMap(Map<String, dynamic> map) {
//     return TokenModel(
//       name: map['name'] as String,
//       networkName: map['networkName'] as String,
//       networkRpcUrl: map['networkRpcUrl'] as String,
//       symbol: map['symbol'] as String,
//       address: map['address'] as String,
//       balance: (map['balance'] as num).toDouble(),
//     );
//   }

//   // Implement toString to make it easier to see information about each TokenModel when using the print statement.
//   @override
//   String toString() {
//     return 'TokenModel{name: $name, symbol: $symbol, address: $address, balance: $balance}';
//   }
// }

class TokenModel {
  final String name;
  final String networkName;
  final String networkRpcUrl;
  final String symbol;
  final String address;
  final double balance;

  TokenModel({
    required this.name,
    required this.networkName,
    required this.networkRpcUrl,
    required this.symbol,
    required this.address,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'networkName': networkName,
      'networkRpcUrl': networkRpcUrl,
      'symbol': symbol,
      'address': address,
      'balance': balance,
    };
  }

  factory TokenModel.fromMap(Map<String, dynamic> map) {
    return TokenModel(
      name: map['name'],
      networkName: map['networkName'],
      networkRpcUrl: map['networkRpcUrl'],
      symbol: map['symbol'],
      address: map['address'],
      balance: map['balance'],
    );
  }
}
