import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math';

// aqui é coletado o path de todas as imagens utilizadas
String judgement = "assets/images/judgement.jpg";
String justice = "assets/images/justice.jpg";
String strenght = "assets/images/strenght.jpg";
String temperance = "assets/images/temperance.jpg";
String the_chariot = "assets/images/the_chariot.jpg";
String the_fool = "assets/images/the_fool.jpg";
String the_moon = "assets/images/the_moon.jpg";
String the_star = "assets/images/the_star.jpg";
String the_sun = "assets/images/the_sun.jpg";
String the_tower = "assets/images/the_tower.jpg";
String the_magician = "assets/images/the_magician.jpeg";
String the_devil = "assets/images/the_devil.jpeg";
String verso = "assets/images/backfaceyugioh.jpg";
int cliques = 0;
List<GlobalKey<MycardState>> clicadas = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: true, //aqui retira a faixa de debug
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Mycard extends StatefulWidget {
  Mycard(String this.face, {super.key});

  final String face;

  @override
  State<Mycard> createState() => MycardState();
}

class MycardState extends State<Mycard> {
  bool isBack = true;
  double angle = 0;

  void flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi); // esse calculo garante que o angle sempre vai se manter entre 0 e 180
    });
  }

  @override
  Widget build(BuildContext context) {
    String faceP = widget.face; //coleto a face da super classe acima
    return GestureDetector(
      onTap: () => {
        clicadas.add(widget.key as GlobalKey<MycardState>), //aqui adiciono a chave da carta clicada na lista de cartas clicadas
        cliques++, //aqui o numero de cliques é incrementado
        if(cliques == 2){
          if(clicadas[0].currentState?.widget.face == clicadas[1].currentState?.widget.face){ //aqui verifico se as duas cartas clicadas são iguais
            print("iguais"),
            clicadas.clear(), //aqui a lista de cartas clicadas é limpa
            cliques = 0, //aqui o numero de cliques é zerado
          }else{
            print("diferentes"),
            Future.delayed(Duration(milliseconds: 1500), () {
              clicadas[0].currentState?.flip(); //se forem diferentes, as duas cartas são viradas para baixo
              clicadas[1].currentState?.flip();
              clicadas.clear(); //aqui a lista de cartas clicadas é limpa
              cliques = 0; //aqui o numero de cliques é zerado
            }),
          }
        },
        flip(), //executo um flip quando a carta for clicada
        print("a imagem sendo exibida é a $faceP"),
      },
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: angle),
        duration: Duration(milliseconds: 500),
        builder: (BuildContext context, double val, __) {
          if (val >= (pi / 2)) {
            //quando a imagem ja foi metade rotacionada a variavel se altera para que a imagem altere
            isBack = false;
          } else {
            isBack = true;
          }
          return (Transform(
            alignment: Alignment
                .center, // aqui é definido que o eixo de rotação é no centro
            transform: Matrix4
                .identity() // aqui é adicionado a profundidade da carta rotacionando
              ..setEntry(3, 2, 0.001)
              ..rotateY(val),
            child: Container(
              child: isBack //aqui começa um operador ternario que definie qual imagem será exibida
            ? Container(
                margin: const EdgeInsets.all(8.0),
                child: Image.asset(verso),
              )
            : Container(
                margin: const EdgeInsets.all(8.0),
                child: Image.asset(faceP),
              ),
            ),
          ));
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<String>> matriz = [
    // aqui é definida a matriz que será posta na interface
    [judgement, judgement, justice, justice, strenght, strenght],
    [temperance, temperance, the_chariot, the_chariot, the_fool, the_fool],
    [the_moon, the_moon, the_star, the_star, the_sun, the_sun],
    [the_tower, the_tower, the_magician, the_magician, the_devil, the_devil],
  ];

  // aqui é definida uma matriz de listas que vai conter as cartas no tabuleiro
  List<List<Mycard>> cards = [[],[],[],[]];

  // aqui é definida uma matriz de listas que vai conter as chaves de cada carta, para podermos controlar as cartas
  List<List<GlobalKey<MycardState>>> keys = List.generate(
    4,
    (i) => List.generate(
      6,
      (j) => GlobalKey<MycardState>(),
    ),
  );
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { // aqui é definido que a função será executada após o build de todos os widgets
      setState(() {
        // shuffleMatrix(matriz); //depois que todos os widgets são gerados pela primeira vez, embaralhamos
      });
    });
  }

  // função para embaralhar matrizes
  void shuffleMatrix(List<List<String>> matrix) {
    final random = Random();

    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        final randomRow = random.nextInt(matrix.length);
        final randomCol = random.nextInt(matrix[i].length);

        // Troca os elementos
        final temp = matrix[i][j];
        matrix[i][j] = matrix[randomRow][randomCol];
        matrix[randomRow][randomCol] = temp;
      }
    }
    // aqui é atualizada a matriz de cartas com as novas imagens
    for(int i = 0;i<matriz.length;i++){
      for(int j = 0;j<matriz[i].length;j++){
        cards[i][j] = Mycard(key: keys[i][j], matriz[i][j]);
      }
    }
  }

  void _reset() {
    //todas as cartas sejam viradas para baixo e depois embaralhadas
    setState(() {
      for (int i = 0; i < keys.length; i++) {
        for (int j = 0; j < keys[i].length; j++) {
          if(keys[i][j].currentState?.isBack == false){
            keys[i][j].currentState?.flip();
          }
        }
      }
      sleep(Duration(milliseconds: 250));
      shuffleMatrix(matriz);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              //container que vai conter o Grid View
              width: 900,
              height: 600,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: matriz[0].length, // aqui é especificado o numero de colunas do grid
                ),
                itemCount: matriz.length * matriz[0].length, // aqui é especificado o numero de elementos do grid
                itemBuilder: (context, index) {
                  // aqui será construido cada item do gridView, o index assume todos os valores de 0 até o valor do tamanho do grid
                  final row = index ~/ matriz[0].length;
                  final col = index % matriz[0].length;
                  cards[row].add(Mycard(key: keys[row][col], matriz[row][col]));
                  return cards[row][col];
                },
              ),
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _reset,
        tooltip: 'Reset',
        child: const Text("Reset"),
      ),
    );
  }
}
