CREATE PROCEDURE generate_model_iris (@trained_model varbinary(max) OUTPUT)
AS
BEGIN
    EXECUTE sp_execute_external_script
      @language = N'R'
    , @script = N'
        #Create a simple model and train it using the training data set
        model <- lm(Sepal_Length ~ Petal_Length + Petal_Width, data = train_data);
        #Before saving the model to the DB table, we need to serialize it
        trained_model <- as.raw(serialize(model, connection=NULL));'

    , @input_data_1 = N'select * from dbo.iris'
    , @input_data_1_name = N'train_data'
    , @params = N'@trained_model varbinary(max) OUTPUT'
    , @trained_model = @trained_model OUTPUT;
END;
GO