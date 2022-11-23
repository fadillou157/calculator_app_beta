import 'package:challenge_appcalculator/models/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = '0';
  //pour afficher le resultat
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            // Pour l'alignement du contenu de la page (Pour les colones un alignment sur l'axe verticale ou y) : Voir documentation Flutter alignement
            crossAxisAlignment: CrossAxisAlignment.end,
            // Pour l'alignement du contenu de la page (Pour les colones un alignment sur l'axe horizontale ou x)
            children: [
              GestureDetector(
                onHorizontalDragEnd: (details) => {_dragToDelete()},
                child: Text(
                  _formatResult(result),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: result.length > 5
                        ? 60
                        : 100, // Pour redimensionner la taille du texte si le text est supérieur à 5 caractéres metre la taille à 60px.
                    color: Colors.white,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
              SizedBox(
                height: 15, // hauteur de la partie resultat
              ),
              Container(
                //color: Colors.amber,
                height: MediaQuery.of(context).size.height * 0.6,
                child: _buildButtonsGrid(),
              ),
            ]),
      ),
    );
  }

  void _dragToDelete() {
    setState(
      () {
        if (result.length > 1) {
          result = result.substring(0, result.length - 1);
          currentNumber = result;
        } else {
          result = '0';
          currentNumber = '';
        }
      },
    );
  }

  String previousNumber = '';
  String currentNumber = '';
  String selectedOperated = '';
  void _onButtonPressed(String buttonText) {
    setState(
      () {
        switch (buttonText) {
          case '÷':
          case '×':
          case '-':
          case '+':
            if (previousNumber != '') {
              _calculateResult();
            } else {
              previousNumber = currentNumber;
            }
            currentNumber = '';
            selectedOperated = buttonText;
            break;
          case '±':
            currentNumber = convertStringToDouble(currentNumber) < 0
                ? currentNumber.replaceAll('-', '')
                : "-$currentNumber";
            result = currentNumber;
            break;
          case '%':
            currentNumber =
                (convertStringToDouble(currentNumber) / 100).toString();
            result = currentNumber;
            break;
          case '=':
            _calculateResult();
            previousNumber = '';
            selectedOperated = '';
            break;
          case 'C':
            _resetCalculator();
            break;
          default:
            currentNumber = currentNumber + buttonText;
            result = currentNumber;
        }
      },
    );
  }

  void _calculateResult() {
    double _previousNumber = convertStringToDouble(previousNumber);
    double _currentNumber = convertStringToDouble(currentNumber);

    switch (selectedOperated) {
      case '÷':
        _previousNumber = _previousNumber / _currentNumber;
        break;
      case '×':
        _previousNumber = _previousNumber * _currentNumber;
        break;
      case '-':
        _previousNumber = _previousNumber - _currentNumber;
        break;
      case '+':
        _previousNumber = _previousNumber + _currentNumber;
        break;
      default:
        break;
    }

    currentNumber =
        (_previousNumber % 1 == 0 ? _previousNumber.toInt() : _previousNumber)
            .toString();
    result = currentNumber;
  }

  void _resetCalculator() {
    result = '0';
    previousNumber = '';
    currentNumber = '';
    selectedOperated = '';
  }

  double convertStringToDouble(String number) {
    return double.tryParse(number) ?? 0;
  }

  String _formatResult(String number) {
    var formatter = NumberFormat("###,###.##", "en_Us");
    return formatter.format(convertStringToDouble(number));
  }

  Widget _buildButtonsGrid() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        final button = buttons[index];
        return MaterialButton(
          padding: button.value == '0'
              ? const EdgeInsets.only(right: 100)
              : EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(60),
            ),
          ),
          color: button.bgColor,
          onPressed: () {
            _onButtonPressed(button.value);
          },
          child: Text(
            button.value,
            style: TextStyle(
              color: (button.value == selectedOperated && currentNumber == '')
                  ? button.bgColor
                  : button.fgColor,
              fontSize: 35,
            ),
          ),
        );
      },
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      staggeredTileBuilder: (index) =>
          StaggeredTile.count(buttons[index].value == '0' ? 2 : 1, 1),
    );
  }
}
