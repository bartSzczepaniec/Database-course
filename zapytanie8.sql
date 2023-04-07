/*
Pytanie:
Sporz¹dzic zestawienie Marek aut, i œredniej iloœci wypadków spowodowanych przez to auto (iloœæ wypadków podzielon¹ przez liczbê aut tej marki)
Uzasadnienie biznesowe: Analiza œredniej iloœci wypadków w celu zmiany stawek ubezpieczenia dla samochodów danej marki
*/
-- Zestawienie marek samochodów, liczby samochodów tej marki, spowodowanych nimi wypadków, oraz œredni¹ iloœæ wypadków na osobê
SELECT Ilosci_aut.Marka, Liczba_aut,ISNULL(liczba_spowodowanych_zdarzen,0) AS Spowodowane_wypadki, (1.0*ISNULL(liczba_spowodowanych_zdarzen,0)/Liczba_aut) AS Srednio_wypadkow 
FROM
	(SELECT Marka, COUNT(*) AS Liczba_aut FROM Samochod  -- policznie iloœci aut danej marki w bazie danych
	GROUP BY Marka) Ilosci_aut 
	LEFT OUTER JOIN statystyka_zdarzen -- Uwzglêdnnia te¿ samochody bezwypadkowe
	ON Statystyka_zdarzen.Marka = Ilosci_aut.Marka
ORDER BY Srednio_wypadkow DESC