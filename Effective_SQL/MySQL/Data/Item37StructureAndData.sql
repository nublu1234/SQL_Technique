CREATE DATABASE Item37Example;

USE Item37Example;

CREATE TABLE Transactions (
	TransactionID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	AccountID int NOT NULL,
	Amount decimal(19,4) NOT NULL
);

INSERT INTO Transactions (AccountID, Amount)
VALUES
	(1, 1237.10),
	(1, 298.19),
	(1, 54.39),
	(1, 123.77),
	(1, 49.25),
	(1, 81.38),
	(2, 394.29),
	(2, 683.39),
	(2, 993.10)
;