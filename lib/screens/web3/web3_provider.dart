import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// cc@rufusopdev
import 'package:link_on/consts/constants.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/models/other_chains_transaction_model.dart';
import 'package:link_on/models/sonic_transaction_model.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/screens/web3/database_helper.dart';
import 'package:link_on/screens/web3/token_model.dart';
import 'package:link_on/screens/web3/web3_wallet.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:link_on/utils/slide_navigation.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';

class Web3Provider extends ChangeNotifier {
  double walletBalanceInDouble = 0.0;
  double walletCustomTokenBalanceInDouble = 0.0;
  double? walletBalanceInDollar;
  bool? checkUserData;
  Usr? getUserData;
  String infuraApiKey = "108a364df19a4494a9f47083b73406f8";
  String selectedChain = "Sonic Mainnet";
  String walletPassPhrase = "Enter_your_passphrase_here";

// change chain
  void changeChain({required String chain}) {
    sonicTransactionList.clear();
    otherChainsTransactionList.clear();
    selectedChain = chain;
    if (selectedChain == "Sonic Mainnet" ||
        selectedChain == "Sonic Blaze Testnet") {
      fetchSonicTokenBalance();
      getSonicChainTransactionHistory(
          page: 1, maxCount: "6", isTransactionHistoryScreen: false);
    }
    getUserDataFuncWallet(
        userid: getStringAsync("user_id"), isFirstTime: false);
    getTokens();
    notifyListeners();
  }

// List of network names, chain IDs, and endpoints for Sepolia
  final List<Map<String, dynamic>> allNetworks = [
    {
      "name": "Sonic Mainnet",
      "chainId": 146,
      "endpoint": "https://rpc.soniclabs.com",
      "alchemy_network": "sonic-mainnet",
    },
    {
      "name": "BSC Mainnet",
      "chainId": 56,
      "endpoint":
          "https://bsc-mainnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
      "alchemy_network": "bnb-mainnet",
    },
    {
      "name": "opBNB Mainnet",
      "chainId": 204,
      "endpoint":
          "https://opbnb-mainnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
      "alchemy_network": "opbnb-mainnet",
    },
    {
      "name": "Ethereum Mainnet",
      "chainId": 1,
      "endpoint":
          "https://mainnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
      "alchemy_network": "eth-mainnet",
    },
    {
      "name": "Linea Mainnet",
      "chainId": 59144,
      "endpoint":
          "https://linea-mainnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
      "alchemy_network": "linea-mainnet",
    },
    {
      "name": "Base Mainnet",
      "chainId": 8453,
      "endpoint":
          "https://base-mainnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
      "alchemy_network": "base-mainnet",
    },
    {
      "name": "Optimism Mainnet",
      "chainId": 10,
      "endpoint":
          "https://optimism-mainnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
      "alchemy_network": "opt-mainnet",
    },
    {
      "name": "Sonic Blaze Testnet",
      "chainId": 57054,
      "endpoint": "https://rpc.blaze.soniclabs.com",
      "alchemy_network": "sonic-blaze",
    },
    {
      "name": "BSC Testnet",
      "chainId": 97,
      "endpoint":
          "https://bsc-testnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
      "alchemy_network": "bnb-testnet",
    },
    {
      "name": "opBNB Testnet",
      "chainId": 5611,
      "endpoint":
          "https://opbnb-testnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
      "alchemy_network": "opbnb-testnet",
    },
    {
      "name": "Ethereum Sepolia",
      "chainId": 11155111,
      "endpoint":
          "https://sepolia.infura.io/v3/108a364df19a4494a9f47083b73406f8",
      "alchemy_network": "eth-sepolia",
    },
    {
      "name": "Linea Sepolia",
      "chainId": 59141,
      "endpoint":
          "https://linea-sepolia.infura.io/v3/108a364df19a4494a9f47083b73406f8",
      "alchemy_network": "linea-sepolia",
    },
    {
      "name": "Base Sepolia",
      "chainId": 84532,
      "endpoint":
          "https://base-sepolia.infura.io/v3/108a364df19a4494a9f47083b73406f8",
      "alchemy_network": "base-sepolia",
    },
    {
      "name": "Optimism Sepolia",
      "chainId": 11155420,
      "endpoint":
          "https://optimism-sepolia.infura.io/v3/108a364df19a4494a9f47083b73406f8",
      "alchemy_network": "opt-sepolia",
    },
  ];

// Mainnet Networks
  final List<Map<String, dynamic>> mainnetNetworks = [
    {
      "name": "Sonic Mainnet",
      "chainId": 146,
      "endpoint": "https://rpc.soniclabs.com",
    },
    {
      "name": "BSC Mainnet",
      "chainId": 56,
      "endpoint":
          "https://bsc-mainnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
    },
    {
      "name": "opBNB Mainnet",
      "chainId": 204,
      "endpoint":
          "https://opbnb-mainnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
    },
    {
      "name": "Ethereum Mainnet",
      "chainId": 1,
      "endpoint":
          "https://mainnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
    },
    {
      "name": "Linea Mainnet",
      "chainId": 59144,
      "endpoint":
          "https://linea-mainnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
    },
    {
      "name": "Base Mainnet",
      "chainId": 8453,
      "endpoint":
          "https://base-mainnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
    },
    {
      "name": "Optimism Mainnet",
      "chainId": 10,
      "endpoint":
          "https://optimism-mainnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
    },
  ];

// Testnet Networks
  final List<Map<String, dynamic>> testnetNetworks = [
    {
      "name": "Sonic Blaze Testnet",
      "chainId": 57054,
      "endpoint": "https://rpc.blaze.soniclabs.com",
    },
    {
      "name": "BSC Testnet",
      "chainId": 97,
      "endpoint":
          "https://bsc-testnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
    },
    {
      "name": "opBNB Testnet",
      "chainId": 5611,
      "endpoint":
          "https://opbnb-testnet.infura.io/v3/108a364df19a4494a9f47083b73406f8",
    },
    {
      "name": "Ethereum Sepolia",
      "chainId": 11155111,
      "endpoint":
          "https://sepolia.infura.io/v3/108a364df19a4494a9f47083b73406f8",
    },
    {
      "name": "Linea Sepolia",
      "chainId": 59141,
      "endpoint":
          "https://linea-sepolia.infura.io/v3/108a364df19a4494a9f47083b73406f8",
    },
    {
      "name": "Base Sepolia",
      "chainId": 84532,
      "endpoint":
          "https://base-sepolia.infura.io/v3/108a364df19a4494a9f47083b73406f8",
    },
    {
      "name": "Optimism Sepolia",
      "chainId": 11155420,
      "endpoint":
          "https://optimism-sepolia.infura.io/v3/108a364df19a4494a9f47083b73406f8",
    },
  ];

// get user data
  Future<void> getUserDataFuncWallet(
      {required String userid, required bool isFirstTime}) async {
    checkUserData = true;

    dynamic res = await apiClient.get_user_data(userId: userid);
    if (res["code"] == '200') {
      getUserData = Usr.fromJson((res["data"]));
      log('wallet address : ${getUserData!.walletAddress}');

      if ((selectedChain == "Sonic Mainnet" ||
              selectedChain == "Sonic Blaze Testnet") &&
          isFirstTime) {
        await fetchSonicTokenBalance();
        getSonicChainTransactionHistory(
            page: 1, maxCount: "6", isTransactionHistoryScreen: false);
      }
      if (selectedChain != "Sonic Mainnet" &&
          selectedChain != "Sonic Blaze Testnet") {
        await queryBalance();
        getOtherChainsTransactionHistory(
            page: 1, maxCount: "6", isTransactionHistoryScreen: false);
      }
    } else {
      toast('Error: ${res['message']}');
    }
    checkUserData = false;
    notifyListeners();
  }

// copy to clipboard
  void copyText({required String text}) async {
    await text.copyToClipboard();
    toast("Copied to clipboard.",
        bgColor: Colors.black, textColor: Colors.white);
  }

// createUserWeb3Wallet
  Future<void> createUserWeb3Wallet(
      {required BuildContext context,
      required Map<String, dynamic> dataArray}) async {
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'update-user-profile', apiData: dataArray);

    log('createUserWeb3Wallet response : ${res['message']}');
    if (res["code"] == '200') {
      // Close the loading dialog and navigate back
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(createRoute(Web3WalletScreen()));
    } else {
      log("Something Went Wrong!!!! ${res["code"]} \n ${res["message"]}");
      Navigator.pop(context);
    }
  }

  bool checkData = false;
  final String apiEndPoint = "https://web3-linkon.vercel.app/api";
  List<SonicTransactionModel> sonicTransactionList = [];
  List<SonicTransactionModel> sonicTransactionListMainScreen = [];
  List<OtherChainsTransactionModel> otherChainsTransactionList = [];
  List<OtherChainsTransactionModel> otherChainsTransactionListMainScreen = [];

// create wallet
  Future<void> createWallet({required BuildContext context}) async {
    try {
      final packageInfo = await getPackageInfo();
      // if (packageInfo.packageName == "com.socioon.linkon") {
      //   toast("change your application package name");
      // } else {
      customDialogueLoader(context: context);
      final response = await dioService.dio
          .get("$apiEndPoint/create-wallet", queryParameters: {
        "user_id": getStringAsync("user_id"),
        "purchase_code": Constants.appPurchaseCode,
        "package_info": packageInfo.packageName
      });
      final responseData = response.data;
      log("create wallet response : ${response}");

      await createUserWeb3Wallet(context: context, dataArray: {
        "wallet_address": responseData["address"],
        "hex": responseData["address"],
        "address_bytes": responseData["encryptedPrivateKey"],
      });
      toast('Wallet Created');
      // }
    } on DioException catch (dioError) {
      Navigator.pop(context);
      log("DioException: ${dioError.message}");
      if (dioError.response != null) {
        log("Response data: ${dioError.response?.data}");
      }
      toast('Something went wrong.');
    } catch (e) {
      Navigator.pop(context);
      log("Exception: $e");
      toast('An unexpected error occurred.');
    }
  }

// import wallet
  Future<void> importWallet(
      {required BuildContext context, required String privateKey}) async {
    try {
      final packageInfo = await getPackageInfo();
      if (packageInfo.packageName == "com.socioon.linkon") {
        toast("change your application package name");
      } else {
        customDialogueLoader(context: context);
        final response =
            await dioService.dio.post("$apiEndPoint/import-wallet", data: {
          "user_id": getStringAsync("user_id"),
          "purchase_code": Constants.appPurchaseCode,
          "package_info": packageInfo.packageName,
          "privateKey": privateKey
        });
        if (response.statusCode == 200) {
          final responseData = response.data;
          log("import wallet response : ${response}");

          await createUserWeb3Wallet(context: context, dataArray: {
            "wallet_address": responseData["address"],
            "hex": responseData["address"],
            "address_bytes": responseData["encryptedPrivateKey"],
          });

          toast('Wallet Imported');
        } else {
          Navigator.pop(context);
          toast('Failed to import wallet');
        }
      }
    } on DioException catch (dioError) {
      Navigator.pop(context);
      log("DioException: ${dioError.message}");
      if (dioError.response != null) {
        log("Response data: ${dioError.response?.data}");
      }
      toast('Something went wrong.');
    } catch (e) {
      Navigator.pop(context);
      log("Exception: $e");
      toast('An unexpected error occurred.');
    }
  }

// Get Sonic Chain Transaction History
  Future<void> getSonicChainTransactionHistory({
    required String maxCount,
    required int page,
    required bool isTransactionHistoryScreen,
    // required BuildContext context,
  }) async {
    try {
      checkData = true;
      // customDialogueLoader(context: context);
      final data = {
        "address": getUserData!.walletAddress,
        "network": selectedChain == "Sonic Mainnet" ? "mainnet" : "testnet",
        "offset": maxCount,
      };
      if (isTransactionHistoryScreen && page != 1) {
        data["page"] = page.toString();
      }

      final response = await dioService.dio
          .get("$apiEndPoint/get-sonic-transactions", queryParameters: data);
      if (response.statusCode == 200) {
        final responseData = response.data;
        log("getSonicChainTransactionHistory : ${responseData}");
        final tempList = (responseData['transactions'] as List)
            .map((e) => SonicTransactionModel.fromJson(e))
            .toList();

        for (int i = 0; i < tempList.length; i++) {
          if (isTransactionHistoryScreen) {
            if (!sonicTransactionListMainScreen
                .any((post) => post.blockNumber == tempList[i].blockNumber)) {
              sonicTransactionListMainScreen.add(tempList[i]);
            }
          } else {
            if (!sonicTransactionList
                .any((post) => post.blockNumber == tempList[i].blockNumber)) {
              sonicTransactionList.add(tempList[i]);
            }
          }
        }
      } else {
        // Navigator.pop(context);
        toast('Failed to get transaction history');
      }
    } on DioException catch (dioError) {
      // Navigator.pop(context);
      log("DioException: ${dioError.message}");
      if (dioError.response != null) {
        log("Response data: ${dioError.response?.data}");
      }
      // toast('Something went wrong.');
    } catch (e) {
      // Navigator.pop(context);
      log("Exception: $e");
      toast('An unexpected error occurred.');
    } finally {
      checkData = false;
      notifyListeners();
    }
  }

// Get Other Chain Transaction History
  Future<void> getOtherChainsTransactionHistory({
    required int page,
    required String maxCount,
    required bool isTransactionHistoryScreen,
    //required BuildContext context
  }) async {
    try {
      checkData = true;
      // customDialogueLoader(context: context);
      final selectedChainNetwork =
          allNetworks.firstWhere((user) => user["name"] == selectedChain);

      final data = {
        "address": getUserData!.walletAddress,
        "network": selectedChainNetwork["alchemy_network"],
        "maxCount": maxCount
      };

      if (isTransactionHistoryScreen && page != 1) {
        data["pageKey"] = page.toString();
      }
      final response = await dioService.dio
          .get("$apiEndPoint/get-transactions", queryParameters: data);
      if (response.statusCode == 200) {
        final responseData = response.data;
        log("getOtherChainsTransactionHistory : ${responseData}");
        final tempList = (responseData as List)
            .map((e) => OtherChainsTransactionModel.fromJson(e))
            .toList();

        for (int i = 0; i < tempList.length; i++) {
          if (isTransactionHistoryScreen) {
            if (!otherChainsTransactionListMainScreen
                .any((post) => post.blockNum == tempList[i].blockNum)) {
              otherChainsTransactionListMainScreen.add(tempList[i]);
            }
          } else {
            if (!otherChainsTransactionList
                .any((post) => post.blockNum == tempList[i].blockNum)) {
              otherChainsTransactionList.add(tempList[i]);
            }
          }
        }
      } else {
        // Navigator.pop(context);
        toast('Failed to get transaction history');
      }
    } on DioException catch (dioError) {
      // Navigator.pop(context);
      log("DioException: ${dioError.message}");
      if (dioError.response != null) {
        log("Response data: ${dioError.response?.data}");
      }
      // toast('Something went wrong.');
    } catch (e) {
      // Navigator.pop(context);
      log("Exception: $e");
      toast('An unexpected error occurred.');
    } finally {
      checkData = false;
      notifyListeners();
    }
  }

// show-private-key
  Future<String> showPrivateKey({required BuildContext context}) async {
    try {
      customDialogueLoader(context: context);
      var headers = {'Content-Type': 'application/json'};
      final data = json.encode({
        "encryptedJson": getUserData!.addressBytes ?? "",
        "user_id": getStringAsync("user_id")
      });
      final response = await dioService.dio.post(
        "$apiEndPoint/decrypt-private-key",
        data: data,
        options: Options(headers: headers),
      );
      final responseData = response.data;
      log("showPrivateKey : ${responseData}");
      return responseData["privateKey"];
    } catch (e) {
      log("Exception createWallet : $e");
      throw Exception("Failed to show private key");
    } finally {
      Navigator.pop(context);
      notifyListeners();
    }
  }

  // get-all-tokens-balance
  Future<String> getAllTokensBalance(
      {required List<String> tokensAddressList}) async {
    try {
      final selectedChainNetwork =
          allNetworks.firstWhere((user) => user["name"] == selectedChain);
      var headers = {'Content-Type': 'application/json'};
      final data = {
        "userAddress": getUserData!.walletAddress,
        "rpcUrl": selectedChainNetwork["endpoint"],
        "tokenAddresses": tokensAddressList,
      };
      final response = await dioService.dio.post(
        "$apiEndPoint/get-all-token-balances",
        data: data,
        options: Options(headers: headers),
      );
      final responseData = response.data;
      final List<dynamic> tokenBalances = responseData['tokens'];
      for (var token in tokenBalances) {
        String tokenAddress = token['tokenAddress'];
        double newBalance = double.parse(token['balance']);

        // Update the balance in the database
        await DatabaseHelper.instance.updateBalance(tokenAddress, newBalance);
      }
      log("getAllTokensBalance : ${responseData}");
      return responseData["privateKey"];
    } catch (e) {
      log("Exception createWallet : $e");
      throw Exception("Failed to get balance");
    } finally {
      notifyListeners();
    }
  }

  Future<List<TokenModel>> getTokens() async {
    final tokens =
        await await DatabaseHelper.instance.fetchTokensByNetwork(selectedChain);
    // Check if the list is not empty
    if (tokens.isNotEmpty) {
      // Extract addresses
      List<String> addresses = tokens.map((token) => token.address).toList();
      getAllTokensBalance(tokensAddressList: addresses);
    }
    return tokens;
  }

  bool isImporting = false;
  dynamic responseData;
// import-token
  Future<dynamic> importToken(
      {required BuildContext context, required String tokenAddress}) async {
    try {
      isImporting = true;
      customDialogueLoader(context: context);

      final selectedChainNetwork =
          allNetworks.firstWhere((user) => user["name"] == selectedChain);

      final data = json.encode({
        "tokenAddress": tokenAddress,
        "userAddress": getUserData!.walletAddress,
        "rpcUrl": "${selectedChainNetwork["endpoint"]}",
      });
      final response = await dioService.dio.post(
        "$apiEndPoint/import-token",
        data: data,
      );
      responseData = response.data;

      log("importToken response : ${responseData}");
      if (response.statusCode == 200) {
        return responseData;
      } else {
        toast("invalid contract address.");
      }
    } catch (e) {
      toast("invalid contract address.");
      Navigator.pop(context);
      log("Exception importToken : $e");
      throw Exception("Failed to import token");
    } finally {
      isImporting = false;
      Navigator.pop(context);
      notifyListeners();
    }
  }

// add imported token to local DB
  Future<void> addTokenToLocalDb({
    required BuildContext context,
    required String tokenAddress,
    required dynamic responseData,
  }) async {
    try {
      final selectedChainNetwork =
          allNetworks.firstWhere((user) => user["name"] == selectedChain);

      // Assuming responseData contains 'name', 'symbol', 'balance'
      TokenModel token = TokenModel(
        name: responseData['name'],
        networkName: selectedChainNetwork["name"],
        networkRpcUrl: selectedChainNetwork["endpoint"],
        symbol: responseData['symbol'],
        address: tokenAddress,
        balance: double.parse(responseData['balance']),
      );

      final db = await DatabaseHelper.instance.database;
      // Check if the token already exists
      var result = await db.query(
        'tokens', // Replace with your actual table name
        where: 'address = ?',
        whereArgs: [tokenAddress],
      );

      if (result.isEmpty) {
        // Token does not exist, proceed to insert
        await DatabaseHelper.instance.insertToken(token);
      } else {
        // Token already exists, handle accordingly (e.g., show a message)
        toast('Token already exists.');
      }
    } catch (e) {
      log("Exception addTokenToLocalDb: $e");
      throw Exception("Failed to import token");
    } finally {
      notifyListeners();
    }
  }

  void changeIsImportingBool({required bool value}) {
    isImporting = value;
    notifyListeners();
  }

// get wallet balance
  Future<void> queryBalance() async {
    try {
      final selectedChainNetwork =
          allNetworks.firstWhere((user) => user["name"] == selectedChain);

      log("selected chain : $selectedChainNetwork");

      final response =
          await dioService.dio.post("$apiEndPoint/query-balance", data: {
        "userAddress": getUserData!.walletAddress,
        "rpcUrl": "${selectedChainNetwork["endpoint"]}",
        "purchase_code": Constants.appPurchaseCode
      });
      log("queryBalance response : ${response.data}");
      final balance = response.data["balance"];
      walletBalanceInDouble = double.parse(balance);
    } catch (e) {
      log("Exception queryBalance : $e");
    } finally {
      notifyListeners();
    }
  }

// transfer eth
  Future<void> transferETH({
    required double amount,
    String? sendToSomeoneAddress,
    required BuildContext context,
  }) async {
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final selectedChainNetwork =
          allNetworks.firstWhere((user) => user["name"] == selectedChain);
      var headers = {'Content-Type': 'application/json'};
      final data = json.encode({
        "rpcUrl": "${selectedChainNetwork["endpoint"]}",
        "privateKey": getUserData!.hex == getUserData!.walletAddress
            ? ""
            : getUserData!.hex ?? "",
        "encryptedJson": getUserData!.addressBytes ?? "",
        "amount": amount.toString(),
        "sendToSomeoneAddress": sendToSomeoneAddress,
        "user_id": getStringAsync("user_id")
      });

      final response = await dioService.dio.post(
        "$apiEndPoint/transfer-eth",
        data: data,
        options: Options(headers: headers),
      );

      log("transferETH response : ${response.data}");

      if (response.statusCode == 200) {
        print(json.encode(response.data));
      } else {
        print(response.statusMessage);
      }

      if (response.statusCode == 200) {
        queryBalance();

        if (selectedChain == "Sonic Mainnet" ||
            selectedChain == "Sonic Blaze Testnet") {
          getSonicChainTransactionHistory(
              page: 1, maxCount: "6", isTransactionHistoryScreen: false);
        } else {
          getOtherChainsTransactionHistory(
              page: 1, maxCount: "6", isTransactionHistoryScreen: false);
        }

        log("✅ Transaction Successful!");
        toast("✅ Transaction Successful!");
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Web3WalletScreen();
        }));
      } else {
        Navigator.pop(context);
        log("❌ Transaction Failed!");
        toast("❌ Transaction Failed!");
      }
    } catch (e) {
      Navigator.pop(context);
      toast("❌ Transaction Failed!\n$e");
      log("❌ Transaction Failed! $e");
    }
  }

// Sonic Chain
  Future<void> fetchSonicTokenBalance() async {
    try {
      final selectedChainNetwork = selectedChain == "Sonic Mainnet"
          ? allNetworks[0]["endpoint"]
          : allNetworks[7]["endpoint"];

      log("fetchSonicTokenBalance selectedChainNetwork: $selectedChainNetwork");

      final response =
          await dioService.dio.post("$apiEndPoint/query-balance", data: {
        "rpcUrl": selectedChainNetwork,
        "userAddress": getUserData!.walletAddress.toString(),
        "purchase_code": Constants.appPurchaseCode
      });

      final balance = response.data["balance"];
      walletBalanceInDouble = double.parse(balance);
      log("fetchSonicTokenBalance native response : ${response.data}");

      if (selectedChain == "Sonic Mainnet") {
        final responseCustomToken = await dioService.dio
            .post("$apiEndPoint/sonic/token-balance", data: {
          "rpcUrl": selectedChainNetwork,
          "address": getUserData!.walletAddress.toString(),
          "tokenAddress": "0xf845583f71b525c41b19c628d1e62a4bb76939e5"
        });

        final customTokenBalance = responseCustomToken.data["balance"];
        walletCustomTokenBalanceInDouble = double.parse(customTokenBalance);

        log("fetchSonicTokenBalance custom response : ${responseCustomToken.data}");
      }
    } catch (e) {
      log("Error fetching Sonic S Token balance: $e");
    } finally {
      notifyListeners();
    }
  }

// transfer sonic custom token
  Future<void> transferSonicCustomToken({
    required double amount,
    required String tokenAddress,
    required String sendToSomeoneAddress,
    required BuildContext context,
  }) async {
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final selectedChainNetwork = selectedChain == "Sonic Mainnet"
          ? allNetworks[0]["endpoint"]
          : allNetworks[7]["endpoint"];

      final data = json.encode({
        "rpcUrl": selectedChainNetwork,
        "privateKey": getUserData!.hex == getUserData!.walletAddress
            ? ""
            : getUserData!.hex ?? "",
        "encryptedJson": getUserData!.addressBytes ?? "",
        "amount": amount.toString(),
        "tokenAddress": tokenAddress,
        "toAddress": sendToSomeoneAddress,
        "user_id": getStringAsync("user_id")
      });
      final response = await dioService.dio
          .post("$apiEndPoint/sonic/transfer-token", data: data);

      log("transferETH response : ${response.data}");

      if (response.statusCode == 200) {
        queryBalance();

        if (selectedChain == "Sonic Mainnet" ||
            selectedChain == "Sonic Blaze Testnet") {
          getSonicChainTransactionHistory(
              page: 1, maxCount: "6", isTransactionHistoryScreen: false);
        } else {
          getOtherChainsTransactionHistory(
              page: 1, maxCount: "6", isTransactionHistoryScreen: false);
        }

        log("✅ Transaction Successful!");
        toast("✅ Transaction Successful!");
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Web3WalletScreen();
        }));
      } else {
        Navigator.pop(context);
        log("❌ Transaction Failed!");
        toast("❌ Transaction Failed!");
      }
    } catch (e) {
      Navigator.pop(context);
      toast("❌ Transaction Failed!\n$e");
      log("❌ Transaction Failed! $e");
    }
  }

  Future<void> transferSonicNativeToken({
    required double amount,
    required bool isCustomTokenTransfer,
    required String tokenAddress,
    String? sendToSomeoneAddress,
    required BuildContext context,
  }) async {
    try {
      if (isCustomTokenTransfer) {
        transferSonicCustomToken(
            sendToSomeoneAddress: sendToSomeoneAddress!,
            amount: amount,
            tokenAddress: tokenAddress,
            context: context);
      } else {
        transferETH(
            context: context,
            sendToSomeoneAddress: sendToSomeoneAddress,
            amount: amount);
      }
    } catch (e) {
      log("Sonic Error transferring Sonic Native Token: $e");
      throw Exception("Failed to transfer native token");
    }
  }
}
