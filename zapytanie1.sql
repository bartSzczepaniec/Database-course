
/*
Pytanie:
Wypisz średnią liczbę Zdarzeń spowodowanych w ostatnim roku przez Osoby 
posiadające Prawo Jazdy od <0, 1), <1, 5), <5, 10), <10, 20), <20, ∞ ) lat(z tych 
przedziałów).
(np. Co dziesiąta(0.1) Osoba mająca Prawo Jazdy mniej niż rok powoduje jakieś 
zdarzenie a tylko co dwusetna(0.005) Osoba mająca Prawo Jazdy od 20 lat.)

Uzasadnienie biznesowe: Analiza ilości zdarzeń spowodowanych przez osoby posiadające prawo jazdy przez dany czas,
aby ustalić stawki cenowe dla poszczególnych kierowców
*/

SELECT 1.0*Przewinienia.liczba / Osoby.liczba -- Liczba przewinień na osobę
FROM
	(SELECT COUNT(*) AS liczba FROM (
		SELECT Osoba.Pesel, Zdarzenie.ID, Zdarzenie.Data_zdarzenia, MIN(Prawo_jazdy.Data_wyd) AS data_wydania FROM Osoba 
				INNER JOIN Uczestnictwo_w_zdarzeniu		-- lista osób, powodujących wypadek, które mają prawo jazdy przez dany okres czasu
				ON Osoba.Pesel = Uczestnictwo_w_zdarzeniu.Pesel
				INNER JOIN Zdarzenie
				ON Uczestnictwo_w_zdarzeniu.ID_Zdarzenia = Zdarzenie.ID
				INNER JOIN Prawo_jazdy
				ON Osoba.Pesel = Prawo_jazdy.Pesel
				WHERE
					Uczestnictwo_w_zdarzeniu.Czy_Spowodowal='true'
					and DATEDIFF(YEAR, Zdarzenie.Data_zdarzenia, '2021-12-31') = 0 -- Sprawdzenie, czy zdarzenie miało miejsce w poprzednim roku
				GROUP BY Osoba.Pesel, Zdarzenie.ID, Prawo_jazdy.Nr, Zdarzenie.Data_zdarzenia
				HAVING DATEDIFF(MONTH,MIN(Prawo_jazdy.Data_wyd),Zdarzenie.Data_zdarzenia)/12 BETWEEN 30 AND 39 -- tutaj określony jest staż kierowcy (w tamtym czasie)
		) przewinienia) AS Przewinienia,
	(SELECT COUNT(*) AS liczba FROM (
		SELECT Osoba.Pesel, Prawo_jazdy.Nr, MIN(Prawo_jazdy.Data_wyd) AS data_wydania FROM Osoba -- Wypisanie kierowców mających prawo jazdy przez X czasu
		INNER JOIN Prawo_jazdy
		ON Osoba.Pesel = Prawo_jazdy.Pesel
		GROUP BY Osoba.Pesel, Prawo_jazdy.Nr
		HAVING DATEDIFF(MONTH,MIN(Prawo_jazdy.Data_wyd),'2021-12-31')/12 BETWEEN 30 AND 39 -- tutaj określony jest staż kierowcy
	) Osoby) AS Osoby;