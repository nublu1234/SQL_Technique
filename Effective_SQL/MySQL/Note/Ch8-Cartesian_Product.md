##  Cartesian Product

#### Subquery in CASE WHEN
```sql
SELECT C.CustomerID, C.CustFirstName, C.CustLastName,
  P.ProductNumber, P.ProductName,
  (CASE WHEN C.CustomerID IN
    (SELECT Orders.CustomerID
     FROM Orders INNER JOIN Order_Details
       ON Orders.OrderNumber = Order_Details.OrderNumber
     WHERE Order_Details.ProductNumber = P.ProductNumber)
     THEN 'You purchased this!'
     ELSE ' ' 
  END) AS ProductOrdered
FROM Customers AS C, Products AS P
ORDER BY C.CustomerID, P.ProductName
LIMIT 5
```
| CustomerID | CustFirstName | CustLastName | ProductNumber | ProductName | ProductOrdered | 
| ---: | --- | --- | ---: | --- | --- | 
| 1001 | Suzanne | Viescas | 37 | AeroFlo ATB Wheels | You purchased this! | 
| 1001 | Suzanne | Viescas | 36 | Cosmic Elite Road Warrior Wheels | You purchased this! | 
| 1001 | Suzanne | Viescas | 38 | Cycle-Doc Pro Repair Stand | You purchased this! | 
| 1001 | Suzanne | Viescas | 21 | Dog Ear Aero-Flow Floor Pump | You purchased this! | 
| 1001 | Suzanne | Viescas | 3 | Dog Ear Cyclecomputer |   | 
---

#### Quintile using CROSS JOIN & RANK
```sql
WITH ProdSale AS (
/* Sales of Accessories */
    SELECT OD.ProductNumber
	       ,SUM(OD.QuantityOrdered * OD.QuotedPrice) AS ProductSales
    FROM Order_Details AS OD
    WHERE OD.ProductNumber IN (SELECT P.ProductNumber
	                            FROM Products AS P 
										 INNER JOIN Categories AS C
                                       ON P.CategoryID = C.CategoryID
                               WHERE C.CategoryDescription = 'Accessories')
    GROUP BY OD.ProductNumber
)
-- SELECT * FROM ProdSale;


, RankedCategories AS (
/* Sales and Rank of Accessories */
    SELECT Categories.CategoryDescription, Products.ProductName, 
           ProdSale.ProductSales, 
           /*
           (SELECT Count(ProductNumber)
            FROM ProdSale AS P2 
            WHERE P2.ProductSales > ProdSale.ProductSales) + 1 AS RankInCategory, 
            */
          RANK() OVER (
            ORDER BY ProdSale.ProductSales DESC
          ) AS RankInCategory
    FROM Categories INNER JOIN Products 
       ON Categories.CategoryID = Products.CategoryID
    INNER JOIN ProdSale
     ON ProdSale.ProductNumber = Products.ProductNumber
    ORDER BY ProductSales DESC
)	 
-- SELECT * FROM RankedCategories;
	 
, ProdCount AS (
/* The Number of Accessories products */
    SELECT COUNT(ProductNumber) AS NumProducts 
    FROM ProdSale
)
-- SELECT * FROM ProdCount;


SELECT P1.CategoryDescription, P1.ProductName, 
    P1.ProductSales, P1.RankInCategory, 
    (CASE WHEN RankInCategory <= ROUND(0.2 * NumProducts, 0)
            THEN 'First' 
          WHEN RankInCategory <= ROUND(0.4 * NumProducts,0)
            THEN 'Second' 
          WHEN RankInCategory <= ROUND(0.6 * NumProducts,0)
            THEN 'Third' 
          WHEN RankInCategory <= ROUND(0.8 * NumProducts,0)
            THEN 'Fourth' 
          ELSE 'Fifth' END) AS Quintile
FROM RankedCategories AS P1 
CROSS JOIN ProdCount
ORDER BY P1.ProductSales DESC
```
| CategoryDescription | ProductName | ProductSales | RankInCategory | Quintile | 
| --- | --- | ---: | ---: | --- | 
| Accessories | Cycle-Doc Pro Repair Stand | 62157.04 | 1 | First | 
| Accessories | King Cobra Helmet | 57572.41 | 2 | First | 
| Accessories | Glide-O-Matic Cycling Helmet | 56286.25 | 3 | First | 
| Accessories | Dog Ear Aero-Flow Floor Pump | 36029.40 | 4 | First | 
| Accessories | Viscount CardioSport Sport Watch | 27954.43 | 5 | Second | 
| Accessories | Pro-Sport 'Dillo Shades | 20336.82 | 6 | Second | 
| Accessories | Viscount C-500 Wireless Bike Computer | 18046.70 | 7 | Second | 
| Accessories | Viscount Tru-Beat Heart Transmitter | 17720.41 | 8 | Second | 
| Accessories | HP Deluxe Panniers | 15984.54 | 9 | Third | 
| Accessories | ProFormance Knee Pads | 14792.96 | 10 | Third | 
| Accessories | Ultra-Pro Knee Pads | 14581.35 | 11 | Third | 
| Accessories | Nikoma Lok-Tight U-Lock | 12488.85 | 12 | Fourth | 
| Accessories | TransPort Bicycle Rack | 9442.44 | 13 | Fourth | 
| Accessories | True Grip Competition Gloves | 7465.70 | 14 | Fourth | 
| Accessories | Kryptonite Advanced 2000 U-Lock | 5999.50 | 15 | Fourth | 
| Accessories | Viscount Microshell Helmet | 4219.20 | 16 | Fifth | 
| Accessories | Dog Ear Monster Grip Gloves | 2779.50 | 17 | Fifth | 
| Accessories | Dog Ear Cyclecomputer | 2238.75 | 18 | Fifth | 
| Accessories | Dog Ear Helmet Mount Mirrors | 767.73 | 19 | Fifth | 
---

#### Team to Team Matching
```sql
SELECT Teams1.TeamID AS Team1ID, Teams1.TeamName AS Team1Name, Teams2.TeamID AS Team2ID, Teams2.TeamName AS Team2Name
FROM Teams AS Teams1 CROSS JOIN Teams AS Teams2
WHERE Teams2.TeamID > Teams1.TeamID
ORDER BY Teams1.TeamID, Teams2.TeamID
LIMIT 5
```
| Team1ID | Team1Name | Team2ID | Team2Name | 
| ---: | --- | ---: | --- | 
| 1 | Marlins | 2 | Sharks | 
| 1 | Marlins | 3 | Terrapins | 
| 1 | Marlins | 4 | Barracudas | 
| 1 | Marlins | 5 | Dolphins | 
| 1 | Marlins | 6 | Orcas | 
```sql
SELECT Teams1.TeamID AS Team1ID, Teams1.TeamName AS Team1Name, Teams2.TeamID AS Team2ID, Teams2.TeamName AS Team2Name
FROM Teams AS Teams1 INNER JOIN Teams AS Teams2
   ON Teams2.TeamID > Teams1.TeamID
ORDER BY Teams1.TeamID, Teams2.TeamID
LIMIT 5
```
| Team1ID | Team1Name | Team2ID | Team2Name | 
| ---: | --- | ---: | --- | 
| 1 | Marlins | 2 | Sharks | 
| 1 | Marlins | 3 | Terrapins | 
| 1 | Marlins | 4 | Barracudas | 
| 1 | Marlins | 5 | Dolphins | 
| 1 | Marlins | 6 | Orcas | 
---

#### One-to-one matching (Full)
```sql
WITH TeamPairs AS (
/* Team to Team Matching */
    SELECT 
        ROW_NUMBER() OVER (ORDER BY Teams1.TeamID, Teams2.TeamID) AS GameSeq,
        Teams1.TeamID AS Team1ID, Teams1.TeamName AS Team1Name, 
        Teams2.TeamID AS Team2ID, Teams2.TeamName AS Team2Name
    FROM Teams AS Teams1 
	 CROSS JOIN Teams AS Teams2
    WHERE Teams2.TeamID > Teams1.TeamID)
-- SELECT * FROM TeamPairs;    

SELECT TeamPairs.GameSeq,
           ROW_NUMBER() OVER (PARTITION BY TeamPairs.Team1ID ORDER BY GameSeq) AS Cond1,
           MOD(ROW_NUMBER() OVER (PARTITION BY TeamPairs.Team1ID ORDER BY GameSeq),2 ) AS Cond1_1, 
           RANK() OVER (ORDER BY TeamPairs.Team1ID) AS Cond2,
			  MOD(RANK() OVER (ORDER BY TeamPairs.Team1ID), 3) AS Cond2_1,
			  RANK() OVER (ORDER BY TeamPairs.Team1ID) AS Cond3,
			  MOD(RANK() OVER (ORDER BY TeamPairs.Team1ID), 3) AS Cond3_1,
			  CASE MOD(ROW_NUMBER() OVER (PARTITION BY TeamPairs.Team1ID ORDER BY GameSeq),2 ) 
			  WHEN 0 THEN 
                      CASE MOD(RANK() OVER (ORDER BY TeamPairs.Team1ID), 3) 
                      WHEN 0 THEN 'Home' ELSE 'Away' END
           ELSE 
                CASE MOD(RANK() OVER (ORDER BY TeamPairs.Team1ID), 3) 
                WHEN 0 THEN 'Away' ELSE 'Home' END
           END AS Team1PlayingAt,
    TeamPairs.Team1ID, TeamPairs.Team1Name, 
    TeamPairs.Team2ID, TeamPairs.Team2Name
FROM TeamPairs
ORDER BY TeamPairs.GameSeq
```
| GameSeq | Cond1 | Cond1_1 | Cond2 | Cond2_1 | Cond3 | Cond3_1 | Team1PlayingAt | Team1ID | Team1Name | Team2ID | Team2Name | 
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- | ---: | --- | ---: | --- | 
| 1 | 1 | 1 | 1 | 1 | 1 | 1 | Home | 1 | Marlins | 2 | Sharks | 
| 2 | 2 | 0 | 1 | 1 | 1 | 1 | Away | 1 | Marlins | 3 | Terrapins | 
| 3 | 3 | 1 | 1 | 1 | 1 | 1 | Home | 1 | Marlins | 4 | Barracudas | 
| 4 | 4 | 0 | 1 | 1 | 1 | 1 | Away | 1 | Marlins | 5 | Dolphins | 
| 5 | 5 | 1 | 1 | 1 | 1 | 1 | Home | 1 | Marlins | 6 | Orcas | 
| 6 | 6 | 0 | 1 | 1 | 1 | 1 | Away | 1 | Marlins | 7 | Manatees | 
| 7 | 7 | 1 | 1 | 1 | 1 | 1 | Home | 1 | Marlins | 8 | Swordfish | 
| 8 | 8 | 0 | 1 | 1 | 1 | 1 | Away | 1 | Marlins | 9 | Huckleberrys | 
| 9 | 9 | 1 | 1 | 1 | 1 | 1 | Home | 1 | Marlins | 10 | MintJuleps | 
| 10 | 1 | 1 | 10 | 1 | 10 | 1 | Home | 2 | Sharks | 3 | Terrapins | 
| 11 | 2 | 0 | 10 | 1 | 10 | 1 | Away | 2 | Sharks | 4 | Barracudas | 
| 12 | 3 | 1 | 10 | 1 | 10 | 1 | Home | 2 | Sharks | 5 | Dolphins | 
| 13 | 4 | 0 | 10 | 1 | 10 | 1 | Away | 2 | Sharks | 6 | Orcas | 
| 14 | 5 | 1 | 10 | 1 | 10 | 1 | Home | 2 | Sharks | 7 | Manatees | 
| 15 | 6 | 0 | 10 | 1 | 10 | 1 | Away | 2 | Sharks | 8 | Swordfish | 
| 16 | 7 | 1 | 10 | 1 | 10 | 1 | Home | 2 | Sharks | 9 | Huckleberrys | 
| 17 | 8 | 0 | 10 | 1 | 10 | 1 | Away | 2 | Sharks | 10 | MintJuleps | 
| 18 | 1 | 1 | 18 | 0 | 18 | 0 | Away | 3 | Terrapins | 4 | Barracudas | 
| 19 | 2 | 0 | 18 | 0 | 18 | 0 | Home | 3 | Terrapins | 5 | Dolphins | 
| 20 | 3 | 1 | 18 | 0 | 18 | 0 | Away | 3 | Terrapins | 6 | Orcas | 
| 21 | 4 | 0 | 18 | 0 | 18 | 0 | Home | 3 | Terrapins | 7 | Manatees | 
| 22 | 5 | 1 | 18 | 0 | 18 | 0 | Away | 3 | Terrapins | 8 | Swordfish | 
| 23 | 6 | 0 | 18 | 0 | 18 | 0 | Home | 3 | Terrapins | 9 | Huckleberrys | 
| 24 | 7 | 1 | 18 | 0 | 18 | 0 | Away | 3 | Terrapins | 10 | MintJuleps | 
| 25 | 1 | 1 | 25 | 1 | 25 | 1 | Home | 4 | Barracudas | 5 | Dolphins | 
| 26 | 2 | 0 | 25 | 1 | 25 | 1 | Away | 4 | Barracudas | 6 | Orcas | 
| 27 | 3 | 1 | 25 | 1 | 25 | 1 | Home | 4 | Barracudas | 7 | Manatees | 
| 28 | 4 | 0 | 25 | 1 | 25 | 1 | Away | 4 | Barracudas | 8 | Swordfish | 
| 29 | 5 | 1 | 25 | 1 | 25 | 1 | Home | 4 | Barracudas | 9 | Huckleberrys | 
| 30 | 6 | 0 | 25 | 1 | 25 | 1 | Away | 4 | Barracudas | 10 | MintJuleps | 
| 31 | 1 | 1 | 31 | 1 | 31 | 1 | Home | 5 | Dolphins | 6 | Orcas | 
| 32 | 2 | 0 | 31 | 1 | 31 | 1 | Away | 5 | Dolphins | 7 | Manatees | 
| 33 | 3 | 1 | 31 | 1 | 31 | 1 | Home | 5 | Dolphins | 8 | Swordfish | 
| 34 | 4 | 0 | 31 | 1 | 31 | 1 | Away | 5 | Dolphins | 9 | Huckleberrys | 
| 35 | 5 | 1 | 31 | 1 | 31 | 1 | Home | 5 | Dolphins | 10 | MintJuleps | 
| 36 | 1 | 1 | 36 | 0 | 36 | 0 | Away | 6 | Orcas | 7 | Manatees | 
| 37 | 2 | 0 | 36 | 0 | 36 | 0 | Home | 6 | Orcas | 8 | Swordfish | 
| 38 | 3 | 1 | 36 | 0 | 36 | 0 | Away | 6 | Orcas | 9 | Huckleberrys | 
| 39 | 4 | 0 | 36 | 0 | 36 | 0 | Home | 6 | Orcas | 10 | MintJuleps | 
| 40 | 1 | 1 | 40 | 1 | 40 | 1 | Home | 7 | Manatees | 8 | Swordfish | 
| 41 | 2 | 0 | 40 | 1 | 40 | 1 | Away | 7 | Manatees | 9 | Huckleberrys | 
| 42 | 3 | 1 | 40 | 1 | 40 | 1 | Home | 7 | Manatees | 10 | MintJuleps | 
| 43 | 1 | 1 | 43 | 1 | 43 | 1 | Home | 8 | Swordfish | 9 | Huckleberrys | 
| 44 | 2 | 0 | 43 | 1 | 43 | 1 | Away | 8 | Swordfish | 10 | MintJuleps | 
| 45 | 1 | 1 | 45 | 0 | 45 | 0 | Away | 9 | Huckleberrys | 10 | MintJuleps | 
---

#### Team to Team Matching (3 Teams)
```sql
SELECT Prod1.ProductNumber AS P1Num, Prod1.ProductName AS P1Name,
    Prod2.ProductNumber AS P2Num, Prod2.ProductName AS P2Name,
    Prod3.ProductNumber AS P3Num, Prod3.ProductName AS P3Name
FROM Products AS Prod1 CROSS JOIN Products AS Prod2 
   CROSS JOIN Products AS Prod3
WHERE Prod1.ProductNumber < Prod2.ProductNumber AND
    Prod2.ProductNumber < Prod3.ProductNumber
LIMIT 5
```
| P1Num | P1Name | P2Num | P2Name | P3Num | P3Name | 
| ---: | --- | ---: | --- | ---: | --- | 
| 1 | Trek 9000 Mountain Bike | 2 | Eagle FS-3 Mountain Bike | 3 | Dog Ear Cyclecomputer | 
| 1 | Trek 9000 Mountain Bike | 2 | Eagle FS-3 Mountain Bike | 4 | Victoria Pro All Weather Tires | 
| 1 | Trek 9000 Mountain Bike | 2 | Eagle FS-3 Mountain Bike | 5 | Dog Ear Helmet Mount Mirrors | 
| 1 | Trek 9000 Mountain Bike | 2 | Eagle FS-3 Mountain Bike | 6 | Viscount Skateboard | 
| 1 | Trek 9000 Mountain Bike | 2 | Eagle FS-3 Mountain Bike | 7 | Viscount C-500 Wireless Bike Computer | 
---

#### Find a Stages that includes all of The Customers' Preferred Genres.
```sql
WITH CustStyles AS (
/* Preferred Music Genre by Customer */
SELECT C.CustomerID, C.CustFirstName, 
      C.CustLastName, MS.StyleName
FROM Customers AS C INNER JOIN Musical_Preferences AS MP
  ON C.CustomerID = MP.CustomerID
INNER JOIN Musical_Styles AS MS
  ON MP.StyleID = MS.StyleID
)  
-- SELECT * FROM CustStyles;

, EntStyles AS (
/* Performer's Genre by Stage */
SELECT E.EntertainerID, E.EntStageName, MS.StyleName
FROM Entertainers AS E INNER JOIN Entertainer_Styles AS ES
  ON E.EntertainerID = ES.EntertainerID
INNER JOIN Musical_Styles AS MS
  ON ES.StyleID = MS.StyleID
)  
-- SELECT * FROM EntStyles;
  
/*
-- INNER JOIN where the Customer's Favorite Genre and the Stage's Genre are the same
SELECT CustStyles.CustomerID, CustStyles.CustFirstName, 
    CustStyles.CustLastName, EntStyles.EntStageName, EntStyles.StyleName
FROM CustStyles INNER JOIN EntStyles
  ON CustStyles.StyleName = EntStyles.StyleName;
*/  

SELECT CustStyles.CustomerID, CustStyles.CustFirstName, 
    CustStyles.CustLastName, EntStyles.EntStageName
FROM CustStyles INNER JOIN EntStyles
  ON CustStyles.StyleName = EntStyles.StyleName
GROUP BY CustStyles.CustomerID, CustStyles.CustFirstName,
     CustStyles.CustLastName, EntStyles.EntStageName
HAVING COUNT(EntStyles.StyleName) =
  (SELECT COUNT(StyleName) 
   FROM CustStyles AS CS1
   WHERE CS1.CustomerID = CustStyles.CustomerID) 
/* The Stages that includes all of The Customers' Preferred Genres. */
ORDER BY CustStyles.CustomerID
```
| CustomerID | CustFirstName | CustLastName | EntStageName | 
| ---: | --- | --- | --- | 
| 10002 | Deb | Smith | JV & the Deep Six | 
| 10003 | Ben | Clothier | Topazz | 
| 10005 | Elizabeth | Hallmark | Julia Schnebly | 
| 10005 | Elizabeth | Hallmark | Katherine Ehrlich | 
| 10008 | Darren | Davidson | Carol Peacock Trio | 
| 10010 | Zachary | Johnson | Jazz Persuasion | 
| 10012 | Kerry | Patterson | Carol Peacock Trio | 
| 10013 | Louise | Johnson | Jazz Persuasion | 
---

#### Preferred Music Genre Matching (Advanced Solution)
```sql
WITH CustPreferences AS (
/* Preferred Music Genre by Customer */
SELECT C.CustomerID, C.CustFirstName, C.CustLastName, 
       MAX((CASE WHEN MP.PreferenceSeq = 1  
                 THEN MP.StyleID 
                 ELSE Null END)) AS FirstPreference,
       MAX((CASE WHEN MP.PreferenceSeq = 2  
                 THEN MP.StyleID 
                 ELSE Null END)) AS SecondPreference,
       MAX((CASE WHEN MP.PreferenceSeq = 3  
                 THEN MP.StyleID 
                 ELSE Null END)) AS ThirdPreference
FROM Musical_Preferences AS MP INNER JOIN Customers AS C
  ON MP.CustomerID = C.CustomerID 
GROUP BY C.CustomerID, C.CustFirstName, C.CustLastName
)
-- SELECT * FROM CustPreferences;

, EntStrengths AS (
SELECT E.EntertainerID, E.EntStageName, 
       MAX((CASE WHEN ES.StyleStrength = 1 
                 THEN ES.StyleID 
                 ELSE Null END)) AS FirstStrength, 
       MAX((CASE WHEN ES.StyleStrength = 2 
                 THEN ES.StyleID 
                 ELSE Null END)) AS SecondStrength, 
       MAX((CASE WHEN ES.StyleStrength = 3 
                 THEN ES.StyleID 
                 ELSE Null END)) AS ThirdStrength 
FROM Entertainer_Styles AS ES
INNER JOIN Entertainers AS E
  ON ES.EntertainerID = E.EntertainerID 
GROUP BY E.EntertainerID, E.EntStageName
)
-- SELECT * FROM EntStrengths;

SELECT CustomerID, CustFirstName, CustLastName, 
   EntertainerID, EntStageName
FROM CustPreferences CROSS JOIN EntStrengths
WHERE (FirstPreference = FirstStrength
       AND SecondPreference = SecondStrength)
   OR (SecondPreference =FirstStrength
       AND FirstPreference = SecondStrength)
ORDER BY CustomerID
```
| CustomerID | CustFirstName | CustLastName | EntertainerID | EntStageName | 
| ---: | --- | --- | ---: | --- | 
| 10002 | Deb | Smith | 1003 | JV & the Deep Six | 
| 10003 | Ben | Clothier | 1002 | Topazz | 
| 10005 | Elizabeth | Hallmark | 1009 | Katherine Ehrlich | 
| 10005 | Elizabeth | Hallmark | 1011 | Julia Schnebly | 
| 10009 | Sarah | Thompson | 1007 | Coldwater Cattle Company | 
| 10012 | Kerry | Patterson | 1001 | Carol Peacock Trio | 

