class ExQ {
  final String q;
  final List<String> o;
  final int a;
  const ExQ(this.q, this.o, this.a);
}

class ExPassage {
  final String text;
  final List<ExQ> qs;
  const ExPassage(this.text, this.qs);
}

class ExKey {
  final String label, pattern;
  const ExKey(this.label, this.pattern);
}

class ExWrite {
  final String prompt;
  final int min;
  final List<ExKey> keys;
  const ExWrite(this.prompt, this.min, this.keys);
}

class ExLevel {
  final int seconds;
  final ExPassage reading, listening;
  final ExWrite writing;
  final List<String> speaking;
  const ExLevel(this.seconds, this.reading, this.listening, this.writing, this.speaking);
}

// Soal latihan buatan sendiri, bukan soal resmi Goethe.
const Map<String, ExLevel> exams = {
  'A1': ExLevel(
    600,
    ExPassage('Hallo Anna, ich bin Tom. Ich wohne in Berlin und arbeite im Supermarkt von Montag bis Freitag. Am Samstag spiele ich Fußball. Am Sonntag besuche ich meine Mutter.', [
      ExQ('Wo wohnt Tom?', ['In Berlin', 'In Hamburg', 'In München'], 0),
      ExQ('Wann arbeitet Tom?', ['Am Wochenende', 'Von Montag bis Freitag', 'Nur am Samstag'], 1),
      ExQ('Was macht Tom am Samstag?', ['Er besucht seine Mutter', 'Er arbeitet', 'Er spielt Fußball'], 2),
    ]),
    ExPassage('Guten Tag, hier ist die Bäckerei Müller. Wir haben heute Brot, Brötchen und Kuchen. Das Brot kostet zwei Euro. Wir sind bis achtzehn Uhr geöffnet.', [
      ExQ('Was kostet das Brot?', ['Zwei Euro', 'Drei Euro', 'Vier Euro'], 0),
      ExQ('Bis wann ist die Bäckerei geöffnet?', ['Bis 16 Uhr', 'Bis 18 Uhr', 'Bis 20 Uhr'], 1),
      ExQ('Was gibt es heute?', ['Fisch und Fleisch', 'Obst und Gemüse', 'Brot, Brötchen und Kuchen'], 2),
    ]),
    ExWrite('Schreiben Sie eine E-Mail an einen Freund. Stellen Sie sich vor: Name, Wohnort und ein Hobby.', 25, [ExKey('Begrüßung (Hallo, Liebe)', 'hallo|liebe|lieber'), ExKey('Name oder Wohnort (ich heiße, ich wohne)', 'hei(ß|ss)e|ich bin|wohne|komme aus'), ExKey('Hobby (gern, spiele)', 'hobby|gern|spiele|mag')]),
    ['Stellen Sie sich vor: Name, Alter, Land und Wohnort.', 'Stellen Sie drei Fragen: Wie heißt du? Woher kommst du? Was machst du gern?'],
  ),
  'A2': ExLevel(
    900,
    ExPassage('Liebe Sara, am Samstag mache ich eine Party in meiner neuen Wohnung. Sie ist im dritten Stock in der Gartenstraße 12. Die Party beginnt um 19 Uhr. Bring bitte etwas zu trinken mit. Kannst du kommen? Viele Grüße, Lena', [
      ExQ('Was macht Lena am Samstag?', ['Sie zieht um', 'Sie macht eine Party', 'Sie geht ins Kino'], 1),
      ExQ('Wann beginnt die Party?', ['Um 17 Uhr', 'Um 19 Uhr', 'Um 21 Uhr'], 1),
      ExQ('Was soll Sara mitbringen?', ['Etwas zu trinken', 'Etwas zu essen', 'Blumen'], 0),
    ]),
    ExPassage('Achtung am Gleis fünf: Der Zug nach München fährt heute zehn Minuten später ab, um vierzehn Uhr vierzig. Bitte beachten Sie: In diesem Zug gibt es keinen Speisewagen.', [
      ExQ('Wohin fährt der Zug?', ['Nach Hamburg', 'Nach Köln', 'Nach München'], 2),
      ExQ('Wann fährt der Zug ab?', ['Um 14:30 Uhr', 'Um 14:40 Uhr', 'Um 14:00 Uhr'], 1),
      ExQ('Was gibt es im Zug nicht?', ['Einen Speisewagen', 'Sitzplätze', 'Toiletten'], 0),
    ]),
    ExWrite('Schreiben Sie eine E-Mail an Ihren Freund. Sie waren am Wochenende im Kino. Schreiben Sie, welchen Film Sie gesehen haben und wie er war.', 40, [ExKey('Begrüßung (Hallo, Liebe)', 'hallo|liebe|lieber'), ExKey('Vergangenheit (habe, bin, war)', 'habe|bin|war|hatte'), ExKey('Film und Meinung (Film, gut, spannend)', 'film|kino|gut|schön|langweilig|spannend')]),
    ['Erzählen Sie von Ihrem letzten Urlaub.', 'Bitten Sie höflich um Hilfe in einem Geschäft.'],
  ),
  'B1': ExLevel(
    1200,
    ExPassage('In den letzten Jahren arbeiten immer mehr Menschen im Homeoffice. Viele schätzen, dass sie keine Zeit im Verkehr verlieren. Allerdings fühlen sich manche einsam, weil sie ihre Kollegen kaum sehen. Deshalb bieten einige Firmen ein Modell an, bei dem man zwei Tage im Büro und drei Tage zu Hause arbeitet.', [
      ExQ('Was ist ein Vorteil des Homeoffice?', ['Man verdient mehr Geld', 'Man spart Zeit im Verkehr', 'Man hat mehr Kollegen'], 1),
      ExQ('Warum fühlen sich manche Menschen einsam?', ['Sie sehen ihre Kollegen selten', 'Sie arbeiten zu viel', 'Sie haben keine Arbeit'], 0),
      ExQ('Was bieten einige Firmen an?', ['Nur Arbeit im Büro', 'Nur Arbeit zu Hause', 'Zwei Tage Büro und drei Tage zu Hause'], 2),
    ]),
    ExPassage('Liebe Hörerinnen und Hörer, heute sprechen wir über Mülltrennung. Viele Menschen trennen ihren Müll nicht richtig. Dabei ist es wichtig, Papier, Plastik und Glas getrennt zu sammeln, denn so kann man viele Rohstoffe wiederverwenden.', [
      ExQ('Worüber spricht der Sprecher?', ['Über Verkehr', 'Über Mülltrennung', 'Über Ernährung'], 1),
      ExQ('Warum ist Mülltrennung wichtig?', ['Man kann Rohstoffe wiederverwenden', 'Müll riecht schlecht', 'Es ist billiger'], 0),
      ExQ('Was soll man getrennt sammeln?', ['Papier, Plastik und Glas', 'Obst und Gemüse', 'Kleidung und Schuhe'], 0),
    ]),
    ExWrite('Schreiben Sie Ihre Meinung zum Thema „Homeoffice: Vorteile und Nachteile“.', 60, [ExKey('Eigene Meinung (meiner Meinung nach, ich finde)', 'meinung|ich finde|ich denke|ich glaube'), ExKey('Vorteil nennen', 'vorteil|positiv|spart'), ExKey('Nachteil oder Gegenargument (allerdings, aber)', 'nachteil|allerdings|jedoch|aber|negativ')]),
    ['Präsentieren Sie das Thema: Soziale Medien im Alltag.', 'Reagieren Sie auf die Frage: Was denken Sie über Homeoffice?'],
  ),
};
