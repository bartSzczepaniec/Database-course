/*
Pytanie:
Policz wszystkie wykroczenia pope³nione przez osobê o peselu "" i ile polis wykupi³ do tej pory w ubezpieczalni
Uzasadnienie biznesowe: W celu ustalenia ceny dla nastêpnej polisy wykupywanej przez t¹ osobê,
ubezpieczyciel sprawdza historiê pope³nionych przez niego wykroczeñ, co jest czynnikiem maj¹cym wp³yw na zwiêkszenie op³aty za polisê
oraz iloœæ jego wykupionych polis(mo¿liwa zni¿ka dla sta³ych klientów)

*/

-- Zestawienie danych osobistych osoby oraz iloœci pope³nionych przez ni¹ wykroczeñ i liczba dotychczas wykupionych polis
SELECT Osoba.Pesel, Imie, Nazwisko, COUNT(Wykroczenie.ID) AS Wykroczenia, Polisy
FROM Osoba 
	LEFT OUTER JOIN Uczestnictwo_w_zdarzeniu -- po³¹czenie osoby z wydarzeniami, w którymi bra³ udzia³
	ON Osoba.Pesel = Uczestnictwo_w_zdarzeniu.Pesel
	LEFT OUTER JOIN Wykroczenie
	ON Wykroczenie.ID_uczestnictwa = Uczestnictwo_w_zdarzeniu.ID,
	(SELECT COUNT(*) AS Polisy 
		FROM Ubezpieczenie 
		WHERE Pesel = '61101135754')Ilosc -- osobno wyszukanie iloœci wykupionych dotychczas polis
	WHERE Osoba.Pesel = '61101135754'
	GROUP BY Osoba.Pesel,Imie,Nazwisko,Polisy
