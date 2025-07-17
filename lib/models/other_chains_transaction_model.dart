class OtherChainsTransactionModel {
  OtherChainsTransactionModel({
    this.blockNum,
    this.uniqueId,
    this.hash,
    this.from,
    this.to,
    this.value,
    this.erc721TokenId,
    this.erc1155Metadata,
    this.tokenId,
    this.asset,
    this.category,
    this.rawContract,
    this.metadata,
  });

  final String? blockNum;
  final String? uniqueId;
  final String? hash;
  final String? from;
  final String? to;
  final double? value;
  final dynamic erc721TokenId;
  final dynamic erc1155Metadata;
  final dynamic tokenId;
  final String? asset;
  final String? category;
  final RawContract? rawContract;
  final Metadata? metadata;

  factory OtherChainsTransactionModel.fromJson(Map<String, dynamic> json) {
    return OtherChainsTransactionModel(
      blockNum: json["blockNum"],
      uniqueId: json["uniqueId"],
      hash: json["hash"],
      from: json["from"],
      to: json["to"],
      value: json["value"],
      erc721TokenId: json["erc721TokenId"],
      erc1155Metadata: json["erc1155Metadata"],
      tokenId: json["tokenId"],
      asset: json["asset"],
      category: json["category"],
      rawContract: json["rawContract"] == null
          ? null
          : RawContract.fromJson(json["rawContract"]),
      metadata:
          json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
    );
  }
}

class Metadata {
  Metadata({
    this.blockTimestamp,
  });

  final DateTime? blockTimestamp;

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      blockTimestamp: DateTime.tryParse(json["blockTimestamp"] ?? ""),
    );
  }
}

class RawContract {
  RawContract({
    required this.value,
    required this.address,
    required this.decimal,
  });

  final String? value;
  final dynamic address;
  final String? decimal;

  factory RawContract.fromJson(Map<String, dynamic> json) {
    return RawContract(
      value: json["value"],
      address: json["address"],
      decimal: json["decimal"],
    );
  }
}
