import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PhoneNumber extends StatelessWidget {
  const PhoneNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildDialogItem(Country country) => Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(width: 8.0),
            Text("+${country.phoneCode}"),
            SizedBox(width: 8.0),
            Flexible(child: Text(country.name))
          ],
        );
    Country _selectedFilteredDialogCountry =
        CountryPickerUtils.getCountryByPhoneCode('90');
    void _openFilteredCountryPickerDialog() => showDialog(
          context: context,
          builder: (context) => Theme(
              data: Theme.of(context).copyWith(primaryColor: Colors.pink),
              child: CountryPickerDialog(
                  titlePadding: EdgeInsets.all(8.0),
                  searchCursorColor: Colors.pinkAccent,
                  searchInputDecoration: InputDecoration(hintText: 'Search...'),
                  isSearchable: true,
                  title: Text('Select your phone code'),
                  onValuePicked: (Country country) =>
                      _selectedFilteredDialogCountry = country,
                  itemFilter: (c) =>
                      ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode),
                  itemBuilder: _buildDialogItem)),
        );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Stack(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Center(
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
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 70),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(22.5)),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF341eff)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35.0),
                                  ),
                                ),
                              ),
                              onPressed: () {},
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
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
