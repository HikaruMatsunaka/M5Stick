#include <M5StickCPlus.h>
#include <WiFi.h>

//SSIDとパスワード
//※ 2.5GHz帯にしか対応していない（5GHz帯には接続できない）ので注意！
const char* ssid     = "mac_room1"; //各自の環境に設定
const char* password = "dept.ofa.i.d."; //各自の環境に設定

const char* server_ip = "192.168.50.204"; //サーバのアドレス・各自の環境で設定
const int port = 20000;

WiFiClient client;

void setup() {
  M5.begin(); //M5Stick C Plusの初期化
  M5.Lcd.setRotation(1);  //Rotate the screen.
  M5.Lcd.setTextSize(2);  //Set font size.  

  //Wi-Fiへの接続
  M5.Lcd.print("Connecting to ");
  M5.Lcd.println(ssid);

  WiFi.begin(ssid, password); //ssidとpasswordを使って無線APに接続
  while (WiFi.status() != WL_CONNECTED) {//接続できたかのチェック
      delay(500);
      M5.Lcd.print(".");
  }
  M5.Lcd.println("");
  M5.Lcd.println("Successfully connected to WiFi.");
  M5.Lcd.println("IP address: ");
  M5.Lcd.println(WiFi.localIP());
  delay(1000);
  //サーバへのソケット接続

  M5.Lcd.fillScreen(BLACK); //画面をクリア
  M5.Lcd.setCursor(0, 0); //表示位置を指定
  M5.Lcd.print("Connecting to ");
  M5.Lcd.println(server_ip);
  while (!client.connected()) {
    client.connect(server_ip, port);
    delay(500);
    M5.Lcd.print("."); 
  }
  M5.Lcd.print("Successfully connected to server ");
  M5.Lcd.println(server_ip);

  M5.Imu.Init();  //IMUの初期化. 
}

void loop() {
  M5.update(); //これを呼び出さないとボタンの状態は更新されない

  float pitch = 0.0F;
  float roll  = 0.0F;
  float yaw   = 0.0F;
  M5.IMU.getAhrsData(&pitch,&roll,&yaw); //市政情報の取得
  //送信するデータの構築
  String str = String(pitch,2) + "," + String(roll,2) + "," + String(yaw,2); 
  client.println(str);//サーバにデータを送信

  //画面にデータを表示
  M5.Lcd.fillScreen(BLACK); //画面をクリア
  M5.Lcd.setCursor(0, 0); //表示位置を指定
  M5.Lcd.println(str);

  delay(50);
}
