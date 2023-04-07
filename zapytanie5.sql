/*
Pytanie:
Zmartwiony ojciec chce kupiæ swojemu synowi samochód. Przed zakupem sprawdza jakie 
auto najrzadziej ulega awarii i bierze udzia³ w wypadkach. Z pierwszych trzech wyników 
wybiera te auto, którego koszt polisy jest najmniejszy. 
Uzasadnienie biznesowe: Pomoc klientowi w doborze auta, które bêdzie móg³ ubezpieczyæ w tej firmie
*/


--Widok pokazuje zestawienie kosztów ostatnich wykupionych polis dla danych aut oraz daty rozpoczêcia i koñca
--U¿yty, aby zmniejszyæ objêtoœæ g³ównego zapytania
CREATE VIEW Najnowsze_polisy AS
SELECT Ostatnie_polisy.Nr_rej, Data_r, Data_k, Koszt FROM
	(SELECT Nr_rej,MAX(Data_rozp) as Data_r,MAX(Data_koñca) as Data_k
	FROM Polisa
	GROUP BY Nr_rej) Ostatnie_polisy
INNER JOIN POLISA
ON Polisa.Nr_rej = Ostatnie_polisy.Nr_rej
AND Polisa.Data_rozp = Data_r;

-- Zestawienie Samochodów(Marki, modelu, numeru rejestracyjnego) oraz iloœci awarii i wypadków, w których auto bra³o odzia³, oraz koszt ostatniej polisy obejmuj¹cej to auto
SELECT Marka, Model,samochody_z_awariami.Nr_rej, Awarie_i_wypadki, Koszt FROM 
	(SELECT TOP 3 Marka, Model, Samochod.Nr_rej, COUNT(ID_Zdarzenia) AS Awarie_i_wypadki FROM -- Zestawienie 3 aut, które najrzadziej ulega awarii/bierze udzia³u w wypadku i liczba tych zdarzeñ
		Samochod LEFT OUTER JOIN Uczestnictwo_w_zdarzeniu
		ON Samochod.Nr_rej = Uczestnictwo_w_zdarzeniu.Nr_rej
		AND (ID_Zdarzenia IN (SELECT ID_Zdarzenia -- Po³¹czenia aut ze zdarzeniami rodzaju 'awaria' i 'wypadek', ale tak¿e uwzglêdnienie aut, które w nich nie bra³y udzia³u 
			FROM Uczestnictwo_w_zdarzeniu JOIN Zdarzenie
			ON Uczestnictwo_w_zdarzeniu.ID_Zdarzenia = Zdarzenie.ID
			WHERE Rodzaj LIKE 'AWARIA' OR Rodzaj LIKE 'Wypadek')
			OR ID_Zdarzenia = NULL)
		INNER JOIN Polisa
		ON Samochod.Nr_rej = Polisa.Nr_rej 
		GROUP BY Marka, Model, Samochod.Nr_rej
		ORDER BY Awarie_i_wypadki ASC) AS samochody_z_awariami -- Rosn¹co ze wzglêdu na liczbê awarii i wypadków
	INNER JOIN Najnowsze_polisy -- Po³¹czenie z ostatnimi polisami dla danych aut (aby, pokazaæ najnowszy koszt polisy)
	ON Najnowsze_polisy.Nr_rej = samochody_z_awariami.Nr_rej
	ORDER BY Koszt ASC; -- Rosn¹co ze wzglêdu na koszt aktualnej polisy, aby wybraæ jedno auto spoœród 3 z najmniejsz¹ iloœci¹ awarii i wypadków
	