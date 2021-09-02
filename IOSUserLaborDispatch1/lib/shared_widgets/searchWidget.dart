import '../configs/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'decoration.dart';

class SearchBar extends StatelessWidget {
  TextEditingController searchController;
  Function onChangedFn;
  String labelText;

  SearchBar({this.searchController, this.onChangedFn, this.labelText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: DecorationBoxes.decorationBackgroundGreyWithRadius(),
      child: new TextFormField(
        controller: searchController,
        keyboardType: TextInputType.text,
        autofocus: false,
        onChanged: (val) {
          onChangedFn(val);
        },
        decoration: DecorationInputs.textBoxInputDecorationWithPrefixIcon(
            prefixIcon: Icon(Icons.search, size: 25.0, color: AppColors.APP_BLACK_COLOR,),
            labelText: labelText),
      ),
    );
  }
}
