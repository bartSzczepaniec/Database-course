/*
Pytanie:
Wypisz 4 Marki samochodów powoduj¹ce najwiêcej Zdarzeñ oraz procentowo za ile 
Zdarzeñ ta marka odpowiada(Tylko te Zdarzenia które maj¹ sprawcê)
*/

-- Widok statystyki spowodowanych zdarzeñ(wypadków) przez samochody danej marki
-- Uzasadnienie bizenosowe: Korzystaj¹c z zapisanych statystyk, mo¿emy sprawdziæ jakimi autami najrzadziej/najczêœciej powodowane s¹ zdarzenia
-- i na podstawie tych informacji, zmieniaæ stawki cen polis ubezpieczaj¹cych auta danej marki
CREATE VIEW Statystyka_zdarzen AS
SELECT Samochod.Marka, COUNT(*) AS Liczba_spowodowanych_zdarzen -- Zestawienie marki oraz liczby zdarzeñ spowodowanych przez auta tej marki
FROM Uczestnictwo_w_zdarzeniu
INNER JOIN Samochod
ON Uczestnictwo_w_zdarzeniu.Nr_rej = Samochod.Nr_rej
WHERE Czy_Spowodowal = 'TRUE'
GROUP BY Samochod.Marka;

--Wydobycie 4 Marek, które maj¹ najwiêksz¹ iloœæ spowodowanych zdarzeñ i pokaznie ich procentowego udzia³u w spowodowanych zdarzeniach
SELECT TOP 4 Marka, Liczba_spowodowanych_zdarzen, 100.0*Liczba_spowodowanych_zdarzen/(SELECT SUM(Liczba_spowodowanych_zdarzen) FROM Statystyka_zdarzen) AS procentowo
FROM Statystyka_zdarzen
GROUP BY Marka, Liczba_spowodowanych_zdarzen
ORDER BY Liczba_spowodowanych_zdarzen DESC;