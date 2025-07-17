class SonicTransactionModel {
    SonicTransactionModel({
         this.blockNumber,
         this.timeStamp,
         this.hash,
         this.nonce,
         this.blockHash,
         this.transactionIndex,
         this.from,
         this.to,
         this.value,
         this.gas,
         this.gasPrice,
         this.isError,
         this.txreceiptStatus,
         this.input,
         this.contractAddress,
         this.cumulativeGasUsed,
         this.gasUsed,
         this.confirmations,
         this.methodId,
         this.functionName,
    });

    final String? blockNumber;
    final String? timeStamp;
    final String? hash;
    final String? nonce;
    final String? blockHash;
    final String? transactionIndex;
    final String? from;
    final String? to;
    final String? value;
    final String? gas;
    final String? gasPrice;
    final String? isError;
    final String? txreceiptStatus;
    final String? input;
    final String? contractAddress;
    final String? cumulativeGasUsed;
    final String? gasUsed;
    final String? confirmations;
    final String? methodId;
    final String? functionName;

    factory SonicTransactionModel.fromJson(Map<String, dynamic> json){ 
        return SonicTransactionModel(
            blockNumber: json["blockNumber"],
            timeStamp: json["timeStamp"],
            hash: json["hash"],
            nonce: json["nonce"],
            blockHash: json["blockHash"],
            transactionIndex: json["transactionIndex"],
            from: json["from"],
            to: json["to"],
            value: json["value"],
            gas: json["gas"],
            gasPrice: json["gasPrice"],
            isError: json["isError"],
            txreceiptStatus: json["txreceipt_status"],
            input: json["input"],
            contractAddress: json["contractAddress"],
            cumulativeGasUsed: json["cumulativeGasUsed"],
            gasUsed: json["gasUsed"],
            confirmations: json["confirmations"],
            methodId: json["methodId"],
            functionName: json["functionName"],
        );
    }

}
