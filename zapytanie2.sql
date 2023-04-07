/*
Pytanie:
Wypisz 3 najbardziej dochodowe(na kt�rych ubezpieczalnia najwi�cej zarobi�a) i 3 
najmniej dochodowe Osoby(na kt�rych ubezpieczalnia najmniej zarobi�a b�d� 
potencjalnie straci�a pieni�dze) kt�re maj�/mieli polis� w ubezpieczalni. 
Dochodowo�� Osoby to (suma Op�at za wszystkie jej Polisy) � (suma Odszkodowa� 
pokrytych przez wszystkie jej Polisy). Wypisz PESEL, Imi� i Nazwisko tych os�b oraz
kwot� jak� ubezpieczalnia zarobi�a/straci�a na tej osobie.

Uzasadnienie biznesowe: 
Analiza dochodowo�ci os�b, kt�rym sprzedawane s� polisy, w celu np. zmiany cen nast�pnych polis, tak aby firma nie traci�a pieni�dzy na tych osobach
*/


SELECT * FROM( -- Wypisanie pesel�w, imion oraz zysku lub straty z polis wykupionych przez te osoby
SELECT TOP 3 Osoba.Pesel, Osoba.Imie, (ISNULL(Oplaty,0) - ISNULL(Odszkodowania,0)) AS Zysk
FROM
OSOBA JOIN Ubezpieczenie                             --Po��czenie os�b, kt�re maj� polis� z sum� ich op�at i odszkodowa� 
ON osoba.Pesel = Ubezpieczenie.Pesel LEFT OUTER JOIN --(tak, aby znalaz�y si� te� osoby, kt�rym nic nie wyp�acono/nie zaplacili jeszcze oplaty
	(SELECT Osoba.Pesel, Imie,SUM(Kwota) AS Oplaty FROM  -- Dla w�a�cicieli polis, wydobywamy wszystkie ich op�aty za wszystkie polisy, kt�re kiedykolwiek posiadali
	Osoba JOIN Ubezpieczenie
	ON Osoba.Pesel = Ubezpieczenie.Pesel
	JOIN Polisa
	ON Ubezpieczenie.ID_polisy = Polisa.ID
	JOIN Oplaty
	ON Polisa.ID = Oplaty.ID
	GROUP BY Osoba.Pesel,Imie) oplaty1
	on Osoba.Pesel = oplaty1.Pesel LEFT OUTER JOIN
		(SELECT Osoba.Pesel, Imie,SUM(Kwota) AS Odszkodowania FROM -- Dla w�a�cicieli polis, wydobywamy wszystkie ich odszkodowania 
		Osoba JOIN Ubezpieczenie								   -- wyp�acone ze wszystkich polisy, kt�re kiedykolwiek posiadali
		ON Osoba.Pesel = Ubezpieczenie.Pesel
		JOIN Polisa
		ON Ubezpieczenie.ID_polisy = Polisa.ID
		JOIN Odszkodowanie
		ON Polisa.ID = Odszkodowanie.ID_polisy
		GROUP BY Osoba.Pesel,Imie) odszkodowania1
ON odszkodowania1.Pesel = oplaty1.Pesel
GROUP BY Osoba.Pesel, Osoba.Imie, Oplaty,Odszkodowania
ORDER BY Zysk DESC) Zyskowni -- Sortowanie, aby zobaczy� najbardziej (nie)op�acalnych klient�w ubezpieczalni
UNION 
SELECT * FROM( -- Analogicznie jak wy�ej, tylko najmniej op�acalne osoby, po��czone za pomoc� UNION
SELECT TOP 3 Osoba.Pesel, Osoba.Imie, (ISNULL(Oplaty,0) - ISNULL(Odszkodowania,0)) AS Zysk
FROM
OSOBA JOIN Ubezpieczenie                             --Po��czenie os�b, kt�re maj� polis� z sum� ich op�at i odszkodowa� 
ON osoba.Pesel = Ubezpieczenie.Pesel LEFT OUTER JOIN --(tak, aby znalaz�y si� te� osoby, kt�rym nic nie wyp�acono/nie zaplacili jeszcze oplaty
	(SELECT Osoba.Pesel, Imie,SUM(Kwota) AS Oplaty FROM  -- Dla w�a�cicieli polis, wydobywamy wszystkie ich op�aty za wszystkie polisy, kt�re kiedykolwiek posiadali
	Osoba JOIN Ubezpieczenie
	ON Osoba.Pesel = Ubezpieczenie.Pesel
	JOIN Polisa
	ON Ubezpieczenie.ID_polisy = Polisa.ID
	JOIN Oplaty
	ON Polisa.ID = Oplaty.ID
	GROUP BY Osoba.Pesel,Imie) oplaty1
	on Osoba.Pesel = oplaty1.Pesel LEFT OUTER JOIN
		(SELECT Osoba.Pesel, Imie,SUM(Kwota) AS Odszkodowania FROM -- Dla w�a�cicieli polis, wydobywamy wszystkie ich odszkodowania 
		Osoba JOIN Ubezpieczenie								   -- wyp�acone ze wszystkich polisy, kt�re kiedykolwiek posiadali
		ON Osoba.Pesel = Ubezpieczenie.Pesel
		JOIN Polisa
		ON Ubezpieczenie.ID_polisy = Polisa.ID
		JOIN Odszkodowanie
		ON Polisa.ID = Odszkodowanie.ID_polisy
		GROUP BY Osoba.Pesel,Imie) odszkodowania1
ON odszkodowania1.Pesel = oplaty1.Pesel
GROUP BY Osoba.Pesel, Osoba.Imie, Oplaty,Odszkodowania
ORDER BY Zysk ASC) Stratni
ORDER BY Zysk DESC
