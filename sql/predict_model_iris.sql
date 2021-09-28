CREATE PROCEDURE predict_model_iris (@model VARCHAR(100), @q NVARCHAR(MAX))
AS
BEGIN
DECLARE @my_model VARBINARY(MAX) = (SELECT model FROM models WHERE model_name = @model);
EXECUTE sp_execute_external_script
@language = N'R'
, @script = N'
            #Before using the model to predict, we need to unserialize it
            simple_model = unserialize(my_model);

            #Call prediction function
            simple_predictions = predict(simple_model, simple_data);
			simple_predictions = data.frame(simple_predictions);'
, @input_data_1 = @q
, @input_data_1_name = N'simple_data'
, @output_data_1_name  = N'simple_predictions' -- must match with the output in @script
, @params = N'@my_model varbinary(max)'
, @my_model = @my_model
WITH RESULT SETS (("predictions" FLOAT));

END;
GO