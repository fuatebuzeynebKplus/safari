import 'dart:convert';

import 'package:bamobile1/common/data/enums/invoice_info_type.dart';
import 'package:bamobile1/common/data/models/login_response.dart';
import 'package:bamobile1/common/data/models/token.dart';
import 'package:bamobile1/cubit/currency-code-cubit/currency_code_cubit.dart';
import 'package:bamobile1/cubit/firabase-cubit/firebase_cubit.dart';
import 'package:bamobile1/helper/shared-preferences/cache_hekper.dart';
import 'package:bamobile1/helper/shared-preferences/service_locator.dart';
import 'package:bamobile1/helper/shared-preferences/shared_preferences_funs.dart';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  // String apiBaseUrlGeneral =
  //     "https://sandbox.kplus.com.tr/kplus/v0/General.svc/Rest/Json";
  String apiBaseUrlGeneral =
      "https://ws.kplus.com.tr/alsafarigate/v0/General.svc/Rest/Json";
  final Dio _dio = Dio();
  String? token;
  String email = getIt<CacheHelper>().getDataString(key: 'email') ?? '';
  String password = getIt<CacheHelper>().getDataString(key: 'password') ?? '';
  bool obscurePasswordTextValue = true;
  bool? termsAndConditionCheckBoxValue = true;
  GlobalKey<FormState> formKeyForSignIn = GlobalKey();

  String? agentFirstName;
  String? agentLastName;
  String? agentEmail;
  String? agentPhone;
  String? agentFax;
  dynamic iataNo;
  double? agentCariBalance;
  String? agentCurrencyCode;
  String? agentUrlImage;
  String? companyName;
  String? companyPhone;
  String? companyAddressCity;
  String? companyAddressCountry;
  String? companyEmail;
  bool? thisUserIsAgent;

  String? invoiceInfoAddress;
  String? invoiceInfoCityCode;
  String? invoiceInfoCompanyName;
  String? invoiceInfoFirstName;
  String? invoiceInfoLastName;
  String? invoiceInfoTitle;
  InvoiceInfoType? invoiceInfoType;

  void updateTermsAndConditionCheckBoxInLoginView({required newValue}) {
    termsAndConditionCheckBoxValue = newValue;

    emit(TermsAndConditionUpdateCheckBoxState());
  }

  void obscurePasswordText() {
    if (obscurePasswordTextValue == true) {
      obscurePasswordTextValue = false;
    } else {
      obscurePasswordTextValue = true;
    }
    emit(ObscurePasswordTextUpdateState());
  }

  Future<Token> createToken() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      //"X-Forwarded-For": "8.8.8.8",
      //"X-Real-IP": "8.8.8.8"
    };

    try {
      final response = await _dio.post(
        "$apiBaseUrlGeneral/CreateTokenV2",
        data: json.encode({
          "channelCredential": {
            // "ChannelCode": "KplusTest",
            // "ChannelPassword": "KplusC*L*L2024!"
            "ChannelCode": "alsafarimobileapp",
            "ChannelPassword": "Ni.lKq2d0w4!N!vz"
          }
        }),
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode! > 400) {
        throw Exception("An error occurred: ${response.data}");
      }

      if (response.statusCode == 200) {
        final tokenData = Token.fromJson(response.data['Result']);
        //    print('TokenCode:::: ${tokenData.tokenCode}');

        token = tokenData.tokenCode;
        saveToken(token!);
        return tokenData;
      }

      throw Exception('Unexpected response from server');
    } catch (e) {
      // print('Error: $e');
      throw Exception('Failed to create token: $e');
    }
  }

  Future<LoginResponse> login({required BuildContext context}) async {
    emit(SignInLoading());

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    // CacheHelper.saveData(key: 'token', value: Data.tokenCode);

    final loginRequest = {
      "tokenCode": token,
      "email": email,
      "password": password,
    };
    //  print('1111111111111111111111111111111111111111111');
    final loginRequestJson = json.encode(loginRequest);
    //   print('2222222222222222222222222222222222');
    //  print('Login Request: $loginRequestJson');

    try {
      final response = await _dio.post(
        "$apiBaseUrlGeneral/Login",
        data: loginRequestJson,
        options: Options(
          headers: headers,
        ),
      );

      // if (response.statusCode! >= 400) {
      //   throw Exception("An error occurred: ${response.data}");
      // }
      print(response);

      final responseData = response.data;
      //    print('Login Response: $responseData');

      final Data = LoginResponse.fromJson(responseData);

      //     print('Login Response: $Data');

      if (Data.result != null) {
        saveEmail(email);
        savePassword(password);

        if (Data.result!.agent != null) {
          invoiceInfoAddress =
              Data.result?.agent?.company?.invoiceInfo?.address ?? 'test';
          invoiceInfoCityCode =
              Data.result?.agent?.company?.invoiceInfo?.cityCode ?? 'test';
          invoiceInfoCompanyName =
              Data.result?.agent?.company?.invoiceInfo?.companyName ?? 'test';
          invoiceInfoFirstName =
              Data.result?.agent?.company?.invoiceInfo?.firstName ?? 'test';
          invoiceInfoLastName =
              Data.result?.agent?.company?.invoiceInfo?.lastName ?? 'test';
          invoiceInfoTitle =
              Data.result?.agent?.company?.invoiceInfo?.invoiceInfoTitle ??
                  'test';
          invoiceInfoType =
              Data.result?.agent?.company?.invoiceInfo?.invoiceInfoType;
        }

        //    print('Data.result!: ${Data.result!.agent!.agentId}');
        companyAddressCity = Data.result?.agent?.company?.cityName ?? '-----';
        companyAddressCountry =
            Data.result?.agent?.company?.countryName ?? '-----';
        companyEmail = Data.result?.agent?.company?.email ?? '-----';
        companyName = Data.result?.agent?.company?.name ?? '-----';
        companyPhone = Data.result?.agent?.company?.phone ?? '-----';

        thisUserIsAgent = Data.result!.agent != null ? true : false;

        agentCariBalance = Data.result?.agent?.currentAccount?.cariBalance ??
            Data.result?.systemOwnerUser['CurrentAccount']['CariBalance'] ??
            '------';
        agentCurrencyCode = Data.result?.agent?.currentAccount?.currencyCode ??
            Data.result?.systemOwnerUser?['CurrentAccount']['CurrencyCode'] ??
            '------';
        agentEmail =
            Data.result?.agent?.user?.email ?? Data.result?.baseUser?.email;
        agentFirstName = Data.result?.agent?.user?.firstName ??
            Data.result?.baseUser?.firstName ??
            '------';
        agentLastName = Data.result?.agent?.user?.lastName ??
            Data.result?.baseUser?.lastName ??
            '------';
        agentPhone = Data.result?.agent?.user?.phone ??
            Data.result?.baseUser?.phone ??
            '------';

        agentFax = Data.result?.agent?.user?.phone ??
            Data.result?.baseUser?.fax ??
            '------';

        iataNo = Data.result?.agent?.iATAType ?? 000000000;
        agentUrlImage = Data.result?.agent?.user?.profileImageUrl ??
            Data.result?.agent?.company?.logoUrl ??
            Data.result?.baseUser?.profileImageUrl ??
            'assets/images/no_image.png';

        emit(SignInSuccuss());

        return Data;
      } else {
        emit(SignInFailure(errorMassage: Data.errorMessage));
        return Data;
      }

      // Return an instance of LoginResult
    } catch (e) {
      print('************************************');
      //    print('Login Error: $e');
      emit(SignInFailure(errorMassage: e.toString()));
      throw Exception('Failed to login: $e');
    }
  }

  // signIn() async {
  //   try {
  //     emit(SignInLoading());
  //     final response = await api.post(
  //       EndPoints.login,
  //       data: {
  //         ApiKey.tokenCode: "c71d0fe9-50b7-4ee8-ae35-70721b90a6aa",
  //         ApiKey.email: email,
  //         ApiKey.password: password,
  //       },
  //     );

  //     print('==========================================================');
  //     print(response);
  //     loginResponse = LoginResponse.fromJson(response);
  //     print(loginResponse!.errorCode);

  //     emit(SignInSuccuss());
  //   } catch (e) {
  //     print('-------------------------*-*-*');
  //     emit(SignInFailure(errorMassage: e.toString()));
  //   }

  //   // on ServerException catch (e) {
  //   //   emit(SignInFailure(errorMassage: e.errorModel.errorMessage));
  //   // }
  // }
}
