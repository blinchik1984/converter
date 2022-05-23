import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';

class SideBarMenu extends StatefulWidget {
  String languageCode;
  Function chooseLanguage;
  List<Language> supportedLanguages = [];
  bool alwaysConvert = false;
  Function onChangeAlwaysConvert;


  SideBarMenu({
    Key? key,
    required this.languageCode,
    required this.chooseLanguage,
    required this.supportedLanguages,
    required this.alwaysConvert,
    required this.onChangeAlwaysConvert,
  }) : super(key: key);

  @override
  _SideBarMenuState createState() => _SideBarMenuState();
}

class _SideBarMenuState extends State<SideBarMenu> {
  String _languageCode = '';
  List<Language> _supportedLanguages = [];
  bool _alwaysConvert = false;

  @override
  void initState() {
    super.initState();

    _languageCode = widget.languageCode;
    _supportedLanguages = widget.supportedLanguages;
    _alwaysConvert = widget.alwaysConvert;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text('Converter'),
          ),
          ListTile(
            title: Text(Language.fromIsoCode(_languageCode).name),
            onTap: _openLanguagePickerDialog,
          ),
          ListTile(
            title: Row(
              children: [
                const Expanded(
                    child: Text('Always convert currency')
                ),
                CupertinoSwitch(
                  value: _alwaysConvert,
                  onChanged: (value) {
                    _alwaysConvert = !_alwaysConvert;
                    widget.onChangeAlwaysConvert();
                    setState(() {});
                  }
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _openLanguagePickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.black),
      child: LanguagePickerDialog(
          languages: _supportedLanguages,
          titlePadding: EdgeInsets.all(8.0),
          searchInputDecoration: InputDecoration(hintText: 'Search...'),
          isSearchable: true,
          title: Text('Select your language'),
          onValuePicked: (Language language) => setState(() {
            _languageCode = language.isoCode;
          }),
          itemBuilder: _buildDialogItem
      )
    ),
  );

  Widget _buildDialogItem(Language language) => Row(
    children: <Widget>[
      Text(language.name),
      SizedBox(width: 8.0),
      Flexible(child: Text("(${language.isoCode})"))
    ],
  );
}

