import processing.net.*;//ソケット通信のためのライブラリを読み込み

String serverAdder = "127.0.0.1"; //サーバのアドレス
int port = 20000; //サーバのポート番号を指定（今回は20000）
int myFrameRate = 30; //フレームレート

Client my_client; //クライアントオブジェクト用の大域変数

// *** 送信したいデータを格納する大域変数 *** //
int cx = 0;
int cy = 0;
//データとして送りたい変数は、ここで宣言して大域変数としておく
int sx = 0;
int sy = 0;
//ボール用の大域変数
float ball_x = 0;
float ball_y = 0;
float ball_r = 30;

int racket_w = 30;
int racket_h = 60;


//初期化
void setup() {
  // *** クライアントの立ち上げ（サーバへの接続）処理 [ここから] *** //
  my_client = new Client(this, serverAdder, port);//サーバに接続
  if (my_client.active() == true){//クライアントがサーバに正しく接続できたか確認
    println("クライアントはサーバ（" + serverAdder + "）に正しく接続しました");
  }
  // *** クライアントの立ち上げ（サーバへの接続）処理 [ここまで] *** //
  // 以下に他の初期化の処理を記述
  frameRate(myFrameRate); //フレームレートの設定
  size(600,400);
  colorMode(HSB, 100);
  rectMode(CENTER);
  ellipseMode(CENTER);
}

//draw関数の定義
void draw() {

  // === データ送信処理 [ここから] === //
  sendDataToServer(); //データを送信する自作関数の呼び出し
  // === データ送信処理 [ここまで] === //

  //描画処理を記述
  background(100);//白で背景を塗りつぶす
  noStroke();
  //サーバの矩形を描画
  fill(0, 100, 50);
  rect(sx, sy, racket_w, racket_h);
  //クライアントの矩形を描画
  fill(50, 100, 50);
  rect(cx, cy, racket_w, racket_h);
  //ボールを描画
  fill(0);
  circle(ball_x, ball_y, ball_r);

}

//サーバーからデータを受け取るたびに呼び出される関数(clientEvent関数）の定義
void clientEvent(Client c) {
  // === データ受信処理 [ここから] === //
  String msg = c.readStringUntil('\n'); //メッセージの読み込み
  while(msg != null) { //メッセージが存在する間繰り返す

    // *** サーバから受け取っメッセージの処理 [ここから] ***
    msg = msg.trim(); //メッセージの最後の改行文字\nを削除
    println("クライアント（" + c.ip() + "）がサーバからメッセージを取得：" + msg);

    // クライアントから受け取ったデータの処理を記述
    String[] data = splitTokens(msg, ",");
    sx = int(data[0]);
    sy = int(data[1]);
    //ボールデータの代入
    ball_x = float(data[2]);
    ball_y = float(data[3]);

    // *** サーバから受け取ったデータの処理 [ここまで] ***

    msg = c.readStringUntil('\n');//次のデータの取得
  }
  // === データ受信処理 [ここまで] === //
}

//データを送信するための自作関数
void sendDataToServer(){
  //送信するメッセージを作成
  String msg = cx + "," + cy + "\n"; //送りたい変数データをカンマで区切り、最後に改行コードを付加 

  // *** サーバにメッセージを送信 ***//
  my_client.write(msg); //サーバにメッセージを送信
  print("クライアントがサーバ（" + serverAdder + "）にメッセージを送信：" + msg); //コンソールに表示
}

//マウスがクリックされたら呼び出される関数
void mouseMoved() {
  // 送信するデータを大域変数として格納しておく
  // マウスの位置を大域変数に入れる
  cx = mouseX;
  cy = mouseY;
}
