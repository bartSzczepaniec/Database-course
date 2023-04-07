/*
Pytanie:
Pewien reporter pisze artyku³ o dzisiejszych kierowcach i wpad³ na pomys³ przedstawienia 
czytelnikom obrazu najbardziej typowego uczestnika wypadku. W tym celu wyszukuje on 
najczêœciej pojawiaj¹ce siê imiê oraz markê samochodu, ale wybiera dane jedynie spoœród 
sprawców. Zapisuje obok równie¿ œredni czas posiadania prawa jazdy na podstawie danych 
wszystkich sprawców w bazie danych.

Cel biznesowy: Udostêpnianie danych statystycznych w celach publicystycznych,
bez ukazywania danych osobowych
*/

-- Zestawienie Imienia oraz marki samochodu, który jad¹c autem/autami tej marki spowodowa³ najwiêcej wypadków i iloœci tych wypadków
-- Dodatkowo w ostatniej kolumnie podany œredni czas
select TOP 1 Imie, Marka, COUNT(ID_zdarzenia) AS Wypadki, Srednia -- Zsumowanie zdarzeñ, które ktoœ spowodowa³ danym autem i wybranie z nich najczêstszej pary auto + osoba
FROM 
	Osoba INNER JOIN Uczestnictwo_w_zdarzeniu
	ON Osoba.Pesel = Uczestnictwo_w_zdarzeniu.Pesel
	INNER JOIN Samochod
	ON Samochod.Nr_rej = Uczestnictwo_w_zdarzeniu.Nr_rej,
	(SELECT AVG(Czas_posiadania) AS Srednia FROM( -- osobne policzenie œredniej posiadania prawa jazdy dla wszystkich sprawców
		SELECT DISTINCT Osoba.Pesel, Osoba.Imie, Osoba.Nazwisko, DATEDIFF(MONTH,MIN(Prawo_jazdy.Data_wyd),CURRENT_TIMESTAMP) AS "Czas_posiadania" -- czas posiadania prawa jazdy
			FROM Osoba
			INNER JOIN Prawo_jazdy
			ON Osoba.Pesel = Prawo_jazdy.Pesel
			INNER JOIN Uczestnictwo_w_zdarzeniu ON
			Osoba.Pesel = Uczestnictwo_w_zdarzeniu.Pesel
			WHERE Uczestnictwo_w_zdarzeniu.Czy_Spowodowal = 'TRUE' -- uwzglêdnienie tylko sprawców
			GROUP BY Osoba.Pesel, Osoba.Imie, Osoba.Nazwisko)
		AS czasy_posiadania) AS srednia_posiadania
	WHERE Czy_Spowodowal = 'TRUE' -- liczenie wypadków, które dany kierowca spowodowa³
	GROUP BY Imie, Marka, Srednia 
	ORDER BY Wypadki DESC;

