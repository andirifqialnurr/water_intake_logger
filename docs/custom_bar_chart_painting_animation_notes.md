# Catatan Custom Bar Chart: Painting, Layout, dan Animation

Dokumen ini menjelaskan semua konsep penting yang muncul saat membuat custom bar chart untuk water intake: mulai dari chart statis, label sumbu X/Y, active bar, sampai animasi bar naik dan efek air bergelombang.

Fokus dokumen ini bukan hanya "kode apa yang ditulis", tapi juga "kenapa logikanya seperti itu".

## Gambaran Besar

Custom bar chart yang kamu buat terdiri dari 2 bagian besar:

1. Widget biasa yang hidup di tree Flutter.
2. Painter yang menggambar langsung ke canvas.

Secara mental, strukturnya seperti ini:

```text
ProgressPage
  -> BarChartProgressWidget
    -> Container sebagai cover / kartu chart
      -> Column
        -> TextWidget title "Weekly Intake"
        -> Expanded
          -> AnimatedBuilder
            -> CustomPaint
              -> WaterIntakeBarChartPainter
```

Pembagian tanggung jawabnya:

```text
BarChartProgressWidget
  - menerima data
  - menerima maxMl
  - menerima activeIndex
  - mengambil theme text dari BuildContext
  - membuat AnimationController
  - mengirim nilai animasi ke painter

WaterIntakeBarChartPainter
  - menghitung posisi chart
  - menggambar grid
  - menggambar label Y
  - menggambar background bar
  - menggambar filled bar
  - menggambar wave
  - menggambar label X
```

Analogi sederhana:

```text
Widget = bingkai dan meja kerja
CustomPaint = kertas gambar
Canvas = permukaan kertasnya
Paint = kuas dan warna
Path = garis bentuk yang kamu gambar
AnimationController = jam / timer yang terus memberi angka
Painter = orang yang menggambar ulang saat angka animasi berubah
```

## Kenapa Pakai Custom Painter

Chart library seperti `fl_chart` cocok kalau kamu butuh chart umum: axis, tooltip, grid, legend, dan interaksi standar.

Tapi untuk chart air seperti ini, custom painter lebih cocok karena kamu ingin:

1. Bar punya bentuk sendiri.
2. Isi bar bisa seperti air.
3. Salah satu bar bisa aktif.
4. Animasi bisa dikontrol penuh.
5. Nanti fitur bisa ditambah tanpa menunggu fitur library.

Custom painter memberi kontrol penuh, tetapi konsekuensinya kamu harus memahami coordinate system, layout manual, dan repaint.

## File dan Peran

Biasanya implementasi kamu dipisah seperti ini:

```text
lib/widgets/charts/bar_chart/cover_widget.dart
lib/widgets/charts/bar_chart/painter.dart
```

### `cover_widget.dart`

File ini berperan sebagai pembungkus chart.

Isinya biasanya:

```dart
class WaterBarChartData {
  final String day;
  final double ml;

  const WaterBarChartData({
    required this.day,
    required this.ml,
  });
}
```

```dart
class BarChartProgressWidget extends StatefulWidget {
  final List<WaterBarChartData> data;
  final double maxMl;
  final int? activeIndex;

  const BarChartProgressWidget({
    required this.data,
    required this.maxMl,
    this.activeIndex,
    super.key,
  });

  @override
  State<BarChartProgressWidget> createState() =>
      _BarChartProgressWidgetState();
}
```

Kenapa data model ada di sini?

Karena widget ini adalah pintu masuk chart. Halaman lain cukup mengirim:

```dart
BarChartProgressWidget(
  maxMl: 3000,
  activeIndex: 2,
  data: const [
    WaterBarChartData(day: 'Mon', ml: 1800),
    WaterBarChartData(day: 'Tue', ml: 2200),
    WaterBarChartData(day: 'Wed', ml: 1600),
    WaterBarChartData(day: 'Thu', ml: 2500),
    WaterBarChartData(day: 'Fri', ml: 2100),
    WaterBarChartData(day: 'Sat', ml: 2800),
    WaterBarChartData(day: 'Sun', ml: 2400),
  ],
)
```

### `painter.dart`

File ini berperan sebagai mesin gambar.

Painter tidak membuat widget seperti `Text`, `Container`, atau `Column`. Painter menggambar bentuk langsung ke `Canvas`.

Contoh constructor painter:

```dart
class WaterIntakeBarChartPainter extends CustomPainter {
  final List<WaterBarChartData> data;
  final double maxMl;
  final TextStyle labelStyle;
  final int? activeIndex;
  final double fillProgress;
  final double waveProgress;

  WaterIntakeBarChartPainter({
    required this.data,
    required this.maxMl,
    required this.labelStyle,
    required this.fillProgress,
    required this.waveProgress,
    this.activeIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Semua drawing dilakukan di sini.
  }

  @override
  bool shouldRepaint(covariant WaterIntakeBarChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.maxMl != maxMl ||
        oldDelegate.activeIndex != activeIndex ||
        oldDelegate.fillProgress != fillProgress ||
        oldDelegate.waveProgress != waveProgress;
  }
}
```

## Istilah Dasar Widget

### `StatelessWidget`

`StatelessWidget` cocok ketika widget tidak punya state internal.

Versi awal chart statis bisa memakai ini:

```dart
class BarChartProgressWidget extends StatelessWidget {
  const BarChartProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaterIntakeBarChartPainter(...),
    );
  }
}
```

Tapi begitu chart butuh animasi, `StatelessWidget` tidak cukup.

### `StatefulWidget`

`StatefulWidget` dipakai ketika widget perlu menyimpan state.

Dalam chart ini, state-nya adalah:

```dart
late final AnimationController _fillController;
late final AnimationController _waveController;
```

Controller animasi harus dibuat saat widget hidup dan dibuang saat widget mati. Karena itu chart berubah menjadi `StatefulWidget`.

### `State`

`State` adalah tempat menyimpan variable yang berubah selama widget masih hidup.

```dart
class _BarChartProgressWidgetState extends State<BarChartProgressWidget>
    with TickerProviderStateMixin {
  late final AnimationController _fillController;
  late final AnimationController _waveController;
}
```

### `widget.data`

Di dalam class `State`, property dari `StatefulWidget` diakses lewat `widget`.

Contoh:

```dart
painter: WaterIntakeBarChartPainter(
  data: widget.data,
  maxMl: widget.maxMl,
  activeIndex: widget.activeIndex,
)
```

Kenapa bukan langsung `data`?

Karena `data`, `maxMl`, dan `activeIndex` adalah milik `BarChartProgressWidget`, bukan langsung milik `State`.

## Istilah Dasar Painting

### `CustomPaint`

`CustomPaint` adalah widget yang menyediakan area gambar.

Contoh:

```dart
CustomPaint(
  size: Size.infinite,
  painter: WaterIntakeBarChartPainter(...),
)
```

`CustomPaint` tidak otomatis menggambar apa pun. Ia hanya memberi canvas ke painter.

Analogi:

```text
CustomPaint = kanvas kosong yang ditempel di UI
Painter = instruksi menggambarnya
```

### `CustomPainter`

`CustomPainter` adalah class yang berisi instruksi menggambar.

Ada 2 method penting:

```dart
@override
void paint(Canvas canvas, Size size) {}
```

dan:

```dart
@override
bool shouldRepaint(covariant WaterIntakeBarChartPainter oldDelegate) {}
```

`paint` menjawab:

```text
Apa yang harus digambar?
```

`shouldRepaint` menjawab:

```text
Apakah gambar lama perlu digambar ulang?
```

### `Canvas`

`Canvas` adalah objek tempat kamu menggambar.

Contoh:

```dart
canvas.drawLine(
  Offset(chartLeft, y),
  Offset(chartRight, y),
  gridPaint,
);
```

Canvas punya banyak method:

```dart
canvas.drawLine(...)
canvas.drawRect(...)
canvas.drawRRect(...)
canvas.drawPath(...)
canvas.drawCircle(...)
```

Dalam chart ini yang paling banyak dipakai:

```dart
drawLine
drawRRect
drawPath
```

### `Paint`

`Paint` adalah pengaturan kuas.

Contoh:

```dart
final gridPaint = Paint()
  ..color = AppColors.outline.withValues(alpha: 0.18)
  ..strokeWidth = 1;
```

Property umum:

```dart
color
strokeWidth
style
```

Contoh jika ingin hanya outline:

```dart
final outlinePaint = Paint()
  ..color = Colors.blue
  ..style = PaintingStyle.stroke
  ..strokeWidth = 2;
```

Contoh jika ingin isi penuh:

```dart
final fillPaint = Paint()
  ..color = Colors.blue
  ..style = PaintingStyle.fill;
```

Kalau `style` tidak diatur, default-nya biasanya `PaintingStyle.fill`.

### Cascade Operator `..`

Syntax:

```dart
final paint = Paint()
  ..color = Colors.blue
  ..strokeWidth = 1;
```

Ini disebut cascade operator.

Artinya sama seperti:

```dart
final paint = Paint();
paint.color = Colors.blue;
paint.strokeWidth = 1;
```

Cascade operator membuat konfigurasi object lebih ringkas.

### `Offset`

`Offset` adalah titik koordinat.

```dart
Offset(x, y)
```

Contoh:

```dart
Offset(chartLeft, y)
```

Artinya titik di posisi X `chartLeft` dan posisi Y `y`.

### Coordinate System di Flutter Canvas

Ini sangat penting.

Canvas Flutter memakai koordinat seperti ini:

```text
(0, 0) ada di kiri atas

X makin besar -> makin ke kanan
Y makin besar -> makin ke bawah
```

Jadi:

```text
y = 0      -> paling atas
y = 100    -> lebih bawah
y = 200    -> makin bawah
```

Ini berlawanan dengan grafik matematika yang biasanya Y makin besar berarti makin ke atas.

Karena itu rumus bar chart perlu dibalik:

```dart
final y = chartBottom - (chartHeight * ratio);
```

Kenapa bukan:

```dart
final y = chartTop + (chartHeight * ratio);
```

Karena kalau memakai itu, nilai besar justru turun ke bawah.

### `Size`

`Size` adalah ukuran area `CustomPaint`.

```dart
void paint(Canvas canvas, Size size) {
  final width = size.width;
  final height = size.height;
}
```

Kalau `CustomPaint` berada di dalam `Expanded`, maka `size` biasanya mengikuti sisa ruang dari parent.

### `Rect`

`Rect` adalah kotak biasa.

Contoh:

```dart
final rect = Rect.fromLTRB(
  barLeft,
  chartBottom - barHeight,
  barRight,
  chartBottom,
);
```

`fromLTRB` artinya:

```text
L = left
T = top
R = right
B = bottom
```

Jadi:

```dart
Rect.fromLTRB(left, top, right, bottom)
```

### `RRect`

`RRect` adalah rounded rectangle.

Ada 2 cara umum:

```dart
RRect.fromRectAndRadius(
  rect,
  const Radius.circular(12),
)
```

Ini membuat semua sudut rounded.

Kalau hanya bagian atas yang rounded:

```dart
RRect.fromRectAndCorners(
  rect,
  topLeft: const Radius.circular(12),
  topRight: const Radius.circular(12),
  bottomLeft: Radius.zero,
  bottomRight: Radius.zero,
)
```

Di chart kamu, variable yang mengatur rounded bar adalah:

```dart
topLeft: const Radius.circular(12),
topRight: const Radius.circular(12),
```

Jika mau lebih bulat:

```dart
topLeft: const Radius.circular(20),
topRight: const Radius.circular(20),
```

Jika mau kotak:

```dart
topLeft: Radius.zero,
topRight: Radius.zero,
```

### `Path`

`Path` adalah bentuk bebas yang dibuat dari titik-titik.

Di chart ini `Path` dipakai untuk membuat air bergelombang.

Contoh sederhana:

```dart
final path = Path();
path.moveTo(0, 50);
path.lineTo(100, 50);
path.lineTo(100, 100);
path.lineTo(0, 100);
path.close();
```

Artinya:

```text
Mulai dari titik (0, 50)
Tarik garis ke (100, 50)
Tarik garis ke (100, 100)
Tarik garis ke (0, 100)
Tutup bentuk
```

Untuk wave:

```dart
final wavePath = Path();
wavePath.moveTo(barLeft, waterTop);

for (double x = 0; x <= barWidth; x++) {
  final y = sin((x / waveLength * 2 * pi) + phase) * waveHeight;
  wavePath.lineTo(barLeft + x, waterTop + y);
}

wavePath.lineTo(barRight, chartBottom);
wavePath.lineTo(barLeft, chartBottom);
wavePath.close();
```

### `TextPainter`

Di dalam `CustomPainter`, kamu tidak bisa langsung memakai widget `Text`.

Salah:

```dart
Text('Mon')
```

Benar:

```dart
final textPainter = TextPainter(
  text: TextSpan(text: text, style: style),
  textDirection: TextDirection.ltr,
)..layout();

textPainter.paint(canvas, offset);
```

Kenapa?

Karena `CustomPainter` menggambar langsung di canvas, bukan menyusun widget.

Widget seperti `Text`, `Container`, `Row`, dan `Column` hanya bisa dipakai di dalam widget tree.

## Layout Cover Chart

Cover chart biasanya memakai `Container`.

```dart
Container(
  height: 260,
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: AppColors.errorContainer,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextWidget(
        text: "Weekly Intake",
        variant: TextWidgetStyle.subtitle,
      ),
      const SizedBox(height: 12),
      Expanded(
        child: CustomPaint(...),
      ),
    ],
  ),
)
```

### Kenapa `Expanded` Dibutuhkan

Kalau `CustomPaint` dimasukkan ke dalam `Column`, ia butuh tinggi yang jelas.

`Column` memberikan tinggi ke children berdasarkan isi. Kalau `CustomPaint` tidak diberi batas tinggi, ukurannya bisa tidak sesuai.

`Expanded` artinya:

```text
Ambil sisa ruang yang tersedia dalam Column.
```

Jadi:

```dart
Expanded(
  child: CustomPaint(...),
)
```

membuat chart mengisi ruang setelah title dan spacing.

### Kapan Memakai `SizedBox`

Kalau chart berdiri sendiri tanpa title:

```dart
SizedBox(
  height: 240,
  width: double.infinity,
  child: CustomPaint(...),
)
```

Kalau chart punya title di dalam cover:

```dart
Container(
  height: 260,
  child: Column(
    children: [
      TextWidget(...),
      Expanded(child: CustomPaint(...)),
    ],
  ),
)
```

## Data Model

### `WaterBarChartData`

```dart
class WaterBarChartData {
  final String day;
  final double ml;

  const WaterBarChartData({
    required this.day,
    required this.ml,
  });
}
```

Artinya setiap bar punya:

```text
day = label sumbu X
ml = tinggi data dalam mililiter
```

Contoh:

```dart
WaterBarChartData(day: 'Mon', ml: 1800)
```

Ini artinya:

```text
Hari Senin memiliki intake 1800 ml.
```

### `List<WaterBarChartData>`

Karena chart punya 7 hari, data dikirim sebagai list:

```dart
data: const [
  WaterBarChartData(day: 'Mon', ml: 1800),
  WaterBarChartData(day: 'Tue', ml: 2200),
  WaterBarChartData(day: 'Wed', ml: 1600),
  WaterBarChartData(day: 'Thu', ml: 2500),
  WaterBarChartData(day: 'Fri', ml: 2100),
  WaterBarChartData(day: 'Sat', ml: 2800),
  WaterBarChartData(day: 'Sun', ml: 2400),
]
```

Loop painter:

```dart
for (var i = 0; i < data.length; i++) {
  final item = data[i];
}
```

`i` adalah index bar.

```text
i = 0 -> Mon
i = 1 -> Tue
i = 2 -> Wed
i = 3 -> Thu
```

## Active Bar

### `activeIndex`

`activeIndex` adalah index bar yang dianggap aktif.

```dart
final int? activeIndex;
```

Kenapa nullable `int?`?

Karena chart bisa saja tidak punya active bar.

```dart
activeIndex: null
```

berarti tidak ada bar aktif.

Contoh:

```dart
BarChartProgressWidget(
  activeIndex: 2,
  ...
)
```

Artinya bar index 2 aktif.

Karena index mulai dari 0:

```text
0 Mon
1 Tue
2 Wed
3 Thu
4 Fri
5 Sat
6 Sun
```

### Mengecek Bar Aktif

Di dalam loop:

```dart
final isActive = i == activeIndex;
```

Lalu warna dipilih:

```dart
canvas.drawRRect(
  filledRect,
  isActive ? activeBarPaint : barPaint,
);
```

Syntax:

```dart
condition ? valueIfTrue : valueIfFalse
```

disebut ternary operator.

Artinya:

```text
Jika isActive true, pakai activeBarPaint.
Jika false, pakai barPaint.
```

### Otomatis Berdasarkan Hari Ini

Nanti kamu bisa membuat:

```dart
final todayIndex = DateTime.now().weekday - 1;
```

Karena:

```text
DateTime.monday    = 1
DateTime.tuesday   = 2
DateTime.wednesday = 3
...
DateTime.sunday    = 7
```

List chart mulai dari 0, jadi dikurangi 1:

```text
Monday -> 1 - 1 = 0
Tuesday -> 2 - 1 = 1
```

## Menghitung Area Chart

Di painter, kamu biasanya mulai dengan menentukan batas chart:

```dart
final chartLeft = 44.0;
final chartTop = 12.0;
final chartRight = size.width;
final chartBottom = size.height - 24;
```

Artinya:

```text
chartLeft   = ruang kiri untuk label Y
chartTop    = ruang atas
chartRight  = batas kanan canvas
chartBottom = batas bawah chart, menyisakan ruang label X
```

Kenapa `chartLeft` tidak 0?

Karena label Y seperti `1.5L`, `2.3L`, `3.0L` butuh ruang di kiri.

Kenapa `chartBottom` dikurangi 24?

Karena label hari seperti `Mon`, `Tue`, `Wed` digambar di bawah bar.

Kalau tidak dikurangi, label X bisa keluar dari canvas.

### Chart Width dan Height

```dart
final chartWidth = chartRight - chartLeft;
final chartHeight = chartBottom - chartTop;
```

Ini menghitung area asli tempat bar digambar.

Contoh:

```text
size.width = 360
chartLeft = 44
chartRight = 360

chartWidth = 316
```

```text
size.height = 180
chartTop = 12
chartBottom = 156

chartHeight = 144
```

Semua perhitungan bar dan grid memakai `chartWidth` dan `chartHeight`, bukan ukuran canvas penuh.

## Menghitung Posisi Bar

### `barAreaWidth`

```dart
final barAreaWidth = chartWidth / data.length;
```

Jika ada 7 data:

```text
barAreaWidth = total lebar chart / 7
```

Ini bukan lebar bar. Ini lebar area untuk 1 hari.

Analogi:

```text
Chart dibagi menjadi 7 slot.
Setiap slot berisi 1 bar.
```

### `barWidth`

```dart
final barWidth = barAreaWidth * 0.82;
```

Ini menentukan lebar visual bar.

Kalau ingin bar lebih ramping:

```dart
final barWidth = barAreaWidth * 0.45;
```

Kalau ingin bar lebih lebar:

```dart
final barWidth = barAreaWidth * 0.9;
```

Nilai yang aman biasanya:

```text
0.4 sampai 0.85
```

Jika terlalu besar, bar antar hari bisa terlihat terlalu rapat.

### `barCenterX`

```dart
final barCenterX = chartLeft + (barAreaWidth * i) + (barAreaWidth / 2);
```

Artinya:

```text
Mulai dari chartLeft.
Geser sesuai slot ke-i.
Ambil tengah slot.
```

Untuk index 0:

```text
chartLeft + 0 + setengah slot
```

Untuk index 3:

```text
chartLeft + 3 slot + setengah slot
```

### `barLeft` dan `barRight`

```dart
final barLeft = barCenterX - (barWidth / 2);
final barRight = barCenterX + (barWidth / 2);
```

Karena kita tahu titik tengah bar, maka sisi kiri dan kanan dihitung dari setengah width.

```text
barLeft  = center - half width
barRight = center + half width
```

## Menghitung Tinggi Bar

### `maxMl`

`maxMl` adalah nilai tertinggi pada sumbu Y.

Contoh:

```dart
maxMl: 3000
```

Artinya jika data `ml = 3000`, bar akan penuh sampai puncak chart.

Jika data:

```dart
ml: 1500
```

maka bar akan setengah tinggi chart.

### `ratio`

```dart
final ratio = (item.ml / maxMl).clamp(0.0, 1.0);
```

Contoh:

```text
item.ml = 1500
maxMl = 3000

ratio = 1500 / 3000 = 0.5
```

`ratio` artinya:

```text
Seberapa penuh bar dibandingkan maxMl?
```

### Kenapa Pakai `clamp`

```dart
clamp(0.0, 1.0)
```

Artinya nilai dipaksa berada di antara 0 dan 1.

Contoh:

```text
-100 / 3000 = -0.03 -> jadi 0.0
3500 / 3000 = 1.16 -> jadi 1.0
1500 / 3000 = 0.5  -> tetap 0.5
```

Ini mencegah bar keluar dari chart.

### `barHeight`

```dart
final barHeight = chartHeight * ratio;
```

Contoh:

```text
chartHeight = 144
ratio = 0.5

barHeight = 72
```

### Posisi Top Filled Bar

```dart
final filledTop = chartBottom - barHeight;
```

Kenapa dikurangi dari `chartBottom`?

Karena bar tumbuh dari bawah ke atas.

```text
bar kosong:
top = chartBottom

bar penuh:
top = chartTop
```

## Menggambar Grid dan Sumbu Y

Grid dibuat dengan membagi `maxMl` menjadi beberapa step.

```dart
final stepCount = 4;

for (var i = 0; i <= stepCount; i++) {
  final step = maxMl / stepCount * i;
  final ratio = step / maxMl;
  final y = chartBottom - (chartHeight * ratio);

  canvas.drawLine(
    Offset(chartLeft, y),
    Offset(chartRight, y),
    gridPaint,
  );
}
```

Jika:

```text
maxMl = 3000
stepCount = 4
```

maka step-nya:

```text
i = 0 -> 0
i = 1 -> 750
i = 2 -> 1500
i = 3 -> 2250
i = 4 -> 3000
```

### Mengubah Jumlah Grid

Lebih sedikit:

```dart
final stepCount = 3;
```

Lebih banyak:

```dart
final stepCount = 6;
```

Semakin banyak step, chart terlihat lebih detail tetapi bisa lebih ramai.

### Format Label Y

Format liter:

```dart
text: '${(step / 1000).toStringAsFixed(1)}L'
```

Contoh:

```text
750 -> 0.8L
1500 -> 1.5L
3000 -> 3.0L
```

Format ml:

```dart
text: '${step.toInt()}ml'
```

Contoh:

```text
750ml
1500ml
3000ml
```

### Kenapa Label Pernah Bertumpuk di Atas

Bug yang pernah terjadi:

```dart
final ratio = step / maxMl;

canvas.drawLine(
  Offset(chartLeft, ratio),
  Offset(chartRight, ratio),
  gridPaint,
);
```

`ratio` hanya bernilai 0 sampai 1.

Canvas butuh pixel, bukan ratio.

Yang benar:

```dart
final y = chartBottom - (chartHeight * ratio);
```

Lalu:

```dart
Offset(chartLeft, y)
```

## Menggambar Background Bar

Background bar adalah "track" atau wadah kosong.

```dart
final backgroundRect = RRect.fromRectAndCorners(
  Rect.fromLTRB(barLeft, chartTop, barRight, chartBottom),
  topLeft: const Radius.circular(12),
  topRight: const Radius.circular(12),
);

canvas.drawRRect(backgroundRect, barBackgroundPaint);
```

Background memakai tinggi penuh chart:

```text
top = chartTop
bottom = chartBottom
```

Ini membuat semua bar punya wadah yang sama tinggi.

## Menggambar Filled Bar Statis

Filled bar adalah isi berdasarkan nilai ml.

```dart
final filledRect = RRect.fromRectAndCorners(
  Rect.fromLTRB(
    barLeft,
    chartBottom - barHeight,
    barRight,
    chartBottom,
  ),
  topLeft: const Radius.circular(12),
  topRight: const Radius.circular(12),
);

canvas.drawRRect(filledRect, isActive ? activeBarPaint : barPaint);
```

Bagian penting:

```dart
chartBottom - barHeight
```

Itu membuat filled bar naik dari bawah.

## Menggambar Label X

Label X adalah nama hari.

```dart
_drawText(
  canvas,
  text: item.day,
  offset: Offset(barCenterX - 12, chartBottom + 10),
  style: labelStyle,
);
```

`barCenterX - 12` adalah cara sederhana untuk membuat label agak ke tengah.

Namun ini belum sempurna, karena label berbeda panjang bisa tidak benar-benar center.

Cara yang lebih rapi:

```dart
void _drawCenteredText(
  Canvas canvas, {
  required String text,
  required Offset center,
  required TextStyle style,
}) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout();

  final offset = Offset(
    center.dx - textPainter.width / 2,
    center.dy - textPainter.height / 2,
  );

  textPainter.paint(canvas, offset);
}
```

Lalu pakai:

```dart
_drawCenteredText(
  canvas,
  text: item.day,
  center: Offset(barCenterX, chartBottom + 16),
  style: labelStyle,
);
```

## Theme dan Text Style

### Kenapa Label X/Y Tidak Otomatis Ikut Theme

Label X/Y digambar memakai `TextPainter`, bukan widget `Text`.

Widget `Text` bisa otomatis membaca:

```dart
Theme.of(context).textTheme
```

Tapi `CustomPainter` tidak punya `BuildContext`.

Karena itu style harus diambil di widget, lalu dikirim ke painter.

Di `cover_widget.dart`:

```dart
final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
  color: AppColors.onSurface,
);
```

Lalu:

```dart
painter: WaterIntakeBarChartPainter(
  labelStyle: labelStyle!,
  ...
)
```

Di painter:

```dart
_drawText(
  canvas,
  text: item.day,
  offset: Offset(...),
  style: labelStyle,
);
```

### Cara Membuat Style Berbeda untuk Y dan X

Tambahkan 2 parameter:

```dart
final TextStyle xLabelStyle;
final TextStyle yLabelStyle;
```

Constructor:

```dart
WaterIntakeBarChartPainter({
  required this.xLabelStyle,
  required this.yLabelStyle,
  ...
});
```

Lalu:

```dart
_drawText(
  canvas,
  text: yText,
  offset: Offset(...),
  style: yLabelStyle,
);
```

dan:

```dart
_drawText(
  canvas,
  text: item.day,
  offset: Offset(...),
  style: xLabelStyle,
);
```

## Animasi: Konsep Dasar

Animasi di Flutter pada dasarnya adalah perubahan angka dari waktu ke waktu.

Contoh:

```text
0.0 -> 0.1 -> 0.2 -> ... -> 1.0
```

Painter menerima angka itu, lalu menggambar ulang chart berdasarkan angka tersebut.

Untuk chart ini:

```text
fillProgress = mengatur tinggi bar
waveProgress = mengatur posisi gelombang
```

## `AnimationController`

`AnimationController` adalah sumber angka animasi.

Untuk fill animation:

```dart
_fillController = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 900),
)..forward();
```

Artinya:

```text
Mulai dari 0.0
Berjalan ke 1.0
Durasi 900 ms
Sekali jalan
```

Untuk wave animation:

```dart
_waveController = AnimationController(
  vsync: this,
  duration: const Duration(seconds: 2),
)..repeat();
```

Artinya:

```text
Mulai dari 0.0
Berjalan ke 1.0
Ulang lagi dari 0.0
Terus berulang
Durasi setiap siklus 2 detik
```

### `forward()`

```dart
_fillController.forward();
```

Menjalankan animasi dari value sekarang menuju 1.0.

Biasanya dipakai untuk animasi masuk.

### `repeat()`

```dart
_waveController.repeat();
```

Menjalankan animasi berulang terus.

Cocok untuk:

```text
loading
wave
rotasi
shimmer
```

### `reverse()`

```dart
_fillController.reverse();
```

Menjalankan animasi dari value sekarang menuju 0.0.

Bisa dipakai kalau nanti chart ingin menghilang atau turun.

### `duration`

Mengatur kecepatan animasi.

Lebih cepat:

```dart
duration: const Duration(milliseconds: 400)
```

Lebih lambat:

```dart
duration: const Duration(milliseconds: 1500)
```

Untuk wave:

```dart
duration: const Duration(seconds: 1)
```

akan membuat air bergerak lebih cepat daripada:

```dart
duration: const Duration(seconds: 3)
```

## `TickerProviderStateMixin`

```dart
with TickerProviderStateMixin
```

dibutuhkan karena `AnimationController` butuh `vsync`.

`vsync` membantu Flutter agar animasi berjalan efisien sesuai frame yang dibutuhkan.

Kalau hanya punya 1 controller, bisa memakai:

```dart
with SingleTickerProviderStateMixin
```

Karena chart kamu punya 2 controller:

```dart
_fillController
_waveController
```

maka lebih aman memakai:

```dart
with TickerProviderStateMixin
```

## `initState`

`initState` dipanggil sekali saat widget pertama dibuat.

Di sinilah controller dibuat:

```dart
@override
void initState() {
  super.initState();

  _fillController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  _waveController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();
}
```

Jangan membuat controller di `build`, karena `build` bisa dipanggil berkali-kali.

## `dispose`

`dispose` dipanggil saat widget dibuang.

Controller harus dibuang agar tidak bocor resource.

```dart
@override
void dispose() {
  _fillController.dispose();
  _waveController.dispose();
  super.dispose();
}
```

Aturan penting:

```text
Kalau kamu membuat AnimationController, kamu wajib dispose.
```

## `AnimatedBuilder`

`AnimatedBuilder` adalah widget yang rebuild ketika animation berubah.

Contoh:

```dart
AnimatedBuilder(
  animation: _fillController,
  builder: (context, child) {
    return CustomPaint(...);
  },
)
```

Dalam chart ini ada 2 animation, jadi memakai:

```dart
AnimatedBuilder(
  animation: Listenable.merge([
    _fillController,
    _waveController,
  ]),
  builder: (context, child) {
    return CustomPaint(...);
  },
)
```

Artinya:

```text
Kalau fillController berubah, gambar ulang.
Kalau waveController berubah, gambar ulang.
```

### `Listenable.merge`

`Listenable.merge` menggabungkan beberapa listenable menjadi satu.

```dart
Listenable.merge([
  _fillController,
  _waveController,
])
```

Tanpa ini, kamu perlu nested `AnimatedBuilder`, yang lebih berantakan.

## `Curves`

`Curves` mengubah feel animasi.

Raw controller bergerak linear:

```text
0.0, 0.1, 0.2, 0.3, ...
```

Dengan curve:

```dart
Curves.easeOutCubic.transform(_fillController.value)
```

hasilnya terasa cepat di awal lalu melambat di akhir.

Untuk bar naik, `easeOutCubic` enak karena terasa natural.

### Mengganti Curve

Linear:

```dart
fillProgress: _fillController.value
```

Pelan di awal, cepat di tengah, pelan di akhir:

```dart
fillProgress: Curves.easeInOut.transform(_fillController.value)
```

Ada efek sedikit memantul:

```dart
fillProgress: Curves.elasticOut.transform(_fillController.value)
```

Efek bounce:

```dart
fillProgress: Curves.bounceOut.transform(_fillController.value)
```

Catatan: untuk chart data, animasi yang terlalu playful kadang terasa kurang profesional. `easeOutCubic` atau `easeOutQuart` biasanya aman.

## Fill Animation

Tujuan fill animation:

```text
Saat halaman pertama dibuka, bar naik dari bawah ke tinggi final.
```

Tanpa animasi:

```dart
final ratio = (item.ml / maxMl).clamp(0.0, 1.0);
final barHeight = chartHeight * ratio;
```

Dengan animasi:

```dart
final ratio = (item.ml / maxMl).clamp(0.0, 1.0);
final animatedRatio = ratio * fillProgress;
final barHeight = chartHeight * animatedRatio;
```

Saat:

```text
fillProgress = 0.0
```

maka:

```text
barHeight = chartHeight * ratio * 0.0 = 0
```

Saat:

```text
fillProgress = 0.5
```

maka bar baru setengah dari tinggi target.

Saat:

```text
fillProgress = 1.0
```

maka bar mencapai tinggi final.

## Wave Animation

Wave animation dibuat dengan fungsi sinus.

Import:

```dart
import 'dart:math';
```

`dart:math` dipakai untuk:

```dart
sin(...)
pi
```

### `sin`

`sin` menghasilkan nilai naik turun antara -1 dan 1.

```text
sin(...) -> -1.0 sampai 1.0
```

Nilai ini cocok untuk membuat gelombang.

### `pi`

`pi` adalah konstanta matematika.

Satu putaran penuh dalam radian:

```dart
2 * pi
```

Untuk menggeser wave:

```dart
final phase = waveProgress * 2 * pi;
```

Saat `waveProgress` bergerak dari 0 ke 1, `phase` bergerak dari:

```text
0 sampai 2*pi
```

Itu membuat wave terlihat berjalan.

### Variable Wave

```dart
final waterTop = chartBottom - barHeight;
final waveHeight = 5.0;
final waveLength = barWidth * 1.2;
final phase = waveProgress * 2 * pi;
```

Artinya:

```text
waterTop   = permukaan air
waveHeight = tinggi naik-turun gelombang
waveLength = panjang satu gelombang
phase      = pergeseran gelombang dari waktu ke waktu
```

Jika ingin wave lebih tinggi:

```dart
final waveHeight = 9.0;
```

Jika ingin wave lebih tenang:

```dart
final waveHeight = 2.0;
```

Jika ingin gelombang lebih rapat:

```dart
final waveLength = barWidth * 0.8;
```

Jika ingin gelombang lebih panjang:

```dart
final waveLength = barWidth * 1.8;
```

### Membuat Wave Path

```dart
final wavePath = Path();
wavePath.moveTo(barLeft, waterTop);

for (double x = 0; x <= barWidth; x++) {
  final y = sin((x / waveLength * 2 * pi) + phase) * waveHeight;
  wavePath.lineTo(barLeft + x, waterTop + y);
}

wavePath.lineTo(barRight, chartBottom);
wavePath.lineTo(barLeft, chartBottom);
wavePath.close();
```

Logikanya:

```text
1. Mulai dari sisi kiri permukaan air.
2. Jalan dari x = 0 sampai x = lebar bar.
3. Untuk setiap x, hitung y gelombang dengan sin.
4. Setelah sampai kanan, tarik garis turun ke bawah bar.
5. Tarik garis ke kiri bawah.
6. Tutup bentuk.
```

Hasilnya adalah bentuk tertutup seperti air.

## `canvas.save`, `clipRRect`, `restore`

### Masalah yang Diselesaikan

Wave path bisa saja keluar dari bentuk bar.

Kita ingin air hanya terlihat di dalam bar.

Solusinya:

```dart
canvas.save();
canvas.clipRRect(backgroundRect);
canvas.drawPath(wavePath, waterPaint);
canvas.restore();
```

### `save`

```dart
canvas.save();
```

Menyimpan kondisi canvas saat ini.

### `clipRRect`

```dart
canvas.clipRRect(backgroundRect);
```

Membatasi area gambar hanya di dalam rounded rectangle.

Analogi:

```text
clip seperti stensil.
Apa pun yang digambar setelah clip hanya terlihat dalam area stensil.
```

### `restore`

```dart
canvas.restore();
```

Mengembalikan canvas ke kondisi sebelum `save`.

Ini penting.

Kalau lupa `restore`, semua gambar setelahnya juga ikut ter-clip.

## Urutan Gambar yang Benar

Urutan drawing penting karena canvas bekerja seperti menumpuk lapisan.

Yang digambar belakangan akan berada di atas.

Urutan umum:

```text
1. Draw grid
2. Draw Y labels
3. Draw background bar
4. Draw filled/wave bar
5. Draw X labels
```

Untuk setiap bar:

```dart
canvas.drawRRect(backgroundRect, barBackgroundPaint);

if (barHeight > 0) {
  canvas.save();
  canvas.clipRRect(backgroundRect);
  canvas.drawPath(wavePath, isActive ? activeBarPaint : barPaint);
  canvas.restore();
}

_drawText(...);
```

### Catatan Penting: Solid Fill vs Wave Fill

Di implementasi saat ini, kamu mungkin punya:

```dart
canvas.drawRRect(filledRect, isActive ? activeBarPaint : barPaint);
canvas.drawPath(wavePath, isActive ? activeBarPaint : barPaint);
```

Kalau warna `filledRect` dan `wavePath` sama, wave bisa tidak terlihat jelas, karena wave digambar di atas warna yang sama.

Ada 2 pendekatan:

### Pendekatan A: Wave sebagai Bentuk Isi Utama

Gambar background, lalu gambar wave path saja:

```dart
canvas.drawRRect(backgroundRect, barBackgroundPaint);

canvas.save();
canvas.clipRRect(backgroundRect);
canvas.drawPath(wavePath, isActive ? activeBarPaint : barPaint);
canvas.restore();
```

Ini membuat permukaan air terlihat karena bagian atasnya mengikuti gelombang.

### Pendekatan B: Solid Body + Highlight Wave

Gambar solid fill dengan warna utama, lalu gambar wave highlight warna lebih terang.

```dart
final bodyPaint = Paint()
  ..color = isActive ? AppColors.primary : AppColors.inversePrimary;

final waveHighlightPaint = Paint()
  ..color = Colors.white.withValues(alpha: 0.20);
```

Lalu:

```dart
canvas.drawRRect(filledRect, bodyPaint);

canvas.save();
canvas.clipRRect(filledRect);
canvas.drawPath(wavePath, waveHighlightPaint);
canvas.restore();
```

Pendekatan B cocok kalau kamu ingin bar tetap terlihat penuh solid, tetapi ada shimmer/gelombang tipis.

## `shouldRepaint`

```dart
@override
bool shouldRepaint(covariant WaterIntakeBarChartPainter oldDelegate) {
  return oldDelegate.data != data ||
      oldDelegate.maxMl != maxMl ||
      oldDelegate.activeIndex != activeIndex ||
      oldDelegate.fillProgress != fillProgress ||
      oldDelegate.waveProgress != waveProgress;
}
```

Painter perlu repaint jika data berubah.

Untuk animasi, ini sangat penting:

```dart
oldDelegate.fillProgress != fillProgress
oldDelegate.waveProgress != waveProgress
```

Karena pada setiap frame animasi, nilai itu berubah.

Kalau tidak dimasukkan, chart bisa tidak redraw.

## Mengganti Animasi

### Membuat Fill Lebih Cepat

Di `cover_widget.dart`:

```dart
_fillController = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 500),
)..forward();
```

### Membuat Fill Lebih Lambat

```dart
duration: const Duration(milliseconds: 1400)
```

### Mengganti Feel Fill

```dart
fillProgress: Curves.easeOutQuart.transform(_fillController.value),
```

Atau:

```dart
fillProgress: Curves.easeInOutCubic.transform(_fillController.value),
```

### Membuat Wave Lebih Cepat

```dart
_waveController = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 900),
)..repeat();
```

### Membuat Wave Lebih Pelan

```dart
duration: const Duration(seconds: 4)
```

### Membuat Wave Bergerak Arah Berlawanan

Saat ini:

```dart
final phase = waveProgress * 2 * pi;
```

Arah sebaliknya:

```dart
final phase = -waveProgress * 2 * pi;
```

### Membuat Wave Hanya Aktif di Active Bar

Di loop:

```dart
final phase = isActive ? waveProgress * 2 * pi : 0.0;
```

Atau:

```dart
if (isActive) {
  canvas.drawPath(wavePath, activeBarPaint);
} else {
  canvas.drawRRect(filledRect, barPaint);
}
```

### Membuat Bar Naik Satu-Satu

Ini disebut staggered animation.

Konsep:

```dart
final delay = i * 0.08;
final raw = ((fillProgress - delay) / (1 - delay)).clamp(0.0, 1.0);
final animatedRatio = ratio * raw;
```

Artinya:

```text
Bar index 0 mulai dulu.
Bar index 1 sedikit terlambat.
Bar index 2 lebih terlambat.
```

Versi yang lebih rapi:

```dart
double staggerProgress({
  required double progress,
  required int index,
  required int itemCount,
}) {
  final start = index / itemCount * 0.4;
  final end = start + 0.6;
  final value = ((progress - start) / (end - start)).clamp(0.0, 1.0);
  return Curves.easeOutCubic.transform(value);
}
```

Lalu:

```dart
final itemProgress = staggerProgress(
  progress: fillProgress,
  index: i,
  itemCount: data.length,
);

final animatedRatio = ratio * itemProgress;
```

## Mengatur Warna

### Warna Background Bar

```dart
final barBackgroundPaint = Paint()
  ..color = AppColors.error.withValues(alpha: 0.18);
```

`alpha` mengatur transparansi.

```text
0.0 = tidak terlihat
1.0 = penuh
```

Contoh:

```dart
AppColors.outline.withValues(alpha: 0.12)
```

### Warna Bar Normal

```dart
final barPaint = Paint()
  ..color = AppColors.inversePrimary;
```

### Warna Active Bar

```dart
final activeBarPaint = Paint()
  ..color = AppColors.primary;
```

### Membuat Warna Bisa Dikirim dari Luar

Tambahkan di widget:

```dart
final Color barColor;
final Color activeBarColor;
```

Constructor:

```dart
const BarChartProgressWidget({
  required this.data,
  required this.maxMl,
  this.activeIndex,
  this.barColor = AppColors.inversePrimary,
  this.activeBarColor = AppColors.primary,
  super.key,
});
```

Lalu kirim ke painter:

```dart
WaterIntakeBarChartPainter(
  barColor: widget.barColor,
  activeBarColor: widget.activeBarColor,
  ...
)
```

Di painter:

```dart
final Color barColor;
final Color activeBarColor;
```

Lalu:

```dart
final barPaint = Paint()..color = barColor;
final activeBarPaint = Paint()..color = activeBarColor;
```

## Membuat `maxMl` Otomatis

Sekarang `maxMl` dikirim manual:

```dart
maxMl: 3000
```

Nanti kamu bisa membuatnya otomatis.

Contoh:

```dart
final highestMl = data.map((item) => item.ml).reduce(max);
final chartMaxMl = highestMl < 3000 ? 3000.0 : highestMl;
```

Butuh:

```dart
import 'dart:math';
```

Atau kalau tidak ingin `reduce` error saat data kosong:

```dart
double getChartMaxMl(List<WaterBarChartData> data) {
  if (data.isEmpty) return 3000;

  final highestMl = data.map((item) => item.ml).reduce(max);
  return highestMl < 3000 ? 3000 : highestMl;
}
```

Catatan:

```text
data kosong harus ditangani, karena reduce tidak bisa bekerja pada list kosong.
```

## Menangani Data Kosong

Saat ini ada perhitungan:

```dart
final barAreaWidth = chartWidth / data.length;
```

Kalau `data.length == 0`, akan terjadi pembagian nol.

Tambahkan guard:

```dart
if (data.isEmpty) return;
```

Di awal `paint`:

```dart
@override
void paint(Canvas canvas, Size size) {
  if (data.isEmpty || maxMl <= 0) return;

  ...
}
```

Kenapa cek `maxMl <= 0`?

Karena ada perhitungan:

```dart
final ratio = step / maxMl;
```

Kalau `maxMl = 0`, akan bermasalah.

## Menjaga Label Tidak Keluar

### Label Y

Label Y sekarang:

```dart
offset: Offset(0, y - 8)
```

Ini manual.

Lebih rapi jika label di-align vertikal tengah:

```dart
void _drawRightAlignedText(
  Canvas canvas, {
  required String text,
  required Offset rightCenter,
  required TextStyle style,
}) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout();

  final offset = Offset(
    rightCenter.dx - textPainter.width,
    rightCenter.dy - textPainter.height / 2,
  );

  textPainter.paint(canvas, offset);
}
```

Pakai:

```dart
_drawRightAlignedText(
  canvas,
  text: '${(step / 1000).toStringAsFixed(1)}L',
  rightCenter: Offset(chartLeft - 8, y),
  style: labelStyle,
);
```

Dengan ini label Y lebih rapi di kanan area label.

### Label X

Gunakan helper centered text:

```dart
_drawCenteredText(
  canvas,
  text: item.day,
  center: Offset(barCenterX, chartBottom + 14),
  style: labelStyle,
);
```

Ini lebih akurat daripada:

```dart
Offset(barCenterX - 12, chartBottom + 10)
```

## Performance

Animasi wave membuat painter repaint terus.

Beberapa tips:

1. Jangan membuat object berat di luar kebutuhan.
2. Pastikan area chart tidak terlalu besar.
3. Hindari rebuild parent besar hanya untuk animasi chart.
4. `AnimatedBuilder` sebaiknya hanya membungkus `CustomPaint`, bukan seluruh halaman.

Di chart kamu, ini sudah benar:

```dart
Expanded(
  child: AnimatedBuilder(
    animation: Listenable.merge([...]),
    builder: (context, child) {
      return CustomPaint(...);
    },
  ),
)
```

Artinya hanya bagian chart yang rebuild, bukan seluruh halaman.

## Debugging Checklist

### Bar Tidak Muncul

Cek:

```dart
data.isNotEmpty
maxMl > 0
chartHeight > 0
barHeight > 0
```

### Semua Bar Sama Tinggi

Cek:

```dart
final ratio = (item.ml / maxMl).clamp(0.0, 1.0);
```

Pastikan bukan:

```dart
clamp(0.0, 0.1)
```

Cek juga apakah semua `item.ml` lebih besar dari `maxMl`. Kalau semua data di atas `maxMl`, semua akan penuh.

### Label Y Bertumpuk

Cek apakah memakai ratio langsung:

```dart
Offset(chartLeft, ratio)
```

Harusnya:

```dart
final y = chartBottom - (chartHeight * ratio);
Offset(chartLeft, y)
```

### Active Bar Tidak Berubah Warna

Cek apakah `activeIndex` dikirim sampai painter:

```dart
WaterIntakeBarChartPainter(
  activeIndex: widget.activeIndex,
  ...
)
```

Cek juga index:

```text
0 Mon
1 Tue
2 Wed
3 Thu
```

### Wave Tidak Terlihat

Kemungkinan:

1. `waveHeight` terlalu kecil.
2. Wave dan fill memakai warna yang sama.
3. Kamu menggambar solid fill penuh lalu wave warna sama di atasnya.
4. `waveProgress` tidak berubah.
5. `_waveController.repeat()` belum dipanggil.

Solusi:

```dart
final waveHeight = 8.0;
```

atau pakai highlight:

```dart
final wavePaint = Paint()
  ..color = Colors.white.withValues(alpha: 0.22);
```

### Animasi Bar Naik Tidak Jalan

Cek:

```dart
_fillController.forward();
```

Cek painter menerima:

```dart
fillProgress: Curves.easeOutCubic.transform(_fillController.value),
```

Cek `barHeight` memakai:

```dart
final animatedRatio = ratio * fillProgress;
```

### Error Ticker / Controller

Pastikan:

```dart
with TickerProviderStateMixin
```

dan:

```dart
vsync: this
```

Pastikan controller dibuat di `initState`, bukan di `build`.

Pastikan controller dibuang di `dispose`.

## Versi Minimal Chart Statis

Ini versi konsep paling kecil tanpa animasi:

```dart
class BarChartProgressWidget extends StatelessWidget {
  final List<WaterBarChartData> data;
  final double maxMl;

  const BarChartProgressWidget({
    required this.data,
    required this.maxMl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall!;

    return SizedBox(
      height: 240,
      width: double.infinity,
      child: CustomPaint(
        painter: WaterIntakeBarChartPainter(
          data: data,
          maxMl: maxMl,
          labelStyle: labelStyle,
        ),
      ),
    );
  }
}
```

Painter statis:

```dart
class WaterIntakeBarChartPainter extends CustomPainter {
  final List<WaterBarChartData> data;
  final double maxMl;
  final TextStyle labelStyle;

  WaterIntakeBarChartPainter({
    required this.data,
    required this.maxMl,
    required this.labelStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || maxMl <= 0) return;

    final chartLeft = 44.0;
    final chartTop = 12.0;
    final chartRight = size.width;
    final chartBottom = size.height - 24;

    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - chartTop;

    final barAreaWidth = chartWidth / data.length;
    final barWidth = barAreaWidth * 0.7;

    final barPaint = Paint()..color = Colors.blue;
    final backgroundPaint = Paint()..color = Colors.blue.withValues(alpha: 0.15);

    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      final barCenterX = chartLeft + (barAreaWidth * i) + barAreaWidth / 2;
      final barLeft = barCenterX - barWidth / 2;
      final barRight = barCenterX + barWidth / 2;

      final ratio = (item.ml / maxMl).clamp(0.0, 1.0);
      final barHeight = chartHeight * ratio;

      final backgroundRect = RRect.fromRectAndCorners(
        Rect.fromLTRB(barLeft, chartTop, barRight, chartBottom),
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(12),
      );

      final filledRect = RRect.fromRectAndCorners(
        Rect.fromLTRB(barLeft, chartBottom - barHeight, barRight, chartBottom),
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(12),
      );

      canvas.drawRRect(backgroundRect, backgroundPaint);
      canvas.drawRRect(filledRect, barPaint);
    }
  }

  @override
  bool shouldRepaint(covariant WaterIntakeBarChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.maxMl != maxMl;
  }
}
```

## Versi Minimal dengan Fill Animation

Widget:

```dart
class BarChartProgressWidget extends StatefulWidget {
  final List<WaterBarChartData> data;
  final double maxMl;

  const BarChartProgressWidget({
    required this.data,
    required this.maxMl,
    super.key,
  });

  @override
  State<BarChartProgressWidget> createState() => _BarChartProgressWidgetState();
}

class _BarChartProgressWidgetState extends State<BarChartProgressWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fillController;

  @override
  void initState() {
    super.initState();
    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _fillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall!;

    return AnimatedBuilder(
      animation: _fillController,
      builder: (context, child) {
        return CustomPaint(
          painter: WaterIntakeBarChartPainter(
            data: widget.data,
            maxMl: widget.maxMl,
            labelStyle: labelStyle,
            fillProgress: Curves.easeOutCubic.transform(_fillController.value),
          ),
        );
      },
    );
  }
}
```

Painter:

```dart
final ratio = (item.ml / maxMl).clamp(0.0, 1.0);
final animatedRatio = ratio * fillProgress;
final barHeight = chartHeight * animatedRatio;
```

## Versi Minimal dengan Wave Animation

Widget:

```dart
_waveController = AnimationController(
  vsync: this,
  duration: const Duration(seconds: 2),
)..repeat();
```

AnimatedBuilder:

```dart
animation: Listenable.merge([
  _fillController,
  _waveController,
]),
```

Painter property:

```dart
final double waveProgress;
```

Wave:

```dart
final waterTop = chartBottom - barHeight;
final waveHeight = 5.0;
final waveLength = barWidth * 1.2;
final phase = waveProgress * 2 * pi;

final wavePath = Path();
wavePath.moveTo(barLeft, waterTop);

for (double x = 0; x <= barWidth; x++) {
  final y = sin((x / waveLength * 2 * pi) + phase) * waveHeight;
  wavePath.lineTo(barLeft + x, waterTop + y);
}

wavePath.lineTo(barRight, chartBottom);
wavePath.lineTo(barLeft, chartBottom);
wavePath.close();

canvas.save();
canvas.clipRRect(backgroundRect);
canvas.drawPath(wavePath, isActive ? activeBarPaint : barPaint);
canvas.restore();
```

## Logika Utama dalam Satu Alur

Untuk setiap frame animasi, Flutter melakukan ini:

```text
1. AnimationController menghasilkan nilai baru.
2. AnimatedBuilder rebuild.
3. CustomPaint dibuat ulang dengan painter baru.
4. Painter menerima fillProgress dan waveProgress terbaru.
5. paint() dipanggil.
6. Grid digambar.
7. Untuk setiap data:
   - hitung slot bar
   - hitung tinggi target dari ml / maxMl
   - kalikan dengan fillProgress
   - buat background bar
   - buat wave path
   - clip agar wave tidak keluar
   - gambar wave
   - gambar label hari
```

Dalam kode mental:

```dart
for each bar:
  slot = chartWidth / data.length
  centerX = chartLeft + slot * index + slot / 2
  ratio = ml / maxMl
  animatedRatio = ratio * fillProgress
  barHeight = chartHeight * animatedRatio
  waterTop = chartBottom - barHeight
  wave = sin(x + phase)
  draw background
  clip inside bar
  draw wave
  draw label
```

## Checklist Saat Mengembangkan Fitur Berikutnya

Jika ingin tambah fitur, pikirkan dulu masuk ke bagian mana:

```text
Data baru?
  -> Tambah field di WaterBarChartData.

Style baru?
  -> Tambah parameter di BarChartProgressWidget, lalu pass ke painter.

Gambar baru?
  -> Tambah logic di paint().

Animasi baru?
  -> Tambah AnimationController atau pakai controller yang sudah ada.

Interaksi tap?
  -> Butuh GestureDetector di widget dan hit testing manual untuk bar.
```

## Ide Pengembangan Berikutnya

### 1. Tooltip Saat Bar Ditekan

Butuh:

```text
GestureDetector
localPosition
hit test bar rect
selectedIndex
setState
```

### 2. Goal Line

Misal target harian 2500 ml.

Hitung:

```dart
final goalRatio = (goalMl / maxMl).clamp(0.0, 1.0);
final goalY = chartBottom - chartHeight * goalRatio;
```

Gambar:

```dart
canvas.drawLine(
  Offset(chartLeft, goalY),
  Offset(chartRight, goalY),
  goalPaint,
);
```

### 3. Highlight Hari Ini Otomatis

```dart
final todayIndex = DateTime.now().weekday - 1;
```

Lalu:

```dart
BarChartProgressWidget(
  activeIndex: todayIndex,
  ...
)
```

### 4. Bar Gradient

`Paint` bisa memakai shader:

```dart
final gradientPaint = Paint()
  ..shader = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      AppColors.primary,
      AppColors.inversePrimary,
    ],
  ).createShader(
    Rect.fromLTRB(barLeft, chartBottom - barHeight, barRight, chartBottom),
  );
```

Lalu:

```dart
canvas.drawPath(wavePath, gradientPaint);
```

### 5. Bar Berbeda Warna Berdasarkan Goal

```dart
final isGoalMet = item.ml >= goalMl;

final currentPaint = Paint()
  ..color = isGoalMet ? Colors.green : Colors.blue;
```

## Ringkasan Istilah

```text
CustomPaint
  Widget yang menyediakan area canvas.

CustomPainter
  Class yang berisi instruksi menggambar.

Canvas
  Permukaan gambar.

Paint
  Kuas: warna, stroke, style.

Offset
  Titik koordinat x dan y.

Size
  Ukuran area gambar.

Rect
  Kotak biasa.

RRect
  Kotak rounded.

Path
  Bentuk bebas dari garis-garis.

TextPainter
  Cara menggambar text di canvas.

AnimationController
  Penghasil nilai animasi 0.0 sampai 1.0.

TickerProviderStateMixin
  Penyedia ticker untuk AnimationController.

AnimatedBuilder
  Widget yang rebuild saat animation berubah.

Listenable.merge
  Menggabungkan beberapa animation/listenable.

Curves
  Mengubah rasa gerak animasi.

sin
  Fungsi matematika untuk membuat gelombang.

pi
  Konstanta matematika untuk satu putaran gelombang.

clipRRect
  Membatasi area gambar di dalam rounded rectangle.

save / restore
  Menyimpan dan mengembalikan state canvas.

shouldRepaint
  Menentukan kapan painter perlu menggambar ulang.
```

## Urutan Belajar yang Disarankan

Kalau kamu ingin benar-benar paham, pelajari dengan urutan ini:

1. Pahami coordinate system canvas.
2. Pahami `Paint`, `Offset`, `Rect`, `RRect`.
3. Pahami cara menghitung `ratio` dan `barHeight`.
4. Pahami kenapa Y harus dihitung dari `chartBottom`.
5. Pahami `TextPainter`.
6. Pahami `StatefulWidget` dan lifecycle `initState` / `dispose`.
7. Pahami `AnimationController`.
8. Pahami `AnimatedBuilder`.
9. Pahami `Path`.
10. Pahami `sin`, `phase`, dan `waveProgress`.
11. Pahami `clipRRect`.

Jika semua ini sudah jelas, custom chart dengan animasi tidak lagi terasa misterius. Yang kamu lakukan hanya mengubah angka dan menggambar ulang berdasarkan angka itu.

