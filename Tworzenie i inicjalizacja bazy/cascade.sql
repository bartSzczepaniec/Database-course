UPDATE Samochod SET Nr_rej = 'ZZ99999' WHERE Nr_rej = 'GKA12765'
UPDATE Samochod SET Nr_rej = 'JJ11111' WHERE Nr_rej = 'KRK73371'
UPDATE Samochod SET Nr_rej = 'AAA3333' WHERE Nr_rej = 'KRK24424'

UPDATE Osoba SET Pesel = '99992572115' WHERE Pesel = '61082577748'
UPDATE Osoba SET Pesel = '21152468888' WHERE Pesel = '80102575738'
UPDATE Osoba SET Pesel = '11111111111' WHERE Pesel = '94100469847'
DELETE Osoba WHERE PESEL = '99992572115'
DELETE Samochod WHERE Nr_rej = 'ZZ99999'
DELETE Osoba WHERE PESEL = '81030349481'
DELETE Samochod WHERE Nr_rej = 'GDA12390'
DELETE Polisa WHERE ID = 9
DELETE Zdarzenie WHERE ID = 4
DELETE Zdarzenie WHERE ID = 1