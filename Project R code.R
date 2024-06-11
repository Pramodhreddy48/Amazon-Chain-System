# Load the necessary libraries
library(dplyr)
library(DBI)
library(RMySQL)

# Create a connection to the MySQL database
con <- dbConnect(RMySQL::MySQL(), 
                 user = "student26", 
                 password = "deputy", 
                 dbname = "DBstudent26", 
                 host = "dbcourse2023.cykbzjtad3ic.us-east-1.rds.amazonaws.com")

POD = tbl(con, "Prj_Orderdetails")
PP = tbl(con, "Prj_Products")
PC= tbl(con, "Prj_Categories")

# Perform the inner joins and aggregation in the database

dbExecute(con, "
  CREATE TABLE Prj_Result AS
  SELECT PC.CategoryID, PC.CategoryName, SUM(POD.Quantity) AS TotalQuantityOrdered
  FROM Prj_Orderdetails POD
  INNER JOIN Prj_Products PP ON POD.ProductID = PP.ProductID
  INNER JOIN Prj_Categories PC ON PP.CategoryID = PC.CategoryID
  GROUP BY PC.CategoryID, PC.CategoryName
")

# Print the result
result <- dbGetQuery(con, "SELECT * FROM Prj_Result")
print(result)

# Close the database connection
dbDisconnect(con)
