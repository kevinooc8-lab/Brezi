import '../models.dart';

// Isi pelajaran. Tambah soal di sini. Pelajaran dengan daftar soal kosong = kerangka.

const List<Lesson> a1 = [
  Lesson('a1-01', 'Sapaan', 'Halo, selamat pagi, terima kasih', '👋', [
    Question.mc('Apa arti “Guten Morgen”?', ['Selamat pagi', 'Selamat malam', 'Terima kasih', 'Sampai jumpa'], 0, speak: 'Guten Morgen'),
    Question.listen('Ketuk speaker, lalu pilih yang kamu dengar', 'Danke', ['Danke', 'Bitte', 'Tschüss', 'Hallo'], 0),
    Question.mc('Apa arti “Tschüss”?', ['Selamat datang', 'Sampai jumpa', 'Selamat tidur', 'Apa kabar'], 1, speak: 'Tschüss'),
    Question.order('Susun: “Halo, nama saya Budi”', ['Hallo', 'ich', 'heiße', 'Budi', 'bin'], 'Hallo ich heiße Budi'),
    Question.mc('Bagaimana mengucapkan “Selamat malam”?', ['Guten Abend', 'Guten Morgen', 'Guten Tag', 'Danke'], 0),
  ]),
  Lesson('a1-02', 'Perkenalan', 'Nama, asal, dan umur', '🙋', [
    Question.mc('Apa arti “Ich komme aus Indonesien”?', ['Saya tinggal di Jerman', 'Saya berasal dari Indonesia', 'Saya suka Indonesia', 'Saya belajar Indonesia'], 1, speak: 'Ich komme aus Indonesien'),
    Question.order('Susun: “Saya berasal dari Indonesia”', ['Ich', 'komme', 'aus', 'Indonesien', 'bin'], 'Ich komme aus Indonesien'),
    Question.mc('Apa arti “Wie heißt du?”', ['Kamu dari mana?', 'Siapa namamu?', 'Berapa umurmu?', 'Apa kabar?'], 1, speak: 'Wie heißt du?'),
    Question.listen('Ketuk speaker, lalu pilih yang kamu dengar', 'Wie geht es dir?', ['Wie heißt du?', 'Wie geht es dir?', 'Woher kommst du?', 'Wie alt bist du?'], 1),
    Question.order('Susun: “Siapa namamu?”', ['Wie', 'heißt', 'du', 'ist'], 'Wie heißt du'),
  ]),
  Lesson('a1-03', 'Makanan', 'Roti, air, kopi', '🥨', [
    Question.mc('Apa arti “das Brot”?', ['Roti', 'Susu', 'Nasi', 'Telur'], 0, speak: 'das Brot'),
    Question.mc('Apa arti “das Wasser”?', ['Teh', 'Air', 'Jus', 'Bir'], 1, speak: 'das Wasser'),
    Question.listen('Ketuk speaker, lalu pilih yang kamu dengar', 'der Kaffee', ['der Tee', 'der Kaffee', 'die Milch', 'das Brot'], 1),
    Question.order('Susun: “Saya minum air”', ['Ich', 'trinke', 'Wasser', 'esse'], 'Ich trinke Wasser'),
    Question.order('Susun: “Saya makan roti”', ['Ich', 'esse', 'Brot', 'trinke'], 'Ich esse Brot'),
  ], premium: true),
  Lesson('a1-04', 'Di kota', 'Bertanya arah dan tempat', '🏰', [], premium: true),
  Lesson('a1-05', 'Keluarga', 'Ibu, ayah, saudara', '👨‍👩‍👧', [], premium: true),
  Lesson('a1-06', 'Belanja', 'Harga dan jumlah', '🛍️', [], premium: true),
];

const List<Lesson> a2 = [
  Lesson('a2-01', 'Rutinitas', 'Kegiatan sehari-hari', '🕗', [
    Question.mc('Apa arti “Ich stehe um sieben Uhr auf”?', ['Saya bangun jam tujuh', 'Saya tidur jam tujuh', 'Saya makan jam tujuh', 'Saya pulang jam tujuh'], 0, speak: 'Ich stehe um sieben Uhr auf'),
    Question.order('Susun: “Saya sarapan jam delapan”', ['Ich', 'frühstücke', 'um', 'acht', 'Uhr', 'esse'], 'Ich frühstücke um acht Uhr'),
    Question.mc('Apa arti “aufstehen”?', ['Bangun', 'Tidur', 'Pergi', 'Makan'], 0, speak: 'aufstehen'),
    Question.listen('Ketuk speaker, lalu pilih yang kamu dengar', 'Ich gehe zur Arbeit', ['Ich gehe zur Arbeit', 'Ich gehe zur Schule', 'Ich komme von der Arbeit', 'Ich fahre zur Arbeit'], 0),
  ], premium: true),
  Lesson('a2-02', 'Belanja', 'Bertanya harga dan membeli', '🛒', [
    Question.mc('Apa arti “Was kostet das?”', ['Berapa harganya?', 'Apa ini?', 'Di mana tokonya?', 'Saya mau ini'], 0, speak: 'Was kostet das?'),
    Question.order('Susun: “Saya mau membeli apel”', ['Ich', 'möchte', 'Äpfel', 'kaufen', 'habe'], 'Ich möchte Äpfel kaufen'),
    Question.mc('Apa arti “zu teuer”?', ['Terlalu mahal', 'Murah sekali', 'Terlalu besar', 'Terlalu kecil'], 0, speak: 'zu teuer'),
    Question.listen('Ketuk speaker, lalu pilih yang kamu dengar', 'Ich nehme das', ['Ich nehme das', 'Ich habe das', 'Ich sehe das', 'Ich mache das'], 0),
  ], premium: true),
  Lesson('a2-03', 'Transportasi', 'Kereta, bus, dan tiket', '🚆', [
    Question.mc('Apa arti “Der Zug fährt um zehn Uhr ab”?', ['Kereta berangkat jam sepuluh', 'Kereta tiba jam sepuluh', 'Bus berangkat jam sepuluh', 'Kereta terlambat sepuluh menit'], 0, speak: 'Der Zug fährt um zehn Uhr ab'),
    Question.order('Susun: “Di mana stasiunnya?”', ['Wo', 'ist', 'der', 'Bahnhof', 'die'], 'Wo ist der Bahnhof'),
    Question.mc('Apa arti “die Fahrkarte”?', ['Tiket', 'Peta', 'Bagasi', 'Peron'], 0, speak: 'die Fahrkarte'),
    Question.order('Susun: “Saya naik bus”', ['Ich', 'fahre', 'mit', 'dem', 'Bus', 'den'], 'Ich fahre mit dem Bus'),
  ], premium: true),
  Lesson('a2-04', 'Kesehatan', 'Di dokter dan apotek', '🩺', [], premium: true),
  Lesson('a2-05', 'Liburan', 'Merencanakan perjalanan', '🏖️', [], premium: true),
];

const List<Lesson> b1 = [
  Lesson('b1-01', 'Pendapat', 'Menyampaikan pendapat', '💬', [
    Question.mc('Apa arti “Ich finde, dass das eine gute Idee ist”?', ['Menurut saya, itu ide yang bagus', 'Saya menemukan ide itu', 'Saya tidak suka ide itu', 'Saya punya banyak ide'], 0, speak: 'Ich finde, dass das eine gute Idee ist'),
    Question.order('Susun: “Menurut saya itu penting”', ['Ich', 'finde', 'das', 'wichtig', 'ist'], 'Ich finde das wichtig'),
    Question.mc('Apa arti “Meiner Meinung nach”?', ['Menurut pendapat saya', 'Tanpa pendapat saya', 'Setelah rapat', 'Pada pendapat kami'], 0, speak: 'Meiner Meinung nach'),
    Question.listen('Ketuk speaker, lalu pilih yang kamu dengar', 'Ich bin damit einverstanden', ['Ich bin damit einverstanden', 'Ich bin damit nicht einverstanden', 'Ich habe damit angefangen', 'Ich bin damit fertig'], 0),
  ], premium: true),
  Lesson('b1-02', 'Pengalaman', 'Bercerita tentang masa lalu', '⏳', [
    Question.mc('Apa arti “Ich bin gestern ins Kino gegangen”?', ['Kemarin saya pergi ke bioskop', 'Besok saya pergi ke bioskop', 'Saya suka bioskop', 'Saya bekerja di bioskop'], 0, speak: 'Ich bin gestern ins Kino gegangen'),
    Question.order('Susun: “Saya sudah belajar bahasa Jerman”', ['Ich', 'habe', 'Deutsch', 'gelernt', 'bin'], 'Ich habe Deutsch gelernt'),
    Question.mc('Apa arti “Wir haben lange gewartet”?', ['Kami menunggu lama', 'Kami bekerja lama', 'Kami pergi lama', 'Kami belajar lama'], 0, speak: 'Wir haben lange gewartet'),
    Question.order('Susun: “Dia pergi ke Berlin” (sudah terjadi)', ['Er', 'ist', 'nach', 'Berlin', 'gefahren', 'hat'], 'Er ist nach Berlin gefahren'),
  ], premium: true),
  Lesson('b1-03', 'Pekerjaan', 'Melamar dan bekerja', '💼', [
    Question.mc('Apa arti “die Bewerbung”?', ['Lamaran kerja', 'Gaji', 'Rapat', 'Kontrak'], 0, speak: 'die Bewerbung'),
    Question.mc('Apa arti “Ich arbeite als Ingenieur”?', ['Saya bekerja sebagai insinyur', 'Saya belajar menjadi insinyur', 'Saya mencari insinyur', 'Saya bertemu insinyur'], 0, speak: 'Ich arbeite als Ingenieur'),
    Question.order('Susun: “Saya melamar pekerjaan ini”', ['Ich', 'bewerbe', 'mich', 'um', 'diese', 'Stelle', 'dich'], 'Ich bewerbe mich um diese Stelle'),
    Question.listen('Ketuk speaker, lalu pilih yang kamu dengar', 'das Vorstellungsgespräch', ['das Vorstellungsgespräch', 'die Besprechung', 'das Arbeitszeugnis', 'die Kündigung'], 0),
  ], premium: true),
  Lesson('b1-04', 'Berita', 'Membahas peristiwa', '📰', [], premium: true),
  Lesson('b1-05', 'Lingkungan', 'Alam dan lingkungan', '🌱', [], premium: true),
];

const Map<String, List<Lesson>> levels = {'A1': a1, 'A2': a2, 'B1': b1};
const Map<String, String> levelNames = {'A1': 'Pemula', 'A2': 'Dasar', 'B1': 'Menengah'};
