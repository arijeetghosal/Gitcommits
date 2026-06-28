-- ============================================================
-- Uber-Datenanalyse Projekt — SQLite Version
-- Autor: Arijeet Ghosal
-- Dieses Skript erstellt die Tabellen, importiert die CSV-Daten
-- und führt alle Analyseabfragen aus.
-- ============================================================

-- Tabellen erstellen
CREATE TABLE IF NOT EXISTS trip_details (
    tripid INTEGER PRIMARY KEY,
    loc_from INTEGER,
    searches INTEGER,
    searches_got_estimate INTEGER,
    searches_for_quotes INTEGER,
    searches_got_quotes INTEGER,
    customer_not_cancelled INTEGER,
    driver_not_cancelled INTEGER,
    otp_entered INTEGER,
    end_ride INTEGER
);

CREATE TABLE IF NOT EXISTS trips (
    tripid INTEGER PRIMARY KEY,
    faremethod INTEGER,
    fare INTEGER,
    loc_from INTEGER,
    loc_to INTEGER,
    driverid INTEGER,
    custid INTEGER,
    distance INTEGER,
    duration INTEGER
);

CREATE TABLE IF NOT EXISTS assembly (
    ID INTEGER PRIMARY KEY,
    Assembly TEXT
);

CREATE TABLE IF NOT EXISTS duration (
    id INTEGER PRIMARY KEY,
    duration TEXT
);

CREATE TABLE IF NOT EXISTS payment (
    id INTEGER PRIMARY KEY,
    method TEXT
);

-- CSV-Daten importieren
.mode csv
.import --skip 1 assembly.csv assembly
.import --skip 1 duration.csv duration
.import --skip 1 payment.csv payment
.import --skip 1 trip_details.csv trip_details
.import --skip 1 trips.csv trips

.mode column
.headers on

-- ============================================================
-- ABSCHNITT 1: Übersichtskennzahlen
-- ============================================================

SELECT '=== ABSCHNITT 1: Übersichtskennzahlen ===' AS info;

-- 1. Gesamtanzahl der einzigartigen Fahrten
SELECT COUNT(DISTINCT tripid) AS gesamtfahrten FROM trip_details;

-- 2. Gesamtanzahl der aktiven Fahrer
SELECT COUNT(DISTINCT driverid) AS gesamtfahrer FROM trips;

-- 3. Gesamteinnahmen (in Euro)
SELECT SUM(fare) AS gesamteinnahmen_euro FROM trips;

-- 4. Abgeschlossene Fahrten
SELECT SUM(end_ride) AS abgeschlossene_fahrten FROM trip_details;

-- ============================================================
-- ABSCHNITT 2: Such- und Buchungstrichter
-- ============================================================

SELECT '=== ABSCHNITT 2: Conversion Funnel ===' AS info;

-- 5. Vollständiger Funnel
SELECT 
    SUM(searches) AS gesamtsuchen,
    SUM(searches_got_estimate) AS mit_schaetzung,
    SUM(searches_for_quotes) AS nach_angeboten,
    SUM(searches_got_quotes) AS mit_angeboten,
    SUM(customer_not_cancelled) AS kunde_ok,
    SUM(driver_not_cancelled) AS fahrer_ok,
    SUM(otp_entered) AS otp_eingabe,
    SUM(end_ride) AS fahrt_fertig
FROM trip_details;

-- 9. Fahrerinitiierte Stornierungen
SELECT COUNT(*) - SUM(driver_not_cancelled) AS fahrer_stornierungen FROM trip_details;

-- ============================================================
-- ABSCHNITT 3: Fahrtleistung
-- ============================================================

SELECT '=== ABSCHNITT 3: Fahrtleistung ===' AS info;

-- 12. Durchschnittliche Entfernung pro Fahrt
SELECT ROUND(AVG(distance), 2) AS durchschn_entfernung_km FROM trips;

-- 13. Durchschnittlicher Fahrpreis
SELECT ROUND(CAST(SUM(fare) AS REAL) / COUNT(*), 2) AS durchschn_fahrpreis_euro FROM trips;

-- 14. Gesamtstrecke
SELECT SUM(distance) AS gesamtstrecke_km FROM trips;

-- ============================================================
-- ABSCHNITT 4: Zahlungsanalyse
-- ============================================================

SELECT '=== ABSCHNITT 4: Zahlungsanalyse ===' AS info;

-- 15. Beliebteste Zahlungsmethode
SELECT a.method AS beliebteste_zahlungsmethode, COUNT(DISTINCT t.tripid) AS anzahl
FROM payment a 
INNER JOIN trips t ON a.id = t.faremethod
GROUP BY a.method
ORDER BY anzahl DESC
LIMIT 1;

-- 17. Höchster Fahrpreis je Zahlungsmethode
SELECT p.method AS zahlungsmethode, MAX(t.fare) AS max_fahrpreis
FROM trips t
JOIN payment p ON t.faremethod = p.id
GROUP BY p.method
ORDER BY max_fahrpreis DESC;

-- ============================================================
-- ABSCHNITT 5: Stadtteilanalyse (Berliner Stadtteile)
-- ============================================================

SELECT '=== ABSCHNITT 5: Berliner Stadtteile ===' AS info;

-- 18. Top 5 Stadtteile (Ziel) mit meisten Fahrten
SELECT a.Assembly AS stadtteil, COUNT(t.loc_to) AS anzahl_fahrten
FROM trips t
JOIN assembly a ON t.loc_to = a.ID
GROUP BY a.Assembly
ORDER BY anzahl_fahrten DESC
LIMIT 5;

-- Top 5 Startorte
SELECT a.Assembly AS start_stadtteil, COUNT(t.loc_from) AS anzahl_fahrten
FROM trips t
JOIN assembly a ON t.loc_from = a.ID
GROUP BY a.Assembly
ORDER BY anzahl_fahrten DESC
LIMIT 5;

-- ============================================================
-- ABSCHNITT 6: Fahrerleistung
-- ============================================================

SELECT '=== ABSCHNITT 6: Top 5 Fahrer ===' AS info;

-- 20. Top 5 umsatzstärkste Fahrer
SELECT driverid AS fahrer_id, SUM(fare) AS gesamteinnahmen_euro
FROM trips
GROUP BY driverid
ORDER BY gesamteinnahmen_euro DESC
LIMIT 5;

-- ============================================================
-- ABSCHNITT 7: Tageszeit-Analyse
-- ============================================================

SELECT '=== ABSCHNITT 7: Tageszeit ===' AS info;

-- 21. Zeitfenster mit den meisten Fahrten
SELECT duration AS zeitfenster, COUNT(DISTINCT tripid) AS anzahl_fahrten
FROM trips
GROUP BY duration
ORDER BY anzahl_fahrten DESC
LIMIT 5;

-- 22. Häufigstes Fahrer-Kunden-Paar
SELECT driverid AS fahrer_id, custid AS kunden_id, COUNT(DISTINCT tripid) AS anzahl
FROM trips
GROUP BY driverid, custid
ORDER BY anzahl DESC
LIMIT 3;

-- ============================================================
-- ABSCHNITT 8: Conversion-Raten
-- ============================================================

SELECT '=== ABSCHNITT 8: Conversion-Raten ===' AS info;

SELECT 
    ROUND(CAST(SUM(searches_got_estimate) AS REAL) / SUM(searches) * 100, 2) AS 'Suche_zu_Schaetzung_%',
    ROUND(CAST(SUM(searches_for_quotes) AS REAL) / SUM(searches_got_estimate) * 100, 2) AS 'Schaetzung_zu_Angebot_%',
    ROUND(CAST(SUM(searches_got_quotes) AS REAL) / SUM(searches_for_quotes) * 100, 2) AS 'Angebotsannahme_%',
    ROUND(CAST(SUM(end_ride) AS REAL) / SUM(searches_got_quotes) * 100, 2) AS 'Angebot_zu_Buchung_%',
    ROUND(CAST(SUM(end_ride) AS REAL) / SUM(searches) * 100, 2) AS 'Gesamt_Conversion_%'
FROM trip_details;

-- Stornierungsrate
SELECT ROUND(
    CAST((COUNT(tripid) - SUM(driver_not_cancelled) + COUNT(tripid) - SUM(customer_not_cancelled)) AS REAL)
    / SUM(end_ride), 2
) AS buchungsstornierungsrate
FROM trip_details;

-- ============================================================
-- ABSCHNITT 9: Stadtteil-Detailanalyse
-- ============================================================

SELECT '=== ABSCHNITT 9: Stadtteil-Details ===' AS info;

-- 31. Stadtteil mit höchstem Gesamtumsatz
SELECT a.Assembly AS stadtteil, SUM(t.fare) AS gesamtumsatz_euro
FROM trips t
JOIN assembly a ON t.loc_from = a.ID
GROUP BY a.Assembly
ORDER BY gesamtumsatz_euro DESC
LIMIT 5;

-- 32. Stadtteil mit meisten Fahrer-Stornierungen
SELECT a.Assembly AS stadtteil, COUNT(*) - SUM(td.driver_not_cancelled) AS fahrer_stornierungen
FROM trip_details td
JOIN assembly a ON td.loc_from = a.ID
GROUP BY a.Assembly
ORDER BY fahrer_stornierungen DESC
LIMIT 5;

-- 33. Stadtteil mit meisten Kunden-Stornierungen
SELECT a.Assembly AS stadtteil, COUNT(*) - SUM(td.customer_not_cancelled) AS kunden_stornierungen
FROM trip_details td
JOIN assembly a ON td.loc_from = a.ID
GROUP BY a.Assembly
ORDER BY kunden_stornierungen DESC
LIMIT 5;

SELECT '=== Analyse abgeschlossen | Arijeet Ghosal ===' AS info;
