CREATE TABLE Osoba (
Pesel CHAR(11) CHECK(Pesel LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' AND LEN(PESEL) = 11) PRIMARY KEY,
Imie VARCHAR(30) NOT NULL CHECK (LEN(Imie)>=2 AND Imie LIKE '[A-Z][a-z]%' ),
Nazwisko VARCHAR(30) NOT NULL CHECK (LEN(Nazwisko)>=2 AND Nazwisko LIKE '[A-Z][a-z]%'),
Telefon VARCHAR(12) UNIQUE NOT NULL CHECK (LEN(Telefon)>=6 AND Telefon LIKE '+[0-9][0-9][0-9][0-9][0-9]%'),
);

CREATE TABLE Prawo_jazdy(
Nr VARCHAR(30) CHECK (LEN(Nr)>=2 AND Nr LIKE '[A-Z][0-9]%'),
Data_wazn DATE CHECK (YEAR(Data_wazn)>1900),
Data_wyd DATE CHECK (YEAR(Data_wyd)>1900),
Pesel CHAR(11) NOT NULL REFERENCES Osoba(Pesel) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY (Nr,Data_wazn)
);

CREATE TABLE Samochod(
Nr_rej VARCHAR(10) CHECK(Nr_rej LIKE '[A-Z][A-Z][A-Z0-9]%') PRIMARY KEY,
Rok_prod INT CHECK(Rok_prod > 1900),
Marka VARCHAR(30) NOT NULL CHECK (LEN(Marka)>=2),
Model VARCHAR(30) CHECK (LEN(Model)>=2) DEFAULT('Nieznany')
);

CREATE TABLE Posiadanie(
Nr_rej VARCHAR(10) REFERENCES Samochod(Nr_rej) ON DELETE CASCADE ON UPDATE CASCADE,
Pesel CHAR(11) REFERENCES Osoba(Pesel) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY(Nr_rej,Pesel)
);

CREATE TABLE Polisa(
ID INT IDENTITY(1,1) PRIMARY KEY,
Rodzaj VARCHAR(20) CHECK (Rodzaj IN ('OC','AC','OC+AC','OC+AC+ASSISTANCE','OC+ASSISTANCE')), -- = 'OC' OR Rodzaj = 'AC' OR Rodzaj = 'OC+AC' OR Rodzaj = 'OC+AC+ASSISTANCE'),
Data_rozp DATE CHECK (YEAR(Data_rozp)>1900) NOT NULL,
Data_ko�ca DATE CHECK (YEAR(Data_ko�ca)>1900) NOT NULL,
Koszt DECIMAL(10,2) CHECK(Koszt > 0) NOT NULL,
Nr_rej VARCHAR(10) NOT NULL REFERENCES Samochod(Nr_rej) ON DELETE CASCADE ON UPDATE CASCADE,
);

CREATE TABLE Ubezpieczenie(
ID_polisy INT NOT NULL REFERENCES Polisa(ID) ON DELETE CASCADE,
Pesel CHAR(11) NOT NULL REFERENCES Osoba(Pesel) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY(ID_polisy)
);


CREATE TABLE Oplaty(
ID INT NOT NULL REFERENCES Polisa(ID) ON DELETE CASCADE,
Data_oplaty DATE NOT NULL CHECK (YEAR(Data_oplaty)>1900),
Kwota DECIMAL(10,2) CHECK(Kwota > 0) NOT NULL,
PRIMARY KEY (ID,Data_oplaty)
);

CREATE TABLE Zdarzenie(
ID INT IDENTITY(1,1) PRIMARY KEY,
Rodzaj VARCHAR(30) NOT NULL CHECK(LEN(Rodzaj)>=3),
Opis VARCHAR(50) DEFAULT('Zdarzenie'),
Data_zdarzenia DATE NOT NULL CHECK (YEAR(Data_zdarzenia)>1900),
);
/*
CREATE TABLE Uczestnictwo_w_zdarzeniu_Os(
Pesel CHAR(11) NOT NULL REFERENCES Osoba(Pesel) ON DELETE CASCADE ON UPDATE CASCADE,
ID INT NOT NULL REFERENCES Zdarzenie(ID) ON DELETE CASCADE,
Czy_Spowodowal BIT NOT NULL,
PRIMARY KEY(Pesel,ID)
);

CREATE TABLE Uczestnictwo_w_zdarzeniu_Aut(
Nr_rej VARCHAR(10) NOT NULL REFERENCES Samochod(Nr_rej) ON DELETE CASCADE ON UPDATE CASCADE,
ID INT NOT NULL REFERENCES Zdarzenie(ID) ON DELETE CASCADE,
Pesel CHAR(11) REFERENCES Osoba(Pesel) ON DELETE CASCADE ON UPDATE CASCADE, -- DEFAULT(NULL), -- REFERENCES Uczestnictwo_w_zdarzeniu_Os(Pesel),
-- FOREIGN KEY (Pesel,ID) REFERENCES Uczestnictwo_w_zdarzeniu_Os(Pesel,ID) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY(Nr_rej,ID)
);*/

CREATE TABLE Uczestnictwo_w_zdarzeniu(
ID INT IDENTITY(1,1) PRIMARY KEY,
ID_Zdarzenia INT NOT NULL REFERENCES Zdarzenie(ID) ON DELETE CASCADE,
Pesel CHAR(11) REFERENCES Osoba(Pesel) ON DELETE CASCADE ON UPDATE CASCADE,
Nr_rej VARCHAR(10)REFERENCES Samochod(Nr_rej) ON DELETE CASCADE ON UPDATE CASCADE,
Czy_Spowodowal BIT,
);



CREATE TABLE Wykroczenie(
ID INT IDENTITY(1,1) PRIMARY KEY,
Rodzaj VARCHAR (40) NOT NULL,
ID_uczestnictwa INT NOT NULL,
FOREIGN KEY(ID_uczestnictwa) REFERENCES Uczestnictwo_w_zdarzeniu(ID) ON DELETE CASCADE
);

CREATE TABLE Odszkodowanie(
ID INT IDENTITY(1,1) PRIMARY KEY,
Kwota DECIMAL(10,2) CHECK(Kwota > 0) NOT NULL,
Data_odszkodowania DATE NOT NULL CHECK (YEAR(Data_odszkodowania)>1900),
Pesel CHAR(11) NOT NULL FOREIGN KEY REFERENCES Osoba(Pesel) ON DELETE CASCADE ON UPDATE CASCADE,
ID_zdarzenia INT NOT NULL REFERENCES Zdarzenie(ID) ON DELETE CASCADE,
ID_polisy INT NOT NULL REFERENCES Polisa(ID) ON DELETE CASCADE
);