/*
Pytanie:
Policz wszystkie wykroczenia pope�nione przez osob� o peselu "" i ile polis wykupi� do tej pory w ubezpieczalni
Uzasadnienie biznesowe: W celu ustalenia ceny dla nast�pnej polisy wykupywanej przez t� osob�,
ubezpieczyciel sprawdza histori� pope�nionych przez niego wykrocze�, co jest czynnikiem maj�cym wp�yw na zwi�kszenie op�aty za polis�
oraz ilo�� jego wykupionych polis(mo�liwa zni�ka dla sta�ych klient�w)

*/

-- Zestawienie danych osobistych osoby oraz ilo�ci pope�nionych przez ni� wykrocze� i liczba dotychczas wykupionych polis
SELECT Osoba.Pesel, Imie, Nazwisko, COUNT(Wykroczenie.ID) AS Wykroczenia, Polisy
FROM Osoba 
	LEFT OUTER JOIN Uczestnictwo_w_zdarzeniu -- po��czenie osoby z wydarzeniami, w kt�rymi bra� udzia�
	ON Osoba.Pesel = Uczestnictwo_w_zdarzeniu.Pesel
	LEFT OUTER JOIN Wykroczenie
	ON Wykroczenie.ID_uczestnictwa = Uczestnictwo_w_zdarzeniu.ID,
	(SELECT COUNT(*) AS Polisy 
		FROM Ubezpieczenie 
		WHERE Pesel = '61101135754')Ilosc -- osobno wyszukanie ilo�ci wykupionych dotychczas polis
	WHERE Osoba.Pesel = '61101135754'
	GROUP BY Osoba.Pesel,Imie,Nazwisko,Polisy
