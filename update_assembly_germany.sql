USE uber_database;

UPDATE assembly
SET Assembly = CASE ID
    WHEN 1 THEN 'Mitte, Berlin, Germany'
    WHEN 2 THEN 'Kreuzberg, Berlin, Germany'
    WHEN 3 THEN 'Friedrichshain, Berlin, Germany'
    WHEN 4 THEN 'Prenzlauer Berg, Berlin, Germany'
    WHEN 5 THEN 'Charlottenburg, Berlin, Germany'
    WHEN 6 THEN 'Schoneberg, Berlin, Germany'
    WHEN 7 THEN 'Neukolln, Berlin, Germany'
    WHEN 8 THEN 'Tempelhof, Berlin, Germany'
    WHEN 9 THEN 'Steglitz, Berlin, Germany'
    WHEN 10 THEN 'Zehlendorf, Berlin, Germany'
    WHEN 11 THEN 'Wilmersdorf, Berlin, Germany'
    WHEN 12 THEN 'Spandau, Berlin, Germany'
    WHEN 13 THEN 'Reinickendorf, Berlin, Germany'
    WHEN 14 THEN 'Pankow, Berlin, Germany'
    WHEN 15 THEN 'Lichtenberg, Berlin, Germany'
    WHEN 16 THEN 'Marzahn, Berlin, Germany'
    WHEN 17 THEN 'Hellersdorf, Berlin, Germany'
    WHEN 18 THEN 'Treptow, Berlin, Germany'
    WHEN 19 THEN 'Kopenick, Berlin, Germany'
    WHEN 20 THEN 'Wedding, Berlin, Germany'
    WHEN 21 THEN 'Moabit, Berlin, Germany'
    WHEN 22 THEN 'Tiergarten, Berlin, Germany'
    WHEN 23 THEN 'Dahlem, Berlin, Germany'
    WHEN 24 THEN 'Grunewald, Berlin, Germany'
    WHEN 25 THEN 'Wannsee, Berlin, Germany'
    WHEN 26 THEN 'Tegel, Berlin, Germany'
    WHEN 27 THEN 'Adlershof, Berlin, Germany'
    WHEN 28 THEN 'Friedenau, Berlin, Germany'
    WHEN 29 THEN 'Lankwitz, Berlin, Germany'
    WHEN 30 THEN 'Mariendorf, Berlin, Germany'
    WHEN 31 THEN 'Rudow, Berlin, Germany'
    WHEN 32 THEN 'Britz, Berlin, Germany'
    WHEN 33 THEN 'Buckow, Berlin, Germany'
    WHEN 34 THEN 'Lichterfelde, Berlin, Germany'
    WHEN 35 THEN 'Nikolassee, Berlin, Germany'
    WHEN 36 THEN 'Altglienicke, Berlin, Germany'
    WHEN 37 THEN 'Karlshorst, Berlin, Germany'
    ELSE Assembly
END
WHERE ID BETWEEN 1 AND 37;

SELECT ID, Assembly
FROM assembly
ORDER BY ID;
