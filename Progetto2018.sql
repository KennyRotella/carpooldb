-- ----------------------------------------------------------------------------
-- MySQL Workbench Migration
-- Migrated Schemata: progetto2018
-- Source Schemata: progetto2018
-- Created: Wed Jul 11 20:33:12 2018
-- Workbench Version: 6.3.10
-- ----------------------------------------------------------------------------

SET sql_mode = '';

-- ----------------------------------------------------------------------------
-- Schema progetto2018
-- ----------------------------------------------------------------------------
DROP SCHEMA IF EXISTS `progetto2018` ;
CREATE SCHEMA IF NOT EXISTS `progetto2018` ;

USE `progetto2018` ;
-- ----------------------------------------------------------------------------
-- Table progetto2018.account
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`account` (
  `NomeUtente` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(45) NOT NULL,
  `Utente` VARCHAR(45) NOT NULL,
  `DataRegistrazione` DATE NOT NULL,
  `Stato` VARCHAR(45) NOT NULL,
  `Ruolo` VARCHAR(45) NOT NULL,
  `DomandaRiserva` VARCHAR(45) NOT NULL,
  `Risposta` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`NomeUtente`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `account` VALUES ('A.Rossi','rossi','cod1','2018-07-03','Attivo','Proponente','Primo Cane','pippo'),('G.Neri','neri','cod3','2018-07-05','Inattivo','Entrambi','Musica','rock'),('M.Verdi','verdi','cod2','2018-07-04','Attivo','Fruitore','Colore','verde');

-- ----------------------------------------------------------------------------
-- Table progetto2018.autovettura
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`autovettura` (
  `NumTarga` VARCHAR(45) NOT NULL,
  `Utente` VARCHAR(45) NOT NULL,
  `CasaProduttrice` VARCHAR(45) NOT NULL,
  `Modello` VARCHAR(45) NOT NULL,
  `Cilindrata` INT(11) NOT NULL,
  `NumPosti` INT(11) NOT NULL,
  `Alimentazione` VARCHAR(45) NOT NULL,
  `AnnoImmatricolazione` INT(11) NOT NULL,
  `Consumo` DOUBLE NOT NULL,
  `Serbatoio` INT(11) NOT NULL,
  `VelocitaMax` INT(11) NOT NULL,
  `CostoOperativo` INT(11) NOT NULL,
  `Optional` VARCHAR(100) NOT NULL,
  `Comfort` INT(11) NOT NULL,
  `Stato` BOOL NULL DEFAULT NULL,
  PRIMARY KEY (`NumTarga`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `autovettura` VALUES ('001','A.Rossi','Fiat','Punto',1900,5,'Benzina',2001,10,20,180,1,'radio, riscaldamento, bagagliaio',3,NULL),('002','A.Rossi','Audi','A4',2000,5,'Diesel',2007,10,20,200,1,'radio, sedili in pelle, bagagliaio',4,NULL);

DROP EVENT IF EXISTS AggiornaStato; -- AGGIORNAMENTO RIDONDANZA

DELIMITER $$
CREATE EVENT AggiornaStato
ON SCHEDULE EVERY 1 HOUR 
DO
BEGIN

UPDATE Autovettura
SET Stato=0;

UPDATE Autovettura
SET Stato=1
WHERE NumTarga IN
	(
	SELECT F.Autovettura
    FROM Fruibilita F
    WHERE F.Inizio <= CURRENT_TIMESTAMP AND
		  (F.Fine IS NULL OR F.Fine >= CURRENT_TIMESTAMP)
	);
END $$

DELIMITER ;
-- ----------------------------------------------------------------------------
-- Table progetto2018.chiamata
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`chiamata` (
  `IdSharing` INT(11) NOT NULL,
  `Fruitore` VARCHAR(45) NOT NULL,
  `StradaPar` INT(11) NOT NULL,
  `KmPar` INT(11) NOT NULL,
  `StradaDest` INT(11) NOT NULL,
  `KmDest` INT(11) NOT NULL,
  `Chiamata` TIMESTAMP,
  `Risposta` TIMESTAMP,
  `FineCorsa` TIMESTAMP,
  `Stato` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`IdSharing`, `Fruitore`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `chiamata` VALUES (1,'M.Verdi',1,0,5,3,'2018-07-10 09:00:00','2018-07-10 09:30:00','2018-07-10 10:30:00','accepted');

-- ----------------------------------------------------------------------------
-- Table progetto2018.coordinate
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`coordinate` (
  `Latitudine` DOUBLE NOT NULL,
  `Longitudine` DOUBLE NOT NULL,
  PRIMARY KEY (`Latitudine`, `Longitudine`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `coordinate` VALUES (43.71,10.4),(43.72,10.4),(43.74,10.4),(43.76,10.4),(43.77,10.4),(43.75,10.37),(43.75,10.38),(43.75,10.39),(43.75,10.4),(43.75,10.41),(43.75,10.42),(43.75,10.43),(43.75,10.44),(43.75,10.45),(43.75,10.46),(43.76,10.46),(43.77,10.46),(43.78,10.46),(43.79,10.46),(43.79,10.47),(43.79,10.48),(43.79,10.49),(43.79,10.5),(43.8,10.5),(43.81,10.5),(43.82,10.5),(43.83,10.5),(43.84,10.52),(43.84,10.51),(43.84,10.5),(43.84,10.49),(43.84,10.48),(43.84,10.47),(43.84,10.46),(43.84,10.45),(43.84,10.44),(43.85,10.44),(43.86,10.44),(43.87,10.44),(43.88,10.44);

-- ----------------------------------------------------------------------------
-- Table progetto2018.documento
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`documento` (
  `NumDocumento` VARCHAR(45) NOT NULL,
  `Utente` VARCHAR(45) NOT NULL,
  `Scadenza` VARCHAR(45) NOT NULL,
  `EnteRilascio` VARCHAR(45) NOT NULL,
  `Tipologia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`NumDocumento`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `documento` VALUES ('001','Cod1','2020','Comune','Carta d\'Identità'),('002','Cod2','2020','Comune','Patente'),('003','Cod3','2019','Prefattura','Passaporto');

-- ----------------------------------------------------------------------------
-- Table progetto2018.fruibilita
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`fruibilita` (
  `Autovettura` VARCHAR(45) NOT NULL,
  `Inizio` DATETIME NOT NULL,
  `Fine` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`Autovettura`, `Inizio`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `fruibilita` VALUES ('001','2018-07-11 10:38:00.000000',NULL);

-- ----------------------------------------------------------------------------
-- Table progetto2018.incrocio
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`incrocio` (
  `IdStrada1` INT NOT NULL,
  `IdStrada2` INT NOT NULL,
  `Km1` INT NOT NULL,
  `Km2` INT NOT NULL,
  PRIMARY KEY (`IdStrada1`, `IdStrada2`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `incrocio` VALUES (1,2,4,3),(2,3,9,0),(3,4,4,0),(4,5,4,0),(5,6,5,2),(6,7,8,0);

-- ----------------------------------------------------------------------------
-- Table progetto2018.indirizzo
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`indirizzo` (
  `Via` VARCHAR(45) NOT NULL,
  `Citta` VARCHAR(45) NOT NULL,
  `NumCivico` VARCHAR(45) NOT NULL,
  `Provincia` VARCHAR(45) NOT NULL,
  `Strada` INT NULL DEFAULT NULL,
  `Km` INT NULL DEFAULT NULL,
  PRIMARY KEY (`Via`, `Citta`, `NumCivico`, `Provincia`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `indirizzo` VALUES ('FIlippo Bonarroti','Pisa','1','Pisa',1,0),('S.Zeno','Pisa','2','Pisa',2,4),('Bonanno Pisano','Pisa','33','Pisa',6,7);

-- ----------------------------------------------------------------------------
-- Table progetto2018.noleggio
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`noleggio` (
  `IdNoleggio` INT NOT NULL,
  `Fruitore` VARCHAR(45) NOT NULL,
  `Autovettura` VARCHAR(45) NOT NULL,
  `DataInizio` DATETIME NOT NULL,
  `DataFine` DATETIME NOT NULL,
  `Stato` VARCHAR(45) NOT NULL DEFAULT 'Attesa',
  PRIMARY KEY (`IdNoleggio`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `noleggio` VALUES (1,'M.Verdi','001','2018-07-26 10:00:00','2018-07-26 11:00:00','Attesa');

DROP TRIGGER IF EXISTS NuovoNoleggio; -- VIG2: Ogni Noleggio può essere registrato se l’autovettura è effettivamente disponibile

DELIMITER $$
CREATE TRIGGER NuovoNoleggio
BEFORE INSERT ON Noleggio
FOR EACH ROW
BEGIN
DECLARE ok INT DEFAULT 0;

SELECT COUNT(*) INTO ok
FROM Fruibilita F
WHERE F.Autovettura=NEW.Autovettura AND
	  NEW.DataInizio >= F.Inizio AND
      (F.Fine IS NULL OR NEW.DataFine <= F.Fine);

IF ok=0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Autovettura non disponibile';
END IF;

END $$
DELIMITER ;
-- ----------------------------------------------------------------------------
-- Table progetto2018.pedaggio
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`pedaggio` (
  `IdStrada` INT NOT NULL,
  `KmInizio` INT NOT NULL,
  `KmFine` INT NOT NULL,
  `Costo` DOUBLE NOT NULL,
  PRIMARY KEY (`IdStrada`, `KmInizio`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `pedaggio` VALUES (1,0,6,0.5);

-- ----------------------------------------------------------------------------
-- Table progetto2018.pool
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`pool` (
  `IdPool` INT NOT NULL,
  `Proponente` VARCHAR(45) NOT NULL,
  `Autovettura` VARCHAR(45) NOT NULL,
  `DataPartenza` DATETIME NOT NULL,
  `DataArrivo` DATETIME NOT NULL,
  `StradaPar` INT NOT NULL,
  `KmPar` INT NOT NULL,
  `StradaArr` INT NOT NULL,
  `KmArr` INT NOT NULL,
  `Flessibilta` VARCHAR(45) NOT NULL,
  `Validita` INT NOT NULL,
  `Tragitto` INT NOT NULL,
  PRIMARY KEY (`IdPool`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `pool` VALUES (1,'A.Rossi', '001', '2018-07-26 10:00:00','2018-07-26 11:00:00',1,0,7,4,'Alta',48,1);

-- ----------------------------------------------------------------------------
-- Table progetto2018.posizione
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`posizione` (
  `IdStrada` INT NOT NULL,
  `KmStrada` INT NOT NULL,
  `Latitudine` DOUBLE NOT NULL,
  `Longitudine` DOUBLE NOT NULL,
  PRIMARY KEY (`IdStrada`, `KmStrada`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `posizione` VALUES (1,0,43.71,10.4),(1,1,43.72,10.4),(1,2,43.73,10.4),(1,3,43.74,10.4),(1,4,43.75,10.4),(1,5,43.76,10.4),(1,6,43.77,10.4),(2,0,43.75,10.37),(2,1,43.75,10.38),(2,2,43.75,10.39),(2,3,43.75,10.4),(2,4,43.75,10.41),(2,5,43.75,10.42),(2,6,43.75,10.43),(2,7,43.75,10.44),(2,8,43.75,10.45),(2,9,43.75,10.46),(3,0,43.75,10.46),(3,1,43.76,10.46),(3,2,43.77,10.46),(3,3,43.78,10.46),(3,4,43.79,10.46),(4,0,43.79,10.46),(4,1,43.79,10.47),(4,2,43.79,10.48),(4,3,43.79,10.49),(4,4,43.79,10.5),(5,0,43.79,10.5),(5,1,43.8,10.5),(5,2,43.81,10.5),(5,3,43.82,10.5),(5,4,43.83,10.5),(5,5,43.84,10.5),(6,0,43.84,10.52),(6,1,43.84,10.51),(6,2,43.84,10.5),(6,3,43.84,10.49),(6,4,43.84,10.48),(6,5,43.84,10.47),(6,6,43.84,10.46),(6,7,43.84,10.45),(6,8,43.84,10.44),(7,0,43.84,10.44),(7,1,43.85,10.44),(7,2,43.86,10.44),(7,3,43.87,10.44),(7,4,43.88,10.44);

-- ----------------------------------------------------------------------------
-- Table progetto2018.prenotazione
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`prenotazione` (
  `IdPrenotazione` INT NOT NULL,
  `Fruitore` VARCHAR(45) NOT NULL,
  `IdPool` INT NOT NULL,
  `Stato` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`IdPrenotazione`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `prenotazione` VALUES (1,'M.Verdi',1,'Accettato');

-- ----------------------------------------------------------------------------
-- Table progetto2018.recensione
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`recensione` (
  `IdRecensione` VARCHAR(45) NOT NULL,
  `Emittente` VARCHAR(45) NOT NULL,
  `Ricevente` VARCHAR(45) NOT NULL,
  `Complessivo` INT NOT NULL,
  `Persona` INT,
  `Comportamento` INT,
  `Serieta` INT,
  `PiacereViaggio` INT,
  `Testo` VARCHAR(45) DEFAULT NULL,
  `Tipo` VARCHAR(45) NOT NULL,
  `Ruolo` VARCHAR(45) NOT NULL,
  `Tragitto` INT DEFAULT NULL,
  PRIMARY KEY (`IdRecensione`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `recensione` VALUES ('1','cod2','cod1',4,3,3,3,3,'Ok','Noleggio','Proponente',NULL),('2','cod1','cod2',1,3,3,3,3,'ha messo il diesel al posto della benzina','Noleggio','Fruitore',1),('3','cod1','cod2',5,3,3,3,3,'molto simpatico','Pool','Fruitore',1),('4','cod2','cod1',3,3,3,3,3,'ha sbagliato strada','Pool','Proponente',1);

-- ----------------------------------------------------------------------------
-- Table progetto2018.sharing
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`sharing` (
  `IdSharing` INT NOT NULL,
  `Proponente` VARCHAR(45) NOT NULL,
  `Autovettura` VARCHAR(45) NOT NULL,
  `DataPartenza` DATETIME NOT NULL,
  `DataArrivo` DATETIME NOT NULL,
  `Tragitto` INT NOT NULL,
  PRIMARY KEY (`IdSharing`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `sharing` VALUES (1,'A.Rossi', '002', '2018-07-10 10:00:00.000000','2018-07-10 11:00:00.000000',1);

-- ----------------------------------------------------------------------------
-- Table progetto2018.sinistro
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`sinistro` (
  `IdNoleggio` INT NOT NULL,
  `NumTarga` VARCHAR(45) NOT NULL,
  `Modello` VARCHAR(45) NOT NULL,
  `CasaAutomobilistica` VARCHAR(45) NOT NULL,
  `Data` DATE NOT NULL,
  `Dinamica` VARCHAR(45) NOT NULL,
  `Latitudine` DOUBLE NOT NULL,
  `Longitudine` DOUBLE NOT NULL,
  PRIMARY KEY (`IdNoleggio`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table progetto2018.stato
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`stato` (
  `Autovettura` VARCHAR(45) NOT NULL,
  `Carburante` INT NOT NULL,
  `KmPercorsi` INT NOT NULL,
  `Disponibilita` BOOL NOT NULL,
  PRIMARY KEY (`Autovettura`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `stato` VALUES ('cod1',15,100000,0);

DROP TRIGGER IF EXISTS Restituzione; -- BUSINESS RULE: Quando viene restituita un’autovettura dopo il noleggio deve avere la stessa quantità di carburante che aveva prima (del noleggio)

DELIMITER $$
CREATE TRIGGER Restituzione
BEFORE UPDATE ON Stato
FOR EACH ROW
BEGIN
IF NEW.Disponibilita<>OLD.Disponibilita AND NEW.Carburante < OLD.Carburante*0.9 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Carburante non sufficiente per effetuare la restituzione';
END IF;
END $$

DELIMITER ;
-- ----------------------------------------------------------------------------
-- Table progetto2018.strada
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`strada` (
  `IdStrada` INT NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Suffisso` VARCHAR(45) NULL DEFAULT NULL,
  `Categoria` VARCHAR(45) NOT NULL,
  `Tipologia` VARCHAR(45) NOT NULL,
  `Corsie` INT NOT NULL,
  `Carreggiate` INT NOT NULL,
  `NumSensi` INT NOT NULL,
  PRIMARY KEY (`IdStrada`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `strada` VALUES (1,'Filippo Buonarroti',NULL,'Urbana','SC',2,1,2),(2,'S.Zeno',NULL,'Urbana','SC',2,1,2),(3,'SS12',NULL,'Urbana','SS',2,1,2),(4,'Contessa Matilde',NULL,'Urbana','SC',2,1,2),(5,'Cammeo Carlo Salomone',NULL,'Urbana','SC',2,1,2),(6,'Bonanno Pisano',NULL,'Urbana','SC',2,1,2),(7,'Giunta Pisano',NULL,'Urbana','SC',1,1,1);

-- ----------------------------------------------------------------------------
-- Table progetto2018.tracking
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`tracking` (
  `Autovettura` VARCHAR(45) NOT NULL,
  `TimeStamp` TIMESTAMP NOT NULL,
  `Latitudine` DOUBLE NOT NULL,
  `Longitudine` DOUBLE NOT NULL,
  PRIMARY KEY (`Autovettura`, `TimeStamp`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `tracking` VALUES ('001','2018-07-11 18:16:00',43.71,10.4),('001','2018-07-11 18:17:00',43.72,10.4),('001','2018-07-11 18:18:00',43.73,10.4),('001','2018-07-11 18:19:00',43.74,10.4);

-- ----------------------------------------------------------------------------
-- Table progetto2018.tragitto
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`tragitto` (
  `IdTragitto` INT NOT NULL,
  `StradaInizio` INT NOT NULL,
  `KmInizio` INT NOT NULL,
  `StradaFine` INT NOT NULL,
  `KmFine` INT NOT NULL,
  PRIMARY KEY (`IdTragitto`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `tragitto` VALUES (1,1,0,7,4);

-- ----------------------------------------------------------------------------
-- Table progetto2018.tratta
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`tratta` (
  `IdTragitto` INT NOT NULL,
  `NumTratta` INT NOT NULL DEFAULT '0',
  `IdStrada` INT NOT NULL,
  `KmInizio` INT NOT NULL,
  PRIMARY KEY (`IdTragitto`, `NumTratta`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `tratta` VALUES (0,1,1,0),(1,1,2,3),(2,1,3,0),(3,1,4,0),(4,1,5,0),(5,1,6,2),(6,1,7,0);

DROP TRIGGER IF EXISTS TratteAdiacenti; -- VIG1: Le tratte adiacenti devono avere un incrocio di riferimento

DELIMITER $$
CREATE TRIGGER TratteAdiacenti
BEFORE INSERT ON Tratta
FOR EACH ROW
BEGIN
DECLARE ok INT DEFAULT 0;
DECLARE Strada1 INT;

SELECT T.IdStrada INTO Strada1
FROM Tratta T
WHERE T.IdTragitto=NEW.IdTragitto AND
	  T.NumTratta=NEW.NumTratta - 1; -- LA TRATTA PRECEDENTE

SELECT COUNT(*) INTO ok
FROM Incrocio I
WHERE ((I.IdStrada1=NEW.IdStrada AND I.Km1=NEW.KmInizio) OR (I.IdStrada2=NEW.IdStrada AND I.Km2=NEW.KmInizio)) AND -- CI DEVE ESSERE UN INCROCIO CHE COINVOLGE LE DUE STRADE
	  ((I.IdStrada1=Strada1) OR (I.IdStrada2=Strada1));

IF ok=0 AND NEW.NumTratta<>0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Non esiste un incrocio con la tratta precedente';
END IF;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS NuovaTratta; -- INSERIMENTO DI NUOVE TRATTE

DELIMITER $$
CREATE PROCEDURE NuovaTratta(IN _IdTragitto INT, IN _IdStrada INT, IN _KmInizio INT)
BEGIN
DECLARE NumTratta INT DEFAULT 0;

SELECT COUNT(*) INTO NumTratta
FROM Tratta T
WHERE T.IdTragitto=_IdTragitto;

INSERT INTO Tratta(NumTratta, IdTragitto, IdStrada, Inizio, Fine)
VALUES (NumTratta, _IdTragitto, _IdStrada, _KmInizio);
END $$

DELIMITER ;
-- ----------------------------------------------------------------------------
-- Table progetto2018.utente
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`utente` (
  `CodFiscale` VARCHAR(100) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `Telefono` INT NOT NULL,
  `Via` VARCHAR(45) NOT NULL,
  `Citta` VARCHAR(45) NOT NULL,
  `NumCivico` VARCHAR(45) NOT NULL,
  `Provincia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CodFiscale`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `utente` VALUES ('cod1','Alessio','Rossi',1234567890,'Filippo Bonarroti','Pisa','1','Pisa'),('cod2','Marco','Verdi',1234567890,'S.Zeno','Pisa','2','Pisa'),('cod3','Giuseppe','Neri',1234567890,'Bonanno Pisano','Pisa','33','Pisa');

-- ----------------------------------------------------------------------------
-- Table progetto2018.variazione
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`variazione` (
  `IdPrenotazione` INT NOT NULL,
  `Tragitto` INT NOT NULL,
  `Entita` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`IdPrenotazione`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table progetto2018.velocità
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progetto2018`.`velocità` (
  `IdStrada` INT(11) NOT NULL,
  `KmInizio` INT(11) NOT NULL,
  `KmFine` INT(11) NOT NULL,
  `Limite` INT(11) NOT NULL,
  PRIMARY KEY (`IdStrada`, `KmInizio`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO `velocità` VALUES (1,0,2,70),(2,0,8,50),(3,1,4,50);

#################################################################################################################################################
## AFFIDABILITA' DI UN UTENTE
#################################################################################################################################################

DROP TABLE IF EXISTS MV_RankingRuolo; 

CREATE TABLE MV_RankingRuolo(
	Utente VARCHAR(45) NOT NULL,
    Ruolo VARCHAR(45) NOT NULL,
    Giudizio INT,
    PRIMARY KEY(Utente, Ruolo)
);

#################################################################################################################################################

DROP PROCEDURE IF EXISTS GiudizioFruitore; -- SERVE PER CALCOLARE IL GIUDIZIO COMPLESSIVO DI UN FRUITORE

DELIMITER $$
CREATE PROCEDURE GiudizioFruitore(IN _Fruitore VARCHAR(45), OUT Giudizio_ INT)
BEGIN

SELECT AVG(R.Complessivo) INTO Giudizio_
FROM Recensione R
WHERE R.Ricevente=_Fruitore AND R.Ruolo='Fruitore';

END $$
DELIMITER ;

#################################################################################################################################################

DROP PROCEDURE IF EXISTS GiudizioOrari; -- SERVE PER CALCOLARE IL GIUDIZIO IN BASE AL RISPETTO DEGLI ORARI 

DELIMITER $$
CREATE PROCEDURE GiudizioOrari(IN _Proponente VARCHAR(45), OUT Giudizio_ INT)
BEGIN
DECLARE totPool INT;
DECLARE okPool INT;
DECLARE totSharing INT;
DECLARE okSharing INT;

SELECT COUNT(*) INTO okPool
FROM Pool P
WHERE P.Proponente=_Proponente AND EXISTS -- UN RECORD IN TRACKING IN CUI SI PASSA PER LA POSIZIONE DI PARTENZA E ARRIVO IN TEMPO
	(
    SELECT *
    FROM Tracking T1 INNER JOIN Posizione PO1 ON T1.Latitudine=PO1.Latitudine AND T1.Longitudine=PO1.Longitudine
    WHERE T1.Autovettura=P.Autovettura AND PO1.IdStrada=P.StradaPar AND PO1.KmStrada=P.KmPar AND
		  (T1.TimeStamp > P.DataPartenza - INTERVAL 0.5 HOUR AND  T1.TimeStamp < P.DataPartenza + INTERVAL 0.5 HOUR)
	) AND EXISTS
    (
    SELECT *
    FROM Tracking T2 INNER JOIN Posizione PO2 ON T2.Latitudine=PO2.Latitudine AND T2.Longitudine=PO2.Longitudine
    WHERE T2.Autovettura=P.Autovettura AND PO2.IdStrada=P.StradaArr AND PO2.KmStrada=P.KmArr AND
		  (T2.TimeStamp > P.DataArrivo - INTERVAL 0.5 HOUR AND  T2.TimeStamp < P.DataArrivo + INTERVAL 0.5 HOUR)
	);
    
SELECT COUNT(*) INTO okSharing
FROM Sharing S INNER JOIN Tragitto T ON S.Tragitto=T.IdTragitto
WHERE S.Proponente=_Proponente AND EXISTS -- UN RECORD IN TRACKING IN CUI SI PASSA PER LA POSIZIONE DI PARTENZA E ARRIVO IN TEMPO
	(
    SELECT *
    FROM Tracking T1 INNER JOIN Posizione PO1 ON T1.Latitudine=PO1.Latitudine AND T1.Longitudine=PO1.Longitudine
    WHERE T1.Autovettura=S.Autovettura AND PO1.IdStrada=T.StradaInizio AND PO1.KmStrada=T.KmInizio AND
		  (T1.TimeStamp > S.DataPartenza - INTERVAL 0.5 HOUR AND  T1.TimeStamp < S.DataPartenza + INTERVAL 0.5 HOUR)
	) AND EXISTS
    (
    SELECT *
    FROM Tracking T2 INNER JOIN Posizione PO2 ON T2.Latitudine=PO2.Latitudine AND T2.Longitudine=PO2.Longitudine
    WHERE T2.Autovettura=S.Autovettura AND PO2.IdStrada=T.StradaFine AND PO2.KmStrada=T.KmFine AND 
		  (T2.TimeStamp > S.DataArrivo - INTERVAL 0.5 HOUR AND  T2.TimeStamp < S.DataArrivo + INTERVAL 0.5 HOUR)
	);
    
SELECT COUNT(*) INTO totPool
FROM Pool P
WHERE P.Proponente=_Proponente;

SELECT COUNT(*) INTO totSharing
FROM Sharing S
WHERE S.Proponente=_Proponente;

SELECT IF((totPool+totSharing)<>0, (okPool+okSharing)*5/(totPool+totSharing), 0) INTO Giudizio_;
END $$
DELIMITER ;

#################################################################################################################################################

DROP PROCEDURE IF EXISTS GiudizioLimiti; -- SERVE PER CALCOLARE IL GIUDIZIO IN BASE AL RISPETTO DEI LIMITI DI VELOCITA'

DELIMITER $$
CREATE PROCEDURE GiudizioLimiti(IN _Proponente VARCHAR(45), OUT Giudizio_ INT)
BEGIN
DECLARE limiteOk INT;
DECLARE limiteTot INT;

SELECT COUNT(B.Velocita <= B.Limite) INTO limiteOk
FROM
	(
	SELECT IF(@TimePrima<>-1 AND @idPrima=D.IdStrada, 
			 IF(@kmPrima<D.KmStrada, 3600*(D.KmStrada-@kmPrima)/(TO_SECONDS(D.TimeStamp)-@timePrima), 3600*(@kmPrima-D.KmStrada)/(TO_SECONDS(D.TimeStamp)-@timePrima)) + LEAST(0, @timePrima:=TO_SECONDS(D.TimeStamp)) + LEAST(0, @idPrima:=D.IdStrada) + LEAST(0, @kmPrima:=D.KmStrada) + LEAST(0, @autoPrima:=D.Autovettura),
			 0 + LEAST(0, @timePrima:=TO_SECONDS(D.TimeStamp)) + LEAST(0, @idPrima:=D.IdStrada) + LEAST(0, @kmPrima:=D.KmStrada) + LEAST(0, @autoPrima:=D.Autovettura)) AS Velocita, D.Limite
	FROM
		(
		SELECT T.Autovettura, T.TimeStamp, P.IdStrada, P.KmStrada, V.Limite
		FROM Tracking T INNER JOIN
			 Autovettura A ON T.Autovettura=A.NumTarga INNER JOIN
			 Account AC ON A.Utente=AC.NomeUtente INNER JOIN 
			 Posizione P ON T.Latitudine=P.Latitudine AND T.Longitudine=P.Longitudine INNER JOIN
			 Velocità V ON P.IdStrada=V.IdStrada AND V.KmInizio<=P.KmStrada AND V.KmFine>=P.KmStrada
		WHERE AC.NomeUtente=_Proponente
		ORDER BY T.Autovettura, T.TimeStamp
		) AS D,
		(SELECT @autoPirma:=-1, @TimePrima:=-1, @idPrima:=-1, @kmPrima:=-1) AS C
	) AS B;
    
SELECT COUNT(*) INTO limiteTot -- STESSA ANALYTIC DI PRIMA, MA SI UTILIZZA PER CONTARE TUTTI I RECORD
FROM
	(
	SELECT IF(@TimePrima<>-1 AND @idPrima=D.IdStrada, 
			 IF(@kmPrima<D.KmStrada, 3600*(D.KmStrada-@kmPrima)/(TO_SECONDS(D.TimeStamp)-@timePrima), 3600*(@kmPrima-D.KmStrada)/(TO_SECONDS(D.TimeStamp)-@timePrima)) + LEAST(0, @timePrima:=TO_SECONDS(D.TimeStamp)) + LEAST(0, @idPrima:=D.IdStrada) + LEAST(0, @kmPrima:=D.KmStrada) + LEAST(0, @autoPrima:=D.Autovettura),
			 0 + LEAST(0, @timePrima:=TO_SECONDS(D.TimeStamp)) + LEAST(0, @idPrima:=D.IdStrada) + LEAST(0, @kmPrima:=D.KmStrada) + LEAST(0, @autoPrima:=D.Autovettura)) AS Velocita, D.Limite
	FROM
		(
		SELECT T.Autovettura, T.TimeStamp, P.IdStrada, P.KmStrada, V.Limite
		FROM Tracking T INNER JOIN
			 Autovettura A ON T.Autovettura=A.NumTarga INNER JOIN
			 Account AC ON A.Utente=AC.NomeUtente INNER JOIN 
			 Posizione P ON T.Latitudine=P.Latitudine AND T.Longitudine=P.Longitudine INNER JOIN
			 Velocità V ON P.IdStrada=V.IdStrada AND V.KmInizio<=P.KmStrada AND V.KmFine>=P.KmStrada
		WHERE AC.NomeUtente=_Proponente
		ORDER BY T.Autovettura, T.TimeStamp
		) AS D,
		(SELECT @autoPirma:=-1, @TimePrima:=-1, @idPrima:=-1, @kmPrima:=-1) AS C
	) AS B;

SELECT IF(limiteTot<>0, 5*limiteOk/limiteTot, 0) INTO Giudizio_;

END $$
DELIMITER ;

#################################################################################################################################################

DROP PROCEDURE IF EXISTS GiudizioProponente; -- SERVE PER CALCOLARE IL GIUDIZIO IN BASE ALLE RECENSIONI DI UN PROPONENTE

DELIMITER $$
CREATE PROCEDURE GiudizioProponente(IN _Proponente VARCHAR(45), OUT Giudizio_ INT)
BEGIN

SELECT AVG(R.Complessivo) INTO Giudizio_
FROM Recensione R
WHERE R.Ricevente=_Proponente AND R.Ruolo='Proponente';

END $$
DELIMITER ;

#################################################################################################################################################
DROP PROCEDURE IF EXISTS BuildRanking;

DELIMITER $$
CREATE PROCEDURE BuildRanking()
BEGIN
DECLARE finito INT DEFAULT 0;
DECLARE NomeU VARCHAR(45);
DECLARE CodF VARCHAR(45);
DECLARE Ruol VARCHAR(45);
DECLARE Giudizio INT;
DECLARE GiudizioOrario INT;
DECLARE GiudizioLimiti INT;
DECLARE GiudizioRecensioni INT;

DECLARE Utente CURSOR FOR
SELECT A.NomeUtente, U.CodFiscale, A.Ruolo
FROM Account A INNER JOIN
	 Utente U ON A.Utente=U.CodFiscale;

DECLARE CONTINUE HANDLER FOR NOT FOUND
SET finito=1;

TRUNCATE MV_RankingRuolo;

OPEN Utente;

scan: LOOP
FETCH Utente INTO NomeU, CodF, Ruol;

IF finito=1 THEN 
	LEAVE scan;
END IF;

IF Ruol='Fruitore' THEN
	CALL GiudizioFruitore(CodF, Giudizio);
    INSERT INTO MV_RankingRuolo
    SELECT CodF, Ruol, Giudizio;
END IF;

IF Ruol='Proponente' THEN
	CALL GiudizioOrari(NomeU, GiudizioOrario);
    CALL GiudizioLimiti(NomeU, GiudizioLimiti);
    CALL GiudizioProponente(CodF, GiudizioRecensioni);
    SET @quanti:=3;
    SELECT (IFNULL(GiudizioOrario, 0 + LEAST(0, @quanti:=@quanti-1))+IFNULL(GiudizioLimiti, 0 + LEAST(0, @quanti:=@quanti-1))+IFNULL(GiudizioRecensioni, 0 + LEAST(0, @quanti:=@quanti-1)))/IF(@quanti=0, NULL, @quanti) INTO Giudizio;
    INSERT INTO MV_RankingRuolo
    SELECT CodF, Ruol, Giudizio;
END IF;

IF Ruol='Entrambi' THEN
	CALL GiudizioFruitore(CodF, Giudizio);
    INSERT INTO MV_RankingRuolo
    SELECT CodF, 'Fruitore', Giudizio;
    
	CALL GiudizioOrari(NomeU, GiudizioOrario);
    CALL GiudizioLimiti(NomeU, GiudizioLimiti);
    CALL GiudizioProponente(CodF, GiudizioRecensioni);
    SET @quanti:=3;
    SELECT (IFNULL(GiudizioOrario, 0 + LEAST(0, @quanti:=@quanti-1))+IFNULL(GiudizioLimiti, 0 + LEAST(0, @quanti:=@quanti-1))+IFNULL(GiudizioRecensioni, 0 + LEAST(0, @quanti:=@quanti-1)))/IF(@quanti=0, NULL, @quanti) INTO Giudizio;
    INSERT INTO MV_RankingRuolo
    SELECT CodF, 'Proponente', Giudizio;
END IF;
ITERATE scan;
END LOOP;
END $$
DELIMITER ;

#################################################################################################################################################
## TEMPI DI PERCORRENZA DELLE STRADE PERCORSE 
#################################################################################################################################################
DROP TABLE IF EXISTS MV_TempiPercorrenza;

CREATE TABLE MV_TempiPercorrenza( 
IdStrada INT NOT NULL,
KmStrada INT NOT NULL,
Tempo INT DEFAULT NULL,
PRIMARY KEY (IdStrada, KmStrada)
);

DROP PROCEDURE IF EXISTS BuildPercorrenza;

DELIMITER $$
CREATE PROCEDURE BuildPercorrenza()
BEGIN

TRUNCATE MV_TempiPercorrenza;

INSERT INTO MV_TempiPercorrenza
SELECT P1.IdStrada, P1.KmStrada, AVG(B.SecondiKm)
FROM
	(
	SELECT D.IdStrada, D.KmStrada, 
			IF(@TimePrima<>-1 AND @idPrima=D.IdStrada AND @autoPrima=D.Autovettura, 
			IF(@kmPrima<D.KmStrada, (TO_SECONDS(D.TimeStamp)-@timePrima)/(D.KmStrada-@kmPrima), (TO_SECONDS(D.TimeStamp)-@timePrima)/(@kmPrima-D.KmStrada)) + LEAST(0, @timePrima:=TO_SECONDS(D.TimeStamp)) + LEAST(0, @idPrima:=D.IdStrada) + LEAST(0, @kmPrima:=D.KmStrada) + LEAST(0, @autoPrima:=D.Autovettura),
			NULL + LEAST(0, @timePrima:=TO_SECONDS(D.TimeStamp)) + LEAST(0, @idPrima:=D.IdStrada) + LEAST(0, @kmPrima:=D.KmStrada) + LEAST(0, @autoPrima:=D.Autovettura)) AS SecondiKm
	FROM
		(
		SELECT T.Autovettura, T.TimeStamp, P.IdStrada, P.KmStrada
		FROM Tracking T INNER JOIN
			 Posizione P ON T.Latitudine=P.Latitudine AND T.Longitudine=P.Longitudine
		ORDER BY T.Autovettura, T.TimeStamp
		) AS D,
		(SELECT @autoPirma:=-1, @TimePrima:=-1, @idPrima:=-1, @kmPrima:=-1) AS C
	) AS B RIGHT OUTER JOIN Posizione P1 ON B.IdStrada=P1.IdStrada AND B.KmStrada=P1.KmStrada
GROUP BY P1.IdStrada, P1.KmStrada;


END $$
DELIMITER ;

#################################################################################################################################################
# RILEVAZIONE DELLE CRITICITA’ 
#################################################################################################################################################
DROP TABLE IF EXISTS MV_Criticita;

CREATE TABLE MV_Criticita( 
IdStrada INT NOT NULL,
KmStrada INT NOT NULL,
Tempo INT DEFAULT NULL,
PRIMARY KEY (IdStrada, KmStrada)
);
DROP EVENT IF EXISTS Criticita;

DELIMITER $$
CREATE EVENT Criticita
ON SCHEDULE EVERY 30 MINUTE DO 
BEGIN

TRUNCATE MV_Criticita;

INSERT INTO MV_Criticita
SELECT TP.IdStrada, TP.KmStrada, (J.Tempo - TP.Tempo) -- SI FA LA DIFFERENZA TRA I DUE TEMPI (PIU E' GRANDE IL VALORE, MAGGIORE SARA LA CRITICITA')
FROM MV_TempiPercorrenza TP LEFT OUTER JOIN 
	(
	SELECT P1.IdStrada, P1.KmStrada, AVG(B.SecondiKm) AS Tempo
	FROM
		(
		SELECT D.IdStrada, D.KmStrada,  -- STESSA ANALYTIC DEI TEMPI DI PERCORRENZA
				IF(@TimePrima<>-1 AND @idPrima=D.IdStrada AND @autoPrima=D.Autovettura, 
				IF(@kmPrima<D.KmStrada, (TO_SECONDS(D.TimeStamp)-@timePrima)/(D.KmStrada-@kmPrima), (TO_SECONDS(D.TimeStamp)-@timePrima)/(@kmPrima-D.KmStrada)) + LEAST(0, @timePrima:=TO_SECONDS(D.TimeStamp)) + LEAST(0, @idPrima:=D.IdStrada) + LEAST(0, @kmPrima:=D.KmStrada) + LEAST(0, @autoPrima:=D.Autovettura),
				NULL + LEAST(0, @timePrima:=TO_SECONDS(D.TimeStamp)) + LEAST(0, @idPrima:=D.IdStrada) + LEAST(0, @kmPrima:=D.KmStrada) + LEAST(0, @autoPrima:=D.Autovettura)) AS SecondiKm
		FROM
			(
			SELECT T.Autovettura, T.TimeStamp, P.IdStrada, P.KmStrada
			FROM Tracking T INNER JOIN
				 Posizione P ON T.Latitudine=P.Latitudine AND T.Longitudine=P.Longitudine
			WHERE T.TimeStamp >= CURRENT_TIMESTAMP - INTERVAL 30 MINUTE
			ORDER BY T.Autovettura, T.TimeStamp
			) AS D,
			(SELECT @autoPirma:=-1, @TimePrima:=-1, @idPrima:=-1, @kmPrima:=-1) AS C
		) AS B RIGHT OUTER JOIN Posizione P1 ON B.IdStrada=P1.IdStrada AND B.KmStrada=P1.KmStrada
	GROUP BY P1.IdStrada, P1.KmStrada
    ) AS J ON TP.IdStrada=J.IdStrada AND TP.KmStrada=J.KmStrada;
    
END $$
DELIMITER ;
#################################################################################################################################################