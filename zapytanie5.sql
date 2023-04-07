/*
Pytanie:
Zmartwiony ojciec chce kupi� swojemu synowi samoch�d. Przed zakupem sprawdza jakie 
auto najrzadziej ulega awarii i bierze udzia� w wypadkach. Z pierwszych trzech wynik�w 
wybiera te auto, kt�rego koszt polisy jest najmniejszy. 
Uzasadnienie biznesowe: Pomoc klientowi w doborze auta, kt�re b�dzie m�g� ubezpieczy� w tej firmie
*/


--Widok pokazuje zestawienie koszt�w ostatnich wykupionych polis dla danych aut oraz daty rozpocz�cia i ko�ca
--U�yty, aby zmniejszy� obj�to�� g��wnego zapytania
CREATE VIEW Najnowsze_polisy AS
SELECT Ostatnie_polisy.Nr_rej, Data_r, Data_k, Koszt FROM
	(SELECT Nr_rej,MAX(Data_rozp) as Data_r,MAX(Data_ko�ca) as Data_k
	FROM Polisa
	GROUP BY Nr_rej) Ostatnie_polisy
INNER JOIN POLISA
ON Polisa.Nr_rej = Ostatnie_polisy.Nr_rej
AND Polisa.Data_rozp = Data_r;

-- Zestawienie Samochod�w(Marki, modelu, numeru rejestracyjnego) oraz ilo�ci awarii i wypadk�w, w kt�rych auto bra�o odzia�, oraz koszt ostatniej polisy obejmuj�cej to auto
SELECT Marka, Model,samochody_z_awariami.Nr_rej, Awarie_i_wypadki, Koszt FROM 
	(SELECT TOP 3 Marka, Model, Samochod.Nr_rej, COUNT(ID_Zdarzenia) AS Awarie_i_wypadki FROM -- Zestawienie 3 aut, kt�re najrzadziej ulega awarii/bierze udzia�u w wypadku i liczba tych zdarze�
		Samochod LEFT OUTER JOIN Uczestnictwo_w_zdarzeniu
		ON Samochod.Nr_rej = Uczestnictwo_w_zdarzeniu.Nr_rej
		AND (ID_Zdarzenia IN (SELECT ID_Zdarzenia -- Po��czenia aut ze zdarzeniami rodzaju 'awaria' i 'wypadek', ale tak�e uwzgl�dnienie aut, kt�re w nich nie bra�y udzia�u 
			FROM Uczestnictwo_w_zdarzeniu JOIN Zdarzenie
			ON Uczestnictwo_w_zdarzeniu.ID_Zdarzenia = Zdarzenie.ID
			WHERE Rodzaj LIKE 'AWARIA' OR Rodzaj LIKE 'Wypadek')
			OR ID_Zdarzenia = NULL)
		INNER JOIN Polisa
		ON Samochod.Nr_rej = Polisa.Nr_rej 
		GROUP BY Marka, Model, Samochod.Nr_rej
		ORDER BY Awarie_i_wypadki ASC) AS samochody_z_awariami -- Rosn�co ze wzgl�du na liczb� awarii i wypadk�w
	INNER JOIN Najnowsze_polisy -- Po��czenie z ostatnimi polisami dla danych aut (aby, pokaza� najnowszy koszt polisy)
	ON Najnowsze_polisy.Nr_rej = samochody_z_awariami.Nr_rej
	ORDER BY Koszt ASC; -- Rosn�co ze wzgl�du na koszt aktualnej polisy, aby wybra� jedno auto spo�r�d 3 z najmniejsz� ilo�ci� awarii i wypadk�w
	