// *** サーバのテンプレート *** //
import processing.net.*; //
int port = 20000;//サーバのポート番号を指定（今回は20000）
int myFrameRate = 30; //フレームレート
Server my_server; //サーバオブジェクト用の大域変数

float pitch = 0;
float roll = 0;
float yaw = 0;

//初期化
void setup(){
  // *** サーバの立ち上げ処理 [ここから] *** //
  my_server = new Server(this, port); //サーバを立ち上げる
  if(my_server.active() == true){ //サーバが正しく立ち上がったか確認
    println("サーバの立ち上げに成功しました。");
  }
  // *** サーバの立ち上げ処理 [ここまで] *** //
  // 以下に他の初期化の処理を記述
  frameRate(myFrameRate); //フレームレートの設定
  size(600,400);
  colorMode(HSB, 100);
  rectMode(CENTER);
}
//draw関数
void draw(){

  // === データ受信処理 [ここから] === //
  Client c = my_server.available();//通信してきたクライアントを取得
  while(c != null){ //通信してきたすべてのクライアントを処理
    String msg = c.readStringUntil('\n'); //クライアントからのメッセージを読み込む
    if (msg != null){ //メッセージが存在していたら
      // *** クライアントから受け取ったメッセージの処理 [ここから] ***
      msg = msg.trim(); //メッセージの最後の改行文字\nを削除
      println("サーバがクライアント（" + c.ip() + "）からメッセージを受信: " + msg);//コンソールにメッセージを出力
      // クライアントから受け取ったメッセージの処理を記述
      String[] data = splitTokens(msg,","); //データを分割
      //受け取ったデータを変数に代入
      pitch = float(data[0]);
      roll = float(data[1]);
      yaw = float(data[2]);
      // *** クライアントから受け取ったメッセージの処理 [ここまで] ***
    }
    c = my_server.available(); //待っている次のクライアントを取得
  }
  // === データ受信処理 [ここまで] === //
  // === データ送信処理 [ここから] === //
  //sendDataToAllClients(); //データを送信する自作関数の呼び出し
  // === データ送信処理 [ここまで] === //
  //描画処理を記述
  int center_x = width/2;
  int center_y = height/2;

  background(100);
  fill(0, 50, 50);
  rect((roll * 2)+ center_x,  (pitch * (-2)) + center_y, 20, 20);

}
//データを送信するための自作関数
void sendDataToAllClients(){
  //送信するメッセージを作成
  String msg = "\n"; //データをカンマで区切り、最後に改行コードを付加
  // *** クライアントにメッセージを送信 ***//
  my_server.write(msg);//接続しているすべてのクライアントにメッセージを送る
  println("サーバがすべてのクライアントにメッセージを送信：" + msg);//コンソールに表示
}
