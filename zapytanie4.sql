/*
Pytanie:
Pragmatyczny kierowca postanowi�, �e ubezpieczy swoje auto w jak najbardziej efektywny 
spos�b. W tym celu sprawdza on baz� danych w celu poszukiwania zdarzenia, kt�re ma 
najwi�kszy wsp�czynnik cz�sto�ci do kwoty odszkodowania pomniejszonej o kwot� rocznej 
op�aty polisy. 
Uzasadnienie biznesowe: Doradztwo klientowi, w celu wybrania najkorzystniejszego ubezpieczenia
*/

-- Zestawienie rodzaju zdarzenia, ilo�ci(cz�sto�ci wyst�pie�), zysku(�redniej kwoty odszkodowania pomniejszonej o op�at�) oraz wsp�czynnia Zysk/ilo��
SELECT zliczenie.Rodzaj, Ilosc, Zysk, (1.0*Zysk)/Ilosc AS Wspolczynnik 
FROM 
	(SELECT Zdarzenie.Rodzaj, COUNT(*) AS Ilosc  -- -- wydobycie ilo�ci wypadk�w danego rodzaju, aby policzy� ich cz�stotliwo��
	FROM Zdarzenie JOIN Odszkodowanie
	ON Odszkodowanie.ID_zdarzenia = Zdarzenie.ID
	JOIN Polisa
	ON Odszkodowanie.ID_polisy = Polisa.ID
	GROUP BY Zdarzenie.Rodzaj) AS zliczenie
	JOIN (SELECT Zdarzenie.Rodzaj, AVG(odszkodowania-Koszt) as Zysk -- policzenie �redniej kwoty wyp�aconych odszkodowa� za zdarzenie pomniejszonej o koszt polisy
			FROM Zdarzenie JOIN
				(SELECT Zdarzenie.Rodzaj, Zdarzenie.ID, SUM(Kwota) as odszkodowania, Koszt FROM -- zsumowanie wszystkich wyp�aconych odszkodowa� dla jednego zdarzenia
				Zdarzenie JOIN Odszkodowanie
				ON Zdarzenie.ID = Odszkodowanie.ID_zdarzenia
				JOIN Polisa
				ON Polisa.ID = Odszkodowanie.ID_polisy
				GROUP BY Zdarzenie.Rodzaj,Zdarzenie.ID, Koszt) sumyodszkodowan
		ON sumyodszkodowan.ID = Zdarzenie.ID
		GROUP BY Zdarzenie.Rodzaj) Zyski
ON Zyski.Rodzaj = zliczenie.Rodzaj 
ORDER BY Wspolczynnik DESC
