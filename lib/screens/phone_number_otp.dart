import 'package:chatting_application/screens/user_profile_input_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rive/rive.dart';

import '../controller/controller.dart';

enum screen {
  number,
  otp,
}

class PhoneNumberAndOtp extends StatefulWidget {
  const PhoneNumberAndOtp({Key? key}) : super(key: key);

  @override
  State<PhoneNumberAndOtp> createState() => _PhoneNumberAndOtpState();
}

class _PhoneNumberAndOtpState extends State<PhoneNumberAndOtp> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpTextEditingController = TextEditingController();
  RiveAnimationController? _controller;
  RiveAnimationController? _controller1;
  RiveAnimationController? _controller2;
  bool _isPlaying = false;
  bool _isPlaying1 = false;
  bool _isPlaying2 = false;

  @override
  void dispose() {
    phoneNumberController.dispose();
    otpTextEditingController.dispose();
    _controller!.dispose();
    _controller1!.dispose();
    _controller2!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = OneShotAnimation(
      'Look_down_right',
      autoplay: false,
      onStop: () => setState(() => _isPlaying = false),
      onStart: () => setState(() => _isPlaying = true),
    );
    _controller1 = OneShotAnimation(
      'success',
      autoplay: false,
      onStop: () => setState(() => _isPlaying1 = false),
      onStart: () => setState(() => _isPlaying1 = true),
    );
    _controller2 = OneShotAnimation(
      'fail',
      autoplay: false,
      onStop: () => setState(() => _isPlaying2 = false),
      onStart: () => setState(() => _isPlaying2 = true),
    );
  }

  var currentScreen = screen.number.obs;

  @override
  Widget build(BuildContext context) {
    var mainScreen = false;

    Widget _buildDialogItem(Country country) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          const SizedBox(width: 8.0),
          if (mainScreen) Flexible(child: Text(country.name))
        ],
      );
    }

    Future _openCountryPickerDialog() {
      mainScreen = true;
      return showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: CountryPickerDialog(
            titlePadding: const EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: const InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: const Text('Select your phone code'),
            onValuePicked: (Country country) {
              Get.find<Controller>().setCountry(country);
            },
            itemBuilder: _buildDialogItem,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('TR'),
              CountryPickerUtils.getCountryByIsoCode('US'),
            ],
          ),
        ),
      ).then((value) {
        mainScreen = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          currentScreen.value == screen.number
              ? "Phone Number"
              : "Verification",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFd6e2ea),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 275,
              child: RiveAnimation.asset(
                "assets/animations/teddy.riv",
                animations: const ['idle', 'curves'],
                controllers: [_controller!, _controller1!, _controller2!],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => Text(
                          currentScreen.value == screen.number
                              ? "Step 01/03"
                              : "Step 02/03",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFFb8bbc4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      currentScreen.value == screen.number
                          ? Column(
                              children: [
                                const Text(
                                  "Your phone number",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "We'll send you a code to your phone number",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFFb8bbc4),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 20,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: const Color(0xFFb8bbc4),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: _openCountryPickerDialog,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                border: Border.all(
                                                  color: Color(0xFFb8bbc4),
                                                  width: 1,
                                                ),
                                              ),
                                              child: GetBuilder<Controller>(
                                                init: Controller(),
                                                builder: (chatController) =>
                                                    _buildDialogItem(chatController
                                                        .selectedDialogCountry),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: phoneNumberController,
                                            // focusNode: phoneNumberFocusNode,
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              border: InputBorder.none,
                                              hintText: "Phone number",
                                            ),
                                            keyboardType: TextInputType.number,
                                            onChanged: (val) {
                                              _isPlaying
                                                  ? null
                                                  : _controller?.isActive =
                                                      true;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 70,
                                  ),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.all(20.0)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      if (phoneNumberController.text.length <
                                              10 ||
                                          phoneNumberController.text.length >
                                              10) {
                                        _isPlaying2
                                            ? null
                                            : _controller2?.isActive = true;
                                      } else {
                                        _isPlaying1
                                            ? null
                                            : _controller1?.isActive = true;
                                        currentScreen.value = screen.otp;
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "Send code",
                                          style: TextStyle(
                                            fontSize: 22,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(Icons.send_rounded),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                const Text(
                                  "Verifying your number",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GetBuilder<Controller>(
                                  builder: (getController) => Center(
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Enter the otp sent to ',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFFb8bbc4),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '+${getController.selectedDialogCountry.phoneCode} ${phoneNumberController.text.substring(0, 5)} ${phoneNumberController.text.substring(5)}.',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Text(
                                    'Wrong number?',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: PinCodeTextField(
                                    length: 6,
                                    obscureText: true,
                                    animationType: AnimationType.fade,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 40,
                                      inactiveFillColor: Colors.orange,
                                      activeFillColor: Colors.white,
                                      selectedColor: const Color(0xFFd6e2ea),
                                      selectedFillColor:
                                          const Color(0xFFd6e2ea),
                                    ),
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    enableActiveFill: true,
                                    // errorAnimationController: errorController,
                                    controller: otpTextEditingController,
                                    onCompleted: (v) {
                                      print(otpTextEditingController.text);
                                    },
                                    onChanged: (value) {},
                                    beforeTextPaste: (text) {
                                      print("Allowing to paste $text");
                                      return true;
                                    },
                                    appContext: context,
                                  ),
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'If you didn\'t get a otp! ',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFFb8bbc4),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' Resend',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {},
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                        horizontal: 40.0,
                                        vertical: 15,
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (otpTextEditingController.text.length <
                                          6) {
                                        _isPlaying2
                                            ? null
                                            : _controller2?.isActive = true;
                                      } else {
                                        _isPlaying1
                                            ? null
                                            : _controller1?.isActive = true;
                                        Get.to(
                                            () =>
                                                const UserProfileInputScreen(),
                                            transition:
                                                Transition.rightToLeftWithFade);
                                      }
                                    },
                                    child: const Text("Verify"),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
