#import "template.typ": *


#show: project.with(
  title: "筋電義手人工感覚のための駆動部エネルギー測定に基づく力覚センシング",
  englishTitle: "Kinesthetic sense based on evaluation of actuator energy for artificial sense in myoelectric prosthetic hands",
  author: "半田 寛明",
  supervisor: "葛西 誠也 教授",
  affiliation: "工学部情報エレクトロニクス学科電気電子工学コース",
  lab: "量子知能デバイス研究室",
  grade: "学部4年",
  year: "令和5",
)

#outline(indent: 2em, fill: box(width: 1fr, repeat[⋯]))

// start page number
#set page(numbering: "1", number-align: center, margin: (top: 35.01mm, left: 30mm, right: 30mm, bottom: 30mm))
#counter(page).update(1)


= 序論

== 背景

何らかの事故や病気により後天的に上肢を無くしてしまった人、そして先天的に上肢がない人は本人の意思とは無関係に、取れる社会参加の選択肢が限られてしまう。社会構造自体をそのような人々も参画しやすい形に変革する方法も考えられるが、そのためには上肢を必要としないコミュニケーションや業務執行の方法を考える必要が出てくるため、いずれにせよ技術的課題に直面する。\
このため、上肢を補う形での社会参加が克服すべきハードルが最小に思える。そこで使用者自身の身体の一部のように感じることのできる操作感の義手が必要になってくるのは明らかである。そもそも義手には審美性のみを目的とした物も存在するが、操作可能な上、侵襲性がないため着脱が容易な筋電義手が本分野のこれからの潮流を為すと考えられる。\
人間が自分の手を動作させる際、随意動作（意識的動作）と不随意動作（無意識的動作）に分類できる。随意動作とは、人間が意図した通りの動きをする動作である一方、不随意操作は人間が動作に対して意識的にならずとも確かに行っている動作や制御のことである。熱いものや痛みを感じると同時かむしろ感じるより前に手を引っ込めたり、重いものを持つときに無意識に力を加えてものが落ちないように制御したりといったことがこれに当たる。
筋電義手の目指す先は使用者があたかも自分の手であったかのように操作を行える状態である。このため、その完成度は問題になるが、筋電義手における随意操作性能自体は研究分野としてすでに大きなものとして存在する @Prosthetic-Hands-Trends 。一方で不随意の動作に関してはその課題感の共有の難しさから課題として捉えられにくい分野になってくる。しかし、この不随意動作無くして人の手のような操作感は得られない。

#figure(image("assets/overview_table.png"), numbering: "1", caption: text("筋電義手研究の方針と現在地"), kind: table)

== 目的

不随意動作を暗黙的に義手に実装するのでは自分の手のようにはならない。生体の手のように、触る温度の形状、触り心地などはもちろんのこと、手にかかっている重量的な負担をも利用者にフィードバックする必要がある。触覚に当たる部分を皮膚感覚、重量的負担を感じる力覚の部分を深部感覚と呼ばれているが、皮膚感覚の分野については義手のみならずxRなどの分野でもハプティクスと呼ばれるように、他分野に渡り研究が進められている。一方で深部感覚については皮膚感覚と同様に重要であるにも関わらず比較的研究が進められていない。これはGoogle Scholarにて "haptics" は225,000件、 "cutaneous sensation" は516,000件ヒットするのに対し、深部感覚にあたる "bathyesthesia" は86件しかヒットしないことからも明らかである。なお "deep sense" や "deep sensing" などはディープラーニングのアルゴリズムなど多岐にわたる分野での使用がされている用語であるため除外した。これらの研究動向を踏まえ、我々は重要にも関わらずあまり手をつけられていない分野である力覚のフィードバックに今回取り組むこととした。

== 本論文の構成

本論文は全6章から構成されている。\
第1章では本論文の目的及び先行研究を踏まえた立ち位置を論じた。\
第2章では力覚センシング技術を紹介する。\
第3章では筋電義手の駆動部エネルギー測定をすることで如何に力覚センシングを行うかを説明する。\
第4章では本研究結果を用いて推論モデルを作成するのにに用いるリザバーコンピューティングの説明を行う。\
第5章では駆動部エネルギーという信号をリザバーコンピューティングを用いて解析する手法について紹介する。\
最後に第6章を本論文のまとめとする。

#pagebreak(weak: true)

= 力覚センシング

力覚を測定するための機構は古くから研究されており、産業用ロボットやタッチディスプレイなど幅広い用途で利用されてきた。以下に主な力覚センシングをする技術を紹介する。 @Sensors

== 既存の力覚センシング技術

=== 歪みゲージセンサ

歪みゲージセンサはセンサー部にかかる引張力・圧縮力により、電気抵抗が変化する金属抵抗材料の性質を利用して、力やトルクに換算する。小型で精度が高く、応答性も高いことから多くの場面で使われる。

=== 圧電センサ

水晶やPZT (ジルコン酸チタン酸鉛) などの圧電効果を有する材料をセンサー部に使用して、力を測定する。小型で応答性が高く、コストも比較的優れいるが精度は、ひずみゲージ式や静電容量式には及ばない。

=== 静電容量センサ

センサー部を金属材料の電極が向かい合わせに配置されたコンデンサ型とし、力により導体間にひずみが生じて距離が変わることによる静電容量の変化を検知する。構成が比較的簡単で低コストで生産できる上、電極をフィルム状にすると、小型化・薄型化が可能である。精度や応答性も優れている。

=== 光学センサ

計測対象物に一定間隔で模様をマーキングしておき、力が加わった時に生じる模様の変化を、カメラやレーザーなどの光学センサで検出して、力の大きさを計算して求める。非接触で測定できることが最大のメリットではあるが精度、応答性、小型化、コストは、他の方式に軍配が上がるため使われる場面は限られる。

=== サーボの逆起電力とサーボ内蔵センサを用いた手法

先述のようなセンサを用いない手法も古くから研究されている。
特に今回のようにサーボモータを内蔵する場合が非常に多い筋電義手のようなものの場合、もともともと内蔵されているサーボから得られる信号を用いる方法として逆起電力を観測する方法がある。これはモータに外力を与えて回転させた際にモータが発電機として振る舞う現象を用いる手法である。しかしこれだけでは回転方向がわからないため、サーボモータの回転角制御用に搭載されているエンコーダやタコジェネレータを用いることで外力の方向を割り出すというものである。\
以下にその数理的説明を行う。

==== センサレスセンシングの数理的説明

全外乱から外力以外の要素をモデル化し取り除くことで外力のみを抽出可能として考えると以下の式で表現される。\

#math.equation(block:true,numbering: "(1)" ,$ F_"ext"=F_"dis"-(F_"int"+F_"g"+F_"c"+D s X^"res"+Delta M s ^2X^"res"-Delta"K"_t"I"^"ref"_a) $)

ただしここで$F_"dis"$は全外乱、$F_"int"$はコリオリ力・遠心力などの内部干渉力、$F_g$は姿勢の影響で重力加速度により発生する力、$F_c$はクーロン摩擦力、$D s X^"res"$は粘性摩擦力、$M$はモータ稼働部の慣性であり$M s^2 X^"res"$は周波数領域におけるモータの動力学を表す（すなわち$s, X^"res"$はそれぞれラプラス演算子と周波数領域での角度を表す変数）。$K_t$はモータに使用されている磁石の強さやコイルの巻線量によって変化するモータ固有の推力定数、$I_a^"ref"$は周波数領域における電流を表す変数である。\
式(1)におけるC摩擦力$F_c$、粘性摩擦力$D s X^"res"$は二種の等速度試験、慣性変動$Delta M$は加速度試験によって同定することができる。@Sensorless-Sensing


== 既存技術の課題

力覚を取得する方法には各種センサを用いる方法と、内蔵されているサーボモータから得られる信号を用いる方法とが一般的であることがわかった。しかし、どちらの方法も筋電義手に力覚を与えるためのアプローチとしては相応しくない。

=== 力覚センサの問題点

前節で紹介した力覚センサを筋電義手に用いるとなると二つの懸念点が浮かんでくる。搭載センサの取り付け位置とコストの増加だ。前節で紹介した力覚センサはどれも圧力が直接かかる部分に設置する必要がある。物に触れた際に感じる感触が認識対象であればこれでも構わないが、今回対象とするのは稼働部にかかる力覚であるため力覚センサも稼働部に取り付ける必要が出てくる。駆動部にある程度サイズのある力覚センサを取り付けるとなると取り付け位置や取り付け方にかなりの工夫が必要となってくることは想像に難くない。\
また、コストの面でも各サーボ関節部分に力覚センサが必要となってくることから効果になってくる。筋電義手は上肢がない方が生活に支障のないようするという、人権の面からも最低限必要なものとなってくるものであるため、低コストに抑えることが重要である。そのためには各関節ごとに高価なセンサを搭載することは望ましくない。

=== サーボの逆起電力を用いた場合の問題点

既存技術の中で安価なアプローチとしてサーボの逆起電力とエンコーダ等の回転方向を検出するセンサとを組み合わせたセンサレスの手法がある。前節でも紹介した通り、この手法を用いることで、逆起電力を検出する回路以外の追加部品を必要とせず実装できる。また、追加部品が必要ないため取り付け位置に創意工夫の必要性がない。\
しかし決定的な弱点が存在する。モータの特性上、逆起電力を得るにはシャフトの回転が必要な点である。実際の力覚を測定する際、モータを回転させるには弱すぎる力が付与される場合も多く存在する。しかし、そのような場合でもこのセンサレスの手法ではかかっている力覚は0として判断されてしまう。これでは実際の生体のように、外力に耐えている状態でも筋肉の負荷を感じ取ることで外力の大きさを大凡認知することは叶わない。

== サーボの消費電力を用いる方法

前節では力覚センサの搭載や、サーボの逆起電力を用いた、場合の欠点を紹介した。筋電義手の力覚を測定するためにはこれらの方法では実用性に欠ける部分があることがわかった。これらの方法より簡便かつ静止時の計測も可能な手法が望ましいわけであるが、ここで我々は他の研究テーマでのトラブルに着目した。

#heading("過負荷によるサーボの故障", numbering: none, level: 3, outlined: false)

同じ研究室内の別の研究グループでサーボの故障が何度か発生した。そのグループではロボットを使用していたのだが、ロボットの足を為すサーボに過負荷がかかり電流制御用のトランジスタが焼き切れてしまうことが原因だった。サーボは与えられたPWM信号に対応する回転角度（目標角度）と現在の回転角度とにずれがある場合に目標角度となるように回転する性質がある。目標角度まで回転する際に外力により回転にブレーキがかかる際はそれに負けじと供給電流を増やすことで動こうとする。しかしその際に内部の電子回路の許容電流を超えてしまい破損することがあった。我々はこの現象に着目をして、サーボにかかる外力を消費電力を用いて検出する手法を考案した。


#pagebreak(weak: true)

= 筋電義手の駆動部エネルギー測定について

筋電義手の稼働部を為すサーボの消費電力を測定することで、義手にかかる力覚を測定できるというコンセプトの実証を行った。今回は簡単のために筋電義手を用いるのではなく、実験用のロボットアームを用いた。

=== 実験器具

以下に今回の実験で使用した実験器具を表記する

- ロボットアーム：近藤科学株式会社 KXR-A5
- マイコン：Arduino Uno
- シャント抵抗：1Ω
- 差動増幅回路
  - オペアンプ：Texas Instrument TLC-2274
  - 抵抗1: 1kΩ
  - 抵抗2: 2kΩ
- 分銅： 50g, 100g

== 実験方法

#figure(image("assets/実験器具構成図.png"), kind: image, caption: text("実験器具構成図"))
#pagebreak()

上図のように筋電義手を模したロボットアームのサーボの3つを使い、それぞれの消費電力を電流を計測することで測定した。各サーボの消費電力は、サーボの電源ラインに直列にシャント抵抗を接続し、その抵抗の始端と終端の電圧を差動増幅回路を用いることでマイコンにアナログ情報として取り入れられるようにした。\
計測に用いたマイコンは、各サーボの動作を指令するマイコンと同一のものを用いることでサーボの動作開始とほとんど同時に計測が開始されるように設計した。ここでサーボの動作開始と計測開始とが完全に同時でないのは、今回使用したマイコンでは同時に一つのスレッドしか実行できないため厳密には数クロック分だけ動作開始と計測開始とがずれてしまうためである。\

=== 手順

本研究の実験では二つの動作パターンのデータをロボットアームに付加する負荷を変えながら取得することで動作パターンと重さの関係性を調べやすくした。以下にその手順を示す。

+ 負荷をかけない状態で動作１を実行し、その際のシャント抵抗にかかる電圧を358Hzで1秒間計測した。これを8回繰り返した。
+ 1と同様のことを、ロボットアームの先端部分に50gの分銅を吊るした状態で実行した。
+ 1と同様のことを、ロボットアームの先端部分に100gの分銅を吊るした状態で実行した。
+ 動作2で1〜3と同様のことを実行した。

== 実験結果

この実験を行った結果、次の図に示すような消費電力の時系列変化が見られた。

#pagebreak(weak: true)

#figure(image("assets/servo_data/motion1_1_servo2_0g.png", height: 12em), caption: text("動作1（上昇）の際のサーボ1の消費電力（負荷0g）"))
#figure(image("assets/servo_data/motion1_1_servo2_50g.png", height: 12em), caption: text("動作1（上昇）の際のサーボ1の消費電力（負荷50g）"))
#figure(image("assets/servo_data/motion1_1_servo2_100g.png", height: 12em), caption: text("動作1（上昇）の際のサーボ1の消費電力（負荷100g）"))
#figure(image("assets/servo_data/motion1_1_servo3_0g.png", height: 12em), caption: text("動作1（上昇）の際のサーボ2の消費電力（負荷0g）"))
#figure(image("assets/servo_data/motion1_1_servo3_50g.png", height: 12em), caption: text("動作1（上昇）の際のサーボ2の消費電力（負荷50g）"))
#figure(image("assets/servo_data/motion1_1_servo3_100g.png", height: 12em), caption: text("動作1（上昇）の際のサーボ2の消費電力（負荷100g）"))
#figure(image("assets/servo_data/motion1_1_servo5_0g.png", height: 12em), caption: text("動作1（上昇）の際のサーボ3の消費電力（負荷0g）"))
#figure(image("assets/servo_data/motion1_1_servo5_50g.png", height: 12em), caption: text("動作1（上昇）の際のサーボ3の消費電力（負荷50g）"))
#figure(image("assets/servo_data/motion1_1_servo5_100g.png", height: 12em), caption: text("動作1（上昇）の際のサーボ3の消費電力（負荷100g）"))
#figure(image("assets/servo_data/motion1_2_servo2_0g.png", height: 12em), caption: text("動作1（下降）の際のサーボ1の消費電力（負荷0g）"))
#figure(image("assets/servo_data/motion1_2_servo2_50g.png", height: 12em), caption: text("動作1（下降）の際のサーボ1の消費電力（負荷50g）"))
#figure(image("assets/servo_data/motion1_2_servo2_100g.png", height: 12em), caption: text("動作1（下降）の際のサーボ1の消費電力（負荷100g）"))
#figure(image("assets/servo_data/motion1_2_servo3_0g.png", height: 12em), caption: text("動作1（下降）の際のサーボ2の消費電力（負荷0g）"))
#figure(image("assets/servo_data/motion1_2_servo3_50g.png", height: 12em), caption: text("動作1（下降）の際のサーボ2の消費電力（負荷50g）"))
#figure(image("assets/servo_data/motion1_2_servo3_100g.png", height: 12em), caption: text("動作1（下降）の際のサーボ2の消費電力（負荷100g）"))
#figure(image("assets/servo_data/motion1_2_servo5_0g.png", height: 12em), caption: text("動作1（下降）の際のサーボ3の消費電力（負荷0g）"))
#figure(image("assets/servo_data/motion1_2_servo5_50g.png", height: 12em), caption: text("動作1（下降）の際のサーボ3の消費電力（負荷50g）"))
#figure(image("assets/servo_data/motion1_2_servo5_100g.png", height: 12em), caption: text("動作1（下降）の際のサーボ3の消費電力（負荷100g）"))
#figure(image("assets/servo_data/motion2_1_servo2_0g.png", height: 12em), caption: text("動作2（上昇）の際のサーボ1の消費電力（負荷0g）"))
#figure(image("assets/servo_data/motion2_1_servo2_50g.png", height: 12em), caption: text("動作2（上昇）の際のサーボ1の消費電力（負荷50g）"))
#figure(image("assets/servo_data/motion2_1_servo2_100g.png", height: 12em), caption: text("動作2（上昇）の際のサーボ1の消費電力（負荷100g）"))
#figure(image("assets/servo_data/motion2_1_servo3_0g.png", height: 12em), caption: text("動作2（上昇）の際のサーボ2の消費電力（負荷0g）"))
#figure(image("assets/servo_data/motion2_1_servo3_50g.png", height: 12em), caption: text("動作2（上昇）の際のサーボ2の消費電力（負荷50g）"))
#figure(image("assets/servo_data/motion2_1_servo3_100g.png", height: 12em), caption: text("動作2（上昇）の際のサーボ2の消費電力（負荷100g）"))
#figure(image("assets/servo_data/motion2_1_servo5_0g.png", height: 12em), caption: text("動作2（上昇）の際のサーボ3の消費電力（負荷0g）"))
#figure(image("assets/servo_data/motion2_1_servo5_50g.png", height: 12em), caption: text("動作2（上昇）の際のサーボ3の消費電力（負荷50g）"))
#figure(image("assets/servo_data/motion2_1_servo5_100g.png", height: 12em), caption: text("動作2（上昇）の際のサーボ3の消費電力（負荷100g）"))
#figure(image("assets/servo_data/motion2_2_servo2_0g.png", height: 12em), caption: text("動作2（下降）の際のサーボ1の消費電力（負荷0g）"))
#figure(image("assets/servo_data/motion2_2_servo2_50g.png", height: 12em), caption: text("動作2（下降）の際のサーボ1の消費電力（負荷50g）"))
#figure(image("assets/servo_data/motion2_2_servo2_100g.png", height: 12em), caption: text("動作2（下降）の際のサーボ1の消費電力（負荷100g）"))
#figure(image("assets/servo_data/motion2_2_servo3_0g.png", height: 12em), caption: text("動作2（下降）の際のサーボ2の消費電力（負荷0g）"))
#figure(image("assets/servo_data/motion2_2_servo3_50g.png", height: 12em), caption: text("動作2（下降）の際のサーボ2の消費電力（負荷50g）"))
#figure(image("assets/servo_data/motion2_2_servo3_100g.png", height: 12em), caption: text("動作2（下降）の際のサーボ2の消費電力（負荷100g）"))
#figure(image("assets/servo_data/motion2_2_servo5_0g.png", height: 12em), caption: text("動作2（下降）の際のサーボ3の消費電力（負荷0g）"))
#figure(image("assets/servo_data/motion2_2_servo5_50g.png", height: 12em), caption: text("動作2（下降）の際のサーボ3の消費電力（負荷50g）"))
#figure(image("assets/servo_data/motion2_2_servo5_100g.png", height: 12em), caption: text("動作2（下降）の際のサーボ3の消費電力（負荷100g）"))

= リザバーコンピューティング

実験で得られた一定の規則性の認められる結果をモデル化することで、入力信号から出力の予測ができるようになる。そのための手法は古くから多く考えられてきたが、計算機の高性能化に伴い近年では機械学習を用いた手法が広く研究されるようになった。機械学習と大きく括ってもそのフレームワークにはいくつもの種類があり、それぞれに得意とする分野が存在する。例えばConvolutional Neural Networkを用いた機械学習は画像解析に適しているが時系列データを扱う場面で採用されることは少ない。同様にTransformerは自然言語処理の分野で今や主流となっているが、画像処理には適さない。\

== 概要

前章での結果でも示したとおり、本研究の学習対象は時系列変化する信号となっている。すると時系列変化する信号の学習に適した手法が必要となってくるわけであるが、これにあたるのがRecursive Neural Network (RNN)を用いた機械学習である。しかし従来型のRNNは推論フェーズと実行フェーズともに多くの計算量を必要とし、さらに学習のために多くのデータ数を必要とすることが知られている。学習はともかく、筋電義手を操作するための計算機の処理能力で推論がリアルタイムで行われることが理想的であるため、従来型のRNNのような多くの計算リソースを必要とするようなモデルを採用することは困難となってしまう。@Reservoir-Computing \
そこで登場するのがリザバーコンピューティング（RC）である。RCはRNNの一種ではあるが、ニューラルネット層の重みづけは行わずに出力層（リードアウト）の重みづけのみを学習させることでモデルの最適化を行う。この手法を用いることで、多くのデータ数がなくとも十分な精度が得られる学習ができることが先行の研究で明らかになっている。我々は今回RCを用いてサーボの消費電力の波形を学習させ、系にかかっている負荷を予測するモデルを作成した。\
RCを用いて得られる結果は

== 評価方法

モデルの評価にはRoot Mean Squared Error (RMSE)という指標を用いた。

=== RMSE（平方平均二乗誤差）

モデル出力と目標出力が共に連続地で与えられる時系列予測タスクや、時系列生成タスクの誤差を評価する指標としてRMSEが広く用いられる。\

$ "RMSE" = sqrt(frac(1,T) sum_(n=1)^T norm(upright(bold(d))(n)-accent(upright(bold(y)), hat)(n) )^2_2) $

と定義される。これはモデル出力と目標出力の間の二乗誤差の時間平均の平方根を表している。目標出力データの特徴を考慮していないので、異なるデータに対するRMSEの値を比較に意味がない点は注意されるべきである。また、RMSEはデータや予測値に平均から大きく外れた異常値や外れ値が含まれていると、その影響を大きく受けやすい。 @Reservoir-Computing

#pagebreak(weak: true)

= 消費電力から負荷を学習

3章で取得したデータを使ってRCを用いて学習させることで、3つのサーボの消費電力から系にかかる負荷を割り出すモデルを作成した。
また、消費電力のみを与えたところで負荷を予測するモデルを作成したところで汎用性に欠けるという予測のもと、3つのサーボの消費電力の時系列データのほかに特徴量としてそれぞれのサーボの動作開始と動作終了角度、そして設定した回転速度を与えることとした。これらの情報は取得に個別のセンサなどの機構を必要とせずサーボ制御用、すなわちRC推論にも用いるマイコン上で取得可能なデータの中から選んでいる点を強調する。

== データの前処理

RCを用いた学習をするためにはまずデータを学習に使用しやすい形にする必要がある。今回はサーボ3つの消費電力の時系列変化という特徴量に加えて、サーボそれぞれの初期角度、終了角度、そして設定速度を横並びにすることデータをわかりやすくした。また、最後にラベルとして機能する負荷重量を記載することで、プログラム上で教師ラベルとして扱いやすい形にした。

#pagebreak(weak: true)
#figure(image("assets/前処理データ.png"), caption: text("リザバー学習にをさせる際に用いたデータ構造"), kind: table)
#pagebreak(weak: true)

== リザバーコンピューティングの各種設定

実はRCにもさまざまな方法が提案されている。Echo State Network (ESN), Liquid State Machine (LSM), FORCEなどが一般的であるが、今回は最もシンプルで実装の簡単なESNを採用することとした。ESNはEcho State Propertyを満たすリザバー層に入力を与え、リードアウトの重みづけを線形回帰を用いて学習させる点から非常にシンプルであるためRCを使用する上で広く使われている。また、今回の実験では reservoirpy という Python のモジュールを用いてRCを実装した。@reservoirpy @FORCE

=== リザバー層

リザバー層には Intrinsic Plasticity を用いて調整されたニューラルネットを用いた。 @Intrinsic-Plasticity
// IPReservoir について調べる

==== 適切なノード数の調査

リザバー層のノード数は学習の精度とその速度、そして推論フェーズでの速度を決定するため非常に重要なパラメータである。本研究はサーボの消費電力から系にかかっている負荷が推論できるかというコンセプトの実証が本題ではあるが、筋電義手で使用するにあたって十分に少ないノード数で推論できなければ実行スピードがボトルネックとなってしまう。そこで次のような実験を行うことで今回のデータに適切なノード数を調査した。

===== 実験方法

リザバー層のノード数を5から100に変化させた時のRMSEの値を比較した。ただし、48個のデータを8対2の割合で学習用と評価用のデータにランダムに分けてから学習と評価を行うようにしているため、実行ごとに結果が変わってくる。この変化を鑑みて比較するためにそれぞれのノード数で1000回の学習と評価を行い、そのRMSEの平均をとった。このRMSEの平均とリザバー層のノード数との関係が次の図の通りである。


===== 実験結果

#figure(image("assets/node_vs_rmse.png"), caption: text("RMSEの平均のノード数との依存関係"))
#pagebreak(weak: true)

48個のデータを8対2の割合で分けているため学習用のデータは38個である。この図から見て取れる通り、ノード数が38個に近づくにつれてRMSEが急激に増加しており、そこから離れるにつれて減っていることがわかった。この現象はdouble descentと呼ばれている。 @double-descent

===== 考察

この実験から、設定すべきノード数は学習用データのデータ長よりも大きくすることがRC学習には適していることがわかった。

=== リードアウト層

次にリードアウト層の重みづけの学習方法について説明する。今回はESNを用いるため線形回帰での重みづけ学習を行ったのだが、外れ値の影響を必要以上に大きくすることを避けるためにRidge回帰を用いた。@Ridge

== 学習結果

以下がリザバー層のノード数を50、Ridge回帰の係数を0.03にして学習を行った結果である。

#figure(image("assets/training_set_result.png"), caption: text("推論モデルで学習データセットの予測をさせた結果"))
#pagebreak(weak: true)
#figure(image("assets/test_set_result.png"), caption: text("推論モデルで評価データセットの予測をさせた結果"))
#pagebreak(weak: true)
== 考察

評価用データを用いての評価は正答率20%と低い値となった。しかし、今回の実験では3つのサーボ入力を3次元の入力として与えずに3つの特徴量として与えてしまっていた。このように、入力データの与え方を変えたり、学習させるデータの個数や動きのバリエーションを増やすことで精度の向上が望めると考えられる。

#pagebreak(weak: true)

= まとめ

筋電義手の操作性向上に必要となってくる力覚の検知を行う方法として、義手内に搭載されることの多いサーボの消費電力を用いる手法の妥当性について検討した。筋電義手におけるサーボというのは生体における筋肉のように、位置を移動させる能力を持ちながら外力が加えられた際にその大きさに対応する反応を示す。その類似性は日頃の感覚としては誰しもが気づく余地あるものではあるが、今回の研究を通してその対応がとれることが明らかとなった。もちろん今の精度や学習方法のままでは対応できない場面が存在すると考えられるが、センサを増やして特徴量を増やすのではなく、データを増やしたり動きのバリエーションを増やしたりといった単純な作業を進めることでより汎用性の高いモデルが出来上がると考えられる。\
本研究で実証できたコンセプトを利用して筋電義手の力覚センシングやそれを用いたフィードバック技術の研究を進めていくことで筋電義手制御の基礎的技術が確立され、操作性の良い義手が必要としている人が手頃な価格帯で入手できるようになることを強く願う。

#set heading(numbering: none)

= 謝辞

本研究を進めるにあたり、多大なご指導、ご助言を頂いた葛西誠也教授をはじめとする工学部情報エレクトロニクス学科量子知能デバイス研究室の構成員の皆様に深謝の意を表します。常に楽をしようと堕落の方向へ向かう私に妥協を許さず研鑽の日々を促して下さった葛西教授はもちろん、ご自身が修士論文研究や学会発表、就職活動等でお忙しいにも関わらず進んで研究内容や発表資料の校閲、的確な助言をくださった修士2年吉田聖氏、修士1年松田一希氏に深謝の意を表します。また、日頃からご指導、ご意見を頂いた、量子集積エレクトロニクス研究センター長であられる本久順一教授、先進ナノ電子材料研究室の石川史太郎教授、原真二郎准教授、量子知能デバイス研究室の佐藤威友准教授、機能通信センシング研究室の池辺将之教授、赤澤正道准教授、集積電子デバイス研究室の冨岡克広准教授に深く感謝致します。

#heading(numbering: none, text("Appendix"))

以下にRCで学習を行った際に用いたコードを示す。

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from reservoirpy.nodes import IPReservoir, Ridge
from reservoirpy.observables import rmse


# CSVファイルからデータを読み込む
def load_data(file_path):
    data = pd.read_csv(file_path)
    X = data.drop("Load", axis=1).values
    y = data["Load"].values.reshape(-1, 1)
    return X, y


# データの読み込み
X, y = load_data("data/3_servos/curated_data/combined_data.csv")

# データの正規化。これがないと精度が低くなる。
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# データをトレーニングセットとテストセットに分割
X_train, X_test, y_train, y_test = train_test_split(
    X_scaled, y, test_size=0.2, random_state=42
)

# ESNの設定
input_dim = X_train.shape[1]
reservoir = IPReservoir(units=50, input_dim=input_dim)
readout = Ridge(ridge=3e-1)
esn = reservoir >> readout

# ESNの学習
esn.fit(X_train, y_train)

# トレーニングセットでの予測と評価
y_train_pred = esn.run(X_train)
train_rmse = rmse(y_train_pred, y_train)

# テストセットでの予測と評価
y_test_pred = esn.run(X_test)
test_rmse = rmse(y_test_pred, y_test)


# 許容誤差内であるかどうかをチェックする関数
def calculate_accuracy(y_true, y_pred, tolerance):
    correct = np.abs(y_true - y_pred) <= tolerance
    accuracy = np.mean(correct)
    return accuracy


# 許容誤差の設定（例：5グラム）
tolerance = 5

# トレーニングセットの正答率
train_accuracy = calculate_accuracy(y_train, y_train_pred, tolerance)

# テストセットの正答率
test_accuracy = calculate_accuracy(y_test, y_test_pred, tolerance)

# 結果の表示
print("Training RMSE:", train_rmse)
print("Testing RMSE:", test_rmse)
print("Training Accuracy:", train_accuracy)
print("Testing Accuracy:", test_accuracy)


# トレーニングセットの予測値と実際の値の散布図
plt.figure(figsize=(12, 6))
plt.subplot(1, 2, 1)
plt.scatter(range(len(y_train)), y_train, label="Actual", alpha=0.6)
plt.scatter(range(len(y_train)), y_train_pred, label="Predicted", alpha=0.6)
plt.title("Training Set Predictions")
plt.xlabel("Sample")
plt.ylabel("Load")
plt.legend()

# テストセットの予測値と実際の値の散布図
plt.subplot(1, 2, 2)
plt.scatter(range(len(y_test)), y_test, label="Actual", alpha=0.6)
plt.scatter(range(len(y_test)), y_test_pred, label="Predicted", alpha=0.6)
plt.title("Test Set Predictions")
plt.xlabel("Sample")
plt.ylabel("Load")
plt.legend()

plt.tight_layout()
plt.show()

# 予測値と実際の値をDataFrameに変換
train_df = pd.DataFrame(
    {"Actual": y_train.flatten(), "Predicted": y_train_pred.flatten()}
)

test_df = pd.DataFrame({"Actual": y_test.flatten(), "Predicted": y_test_pred.flatten()})

# CSVファイルに出力
train_df.to_csv("results/training_predictions.csv", index=False)
test_df.to_csv("results/test_predictions.csv", index=False)
```

#[
  #set text(lang: "en")
  #bibliography("bibliography/bib.yaml", title: text(bibliographyTitleJa), style: "institute-of-electrical-and-electronics-engineers")
]
