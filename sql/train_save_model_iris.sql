-- train model and save
DECLARE @model VARBINARY(MAX);
EXEC generate_model_iris @model OUTPUT;
INSERT INTO models (model_name, model) VALUES('iris_test1', @model);
SELECT * FROM models;

-- then predict
EXEC dbo.predict_model_iris @model = 'iris_test1',
@q ='SELECT TOP (10) * FROM iris';