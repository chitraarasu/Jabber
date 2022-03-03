import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({Key? key}) : super(key: key);

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  String animationType = "idle";

  final phoneNumberController = TextEditingController();
  final phoneNumberFocusNode = FocusNode();

  // @override
  // void initState() {
  // phoneNumberFocusNode.addListener(() {
  //   if (phoneNumberFocusNode.hasFocus) {
  //     setState(() {
  //       animationType = "test";
  //     });
  //   } else {
  //     setState(() {
  //       animationType = "idle";
  //     });
  //   }
  // });
  //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    Country _selectedDialogCountry =
        CountryPickerUtils.getCountryByPhoneCode('91');

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
            onValuePicked: (Country country) =>
                setState(() => _selectedDialogCountry = country),
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
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
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
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animations: [animationType],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
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
                      const Text(
                        "Step 01/03",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFb8bbc4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: Color(0xFFb8bbc4),
                                        width: 1,
                                      ),
                                    ),
                                    child: _buildDialogItem(
                                        _selectedDialogCountry),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: phoneNumberController,
                                  focusNode: phoneNumberFocusNode,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    hintText: "Phone number",
                                  ),
                                  keyboardType: TextInputType.number,
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
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF341eff)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (phoneNumberController.text.length == 10) {
                              setState(() {
                                animationType = "success";
                              });
                            } else {
                              setState(() {
                                animationType = "fail";
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
