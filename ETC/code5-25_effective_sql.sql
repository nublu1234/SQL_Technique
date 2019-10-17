
USE RecipesSample;

WITH Recipes_All AS (
SELECT Recipes.RecipeID
      ,Recipes.RecipeTitle
      /*,Recipes.Preparation
      ,Recipes.Notes */
      ,Recipe_Classes.RecipeClassID
      ,Recipe_Classes.RecipeClassDescription
FROM Recipe_Classes 
INNER JOIN Recipes
        ON Recipe_Classes.RecipeClassID = Recipes.RecipeClassID
)
-- SELECT * FROM Recipes_All;

, Ingredients_All AS (
SELECT Ingredients.IngredientID
      ,Ingredients.IngredientName
      ,Ingredients.IngredientClassID
      ,Ingredient_Classes.IngredientClassDescription
      ,Ingredients.MeasureAmountID
FROM Ingredients
INNER JOIN Ingredient_Classes 
        ON Ingredients.IngredientClassID = Ingredient_Classes.IngredientClassID
)
-- SELECT * FROM Ingredients_All;

, Recipe_Ingredients_ALL AS (
SELECT Recipes_All.RecipeID
      ,Recipes_All.RecipeTitle
      /*,.Preparation
      ,.Notes */
      ,Recipes_All.RecipeClassID
      ,Recipes_All.RecipeClassDescription
      ,RI.IngredientID 
      ,RI.IngredientName 
      ,RI.IngredientClassID
      ,RI.IngredientClassDescription
      ,RI.MeasureAmountID
      ,RI.RecipeSeqNo
      ,RI.Amount
FROM Recipes_All
LEFT JOIN (SELECT Ingredients_All.IngredientID 
                 ,Ingredients_All.IngredientName 
					  ,Ingredients_All.IngredientClassID
                 ,Ingredients_All.IngredientClassDescription
                 ,Ingredients_All.MeasureAmountID
                 ,Recipe_Ingredients.RecipeID
                 ,Recipe_Ingredients.RecipeSeqNo
                 ,Recipe_Ingredients.Amount
           FROM Recipe_Ingredients
           LEFT JOIN Ingredients_All
                  ON Recipe_Ingredients.IngredientID = Ingredients_All.IngredientID
			 ) AS RI
       ON Recipes_All.RecipeID = RI.RecipeID
)
-- SELECT * FROM Recipe_Ingredients_ALL;

SELECT RecipeTitle, COUNT(RecipeID) AS IngredCount
FROM Recipe_Ingredients_ALL
WHERE RecipeClassDescription = 'Main course'
  AND IngredientClassDescription = 'Spice'
GROUP BY RecipeTitle
HAVING COUNT(RecipeID) > 3;