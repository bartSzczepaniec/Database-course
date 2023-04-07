/*
Pytanie:
Pragmatyczny kierowca postanowi³, ¿e ubezpieczy swoje auto w jak najbardziej efektywny 
sposób. W tym celu sprawdza on bazê danych w celu poszukiwania zdarzenia, które ma 
najwiêkszy wspó³czynnik czêstoœci do kwoty odszkodowania pomniejszonej o kwotê rocznej 
op³aty polisy. 
Uzasadnienie biznesowe: Doradztwo klientowi, w celu wybrania najkorzystniejszego ubezpieczenia
*/

-- Zestawienie rodzaju zdarzenia, iloœci(czêstoœci wyst¹pieñ), zysku(œredniej kwoty odszkodowania pomniejszonej o op³atê) oraz wspó³czynnia Zysk/iloœæ
SELECT zliczenie.Rodzaj, Ilosc, Zysk, (1.0*Zysk)/Ilosc AS Wspolczynnik 
FROM 
	(SELECT Zdarzenie.Rodzaj, COUNT(*) AS Ilosc  -- -- wydobycie iloœci wypadków danego rodzaju, aby policzyæ ich czêstotliwoœæ
	FROM Zdarzenie JOIN Odszkodowanie
	ON Odszkodowanie.ID_zdarzenia = Zdarzenie.ID
	JOIN Polisa
	ON Odszkodowanie.ID_polisy = Polisa.ID
	GROUP BY Zdarzenie.Rodzaj) AS zliczenie
	JOIN (SELECT Zdarzenie.Rodzaj, AVG(odszkodowania-Koszt) as Zysk -- policzenie œredniej kwoty wyp³aconych odszkodowañ za zdarzenie pomniejszonej o koszt polisy
			FROM Zdarzenie JOIN
				(SELECT Zdarzenie.Rodzaj, Zdarzenie.ID, SUM(Kwota) as odszkodowania, Koszt FROM -- zsumowanie wszystkich wyp³aconych odszkodowañ dla jednego zdarzenia
				Zdarzenie JOIN Odszkodowanie
				ON Zdarzenie.ID = Odszkodowanie.ID_zdarzenia
				JOIN Polisa
				ON Polisa.ID = Odszkodowanie.ID_polisy
				GROUP BY Zdarzenie.Rodzaj,Zdarzenie.ID, Koszt) sumyodszkodowan
		ON sumyodszkodowan.ID = Zdarzenie.ID
		GROUP BY Zdarzenie.Rodzaj) Zyski
ON Zyski.Rodzaj = zliczenie.Rodzaj 
ORDER BY Wspolczynnik DESC
