import 'dart:io';
import 'dart:math';

import 'package:bamobile1/cubit/auth-cubit/auth_cubit.dart';
import 'package:bamobile1/cubit/currency-code-cubit/currency_code_cubit.dart';
import 'package:bamobile1/cubit/firabase-cubit/firebase_cubit.dart';
import 'package:bamobile1/cubit/settings-app/settings_cubit.dart';
import 'package:bamobile1/generated/l10n.dart';
import 'package:bamobile1/helper/custom_clip_path.dart';
import 'package:bamobile1/bottom_nav_bar.dart';
import 'package:bamobile1/helper/functions.dart';
import 'package:bamobile1/helper/shared-preferences/cache_hekper.dart';
import 'package:bamobile1/helper/shared-preferences/service_locator.dart';

import 'package:bamobile1/views/other-views/tow_factor_login_view.dart';
import 'package:bamobile1/views/popup_widget.dart';
import 'package:bamobile1/widgets/button_widget.dart';
import 'package:bamobile1/widgets/check_box_widget.dart';
import 'package:bamobile1/utils/app_colors.dart';
import 'package:bamobile1/utils/app_images.dart';
import 'package:bamobile1/utils/app_sizes.dart';
import 'package:bamobile1/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/text_field_widget.dart';
import '../../widgets/text_widget.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});
  static String id = 'SignInView';
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CurrencyCodeCubit>(context).fetchCurrencyData();
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignInFailure) {
          SnackbarUtils.showSnackbar(context, state.errorMassage);
        } else if (state is SignInSuccuss) {
          // SnackbarUtils.showSnackbar(context, 'success');

          // BlocProvider.of<AuthCubit>(context).getUserProfile();
          Navigator.pushReplacementNamed(context, BottomNavBar.id);
          // Navigator.pushReplacementNamed(context, TowFactorLogin.id);
        }
      },
      builder: (context, state) {
        AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
        return ModalProgressHUD(
            inAsyncCall: state is SignInLoading,
            progressIndicator: const LoadingWidget(
              showImageLoading: false,
            ),
            child: Scaffold(
              backgroundColor: AppColors.kSecondColor,
              body: Stack(
                children: [
                  ClipPath(
                    clipper: CustomClipPath(),
                    child: Container(
                      color: Colors.white, // أو أي لون ترغب فيه في الجزء العلوي
                      height: context.height * 1,
                      width: double.infinity,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Platform.isAndroid
                          ? getIt<CacheHelper>()
                                      .getDataString(key: 'versionAndroid') ==
                                  BlocProvider.of<FirebaseCubit>(context)
                                      .versionAndroid
                              ? Center(
                                  child: Form(
                                    key: authCubit.formKeyForSignIn,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/icon_logo.png',
                                            height: context.width * 0.4,
                                            width: context.width * 0.4,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black45,
                                                  offset:
                                                      Offset(0.0, 1.0), //(x,y)
                                                  blurRadius: 10.0,
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Colors.white,
                                            ),
                                            padding: const EdgeInsets.all(20),
                                            height: context.height * 0.4,
                                            width: context.height * 0.4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                  text: S.of(context).Login,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                TextFieldWidget(
                                                  hint: S.of(context).EMail,
                                                  icon: Icons.mail,
                                                  initialValue: getIt<
                                                              CacheHelper>()
                                                          .getDataString(
                                                              key: 'email') ??
                                                      '',
                                                  onChanged: (value) {
                                                    authCubit.email = value;
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                TextFieldWidget(
                                                  initialValue: getIt<
                                                              CacheHelper>()
                                                          .getDataString(
                                                              key:
                                                                  'password') ??
                                                      '',
                                                  onChanged: (value) {
                                                    authCubit.password = value;
                                                  },
                                                  onTapSuffixIcon: () {
                                                    BlocProvider.of<AuthCubit>(
                                                            context)
                                                        .obscurePasswordText();
                                                  },
                                                  icon: Icons.lock,
                                                  colorSuffixIcon: Colors.grey,
                                                  suffixIcon: authCubit
                                                              .obscurePasswordTextValue ==
                                                          true
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                  hint: S.of(context).Password,
                                                ),
                                                SizedBox(
                                                  height: context.height * 0.01,
                                                ),
                                                // Row(
                                                //   mainAxisAlignment: MainAxisAlignment.end,
                                                //   children: [
                                                //     TextWidget(
                                                //       fontSize: 13,
                                                //       text: S.of(context).ForgetPassword,
                                                //       color: AppColors.kSecondColor,
                                                //     )
                                                //   ],
                                                // ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    CheckBoxWidget(
                                                      value: BlocProvider.of<
                                                                  AuthCubit>(
                                                              context)
                                                          .termsAndConditionCheckBoxValue,
                                                      onChanged: (value) {
                                                        BlocProvider.of<
                                                                    AuthCubit>(
                                                                context)
                                                            .updateTermsAndConditionCheckBoxInLoginView(
                                                                newValue:
                                                                    value);
                                                      },
                                                    ),
                                                    TextWidget(
                                                      text: S
                                                          .of(context)
                                                          .IHaveAgreeToOur,
                                                      fontSize: 12,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        launchUrl(Uri.parse(
                                                            'https://www.bookingagora.com/Page/kvkk--kisisel-verilerin-korunmasi-ve-islenmesi-hakkinda-aydinlatma-metni'));
                                                      },
                                                      child: Text(
                                                        S
                                                            .of(context)
                                                            .TermsAndCondition,
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationColor:
                                                                AppColors
                                                                    .kSecondColor,
                                                            fontSize: 12,
                                                            color: AppColors
                                                                .kSecondColor),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: context.height * 0.02,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (authCubit
                                                            .termsAndConditionCheckBoxValue ==
                                                        false) {
                                                      SnackbarUtils.showSnackbar(
                                                          context,
                                                          S
                                                              .of(context)
                                                              .YouCannotLogInWithoutAcceptingTheTerms,
                                                          2);
                                                    } else {
                                                      await authCubit.login(
                                                          context: context);

                                                      BlocProvider.of<
                                                                  CurrencyCodeCubit>(
                                                              context)
                                                          .saveTimeAndStartTimer();
                                                    }
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 36,
                                                          vertical: 12),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color:
                                                            AppColors.kBluColor,
                                                      ),
                                                      child: TextWidget(
                                                        text:
                                                            S.of(context).Login,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const UpdatePopup()
                          : getIt<CacheHelper>()
                                      .getDataString(key: 'versionIos') ==
                                  BlocProvider.of<FirebaseCubit>(context)
                                      .versionIos
                              ? Center(
                                  child: Form(
                                    key: authCubit.formKeyForSignIn,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black45,
                                                  offset:
                                                      Offset(0.0, 1.0), //(x,y)
                                                  blurRadius: 10.0,
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Colors.white,
                                            ),
                                            padding: const EdgeInsets.all(20),
                                            height: context.height * 0.4,
                                            width: context.height * 0.4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                  text: S.of(context).Login,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                TextFieldWidget(
                                                  hint: S.of(context).EMail,
                                                  icon: Icons.mail,
                                                  initialValue: getIt<
                                                              CacheHelper>()
                                                          .getDataString(
                                                              key: 'email') ??
                                                      '',
                                                  onChanged: (value) {
                                                    authCubit.email = value;
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                TextFieldWidget(
                                                  initialValue: getIt<
                                                              CacheHelper>()
                                                          .getDataString(
                                                              key:
                                                                  'password') ??
                                                      '',
                                                  onChanged: (value) {
                                                    authCubit.password = value;
                                                  },
                                                  onTapSuffixIcon: () {
                                                    BlocProvider.of<AuthCubit>(
                                                            context)
                                                        .obscurePasswordText();
                                                  },
                                                  icon: Icons.lock,
                                                  colorSuffixIcon: Colors.grey,
                                                  suffixIcon: authCubit
                                                              .obscurePasswordTextValue ==
                                                          true
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                  hint: S.of(context).Password,
                                                ),
                                                SizedBox(
                                                  height: context.height * 0.01,
                                                ),
                                                // Row(
                                                //   mainAxisAlignment: MainAxisAlignment.end,
                                                //   children: [
                                                //     TextWidget(
                                                //       fontSize: 13,
                                                //       text: S.of(context).ForgetPassword,
                                                //       color: AppColors.kSecondColor,
                                                //     )
                                                //   ],
                                                // ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    CheckBoxWidget(
                                                      value: BlocProvider.of<
                                                                  AuthCubit>(
                                                              context)
                                                          .termsAndConditionCheckBoxValue,
                                                      onChanged: (value) {
                                                        BlocProvider.of<
                                                                    AuthCubit>(
                                                                context)
                                                            .updateTermsAndConditionCheckBoxInLoginView(
                                                                newValue:
                                                                    value);
                                                      },
                                                    ),
                                                    TextWidget(
                                                      text: S
                                                          .of(context)
                                                          .IHaveAgreeToOur,
                                                      fontSize: 12,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        launchUrl(Uri.parse(
                                                            'https://www.bookingagora.com/Page/kvkk--kisisel-verilerin-korunmasi-ve-islenmesi-hakkinda-aydinlatma-metni'));
                                                      },
                                                      child: Text(
                                                        S
                                                            .of(context)
                                                            .TermsAndCondition,
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationColor:
                                                                AppColors
                                                                    .kSecondColor,
                                                            fontSize: 12,
                                                            color: AppColors
                                                                .kSecondColor),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: context.height * 0.02,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (authCubit
                                                            .termsAndConditionCheckBoxValue ==
                                                        false) {
                                                      SnackbarUtils.showSnackbar(
                                                          context,
                                                          S
                                                              .of(context)
                                                              .YouCannotLogInWithoutAcceptingTheTerms,
                                                          2);
                                                    } else {
                                                      await authCubit.login(
                                                          context: context);

                                                      BlocProvider.of<
                                                                  CurrencyCodeCubit>(
                                                              context)
                                                          .saveTimeAndStartTimer();
                                                    }
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 36,
                                                          vertical: 12),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color:
                                                            AppColors.kBluColor,
                                                      ),
                                                      child: TextWidget(
                                                        text:
                                                            S.of(context).Login,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // ButtonWidget(
                                                //   title: '55',
                                                //   height: 0.06,
                                                //   width: getIt<CacheHelper>()
                                                //               .getDataString(
                                                //                   key: 'Lang') ==
                                                //           'ar'
                                                //       ? 0.35
                                                //       : 0.25,
                                                //   color: AppColors.kSecondColor,
                                                //   fontSize: 18,
                                                //   fontWeight: FontWeight.bold,
                                                //   textColor: Colors.white,
                                                //   onTap: () async {
                                                //     if (authCubit
                                                //             .termsAndConditionCheckBoxValue ==
                                                //         false) {
                                                //       SnackbarUtils.showSnackbar(
                                                //           context,
                                                //           S
                                                //               .of(context)
                                                //               .YouCannotLogInWithoutAcceptingTheTerms,
                                                //           2);
                                                //     } else {
                                                //       await authCubit.login(
                                                //           context: context);

                                                //       BlocProvider.of<
                                                //                   CurrencyCodeCubit>(
                                                //               context)
                                                //           .saveTimeAndStartTimer();
                                                //     }

                                                //   },
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const UpdatePopup(),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
