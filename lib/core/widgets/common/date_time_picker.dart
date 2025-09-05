import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:country_picker/country_picker.dart';
import '../../resources/export_resources.dart';
import '../export_custom_widget.dart';

Future datePicker(BuildContext context, {bool issuedDate = false}) async {
  DateTime initialDate = DateTime.now();

  final DateTime maxSelectableDate = DateTime(initialDate.year, initialDate.month, initialDate.day);
  return await showDatePicker(
    context: context,
    initialDate: issuedDate ? maxSelectableDate : initialDate,
    firstDate: issuedDate ? DateTime(1900) : DateTime.now(),
    lastDate: issuedDate ? maxSelectableDate : DateTime(2500),
    initialEntryMode: DatePickerEntryMode.calendar,
    helpText: 'Select a date',
    cancelText: 'Close',
    confirmText: 'Select',
    fieldHintText: 'Month/Day/Year',
    fieldLabelText: 'BirthDate',
    errorInvalidText: 'Please enter a valid date',
    errorFormatText: 'This is not the correct format',
    selectableDayPredicate: (day) {
      return true;
    },
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: primaryColor),
          datePickerTheme: const DatePickerThemeData(
            backgroundColor: whiteColor,
            dividerColor: blackColor,
            headerBackgroundColor: primaryColor,
            headerForegroundColor: whiteColor,
          ),
        ),
        child: child!,
      );
    },
  );
}

Future nepaliDatePicker(
  BuildContext context, {
  bool issuedDate = false,
  Function(NepaliDateTime)? onDateChanged,
}) async {
  NepaliDateTime initialDate = NepaliDateTime.now();

  final NepaliDateTime maxSelectableDate = NepaliDateTime(
    initialDate.year,
    initialDate.month,
    initialDate.day,
  );
  return showMaterialDatePicker(
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: primaryColor,
            onPrimary: whiteColor,
            onSurface: blackColor,
          ),
          dialogBackgroundColor:
              Theme.of(context).brightness == Brightness.dark
                  ? greyColor.withOpacity(0.6)
                  : whiteColor,
        ),
        child: child!,
      );
    },
    context: context,
    initialDate: issuedDate ? maxSelectableDate : initialDate,
    firstDate: issuedDate ? NepaliDateTime(1970) : NepaliDateTime.now(),
    lastDate: issuedDate ? maxSelectableDate : NepaliDateTime(2100),
  );
}

Future timePicker(BuildContext context) async {
  TimeOfDay initialTime = TimeOfDay.now();

  return await showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: primaryColor,
            onPrimary: whiteColor,
            onTertiary: whiteColor,
            onSurface: blackColor,
            tertiary: primaryColor,
          ),
          dialogBackgroundColor:
              Theme.of(context).brightness == Brightness.dark
                  ? greyColor.withOpacity(0.6)
                  : whiteColor,
        ),
        child: child!,
      );
    },
  );
}

Future countryPicker(BuildContext context, Function(Country) onSelect) async {
  showCountryPicker(
    context: context,
    countryListTheme: CountryListThemeData(
      flagSize: 25,
      backgroundColor: Colors.white,
      textStyle: customTextStyle(fontSize: 16, color: Colors.blueGrey),
      bottomSheetHeight: 400,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      inputDecoration: InputDecoration(
        labelText: 'Search',
        hintText: 'Start typing to search',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFF8C98A8).withOpacity(0.2)),
        ),
      ),
    ),
    onSelect: (Country country) => onSelect(country),
  );
}
