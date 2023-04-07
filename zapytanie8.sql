/*
Pytanie:
Sporz�dzic zestawienie Marek aut, i �redniej ilo�ci wypadk�w spowodowanych przez to auto (ilo�� wypadk�w podzielon� przez liczb� aut tej marki)
Uzasadnienie biznesowe: Analiza �redniej ilo�ci wypadk�w w celu zmiany stawek ubezpieczenia dla samochod�w danej marki
*/
-- Zestawienie marek samochod�w, liczby samochod�w tej marki, spowodowanych nimi wypadk�w, oraz �redni� ilo�� wypadk�w na osob�
SELECT Ilosci_aut.Marka, Liczba_aut,ISNULL(liczba_spowodowanych_zdarzen,0) AS Spowodowane_wypadki, (1.0*ISNULL(liczba_spowodowanych_zdarzen,0)/Liczba_aut) AS Srednio_wypadkow 
FROM
	(SELECT Marka, COUNT(*) AS Liczba_aut FROM Samochod  -- policznie ilo�ci aut danej marki w bazie danych
	GROUP BY Marka) Ilosci_aut 
	LEFT OUTER JOIN statystyka_zdarzen -- Uwzgl�dnnia te� samochody bezwypadkowe
	ON Statystyka_zdarzen.Marka = Ilosci_aut.Marka
ORDER BY Srednio_wypadkow DESC