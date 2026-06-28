-- ============================================================
-- Uber-Datenanalyse Projekt
-- Autor: Arijeet Ghosal
-- Technologien: MySQL, Power BI
-- Standort: Berlin, Deutschland
-- Beschreibung: Umfassende SQL-Analyse von Uber-Fahrtdaten
--               aus Berlin zur Gewinnung von Geschäfts-
--               einblicken zu Fahrleistung, Fahrereinnahmen,
--               Kundenverhalten und Conversion-Funnel-Metriken.
-- ============================================================

USE uber_database;

-- ============================================================
-- ABSCHNITT 1: Übersichtskennzahlen
-- ============================================================

-- 1. Gesamtanzahl der einzigartigen Fahrten
SELECT COUNT(DISTINCT tripid) AS gesamtfahrten
FROM trip_details;

-- 2. Gesamtanzahl der aktiven Fahrer
SELECT COUNT(DISTINCT driverid) AS gesamtfahrer
FROM trips;

-- 3. Gesamteinnahmen aller Fahrten (in Euro)
SELECT SUM(fare) AS gesamteinnahmen
FROM trips;

-- 4. Abgeschlossene Fahrten (bis zum Ziel gefahren)
SELECT SUM(end_ride) AS abgeschlossene_fahrten
FROM trip_details;

-- ============================================================
-- ABSCHNITT 2: Such- und Buchungstrichter (Conversion Funnel)
-- ============================================================

-- 5. Vollständige Funnel-Aufschlüsselung — von Suche bis Fahrtvollendung
SELECT 
    SUM(searches) AS gesamtsuchen,
    SUM(searches_got_estimate) AS suchen_mit_schaetzung,
    SUM(searches_for_quotes) AS suchen_nach_angeboten,
    SUM(searches_got_quotes) AS suchen_mit_angeboten,
    SUM(customer_not_cancelled) AS kunde_nicht_storniert,
    SUM(driver_not_cancelled) AS fahrer_nicht_storniert,
    SUM(otp_entered) AS otp_eingegeben,
    SUM(end_ride) AS fahrt_abgeschlossen
FROM trip_details;

-- 6. Suchen die eine Kostenschätzung erhalten haben
SELECT SUM(searches_got_estimate) AS suchen_mit_schaetzung
FROM trip_details;

-- 7. Suchen bei denen der Kunde ein Angebot angefragt hat
SELECT SUM(searches_for_quotes) AS suchen_nach_angeboten
FROM trip_details;

-- 8. Suchen die tatsächlich ein Angebot erhalten haben
SELECT SUM(searches_got_quotes) AS suchen_mit_angeboten
FROM trip_details;

-- 9. Fahrerinitiierte Stornierungen
SELECT COUNT(*) - SUM(driver_not_cancelled) AS fahrer_stornierungen
FROM trip_details;

-- 10. OTP-Eingaben (Fahrer bestätigt Abholung)
SELECT SUM(otp_entered) AS otp_eingaben
FROM trip_details;

-- 11. Vollständig abgeschlossene Fahrten
SELECT SUM(end_ride) AS abgeschlossene_fahrten
FROM trip_details;

-- ============================================================
-- ABSCHNITT 3: Fahrtleistungskennzahlen
-- ============================================================

-- 12. Durchschnittliche Entfernung pro Fahrt (in km)
SELECT AVG(distance) AS durchschnittliche_entfernung
FROM trips;

-- 13. Durchschnittlicher Fahrpreis pro Fahrt (in Euro)
SELECT SUM(fare) / COUNT(*) AS durchschnittlicher_fahrpreis
FROM trips;

-- 14. Gesamtstrecke aller Fahrten (in km)
SELECT SUM(distance) AS gesamtstrecke
FROM trips;

-- ============================================================
-- ABSCHNITT 4: Zahlungsanalyse
-- ============================================================

-- 15. Beliebteste Zahlungsmethode
SELECT a.method AS zahlungsmethode
FROM payment a 
INNER JOIN (
    SELECT faremethod, COUNT(DISTINCT tripid) AS anzahl_fahrten 
    FROM trips 
    GROUP BY faremethod 
    ORDER BY anzahl_fahrten DESC 
    LIMIT 1
) b ON a.id = b.faremethod;

-- 16. Zahlungsmethode mit dem höchsten Einzelfahrpreis
SELECT a.method AS zahlungsmethode
FROM payment a 
INNER JOIN (
    SELECT faremethod, MAX(fare) AS max_fahrpreis 
    FROM trips 
    GROUP BY faremethod 
    ORDER BY max_fahrpreis DESC 
    LIMIT 2
) b ON a.id = b.faremethod;

-- 17. Höchster Fahrpreis je Zahlungsmethode
SELECT faremethod, MAX(fare) AS max_fahrpreis 
FROM trips 
GROUP BY faremethod 
ORDER BY max_fahrpreis DESC;

-- ============================================================
-- ABSCHNITT 5: Stadtteilanalyse (Berliner Stadtteile)
-- ============================================================

-- 18. Top 2 Stadtteile mit den meisten Fahrtzielen
SELECT a.Assembly AS stadtteil
FROM assembly a 
INNER JOIN (
    SELECT loc_to, COUNT(loc_to) AS anzahl_fahrten 
    FROM trips 
    GROUP BY loc_to 
    ORDER BY anzahl_fahrten DESC 
    LIMIT 2
) b ON a.id = b.loc_to;

-- 19. Häufigste Start-Ziel-Kombinationen
SELECT * FROM (
    SELECT *, DENSE_RANK() OVER (ORDER BY fahrten DESC) AS rang 
    FROM (
        SELECT loc_from, loc_to, COUNT(loc_to) AS fahrten 
        FROM trips 
        GROUP BY loc_from, loc_to 
        ORDER BY fahrten DESC 
        LIMIT 2
    ) a
) b
WHERE rang = 1;

-- ============================================================
-- ABSCHNITT 6: Fahrerleistung
-- ============================================================

-- 20. Top 5 umsatzstärkste Fahrer
SELECT * FROM (
    SELECT *, DENSE_RANK() OVER (ORDER BY gesamteinnahmen DESC) AS rang 
    FROM (
        SELECT driverid AS fahrer_id, SUM(fare) AS gesamteinnahmen
        FROM trips
        GROUP BY driverid
    ) a
) b 
WHERE rang < 6;

-- ============================================================
-- ABSCHNITT 7: Tageszeit- und Daueranalyse
-- ============================================================

-- 21. Zeitfenster mit den meisten Fahrten
SELECT * FROM (
    SELECT *, DENSE_RANK() OVER (ORDER BY anzahl_fahrten DESC) AS rang 
    FROM (
        SELECT duration AS zeitfenster, COUNT(DISTINCT tripid) AS anzahl_fahrten
        FROM trips
        GROUP BY duration
        ORDER BY anzahl_fahrten DESC
    ) a
) b
WHERE rang = 1;

-- 22. Häufigstes Fahrer-Kunden-Paar
SELECT driverid AS fahrer_id, custid AS kunden_id, COUNT(DISTINCT tripid) AS anzahl_bestellungen
FROM trips
GROUP BY driverid, custid
ORDER BY anzahl_bestellungen DESC
LIMIT 1;

-- Alternativer Ansatz mit Fensterfunktion
SELECT * FROM (
    SELECT *, DENSE_RANK() OVER (ORDER BY anzahl_bestellungen DESC) AS rang 
    FROM (
        SELECT driverid AS fahrer_id, custid AS kunden_id, COUNT(DISTINCT tripid) AS anzahl_bestellungen
        FROM trips
        GROUP BY driverid, custid
    ) a
) b
WHERE rang = 1;

-- ============================================================
-- ABSCHNITT 8: Conversion-Funnel-Raten
-- ============================================================

-- 23. Suche-zu-Schätzung-Rate
SELECT (SUM(searches_got_estimate) / SUM(searches) * 100) AS suche_zu_schaetzung_rate
FROM trip_details;

-- 24. Schätzung-zu-Angebotsanfrage-Rate
SELECT (SUM(searches_for_quotes) / SUM(searches_got_estimate) * 100) AS schaetzung_zu_angebot_rate
FROM trip_details;

-- 25. Angebotsannahme-Rate
SELECT (SUM(searches_got_quotes) / SUM(searches_for_quotes) * 100) AS angebotsannahme_rate
FROM trip_details;

-- 26. Angebot-zu-Buchung-Rate
SELECT (SUM(end_ride) / SUM(searches_got_quotes) * 100) AS angebot_zu_buchung_rate
FROM trip_details;

-- 27. Buchungsstornierungsrate
SELECT (
    (COUNT(tripid) - SUM(driver_not_cancelled) + COUNT(tripid) - SUM(customer_not_cancelled)) 
    / SUM(end_ride)
) AS buchungsstornierungsrate
FROM trip_details;

-- 28. Gesamt-Conversion-Rate (Suchen zu abgeschlossenen Fahrten)
SELECT (SUM(end_ride) / SUM(searches) * 100) AS conversion_rate
FROM trip_details;

-- ============================================================
-- ABSCHNITT 9: Stadtteil-Detailanalyse
-- ============================================================

-- 29. Stadtteil-Zeitfenster-Kombination mit den meisten Fahrten
SELECT area AS stadtteil, duration AS zeitfenster, COUNT(*) AS anzahl_fahrten
FROM trips
JOIN duration ON trips.durationid = duration.durationid
GROUP BY area, duration
ORDER BY anzahl_fahrten DESC
LIMIT 1;

-- 30. Meistfrequentierter Startort je Zeitfenster
SELECT * FROM (
    SELECT *, RANK() OVER (PARTITION BY zeitfenster ORDER BY anzahl DESC) AS rang 
    FROM (
        SELECT duration AS zeitfenster, loc_from AS startort, COUNT(tripid) AS anzahl 
        FROM trips
        GROUP BY duration, loc_from
    ) a
) b
WHERE rang = 1;

-- 31. Stadtteil mit dem höchsten Gesamtumsatz
SELECT * FROM (
    SELECT *, RANK() OVER (ORDER BY gesamtumsatz DESC) AS rang 
    FROM (
        SELECT loc_from AS startort, SUM(fare) AS gesamtumsatz 
        FROM trips 
        GROUP BY loc_from
    ) a
) b
WHERE rang = 1;

-- 32. Stadtteil mit den meisten Fahrer-Stornierungen
SELECT * FROM (
    SELECT *, RANK() OVER (ORDER BY stornierungen DESC) AS rang 
    FROM (
        SELECT loc_from AS startort, COUNT(*) - SUM(driver_not_cancelled) AS stornierungen 
        FROM trip_details 
        GROUP BY loc_from
    ) a
) b
WHERE rang = 1;

-- 33. Stadtteil mit den meisten Kunden-Stornierungen
SELECT * FROM (
    SELECT *, RANK() OVER (ORDER BY stornierungen DESC) AS rang 
    FROM (
        SELECT loc_from AS startort, COUNT(*) - SUM(customer_not_cancelled) AS stornierungen 
        FROM trip_details 
        GROUP BY loc_from
    ) a
) b
WHERE rang = 1;

-- ============================================================
-- Ende der Analyse | Arijeet Ghosal | Berlin, Deutschland
-- ============================================================