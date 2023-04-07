/*
Pytanie:
Wypisz 3 najbardziej dochodowe(na których ubezpieczalnia najwiêcej zarobi³a) i 3 
najmniej dochodowe Osoby(na których ubezpieczalnia najmniej zarobi³a b¹dŸ 
potencjalnie straci³a pieni¹dze) które maj¹/mieli polisê w ubezpieczalni. 
Dochodowoœæ Osoby to (suma Op³at za wszystkie jej Polisy) – (suma Odszkodowañ 
pokrytych przez wszystkie jej Polisy). Wypisz PESEL, Imiê i Nazwisko tych osób oraz
kwotê jak¹ ubezpieczalnia zarobi³a/straci³a na tej osobie.

Uzasadnienie biznesowe: 
Analiza dochodowoœci osób, którym sprzedawane s¹ polisy, w celu np. zmiany cen nastêpnych polis, tak aby firma nie traci³a pieniêdzy na tych osobach
*/


SELECT * FROM( -- Wypisanie peselów, imion oraz zysku lub straty z polis wykupionych przez te osoby
SELECT TOP 3 Osoba.Pesel, Osoba.Imie, (ISNULL(Oplaty,0) - ISNULL(Odszkodowania,0)) AS Zysk
FROM
OSOBA JOIN Ubezpieczenie                             --Po³¹czenie osób, które maj¹ polisê z sum¹ ich op³at i odszkodowañ 
ON osoba.Pesel = Ubezpieczenie.Pesel LEFT OUTER JOIN --(tak, aby znalaz³y siê te¿ osoby, którym nic nie wyp³acono/nie zaplacili jeszcze oplaty
	(SELECT Osoba.Pesel, Imie,SUM(Kwota) AS Oplaty FROM  -- Dla w³aœcicieli polis, wydobywamy wszystkie ich op³aty za wszystkie polisy, które kiedykolwiek posiadali
	Osoba JOIN Ubezpieczenie
	ON Osoba.Pesel = Ubezpieczenie.Pesel
	JOIN Polisa
	ON Ubezpieczenie.ID_polisy = Polisa.ID
	JOIN Oplaty
	ON Polisa.ID = Oplaty.ID
	GROUP BY Osoba.Pesel,Imie) oplaty1
	on Osoba.Pesel = oplaty1.Pesel LEFT OUTER JOIN
		(SELECT Osoba.Pesel, Imie,SUM(Kwota) AS Odszkodowania FROM -- Dla w³aœcicieli polis, wydobywamy wszystkie ich odszkodowania 
		Osoba JOIN Ubezpieczenie								   -- wyp³acone ze wszystkich polisy, które kiedykolwiek posiadali
		ON Osoba.Pesel = Ubezpieczenie.Pesel
		JOIN Polisa
		ON Ubezpieczenie.ID_polisy = Polisa.ID
		JOIN Odszkodowanie
		ON Polisa.ID = Odszkodowanie.ID_polisy
		GROUP BY Osoba.Pesel,Imie) odszkodowania1
ON odszkodowania1.Pesel = oplaty1.Pesel
GROUP BY Osoba.Pesel, Osoba.Imie, Oplaty,Odszkodowania
ORDER BY Zysk DESC) Zyskowni -- Sortowanie, aby zobaczyæ najbardziej (nie)op³acalnych klientów ubezpieczalni
UNION 
SELECT * FROM( -- Analogicznie jak wy¿ej, tylko najmniej op³acalne osoby, po³¹czone za pomoc¹ UNION
SELECT TOP 3 Osoba.Pesel, Osoba.Imie, (ISNULL(Oplaty,0) - ISNULL(Odszkodowania,0)) AS Zysk
FROM
OSOBA JOIN Ubezpieczenie                             --Po³¹czenie osób, które maj¹ polisê z sum¹ ich op³at i odszkodowañ 
ON osoba.Pesel = Ubezpieczenie.Pesel LEFT OUTER JOIN --(tak, aby znalaz³y siê te¿ osoby, którym nic nie wyp³acono/nie zaplacili jeszcze oplaty
	(SELECT Osoba.Pesel, Imie,SUM(Kwota) AS Oplaty FROM  -- Dla w³aœcicieli polis, wydobywamy wszystkie ich op³aty za wszystkie polisy, które kiedykolwiek posiadali
	Osoba JOIN Ubezpieczenie
	ON Osoba.Pesel = Ubezpieczenie.Pesel
	JOIN Polisa
	ON Ubezpieczenie.ID_polisy = Polisa.ID
	JOIN Oplaty
	ON Polisa.ID = Oplaty.ID
	GROUP BY Osoba.Pesel,Imie) oplaty1
	on Osoba.Pesel = oplaty1.Pesel LEFT OUTER JOIN
		(SELECT Osoba.Pesel, Imie,SUM(Kwota) AS Odszkodowania FROM -- Dla w³aœcicieli polis, wydobywamy wszystkie ich odszkodowania 
		Osoba JOIN Ubezpieczenie								   -- wyp³acone ze wszystkich polisy, które kiedykolwiek posiadali
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
