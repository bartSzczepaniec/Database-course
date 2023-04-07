/*
Pytanie:
Pewien reporter pisze artyku� o dzisiejszych kierowcach i wpad� na pomys� przedstawienia 
czytelnikom obrazu najbardziej typowego uczestnika wypadku. W tym celu wyszukuje on 
najcz�ciej pojawiaj�ce si� imi� oraz mark� samochodu, ale wybiera dane jedynie spo�r�d 
sprawc�w. Zapisuje obok r�wnie� �redni czas posiadania prawa jazdy na podstawie danych 
wszystkich sprawc�w w bazie danych.

Cel biznesowy: Udost�pnianie danych statystycznych w celach publicystycznych,
bez ukazywania danych osobowych
*/

-- Zestawienie Imienia oraz marki samochodu, kt�ry jad�c autem/autami tej marki spowodowa� najwi�cej wypadk�w i ilo�ci tych wypadk�w
-- Dodatkowo w ostatniej kolumnie podany �redni czas
select TOP 1 Imie, Marka, COUNT(ID_zdarzenia) AS Wypadki, Srednia -- Zsumowanie zdarze�, kt�re kto� spowodowa� danym autem i wybranie z nich najcz�stszej pary auto + osoba
FROM 
	Osoba INNER JOIN Uczestnictwo_w_zdarzeniu
	ON Osoba.Pesel = Uczestnictwo_w_zdarzeniu.Pesel
	INNER JOIN Samochod
	ON Samochod.Nr_rej = Uczestnictwo_w_zdarzeniu.Nr_rej,
	(SELECT AVG(Czas_posiadania) AS Srednia FROM( -- osobne policzenie �redniej posiadania prawa jazdy dla wszystkich sprawc�w
		SELECT DISTINCT Osoba.Pesel, Osoba.Imie, Osoba.Nazwisko, DATEDIFF(MONTH,MIN(Prawo_jazdy.Data_wyd),CURRENT_TIMESTAMP) AS "Czas_posiadania" -- czas posiadania prawa jazdy
			FROM Osoba
			INNER JOIN Prawo_jazdy
			ON Osoba.Pesel = Prawo_jazdy.Pesel
			INNER JOIN Uczestnictwo_w_zdarzeniu ON
			Osoba.Pesel = Uczestnictwo_w_zdarzeniu.Pesel
			WHERE Uczestnictwo_w_zdarzeniu.Czy_Spowodowal = 'TRUE' -- uwzgl�dnienie tylko sprawc�w
			GROUP BY Osoba.Pesel, Osoba.Imie, Osoba.Nazwisko)
		AS czasy_posiadania) AS srednia_posiadania
	WHERE Czy_Spowodowal = 'TRUE' -- liczenie wypadk�w, kt�re dany kierowca spowodowa�
	GROUP BY Imie, Marka, Srednia 
	ORDER BY Wypadki DESC;

