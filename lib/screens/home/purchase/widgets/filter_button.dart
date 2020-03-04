import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/purchase/purchase.dart';
import 'package:gulmate/model/visibility_filter.dart';

typedef FilterSelected<T> = void Function(T value);

class FilterButton extends StatelessWidget {


  FilterButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle =
        TextStyle(fontSize: 16, color: Color.fromRGBO(187, 187, 187, 1));
    final activeStyle =
        TextStyle(fontSize: 16, color: Color.fromRGBO(34, 34, 34, 1));
    return BlocBuilder<FilteredPurchaseBloc, FilteredPurchaseState>(
        builder: (context, state) {
      final button = _Button(
        activeFilter: state is FilteredPurchaseLoaded
            ? state.activeFilter
            : VisibilityFilter.all,
        activeStyle: activeStyle,
        defaultStyle: defaultStyle,
        onSelected: (filter) {
          BlocProvider.of<FilteredPurchaseBloc>(context)
              .add(UpdateFilter(filter));
        },
      );
      return button;
    });
  }
}

class _Button extends StatelessWidget {
  final VisibilityFilter activeFilter;
  final FilterSelected<VisibilityFilter> onSelected;
  final TextStyle activeStyle;
  final TextStyle defaultStyle;

  static const _buttonPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 12);

  _Button(
      {Key key,
      @required this.activeFilter,
      @required this.onSelected,
      @required this.activeStyle,
      @required this.defaultStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () => onSelected(VisibilityFilter.all),
            child: _buildButtonContent("전체", VisibilityFilter.all),
          ),
          InkWell(
            onTap: () => onSelected(VisibilityFilter.active),
            child: _buildButtonContent("구매 예정", VisibilityFilter.active),
          ),
          InkWell(
            onTap: () => onSelected(VisibilityFilter.completed),
            child: _buildButtonContent("구매 완료", VisibilityFilter.completed),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonContent(String text, VisibilityFilter filter) {
    return Container(
          padding: _buttonPadding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            text,
            style: activeFilter == filter
                ? activeStyle
                : defaultStyle,
          ),
        );
  }
}
