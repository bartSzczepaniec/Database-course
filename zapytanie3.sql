/*
Pytanie:
Wypisz 4 Marki samochod�w powoduj�ce najwi�cej Zdarze� oraz procentowo za ile 
Zdarze� ta marka odpowiada(Tylko te Zdarzenia kt�re maj� sprawc�)
*/

-- Widok statystyki spowodowanych zdarze�(wypadk�w) przez samochody danej marki
-- Uzasadnienie bizenosowe: Korzystaj�c z zapisanych statystyk, mo�emy sprawdzi� jakimi autami najrzadziej/najcz�ciej powodowane s� zdarzenia
-- i na podstawie tych informacji, zmienia� stawki cen polis ubezpieczaj�cych auta danej marki
CREATE VIEW Statystyka_zdarzen AS
SELECT Samochod.Marka, COUNT(*) AS Liczba_spowodowanych_zdarzen -- Zestawienie marki oraz liczby zdarze� spowodowanych przez auta tej marki
FROM Uczestnictwo_w_zdarzeniu
INNER JOIN Samochod
ON Uczestnictwo_w_zdarzeniu.Nr_rej = Samochod.Nr_rej
WHERE Czy_Spowodowal = 'TRUE'
GROUP BY Samochod.Marka;

--Wydobycie 4 Marek, kt�re maj� najwi�ksz� ilo�� spowodowanych zdarze� i pokaznie ich procentowego udzia�u w spowodowanych zdarzeniach
SELECT TOP 4 Marka, Liczba_spowodowanych_zdarzen, 100.0*Liczba_spowodowanych_zdarzen/(SELECT SUM(Liczba_spowodowanych_zdarzen) FROM Statystyka_zdarzen) AS procentowo
FROM Statystyka_zdarzen
GROUP BY Marka, Liczba_spowodowanych_zdarzen
ORDER BY Liczba_spowodowanych_zdarzen DESC;