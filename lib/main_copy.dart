import 'package:flutter/material.dart';

/*
void main() {
  runApp(const MyApp());
}
*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // このウィジェットは、アプリケーションのルートとなるものです。
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // これがアプリケーションのテーマです。
        //
        // "flutter run "でアプリケーションを実行してみてください。を見ることができます。
        // アプリケーションには青いツールバーがあります。次に、アプリを終了させずに、以下を試してみてください。
        // 下のprimarySwatchをColors.greenに変更して、起動します。
        // "ホットリロード"（"フラッターラン "を実行したコンソールで "r "を押してください、
        // あるいは単に変更を保存してFlutter IDEで「ホットリロード」する）。
        // カウンターがゼロにリセットされなかったことに注目してください。
        // は再起動されない。
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // このウィジェットは、アプリケーションのホームページとなります。このウィジェットはステートフルで、つまり
  // Stateオブジェクト（以下に定義）を持ち、そのオブジェクトに影響を与えるフィールドがあること。
  // どのように見えるか
  //
  //このクラスは、状態の設定です。値を保持します（この場合
  // 親（この場合、Appウィジェット）が提供する // タイトル）と
  // Stateのbuildメソッドで使用されます。Widgetサブクラス内のフィールドは
  // 常に "final "と表示される。

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // このsetStateの呼び出しは、Flutterフレームワークに何かが起こったことを伝えますこのStateで
      // 変更があったため、以下のビルドメソッドを再実行する。
      // 更新された値をディスプレイに反映させることができるようにします。もし私たちがsetState() を呼び出さずに
      // _counter を呼び出すと、ビルドメソッドに失敗します。
      // 再び呼び出されたので、何も起こらないように見えるだろう。
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // このメソッドは、setStateが呼ばれるたびに再実行されます。
    //上記の_incrementCounterメソッドによって、
    // Flutterフレームワークは、ビルドメソッドを再実行するように最適化されています。
    //更新が必要なものはすぐにリビルドできるように、速いです。
    // ウィジェットのインスタンスを個別に変更する必要がない

    return Scaffold(
      appBar: AppBar(
        // で作成されたMyHomePageオブジェクトから値を取得します。
        // App.buildメソッドを使用し、appbarのタイトルを設定するために使用します。
        title: Text(widget.title),
      ),
      body: Center(
        // Center はレイアウトウィジェットです。子機を1つ取り、それを配置します。
        // 親の真ん中に
        child: Column(
          // Columnもレイアウトウィジェットです。これは、子供のリストを受け取り
          // 縦に並べます。デフォルトでは親と同じ高さになるように、 子を水平に並べる。
        // 「デバッグペインティング」を起動する（コンソールで「p」を押し、「デバッグペインティング」を選ぶ
        // AndroidのFlutter Inspectorから "Toggle Debug Paint "アクションを実行する。
        // Studio、または Visual Studio Code の "Toggle Debug Paint" コマンド)
        // 各ウィジェットのワイヤーフレームを見ることができます。
        //
        // カラムには、サイズを制御するためのさまざまなプロパティがあります。
        // 子をどのように配置するか。ここでは、mainAxisAlignmentを使用して、次のようにしています。
        // ここでは、主軸は垂直方向です。Columnが垂直なので
        // 軸（十字軸は水平）。


          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), //この末尾のカンマは、ビルドメソッドの自動書式設定をより適切にします。
    );
  }
}
