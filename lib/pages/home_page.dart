import 'package:challenge_appcalculator/models/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = '123455';
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
                  result,
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
    print("Delete last digit");
  }

  void _onButtonPressed(String buttonText) {
    print(buttonText);
  }

  Widget _buildButtonsGrid() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        final button = buttons[index];
        return MaterialButton(
          padding: button.value == '0'
              ? EdgeInsets.only(right: 100)
              : EdgeInsets.zero,
          shape: RoundedRectangleBorder(
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
              color: button.fgColor,
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
