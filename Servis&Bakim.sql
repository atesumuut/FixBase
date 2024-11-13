If Not Exists(Select * From sys.databases Where name='ServisBakim')
Create Database ServisBakim

GO
USE ServisBakim

--Brands
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='Brands')
CREATE TABLE Brands (
  brand_id INT Identity,
  brand_name VARCHAR(250) NOT NULL,
  Constraint PK_Brands_brand_id Primary Key(brand_id)
);

INSERT INTO Brands (brand_name) VALUES ('Samsung');
INSERT INTO Brands (brand_name) VALUES ('Apple');
INSERT INTO Brands (brand_name) VALUES ('LG');

GO
DROP PROCEDURE IF EXISTS GetBrandsByID;
GO
CREATE PROCEDURE GetBrandsByID
    @brand_id INT
AS
BEGIN
    SELECT * FROM Brands WHERE brand_id = @brand_id;
END;

EXEC GetBrandsByID @brand_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddBrands;
Go
Create Proc SP_AddBrands
	@brand_name VARCHAR(250)
As
	Insert Into Brands Values (@brand_name)
Go
Exec SP_AddBrands 'SONY'

DROP PROCEDURE IF EXISTS SP_DeleteBrands;
Go
Create Proc SP_DeleteBrands
	@brand_id int
As
	Delete From Brands Where @brand_id = @brand_id
Go
Exec SP_DeleteBrands 1
Go
Alter Proc SP_DeleteBrands
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Brands Where brand_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteBrands 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateBrand;
GO
CREATE PROCEDURE UpdateBrand
  @brand_name VARCHAR(250),
  @new_brand_name VARCHAR(250)
AS
BEGIN
  UPDATE Brands
  SET brand_name = @new_brand_name
  WHERE brand_name = @brand_name;
END;

EXEC UpdateBrand @brand_name = 'Samsung', @new_brand_name = 'NOKIA';

GO
DROP VIEW IF EXISTS BrandsView;
GO
CREATE VIEW BrandsView WITH SCHEMABINDING
AS
SELECT B.brand_name
FROM dbo.Brands B;

GO
SELECT * FROM BrandsView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetBrandsByName')
BEGIN
    EXEC('CREATE FUNCTION dbo.GetBrandsByName(@brandName VARCHAR(250))
    RETURNS TABLE
    AS
    RETURN (
      SELECT * FROM Brands WHERE brand_name = @brandName);
    ');
END

GO
SELECT * FROM dbo.GetBrandsByName('SONY');
--Brands


--Products
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='Products')
CREATE TABLE Products (
  product_id INT Identity,
  product_name VARCHAR(255) NOT NULL,
  brand_id INT,
  Constraint PK_Products_product_id Primary Key(product_id),
  Constraint FK_Products_brand_id FOREIGN KEY(brand_id) REFERENCES Brands(brand_id)
);

INSERT INTO Products (product_name) VALUES ('ELECTRONIC PARTS');
INSERT INTO Products (product_name) VALUES ('CABLES');
INSERT INTO Products (product_name) VALUES ('PANEL');

GO
DROP PROCEDURE IF EXISTS GetProductsByID;
GO
CREATE PROCEDURE GetProductsByID
    @product_id INT
AS
BEGIN
    SELECT * FROM Products WHERE product_id = @product_id;
END;

EXEC GetProductsByID @product_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddProducts;
GO
CREATE PROCEDURE SP_AddProducts
  @product_name VARCHAR(255)
AS
BEGIN
  INSERT INTO Products (product_name)
  VALUES (@product_name);
END
GO
Exec SP_AddProducts 'HARDWARE PARTS'

DROP PROCEDURE IF EXISTS SP_DeleteProducts;
Go
Create Proc SP_DeleteProducts
	@product_id int
As
	Delete From Products Where @product_id = @product_id
Go
Exec SP_DeleteProducts 1
Go
Alter Proc SP_DeleteProducts
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Products Where product_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteProducts 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateProducts;
GO
CREATE PROCEDURE UpdateProducts
  @product_name VARCHAR(250),
  @new_product_name VARCHAR(250)
AS
BEGIN
  UPDATE Products
  SET product_name = @new_product_name
  WHERE product_name = @product_name;
END;

EXEC UpdateProducts @product_name = 'ELECTRONIC PARTS', @new_product_name = 'MOTHERBOARD ';

GO
DROP VIEW IF EXISTS ProductsView;
GO
CREATE VIEW ProductsView WITH SCHEMABINDING
AS
SELECT P.product_name
FROM dbo.Products P;

GO
SELECT * FROM ProductsView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetProductsByName')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetProductsByName(@productName VARCHAR(250))
    RETURNS TABLE
    AS
    RETURN (
      SELECT product_id, product_name
      FROM Products
      WHERE product_name = @productName
    );
    ');
END

GO
SELECT * FROM dbo.GetProductsByName('ELECTRONIC PARTS');
--Products


--Users
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
CREATE TABLE Users (
  user_id INT IDENTITY,
  user_name VARCHAR(255) NOT NULL,
  CONSTRAINT PK_Users_user_id PRIMARY KEY (user_id)
);

INSERT INTO Users (user_name) VALUES ('ZEKÝ');
INSERT INTO Users (user_name) VALUES ('UMUT');
INSERT INTO Users (user_name) VALUES ('OGÜN');
INSERT INTO Users (user_name) VALUES ('BERAT');

GO
DROP PROCEDURE IF EXISTS GetUsersByID;
GO
CREATE PROCEDURE GetUsersByID
    @user_id INT
AS
BEGIN
    SELECT * FROM Users WHERE user_id = @user_id;
END;

EXEC GetUsersByID @user_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddUsers;
Go
Create Proc SP_AddUsers
	@user_name VARCHAR(255)
As
	Insert Into Users Values (@user_name)
Go
Exec SP_AddUsers 'ELÝF'

DROP PROCEDURE IF EXISTS SP_DeleteUsers;
Go
Create Proc SP_DeleteUsers
	@user_id int
As
	Delete From Users Where @user_id = @user_id
Go
Exec SP_DeleteUsers 1
Go
Alter Proc SP_DeleteUsers
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Users Where user_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteUsers 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateUsers;
GO
CREATE PROCEDURE UpdateUsers
  @user_name VARCHAR(250),
  @new_user_name VARCHAR(250)
AS
BEGIN
  UPDATE Users
  SET user_name = @new_user_name
  WHERE user_name = @user_name;
END;

EXEC UpdateUsers @user_name = 'UMUT', @new_user_name = 'CAN';

GO
DROP VIEW IF EXISTS UsersView;
GO
CREATE VIEW UsersView WITH SCHEMABINDING
AS
SELECT U.user_name
FROM dbo.Users U;

GO
SELECT * FROM UsersView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetUserByName')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetUserByName(@userName VARCHAR(255))
    RETURNS TABLE
    AS
    RETURN (
      SELECT *
      FROM Users
      WHERE user_name = @userName
    );
    ');
END

GO
SELECT * FROM dbo.GetUserByName('ZEKÝ');
--Users


--Staff
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Staff')
CREATE TABLE Staff (
    staff_id INT IDENTITY,
    staff_name VARCHAR(255) NOT NULL,
    position VARCHAR(255) NOT NULL,
    user_id INT,
	department_id INT,
    CONSTRAINT PK_Staff_staff_id PRIMARY KEY (staff_id),
	CONSTRAINT FK_Staff_Departments FOREIGN KEY (department_id) REFERENCES Departments (department_id),
    CONSTRAINT FK_Staff_user_id FOREIGN KEY (user_id) REFERENCES Users (user_id)
);

GO
DROP PROCEDURE IF EXISTS GetStaffByID;
GO
CREATE PROCEDURE GetStaffByID
    @staff_id INT
AS
BEGIN
    SELECT * FROM Staff WHERE staff_id = @staff_id;
END;

EXEC GetStaffByID @staff_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddStaff;
Go
Create Proc SP_AddStaff
	@staff_name VARCHAR(255)
As
	Insert Into Staff Values (@staff_name)
Go
Exec SP_AddStaff 'Ferguson'

DROP PROCEDURE IF EXISTS SP_DeleteStaff;
Go
Create Proc SP_DeleteStaff
	@staff_id int
As
	Delete From Staff Where @staff_id = @staff_id
Go
Exec SP_DeleteStaff 1
Go
Alter Proc SP_DeleteStaff
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Staff Where staff_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteStaff 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateStaff;
GO
CREATE PROCEDURE UpdateStaff
  @staff_name VARCHAR(250),
  @new_staff_name VARCHAR(250)
AS
BEGIN
  UPDATE Staff
  SET staff_name = @new_staff_name
  WHERE staff_name = @staff_name;
END;

EXEC UpdateStaff @staff_name = 'Ferguson', @new_staff_name = 'CAN';
--Staff


--Devices
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='Devices')
CREATE TABLE Devices (
  device_id INT Identity,
  device_name VARCHAR(200) NOT NULL,
  device_type VARCHAR(50) NOT NULL,
  user_id INT,
  Constraint PK_Devices_device_id Primary Key(device_id),
  Constraint FK_Devices_user_id FOREIGN KEY(user_id) REFERENCES Users(user_id)
);

INSERT INTO Devices (device_name, device_type)
VALUES ('Umut ateþ telefonu', 'Phone');

GO
DROP PROCEDURE IF EXISTS GetDevicesByID;
GO
CREATE PROCEDURE GetDevicesByID
    @device_id INT
AS
BEGIN
    SELECT * FROM Devices WHERE device_id = @device_id;
END;

EXEC GetDevicesByID @device_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddDevices;
GO
CREATE PROCEDURE SP_AddDevices
  @device_name VARCHAR(250),
  @device_type VARCHAR(250)
AS
BEGIN
  INSERT INTO Devices (device_name, device_type )
  VALUES (@device_name , @device_type);
END
GO
Exec SP_AddDevices 'elif','samsung'

DROP PROCEDURE IF EXISTS SP_DeleteDevices;
Go
Create Proc SP_DeleteDevices
	@device_id int
As
	Delete From Devices Where @device_id = @device_id
Go
Exec SP_DeleteDevices 1
Go
Alter Proc SP_DeleteDevices
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Devices Where device_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteDevices 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateDevices;
GO
CREATE PROCEDURE UpdateDevices
  @device_type VARCHAR(250),
  @new_device_type VARCHAR(250)
AS
BEGIN
  UPDATE Devices
  SET device_type = @new_device_type
  WHERE device_type = @device_type;
END;

EXEC UpdateDevices @device_type = 'Phone', @new_device_type = 'Computer';

GO
DROP VIEW IF EXISTS DevicesView;
GO
CREATE VIEW DevicesView WITH SCHEMABINDING
AS
SELECT D.device_name, D.device_type
FROM dbo.Devices D;

GO
SELECT * FROM DevicesView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetDevice')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetDevice(@deviceName VARCHAR(200))
    RETURNS TABLE
    AS
    RETURN (
      SELECT device_id, device_name, device_type
      FROM Devices 
      WHERE device_name = @deviceName
    );
    ');
END

GO
SELECT * FROM dbo.GetDevice('Umut ateþ telefonu');
--Devices


--RepairStatus
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'RepairStatus')
CREATE TABLE RepairStatus (
  status_id INT IDENTITY,
  status_name VARCHAR(255) NOT NULL,
  CONSTRAINT PK_RepairStatus_status_id PRIMARY KEY (status_id)
);

INSERT INTO RepairStatus (status_name)
VALUES
    ('Parçalar Bekleniyor'),
    ('Parçalar birleþtiririliyor'),
	('Parça temizleniyor'),
	('Son Kontrolleri yapýlýyor'),
    ('Kutulanma yapýlýyor');

GO
DROP PROCEDURE IF EXISTS GetRepairStatuusByID;
GO
CREATE PROCEDURE GetRepairStatuusByID
    @status_id INT
AS
BEGIN
    SELECT * FROM RepairStatus WHERE status_id = @status_id;
END;

EXEC GetRepairStatuusByID @status_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddRepairStatus;
GO
CREATE PROCEDURE SP_AddRepairStatus
  @status_id INT,
  @status_name VARCHAR(255)
AS
BEGIN
  INSERT INTO RepairStatus (status_id, status_name )
  VALUES (@status_id , @status_name);
END
GO
Exec SP_AddRepairStatus 6,'Teslime hazýr'

DROP PROCEDURE IF EXISTS SP_DeleteRepairStatus;
Go
Create Proc SP_DeleteRepairStatus
	@status_id int
As
	Delete From RepairStatus Where @status_id = @status_id
Go
Exec SP_DeleteRepairStatus 1
Go
Alter Proc SP_DeleteRepairStatus
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From RepairStatus Where status_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteRepairStatus 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateRepairStatus;
GO
CREATE PROCEDURE UpdateRepairStatus
  @status_name VARCHAR(250),
  @new_status_name VARCHAR(250)
AS
BEGIN
  UPDATE RepairStatus
  SET status_name = @new_status_name
  WHERE status_name = @status_name;
END;

EXEC UpdateRepairStatus @status_name = 'Parçalar Bekleniyor',  @new_status_name = 'Kargoya verildi';

GO
DROP VIEW IF EXISTS RepairStatusView;
GO
CREATE VIEW RepairStatusView WITH SCHEMABINDING
AS
SELECT Rs.status_id, Rs.status_name
FROM dbo.RepairStatus Rs;

GO
SELECT * FROM RepairStatusView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetRepairStatusByID')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetRepairStatusByID(@statusID INT)
    RETURNS TABLE
    AS
    RETURN (
      SELECT *
      FROM RepairStatus
      WHERE status_id = @statusID
    );
    ');
END

GO
SELECT * FROM dbo.GetRepairStatusByID(1);
--RepairStatus


--RepairRecords
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='RepairRecords')
CREATE TABLE RepairRecords (
  record_id INT Identity,
  device_id INT,
  repair_type VARCHAR(250),
  status_id INT,
  start_date DATE,
  end_date DATE,
  CONSTRAINT PK_RepairRecords_record_id PRIMARY KEY (record_id),
  FOREIGN KEY (device_id) REFERENCES Devices(device_id),
  FOREIGN KEY (status_id) REFERENCES RepairStatus(status_id)
);

INSERT INTO RepairRecords (repair_type, start_date, end_date)
VALUES ('Elektrik arýzasý', '2023-06-01', '2023-06-05'),
       ('Donaným arýzasý',  '2023-06-03', '2023-06-07'),
	   ('Yazýlým güncellemesi', '2023-06-05', '2023-06-10');


--TRIGGER RepairRecords
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_EkleRepairRecords')
    DROP TRIGGER tr_EkleRepairRecords;
GO
CREATE TRIGGER tr_EkleRepairRecords
ON RepairRecords
AFTER INSERT
AS
BEGIN
    DECLARE @repair_type VARCHAR(250);
    DECLARE @start_date DATE;
    DECLARE @end_date DATE;
    SELECT  @repair_type = repair_type, @start_date = start_date, @end_date = end_date FROM inserted;
    EXEC SP_AddRepairRecords @repair_type, @start_date, @end_date;
END;

GO
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_GuncelleRepairRecords')
    DROP TRIGGER tr_GuncelleRepairRecords;
GO
CREATE TRIGGER tr_GuncelleRepairRecords
ON RepairRecords
AFTER UPDATE
AS
BEGIN
    DECLARE @repair_type VARCHAR(250), @new_repair_type VARCHAR(250);
    SELECT @repair_type = repair_type, @new_repair_type = repair_type FROM inserted;
    EXEC UpdateRepairRecords @repair_type, @new_repair_type;
END;

GO
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_SilRepairRecords')
    DROP TRIGGER tr_SilRepairRecords;
GO
CREATE TRIGGER tr_SilRepairRecords
ON RepairRecords
AFTER DELETE
AS
BEGIN
    DECLARE @record_id INT;
    SELECT @record_id = record_id FROM deleted;
    EXEC SP_DeleteRepairRecords @record_id;
END;

SELECT * FROM sys.triggers WHERE name = 'tr_EkleRepairRecords'
SELECT * FROM sys.triggers WHERE name = 'tr_GuncelleRepairRecords'
SELECT * FROM sys.triggers WHERE name = 'tr_SilRepairRecords'
--TRIGGER RepairRecords

DROP PROCEDURE IF EXISTS GetRepairRecordsByID;
GO
CREATE PROCEDURE GetRepairRecordsByID
    @record_id INT
AS
BEGIN
    SELECT record_id, repair_type, start_date, end_date
    FROM RepairRecords
    WHERE record_id = @record_id;
END;

EXEC GetRepairRecordsByID @record_id = 78;

GO
DROP PROCEDURE IF EXISTS SP_AddRepairRecords;
GO
CREATE PROCEDURE SP_AddRepairRecords
  @repair_type VARCHAR(250),
  @start_date DATE,
  @end_date DATE
AS
BEGIN
  INSERT INTO RepairRecords (repair_type, start_date, end_date)
  VALUES (@repair_type, @start_date, @end_date);
END

GO
Exec SP_AddRepairRecords 'Fan Deðiþimi' ,'2023-06-05', '2023-06-09'

DROP PROCEDURE IF EXISTS SP_DeleteRepairRecords;
Go
Create Proc SP_DeleteRepairRecords
	@record_id int
As
	Delete From RepairRecords Where @record_id = @record_id
Go
Exec SP_DeleteRepairRecords 1
Go
Alter Proc SP_DeleteRepairRecords
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From RepairRecords Where record_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteRepairRecords 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateRepairRecords;
GO
CREATE PROCEDURE UpdateRepairRecords
  @repair_type VARCHAR(250),
  @new_repair_type VARCHAR(250)
AS
BEGIN
  UPDATE RepairRecords
  SET repair_type = @new_repair_type
  WHERE repair_type = @repair_type;
END;

EXEC UpdateRepairRecords @repair_type = 'Yazýlým güncellemesi', @new_repair_type = 'Kasa Deðiþimi';

GO
DROP VIEW IF EXISTS RepairRecordsView;
GO
CREATE VIEW RepairRecordsView WITH SCHEMABINDING
AS
SELECT RR.record_id, RR.repair_type, RR.start_date, RR.end_date
FROM dbo.RepairRecords RR;

GO
SELECT * FROM RepairRecordsView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetRepairRecords')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetRepairRecords(@record_id INT)
    RETURNS TABLE
    AS
    RETURN (
      SELECT record_id, repair_type
      FROM RepairRecords
      WHERE record_id = @record_id
    );
    ')
END

GO
SELECT * FROM dbo.GetRepairRecords(90);
--RepairRecords


--SpareParts
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='SpareParts')
CREATE TABLE SpareParts (
  part_id INT Identity,
  inventory_id INT,
  part_name VARCHAR(255) NOT NULL,
  CONSTRAINT PK_SpareParts_part_id PRIMARY KEY (part_id),
  CONSTRAINT FK_SpareParts_PartInventories FOREIGN KEY (inventory_id) REFERENCES PartInventories (inventory_id)
);

INSERT INTO SpareParts (part_name)
VALUES
    ('Akýllý Telefon Ekraný'),
    ('Batarya'),
    ('Þarj Kablosu'),
    ('Laptop Klavyesi'),
    ('Hard Disk'),
    ('RAM Bellek'),
    ('Tablet Pil'),
    ('Dokunmatik Ekran'),
    ('Televizyon Uzaktan Kumandasý'),
    ('Güç Kablosu'),
    ('Güç Adaptörü'),
    ('Þarj Docku');

GO
DROP PROCEDURE IF EXISTS GetSparePartsByID;
GO
CREATE PROCEDURE GetSparePartsByID
    @part_id INT
AS
BEGIN
    SELECT * FROM SpareParts WHERE part_id = @part_id;
END;

EXEC GetSparePartsByID @part_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddSpareParts;
GO
CREATE PROCEDURE SP_AddSpareParts
  @part_name VARCHAR(255) 
AS
BEGIN
  INSERT INTO SpareParts (part_name)
  VALUES (@part_name);
END

GO
Exec SP_AddSpareParts 'Ekran kartý'

DROP PROCEDURE IF EXISTS SP_DeleteSpareParts;
Go
Create Proc SP_DeleteSpareParts
	@part_id int
As
	Delete From SpareParts Where @part_id = @part_id
Go
Exec SP_DeleteSpareParts 1
Go
Alter Proc SP_DeleteSpareParts
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From SpareParts Where part_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteSpareParts 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateSpareParts;
GO
CREATE PROCEDURE UpdateSpareParts
  @part_name VARCHAR(250),
  @new_part_name VARCHAR(250)
AS
BEGIN
  UPDATE SpareParts
  SET part_name = @new_part_name
  WHERE part_name = @part_name;
END;

EXEC UpdateSpareParts @part_name = 'Akýllý Telefon Ekraný', @new_part_name = 'Telefon Kamerasý';

GO
DROP VIEW IF EXISTS SparePartsView;
GO
CREATE VIEW SparePartsView WITH SCHEMABINDING
AS
SELECT Sp.part_id, Sp.part_name
FROM dbo.SpareParts Sp;

GO
SELECT * FROM SparePartsView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetSparePart')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetSparePart(@part_id INT)
    RETURNS TABLE
    AS
    RETURN (
      SELECT part_id, part_name
      FROM SpareParts
      WHERE part_id = @part_id
    );
    ');
END
GO
SELECT * FROM dbo.GetSparePart(4);
--SpareParts


--PartInventories
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='PartInventories')
CREATE TABLE PartInventories (
  inventory_id INT Identity,
  part_id INT,
  quantity INT,
  record_id INT,
  track_name VARCHAR(250),
  CONSTRAINT PK_PartInventories_inventory_id PRIMARY KEY (inventory_id),
  CONSTRAINT FK_PartInventories_record_id FOREIGN KEY (record_id) REFERENCES RepairRecords(record_id)
);

INSERT INTO PartInventories (quantity, track_name)
VALUES
    (55, 'Ekran kartý'),
    (10, 'Güç kablosu'),
    (93, 'Batarya'),
    (80, 'Dokunmatik Ekran'),
    (62, 'Hard Disk');

GO
DROP PROCEDURE IF EXISTS GetPartInventoriesID;
GO
CREATE PROCEDURE PartInventoriesByID
    @inventory_id INT
AS
BEGIN
    SELECT inventory_id, quantity, track_name
	FROM PartInventories 
	WHERE inventory_id = @inventory_id;
END;

EXEC PartInventoriesByID @inventory_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddPartInventories;
GO
CREATE PROCEDURE SP_AddPartInventories
  @quantity INT,
  @track_name VARCHAR(255) 
AS
BEGIN
  INSERT INTO PartInventories (quantity, track_name)
  VALUES (@quantity, @track_name);
END
GO
Exec SP_AddPartInventories 44,'Ýþlemci'

DROP PROCEDURE IF EXISTS SP_DeletePartInventories;
Go
Create Proc SP_DeletePartInventories
	@inventory_id int
As
	Delete From PartInventories Where @inventory_id = @inventory_id
Go
Exec SP_DeletePartInventories 1
Go
Alter Proc SP_DeletePartInventories
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From PartInventories Where inventory_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeletePartInventories 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdatePartInventories;
GO
CREATE PROCEDURE UpdatePartInventories
  @quantity VARCHAR(250),
  @new_quantity VARCHAR(250)
AS
BEGIN
  UPDATE PartInventories
  SET quantity = @new_quantity
  WHERE quantity = @quantity;
END;

EXEC UpdatePartInventories @quantity = '55', @new_quantity = '90';

GO
DROP VIEW IF EXISTS PartInventoriesView;
GO
CREATE VIEW PartInventoriesView WITH SCHEMABINDING
AS
SELECT PIN.inventory_id, PIN.quantity, PIN.track_name
FROM dbo.PartInventories PIN;

GO
SELECT * FROM PartInventoriesView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetPartInventory')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetPartInventory(@inventory_id INT)
    RETURNS TABLE
    AS
    RETURN (
      SELECT inventory_id, quantity, track_name
      FROM PartInventories
      WHERE inventory_id = @inventory_id
    );
    ');
END

GO
SELECT * FROM dbo.GetPartInventory(1);
--PartInventories


--UserRoles
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='UserRoles')
CREATE TABLE UserRoles (
  role_id INT Identity,
  role_name VARCHAR(255) NOT NULL,
  user_id INT
  CONSTRAINT FK_UserRoles_user_id FOREIGN KEY (user_id) REFERENCES Users (user_id)
);

INSERT INTO UserRoles (role_name)
VALUES
    ('Yöneteci'),
    ('Depo çalýþanlarý'),
    ('Tamir elemanlarý')

GO
DROP PROCEDURE IF EXISTS GetUserRolesByID;
GO
CREATE PROCEDURE GetUserRolesByID
    @role_id INT
AS
BEGIN
    SELECT * FROM UserRoles WHERE role_id = @role_id;
END;

EXEC GetUserRolesByID @role_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddUserRoles;
GO
CREATE PROCEDURE SP_AddUserRoles
  @role_name VARCHAR(250)
AS
BEGIN
  INSERT INTO UserRoles (role_name)
  VALUES (@role_name);
END
GO
Exec SP_AddUserRoles 'CEO'

DROP PROCEDURE IF EXISTS SP_DeleteUserRoles;
Go
Create Proc SP_DeleteUserRoles
	@role_id int
As
	Delete From UserRoles Where @role_id = @role_id
Go
Exec SP_DeleteUserRoles 1
Go
Alter Proc SP_DeleteUserRoles
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From UserRoles Where role_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteUserRoles 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateUserRoles;
GO
CREATE PROCEDURE UpdateUserRoles
  @role_name VARCHAR(250),
  @new_role_name VARCHAR(250)
AS
BEGIN
  UPDATE UserRoles
  SET role_name = @new_role_name
  WHERE role_name = @role_name;
END;

EXEC UpdateUserRoles @role_name = 'Yöneteci', @new_role_name = 'Bölge sorumlusu';

GO
DROP VIEW IF EXISTS UserRolesView;
GO
CREATE VIEW UserRolesView WITH SCHEMABINDING
AS
SELECT Us.role_id, Us.role_name
FROM dbo.UserRoles Us;

GO
SELECT * FROM UserRolesView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetUserRole')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetUserRole(@role_id INT)
    RETURNS TABLE
    AS
    RETURN (
      SELECT role_id, role_name
      FROM UserRoles
      WHERE role_id = @role_id
    );
    ');
END

GO
SELECT * FROM dbo.GetUserRole(3);
--UserRoles


--UserRoleAssignments
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='UserRoleAssignments')
CREATE TABLE UserRoleAssignments (
  assignment_id Varchar(250),
  user_id INT,
  role_id INT,
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO UserRoleAssignments (assignment_id)
VALUES ('atama 1');

GO
DROP PROCEDURE IF EXISTS GetUserRoleAssignmentsByID;
GO
CREATE PROCEDURE GetUserRoleAssignmentsByID
    @assignment_id INT
AS
BEGIN
    SELECT * FROM UserRoleAssignments WHERE assignment_id = @assignment_id;
END;

EXEC GetUserRoleAssignmentsByID @assignment_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddUserRoleAssignments;
GO
CREATE PROCEDURE SP_AddUserRoleAssignments
  @assignment_id Varchar(250)
AS
BEGIN
  INSERT INTO UserRoleAssignments (assignment_id)
  VALUES (@assignment_id);
END
GO
Exec SP_AddUserRoleAssignments 2

DROP PROCEDURE IF EXISTS SP_DeleteUserRoleAssignments;
Go
Create Proc SP_DeleteUserRoleAssignments
	@assignment_id int
As
	Delete From UserRoleAssignments Where @assignment_id = @assignment_id
Go
Exec SP_DeleteUserRoleAssignments 1
Go
Alter Proc SP_DeleteUserRoleAssignments
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From UserRoleAssignments Where assignment_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteUserRoleAssignments 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateUserRoleAssignments;
GO
CREATE PROCEDURE UpdateUserRoleAssignments
  @assignment_id VARCHAR(250),
  @new_assignment_id VARCHAR(250)
AS
BEGIN
  UPDATE UserRoleAssignments
  SET assignment_id = @new_assignment_id
  WHERE assignment_id = @assignment_id;
END;

EXEC UpdateUserRoleAssignments @assignment_id = 'Son kontroller için yönlendiriliyor' , @new_assignment_id = 'Ekran kartý sorunlarý araþtýrýlýyor';

GO
DROP VIEW IF EXISTS UserRoleAssignmentsView;
GO
CREATE VIEW UserRoleAssignmentsView WITH SCHEMABINDING
AS
SELECT Ur.assignment_id 
FROM dbo.UserRoleAssignments Ur;

GO
SELECT * FROM UserRoleAssignmentsView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetUserRoleAssignment')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetUserRoleAssignment(@assignment_id VARCHAR(250))
    RETURNS TABLE
    AS
    RETURN (
      SELECT assignment_id
      FROM UserRoleAssignments
      WHERE assignment_id = @assignment_id
    );
    ');
END

GO
SELECT * FROM dbo.GetUserRoleAssignment(1);
--UserRoleAssignments


--Customers
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='Customers')
CREATE TABLE Customers (
  customer_id INT Identity,
  customer_name VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  phone_number VARCHAR(20),
  CONSTRAINT PK_Customers_customer_id PRIMARY KEY (customer_id)
);

INSERT INTO Customers (customer_name, address, phone_number)
VALUES ('John Smith', '123 Main St', '555-1234'),
       ('Jane Doe', '456 Elm St', '555-5678'),
       ('Michael Johnson', '789 Oak St', '555-9012');

--Customers TRIGGER
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_EkleCustomers')
	DROP TRIGGER tr_EkleCustomers;
GO
CREATE TRIGGER tr_EkleCustomers
ON Customers
AFTER INSERT
AS
BEGIN
    DECLARE @customer_name VARCHAR(255), @address VARCHAR(255), @phone_number VARCHAR(20);
    SELECT @customer_name = customer_name, @address = address, @phone_number = phone_number FROM inserted;
    EXEC SP_AddCustomers @customer_name, @address, @phone_number;
END;

GO
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_SilCustomers')
	DROP TRIGGER tr_SilCustomers;
GO
CREATE TRIGGER tr_SilCustomers
ON Customers
AFTER DELETE
AS
BEGIN
    DECLARE @customer_id INT;
    SELECT @customer_id = customer_id FROM deleted;
    EXEC SP_DeleteCustomers @customer_id;
END;

GO
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_GuncelleCustomers')
	DROP TRIGGER tr_GuncelleCustomers;
GO
CREATE TRIGGER tr_GuncelleCustomers
ON Customers
AFTER UPDATE
AS
BEGIN
    DECLARE @customer_name VARCHAR(255), @new_customer_name VARCHAR(255), @address VARCHAR(255), @new_address VARCHAR(255), @phone_number VARCHAR(20), @new_phone_number VARCHAR(20);
    SELECT @customer_name = customer_name, @new_customer_name = customer_name, @address = address, @new_address = address, @phone_number = phone_number, @new_phone_number = phone_number FROM inserted;
    EXEC UpdateCustomers @customer_name, @new_customer_name, @address, @new_address, @phone_number, @new_phone_number;
END;

SELECT * FROM sys.triggers WHERE name = 'tr_EkleCustomers';
SELECT * FROM sys.triggers WHERE name = 'tr_SilCustomers';
SELECT * FROM sys.triggers WHERE name = 'tr_GuncelleCustomers';
--Customers TRIGGER


GO
DROP PROCEDURE IF EXISTS GetCustomersByID;
GO
CREATE PROCEDURE GetCustomersByID
    @customer_id INT
AS
BEGIN
    SELECT * FROM Customers WHERE customer_id = @customer_id;
END;

EXEC GetCustomersByID @customer_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddCustomers;
Go
Create Proc SP_AddCustomers
  @customer_name VARCHAR(255),
  @address VARCHAR(255),
  @phone_number VARCHAR(20)
As
	Insert Into Customers Values (@customer_name, @address, @phone_number)
GO
Exec SP_AddCustomers 'ELÝF', 'EDÝRNE', '555-5555'

DROP PROCEDURE IF EXISTS SP_DeleteCustomers;
Go
Create Proc SP_DeleteCustomers
	@customer_id int
As
	Delete From Customers Where @customer_id = @customer_id
Go
Exec SP_DeleteCustomers 1
Go
Alter Proc SP_DeleteCustomers
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Customers Where customer_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteCustomers 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateCustomers;
GO
CREATE PROCEDURE UpdateCustomers
  @customer_name VARCHAR(255),
  @new_customer_name VARCHAR(255),
  @address VARCHAR(255),
  @new_address VARCHAR(255),
  @phone_number VARCHAR(20),
  @new_phone_number VARCHAR(20)
AS
BEGIN
  UPDATE Customers
  SET customer_name = @new_customer_name,
	  address = @new_address,
	  phone_number = @new_phone_number
  WHERE customer_name = @customer_name;
END;

EXEC UpdateCustomers 
	@customer_name = 'John Smith',
	@new_customer_name = 'UMUTCAN ATEÞ',
	@address = '123 Main St',
	@new_address = 'Bakýrköy',
	@phone_number = '555-1234',
	@new_phone_number = '123-456';

GO
DROP VIEW IF EXISTS CustomersView;
GO
CREATE VIEW CustomersView With Encryption
AS
SELECT C.customer_name, C.address, C.phone_number
FROM Customers C;

GO
Exec sp_helptext 'CustomersView'

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetCustomer')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetCustomer(@customer_id INT)
    RETURNS TABLE
    AS
    RETURN (
      SELECT customer_id, customer_name, address, phone_number
      FROM Customers
      WHERE customer_id = @customer_id
    );
    ');
END

GO
SELECT * FROM dbo.GetCustomer(3);
--Customers


--Sales
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Sales')
CREATE TABLE Sales (
  sale_id INT IDENTITY,
  customer_id INT,
  sales_amount varchar(2000),
  product_id INT,
  staff_id INT,
  sale_date DATE,
  CONSTRAINT PK_Sales_sale_id PRIMARY KEY (sale_id),
  CONSTRAINT FK_Sales_Staff FOREIGN KEY (staff_id) REFERENCES Staff (staff_id),
  FOREIGN KEY (customer_id) REFERENCES Customers (customer_id),
  FOREIGN KEY (product_id) REFERENCES Products (product_id)
);

INSERT INTO Sales (sales_amount,sale_date)
VALUES ('10$','2023-05-01'),
       ('20$','2023-05-02'),
       ('30$','2023-05-03');

GO
DROP PROCEDURE IF EXISTS GetSalesByID;
GO
CREATE PROCEDURE GetSalesByID
    @sale_id INT
AS
BEGIN
    SELECT * FROM Sales WHERE sale_id = @sale_id;
END;

EXEC GetSalesByID @sale_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddSales;
GO
CREATE PROCEDURE SP_AddSales
  @sales_amount varchar,
  @sale_date DATE
AS
BEGIN
  INSERT INTO Sales (sales_amount, sale_date)
  VALUES (@sales_amount , @sale_date);
END
GO
Exec SP_AddSales '40$', '2023-05-04'

DROP PROCEDURE IF EXISTS SP_DeleteSales;
Go
Create Proc SP_DeleteSales
	@sale_id int
As
	Delete From Sales Where @sale_id = @sale_id
Go
Exec SP_DeleteSales 1
Go
Alter Proc SP_DeleteCustomers
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Sales Where sale_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteCustomers 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateSales;
GO
CREATE PROCEDURE UpdateSales
  @sales_amount VARCHAR(250),
  @new_sales_amount VARCHAR(250)
AS
BEGIN
  UPDATE Sales
  SET sales_amount = @new_sales_amount
  WHERE sales_amount = @sales_amount;
END;

EXEC UpdateSales @sales_amount = '10$' , @new_sales_amount = '200$';

GO
DROP VIEW IF EXISTS SalesView;
GO
CREATE VIEW SalesView With Encryption
AS
SELECT S.sales_amount, S.sale_date 
FROM Sales S;

GO
Exec sp_helptext 'SalesView'

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetSalesByAmountAndDate')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetSalesByAmountAndDate(@amount varchar(2000), @date DATE)
    RETURNS TABLE
    AS
    RETURN (
      SELECT sale_id, sale_date, sales_amount
      FROM Sales
      WHERE sales_amount = @amount AND sale_date = @date
    );
    ');
END

GO
SELECT * FROM dbo.GetSalesByAmountAndDate('10$', '2023-05-01');
--Sales


--SalesTasks
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='SalesTasks')
CREATE TABLE SalesTasks (
  sale_task_id INT IDENTITY,
  sale_id INT,
  task_name VARCHAR(255) NOT NULL,
  task_date DATE,
  CONSTRAINT PK_SalesTasks_sale_task_id PRIMARY KEY (sale_task_id),
  CONSTRAINT FK_SalesTasks_Sales FOREIGN KEY (sale_id) REFERENCES Sales (sale_id)
);

INSERT INTO SalesTasks (task_name, task_date)
VALUES ('Müþteri aramasý yapýlacak', '2023-06-01'),
       ('Teklif hazýrlanacak', '2023-06-02'),
       ('Sözleþme imzalanacak', '2023-06-03');

GO
DROP PROCEDURE IF EXISTS GetSalesTasksByID;
GO
CREATE PROCEDURE GetSalesTasksByID
    @sale_task_id INT
AS
BEGIN
    SELECT * FROM SalesTasks WHERE sale_task_id = @sale_task_id;
END;

EXEC GetSalesTasksByID @sale_task_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddSalesTasks;
GO
CREATE PROCEDURE SP_AddSalesTasks
  @task_name Varchar(255),
  @task_date DATE
AS
BEGIN
  INSERT INTO SalesTasks (task_name, task_date)
  VALUES (@task_name , @task_date);
END
GO
Exec SP_AddSalesTasks 'Teslimat planlanacak', '2023-06-04'

DROP PROCEDURE IF EXISTS SP_DeleteSalesTasks;
Go
Create Proc SP_DeleteSalesTasks
	@sale_task_id int
As
	Delete From SalesTasks Where @sale_task_id = @sale_task_id
Go
Exec SP_DeleteSalesTasks 1
Go
Alter Proc SP_DeleteSalesTasks
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From SalesTasks Where sale_task_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteSalesTasks 1, @msg output
Select @code
Select @msg


DROP PROCEDURE IF EXISTS UpdateSalesTasks;
GO
CREATE PROCEDURE UpdateSalesTasks
  @task_name VARCHAR(250),
  @new_task_name VARCHAR(250)
AS
BEGIN
  UPDATE SalesTasks
  SET task_name = @new_task_name
  WHERE task_name = @task_name;
END;

EXEC UpdateSalesTasks @task_name = 'Müþteri aramasý yapýlacak' , @new_task_name = 'Müþteri Memnuniyet Anketi Yapýlacak';

GO
DROP VIEW IF EXISTS SalesTasksView;
GO
CREATE VIEW SalesTasksView With Encryption
AS
SELECT ST.task_name, ST.task_date 
FROM SalesTasks ST;

GO
Exec sp_helptext 'CustomersView'

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetSalesTasksByDate')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetSalesTasksByDate(@date DATE)
    RETURNS TABLE
    AS
    RETURN (
      SELECT task_name, task_date
      FROM SalesTasks
      WHERE task_date = @date
    );
    ');
END

GO
SELECT task_name, task_date FROM dbo.GetSalesTasksByDate('2023-06-01');
--SalesTasks


--Suppliers
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Suppliers')
CREATE TABLE Suppliers (
supplier_id INT IDENTITY,
supplier_name VARCHAR(255) NOT NULL,
address VARCHAR(255),
phone_number VARCHAR(20),
user_id INT,
CONSTRAINT PK_Suppliers_supplier_id PRIMARY KEY (supplier_id),
CONSTRAINT FK_Suppliers_user_id FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO Suppliers (supplier_name, address, phone_number)
VALUES
  ('ABC Electronics', '123 Main Street, Anytown, USA', '555-1234'),
  ('XYZ Suppliers', '456 Elm Street, Othertown, USA', '555-5678'),
  ('Global Imports', '789 Oak Street, Another Town, USA', '555-9012');

--Suppliers TRIGGER
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_EkleSuppliers')
    DROP TRIGGER tr_EkleSuppliers;
GO
CREATE TRIGGER tr_EkleSuppliers
ON Suppliers
AFTER INSERT
AS
BEGIN
    DECLARE @supplier_name VARCHAR(255);
    DECLARE @address VARCHAR(255);
    DECLARE @phone_number VARCHAR(20);
    SELECT @supplier_name = supplier_name, @address = address, @phone_number = phone_number FROM inserted;
    EXEC SP_AddSuppliers @supplier_name, @address, @phone_number;
END;

GO
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_SilSuppliers')
    DROP TRIGGER tr_SilSuppliers;
GO
CREATE TRIGGER tr_SilSuppliers
ON Suppliers
AFTER DELETE
AS
BEGIN
    DECLARE @supplier_id INT;
    DECLARE @supplier_name VARCHAR(255);
    DECLARE @address VARCHAR(255);
    DECLARE @phone_number VARCHAR(20);
    SELECT @supplier_id = supplier_id FROM deleted;
	EXEC SP_AddSuppliers @supplier_id, @supplier_name, @address, @phone_number;
END;

GO
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_GuncelleSuppliers')
    DROP TRIGGER tr_GuncelleSuppliers;
GO
CREATE TRIGGER tr_GuncelleSuppliers
ON Suppliers
AFTER UPDATE
AS
BEGIN
    DECLARE @supplier_name VARCHAR(255);
    DECLARE @new_supplier_name VARCHAR(255);
    DECLARE @address VARCHAR(255);
    DECLARE @new_address VARCHAR(255);
    DECLARE @phone_number VARCHAR(20);
    DECLARE @new_phone_number VARCHAR(20);
    SELECT @supplier_name = supplier_name, @new_supplier_name = supplier_name, @address = address, @new_address = address, @phone_number = phone_number, @new_phone_number = phone_number FROM inserted;
	EXEC UpdateSuppliers @supplier_name, @new_supplier_name, @address, @new_address, @phone_number, @new_phone_number;
END;

SELECT * FROM sys.triggers WHERE name = 'tr_EkleSuppliers';
SELECT * FROM sys.triggers WHERE name = 'tr_SilSuppliers';
SELECT * FROM sys.triggers WHERE name = 'tr_GuncelleSuppliers';
--Suppliers TRIGGER

GO
DROP PROCEDURE IF EXISTS GetSuppliersByID;
GO
CREATE PROCEDURE GetSuppliersByID
    @supplier_id INT
AS
BEGIN
    SELECT * FROM Suppliers WHERE supplier_id = @supplier_id;
END;

EXEC GetSuppliersByID @supplier_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddSuppliers;
GO
CREATE PROCEDURE SP_AddSuppliers
  @supplier_name VARCHAR(255),
  @address VARCHAR(255),
  @phone_number VARCHAR(20)
AS
BEGIN
  INSERT INTO Suppliers (supplier_name, address, phone_number)
  VALUES (@supplier_name, @address, @phone_number);
END
GO
Exec SP_AddSuppliers 'ABC Company', '456 Oak Avenue, Anytown, USA', '555-6789'

DROP PROCEDURE IF EXISTS SP_DeleteSuppliers;
Go
Create Proc SP_DeleteSuppliers
	@supplier_id int
As
	Delete From Suppliers Where @supplier_id = @supplier_id
Go
Exec SP_DeleteSuppliers 1
Go
Alter Proc SP_DeleteSuppliers
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Suppliers Where supplier_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteSuppliers 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateSuppliers;
GO
CREATE PROCEDURE UpdateSuppliers
  @supplier_name VARCHAR(255),
  @new_supplier_name VARCHAR(255),
  @address VARCHAR(255),
  @new_address VARCHAR(255),
  @phone_number VARCHAR(20),
  @new_phone_number VARCHAR(20)
AS
BEGIN
  UPDATE Suppliers
  SET supplier_name = @new_supplier_name,
	  address = @new_address,
	  phone_number = @new_phone_number
  WHERE supplier_name = @supplier_name;
END;

EXEC UpdateSuppliers 
	@supplier_name = 'ABC Electronics',  
	@new_supplier_name = 'HOPE Company',
	@address = '123 Main Street, Anytown, USA',
	@new_address = 'Bakýrköy',
	@phone_number = '555-1234',
	@new_phone_number = '123-456';

GO
DROP VIEW IF EXISTS SuppliersView;
GO
CREATE VIEW SuppliersView WITH SCHEMABINDING
AS
SELECT Su.supplier_id, Su.supplier_name, Su.address, Su.phone_number
FROM dbo.Suppliers Su;

GO
SELECT * FROM SuppliersView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetSupplier')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetSupplier(@supplier_id INT)
    RETURNS TABLE
    AS
    RETURN (
      SELECT supplier_name, address, phone_number
      FROM Suppliers
      WHERE supplier_id = @supplier_id
    );
    ');
END

GO
SELECT supplier_name, address, phone_number FROM dbo.GetSupplier(3);
--Suppliers


--Supplies
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='Supplies')
CREATE TABLE Supplies (
  supply_id INT IDENTITY,
  supplier_id INT,
  part_id INT,
  supply_date DATE,
  user_id INT,
  CONSTRAINT PK_Supplies_supply_id PRIMARY KEY (supply_id),
  CONSTRAINT FK_Supplies_user_id FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

GO
DROP PROCEDURE IF EXISTS GetSuppliesByID;
GO
CREATE PROCEDURE GetSuppliesByID
    @supply_id INT
AS
BEGIN
    SELECT * FROM Supplies WHERE supply_id = @supply_id;
END;

EXEC GetSuppliesByID @supply_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddSupplies;
Go
Create Proc SP_AddSupplies
	@supply_date DATE
As
	Insert Into Supplies Values (@supply_date)
Go
Exec SP_AddSupplies '2023-05-07'

DROP PROCEDURE IF EXISTS SP_DeleteSupplies;
Go
Create Proc SP_DeleteSupplies
	@supply_id int
As
	Delete From Supplies Where @supply_id = @supply_id
Go
Exec SP_DeleteSupplies 1
Go
Alter Proc SP_DeleteSupplies
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Supplies Where supply_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteSupplies 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateSupplies;
GO
CREATE PROCEDURE UpdateSupplies
  @supply_date DATE,
  @new_supply_date DATE
AS
BEGIN
  UPDATE Supplies
  SET supply_date = @new_supply_date
  WHERE supply_date = @supply_date;
END;

EXEC UpdateSupplies @supply_date = '2023-05-07', @new_supply_date = '2023-05-09';
--Supplies


--SupplierAccounts
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SupplierAccounts')
CREATE TABLE SupplierAccounts (
    account_id INT Identity,
    balance DECIMAL(10, 2),
	user_id INT,
    CONSTRAINT PK_SupplierAccounts PRIMARY KEY (account_id),
    CONSTRAINT FK_SupplierAccounts_Users FOREIGN KEY (user_id) REFERENCES Users (user_id)
);

GO
DROP PROCEDURE IF EXISTS GetSupplierAccountsByID;
GO
CREATE PROCEDURE GetSupplierAccountsByID
    @account_id INT
AS
BEGIN
    SELECT * FROM SupplierAccounts WHERE account_id = @account_id;
END;

EXEC GetSupplierAccountsByID @account_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddSupplierAccounts;
Go
Create Proc SP_AddSupplierAccounts
	@balance DECIMAL(10, 2)
As
	Insert Into SupplierAccounts Values (@balance)
Go
Exec SP_AddSupplierAccounts '5000.00'

DROP PROCEDURE IF EXISTS SP_DeleteSupplierAccounts;
Go
Create Proc SP_DeleteSupplierAccounts
	@account_id int
As
	Delete From SupplierAccounts Where @account_id = @account_id
Go
Exec SP_DeleteSupplierAccounts 1
Go
Alter Proc SP_DeleteSupplierAccounts
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From SupplierAccounts Where account_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteSupplierAccounts 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateSupplierAccounts;
GO
CREATE PROCEDURE UpdateSupplierAccounts
  @balance DECIMAL(10, 2),
  @new_balance DECIMAL(10, 2)
AS
BEGIN
  UPDATE SupplierAccounts
  SET balance = @new_balance
  WHERE balance = @balance;
END;

EXEC UpdateSupplierAccounts @balance = '2023-05-07', @new_balance = '2023-05-09';
--SupplierAccounts


--StaffSalaries
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='StaffSalaries')
CREATE TABLE StaffSalaries (
  salary_id INT Identity,
  staff_id INT,
  sale_id INT,
  salary DECIMAL(10, 2),
  pay_date DATE,
  CONSTRAINT PK_StaffSalaries_salary_id PRIMARY KEY (salary_id),
  CONSTRAINT FK_StaffSalaries_sale_id FOREIGN KEY(sale_id) REFERENCES Sales(sale_id),
);

GO
DROP PROCEDURE IF EXISTS GetStaffSalariesByID;
GO
CREATE PROCEDURE GetStaffSalariesByID
    @salary_id INT
AS
BEGIN
    SELECT * FROM StaffSalaries WHERE salary_id = @salary_id;
END;

EXEC GetStaffSalariesByID @salary_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddStaffSalaries;
Go
Create Proc SP_AddStaffSalaries
	@salary DECIMAL(10, 2)
As
	Insert Into StaffSalaries Values (@salary)
Go
Exec SP_AddStaffSalaries '5000.00'

DROP PROCEDURE IF EXISTS SP_DeleteStaffSalaries;
Go
Create Proc SP_DeleteStaffSalaries
	@salary_id int
As
	Delete From StaffSalaries Where @salary_id = @salary_id
Go
Exec SP_DeleteStaffSalaries 1
Go
Alter Proc SP_DeleteSupplies
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From StaffSalaries Where salary_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteSupplies 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateStaffSalaries;
GO
CREATE PROCEDURE UpdateStaffSalaries
  @salary DECIMAL(10, 2),
  @new_salary DECIMAL(10, 2)
AS
BEGIN
  UPDATE StaffSalaries
  SET salary = @new_salary
  WHERE salary = @salary;
END;

EXEC UpdateStaffSalaries @salary = '5000.00', @new_salary = '6000.00';
--StaffSalaries


--CustomerAccounts
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='CustomerAccounts')
CREATE TABLE CustomerAccounts (
  account_id INT PRIMARY KEY,
  customer_id INT,
  balance DECIMAL(10, 2),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

GO
DROP PROCEDURE IF EXISTS GetCustomerAccountsByID;
GO
CREATE PROCEDURE GetCustomerAccountsByID
    @account_id INT
AS
BEGIN
    SELECT * FROM CustomerAccounts WHERE account_id = @account_id;
END;

EXEC GetCustomerAccountsByID @account_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddCustomerAccounts;
Go
Create Proc SP_AddCustomerAccounts
	@balance DECIMAL(10, 2)
As
	Insert Into StaffSalaries Values (@balance)
Go
Exec SP_AddCustomerAccounts '2000.00'

DROP PROCEDURE IF EXISTS SP_DeleteCustomerAccounts;
Go
Create Proc SP_DeleteCustomerAccounts
	@account_id int
As
	Delete From StaffSalaries Where @account_id = @account_id
Go
Exec SP_DeleteStaffSalaries 1
Go
Alter Proc SP_DeleteCustomerAccounts
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From CustomerAccounts Where account_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteCustomerAccounts 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateCustomerAccounts;
GO
CREATE PROCEDURE UpdateCustomerAccounts
  @balance DECIMAL(10, 2),
  @new_balance DECIMAL(10, 2)
AS
BEGIN
  UPDATE CustomerAccounts
  SET balance = @new_balance
  WHERE balance = @balance;
END;

EXEC UpdateCustomerAccounts @balance = '2000.00', @new_balance = '9000.00';
--CustomerAccounts


--Payments
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='Payments')
CREATE TABLE Payments (
  payment_id INT PRIMARY KEY,
  account_id INT,
  payment_amount DECIMAL(10, 2),
  payment_date DATE,
  FOREIGN KEY (account_id) REFERENCES CustomerAccounts(account_id)
);

GO
DROP PROCEDURE IF EXISTS GetPaymentsByID;
GO
CREATE PROCEDURE GetPaymentsByID
    @account_id INT
AS
BEGIN
    SELECT * FROM Payments WHERE account_id = @account_id;
END;

EXEC GetPaymentsByID @account_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddPayments;
Go
Create Proc SP_AddPayments
	@payment_amount DECIMAL(10, 2)
As
	Insert Into Payments Values (@payment_amount)
Go
Exec SP_AddPayments '4000.00'

DROP PROCEDURE IF EXISTS SP_DeletePayments;
Go
Create Proc SP_DeletePayments
	@payment_id int
As
	Delete From Payments Where @payment_id = @payment_id
Go
Exec SP_DeletePayments 1
Go
Alter Proc SP_DeletePayments
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Payments Where payment_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeletePayments 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdatePayments;
GO
CREATE PROCEDURE UpdatePayments
  @payment_amount DECIMAL(10, 2),
  @new_payment_amount DECIMAL(10, 2)
AS
BEGIN
  UPDATE Payments
  SET payment_amount = @new_payment_amount
  WHERE payment_amount = @payment_amount;
END;

EXEC UpdatePayments @payment_amount = '4000.00', @new_payment_amount = '7000.00';
--Payments


--Purchases
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='Purchases')
CREATE TABLE Purchases (
  purchase_id INT Identity,
  staff_departments_id INT,
  purchase_date DATE,
  CONSTRAINT PK_Purchases_purchase_id PRIMARY KEY (purchase_id),
  CONSTRAINT FK_Purchases_StaffDepartments FOREIGN KEY (staff_departments_id) REFERENCES StaffDepartments (staff_departments_id)
);

GO
DROP PROCEDURE IF EXISTS GetPurchasesByID;
GO
CREATE PROCEDURE GetPurchasesByID
    @purchase_id INT
AS
BEGIN
    SELECT * FROM Purchases WHERE purchase_id = @purchase_id;
END;

EXEC GetPurchasesByID @purchase_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddPurchases;
Go
Create Proc SP_AddPurchases
	@purchase_date DATE
As
	Insert Into Purchases Values (@purchase_date)
Go
Exec SP_AddPurchases '2023-04-04'

DROP PROCEDURE IF EXISTS SP_DeletePurchases;
Go
Create Proc SP_DeletePurchases
	@purchase_id int
As
	Delete From Purchases Where @purchase_id = @purchase_id
Go
Exec SP_DeletePurchases 1
Go
Alter Proc SP_DeletePurchases
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Purchases Where purchase_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeletePurchases 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdatePurchases;
GO
CREATE PROCEDURE UpdatePurchases
  @purchase_date DATE,
  @new_purchase_date DATE
AS
BEGIN
  UPDATE Purchases
  SET purchase_date = @new_purchase_date
  WHERE purchase_date = @purchase_date;
END;

EXEC UpdatePurchases @purchase_date = '2023-04-04' , @new_purchase_date = '2023-07-07';
--Purchases


--StaffTasks
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='StaffTasks')
CREATE TABLE StaffTasks (
  task_id INT PRIMARY KEY,
  staff_id INT,
  task_name VARCHAR(255) NOT NULL,
  task_date DATE,
  constraint FK_StaffTask_staff_id FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

GO
DROP PROCEDURE IF EXISTS GetStaffTasksByID;
GO
CREATE PROCEDURE GetStaffTasksByID
    @task_id INT
AS
BEGIN
    SELECT * FROM StaffTasks WHERE task_id = @task_id;
END;

EXEC GetStaffTasksByID @task_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddStaffTasks;
Go
Create Proc SP_AddStaffTasks
	@task_name VARCHAR(255)
As
	Insert Into StaffTasks Values (@task_name)
Go
Exec SP_AddStaffTasks 'Satýþ'

DROP PROCEDURE IF EXISTS SP_DeleteStaffTasks;
Go
Create Proc SP_DeleteStaffTasks
	@task_id int
As
	Delete From StaffTasks Where @task_id = @task_id
Go
Exec SP_DeleteStaffTasks 1
Go
Alter Proc SP_DeleteStaffTasks
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From StaffTasks Where task_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteStaffTasks 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateStaffTasks;
GO
CREATE PROCEDURE UpdateStaffTasks
  @task_name VARCHAR(255),
  @new_task_name VARCHAR(255)
AS
BEGIN
  UPDATE StaffTasks
  SET task_name = @new_task_name
  WHERE task_name = @task_name;
END;

EXEC UpdateStaffTasks @task_name = 'Satýþ' , @new_task_name = 'Kontrol';
--StaffTasks


--WarrantyStatus
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='WarrantyStatus')
CREATE TABLE WarrantyStatus (
  warranty_id INT PRIMARY KEY,
  warranty_name VARCHAR(255) NOT NULL
);

INSERT INTO WarrantyStatus (warranty_id, warranty_name)
VALUES
    (1, 'Aktif'),
    (2, 'Bitmiþ')

GO
DROP PROCEDURE IF EXISTS GetWarrantyStatusByID;
GO
CREATE PROCEDURE GetWarrantyStatusByID
    @warranty_id INT
AS
BEGIN
    SELECT * FROM WarrantyStatus WHERE warranty_id = @warranty_id;
END;

EXEC GetWarrantyStatusByID @warranty_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddWarrantyStatus;
GO
CREATE PROCEDURE SP_AddWarrantyStatus
  @warranty_id INT,
  @warranty_name VARCHAR(255)
AS
BEGIN
  INSERT INTO WarrantyStatus (warranty_id, warranty_name)
  VALUES (@warranty_id, @warranty_name);
END
GO
Exec SP_AddWarrantyStatus 3, 'Ýade Edilmiþ'

DROP PROCEDURE IF EXISTS SP_DeleteWarrantyStatus;
Go
Create Proc SP_DeleteWarrantyStatus
	@warranty_id int
As
	Delete From WarrantyStatus Where @warranty_id = @warranty_id
Go
Exec SP_DeleteWarrantyStatus 1
Go
Alter Proc SP_DeleteWarrantyStatus
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From WarrantyStatus Where warranty_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteWarrantyStatus 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateWarrantyStatus;
GO
CREATE PROCEDURE UpdateWarrantyStatus
  @warranty_name VARCHAR(250),
  @new_warranty_name VARCHAR(250)
AS
BEGIN
  UPDATE WarrantyStatus
  SET warranty_name = @new_warranty_name
  WHERE warranty_name = @warranty_name;
END;

EXEC UpdateWarrantyStatus @warranty_name = 'Aktif' , @new_warranty_name = 'Son 1 yýl garantisi var';

GO
DROP VIEW IF EXISTS WarrantyStatusView;
GO
CREATE VIEW WarrantyStatusView WITH SCHEMABINDING
AS
SELECT Ws.warranty_id,Ws.warranty_name
FROM dbo.WarrantyStatus Ws;

GO
SELECT * FROM WarrantyStatusView;


IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetWarrantyStatus')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetWarrantyStatus(@warranty_id INT)
    RETURNS TABLE
    AS
    RETURN (
      SELECT warranty_name
      FROM WarrantyStatus
      WHERE warranty_id = @warranty_id
    );
    ');
END

GO
SELECT warranty_name FROM dbo.GetWarrantyStatus(2);
--WarrantyStatus


--WarrantyRecords
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='WarrantyRecords')
CREATE TABLE WarrantyRecords (
  warranty_record_id INT PRIMARY KEY,
  device_id INT,
  warranty_id INT,
  start_date DATE,
  end_date DATE,
  FOREIGN KEY (device_id) REFERENCES Devices(device_id),
  FOREIGN KEY (warranty_id) REFERENCES WarrantyStatus(warranty_id)
);

INSERT INTO WarrantyRecords (warranty_record_id, start_date, end_date)
VALUES
  (1, '2022-01-01', '2023-01-01'), 
  (2, '2022-02-01', '2023-02-01'), 
  (3, '2022-03-01', '2023-03-01');

GO
DROP PROCEDURE IF EXISTS GetWarrantyRecordsByID;
GO
CREATE PROCEDURE GetWarrantyRecordsByID
    @warranty_record_id INT
AS
BEGIN
    SELECT warranty_record_id, start_date, end_date
	FROM WarrantyRecords 
	WHERE warranty_record_id = @warranty_record_id;
END;

EXEC GetWarrantyRecordsByID @warranty_record_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddWarrantyRecords;
GO
CREATE PROCEDURE SP_AddWarrantyRecords
  @warranty_record_id INT,
  @start_date DATE,
  @end_date DATE
AS
BEGIN
  INSERT INTO WarrantyRecords (warranty_record_id, start_date, end_date)
  VALUES (@warranty_record_id, @start_date, @end_date);
END
GO
Exec SP_AddWarrantyRecords 4, '2022-03-01', '2023-03-01';

DROP PROCEDURE IF EXISTS SP_DeleteWarrantyRecords;
Go
Create Proc SP_DeleteWarrantyRecords
	@warranty_record_id int
As
	Delete From WarrantyRecords Where @warranty_record_id = @warranty_record_id
Go
Exec SP_DeleteWarrantyRecords 1
Go
Alter Proc SP_DeleteWarrantyRecords
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From WarrantyRecords Where warranty_record_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteWarrantyRecords 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateWarrantyRecords;
GO
CREATE PROCEDURE UpdateWarrantyRecords
  @start_date DATE,
  @new_start_date DATE,
  @end_date DATE,
  @new_end_date DATE
AS
BEGIN
  UPDATE WarrantyRecords
  SET start_date = @new_start_date,
	  end_date = @new_end_date
  WHERE start_date = @start_date;
END;

EXEC UpdateWarrantyRecords 
	@start_date = '2022-01-01',
	@new_start_date = '2023-05-05',
	@end_date = '2023-01-01',
	@new_end_date = '2021-09-09';

GO
DROP VIEW IF EXISTS WarrantyRecordsView;
GO
CREATE VIEW WarrantyRecordsView WITH SCHEMABINDING
AS
SELECT Wr.warranty_record_id, Wr.start_date, Wr.end_date
FROM dbo.WarrantyRecords Wr;

GO
SELECT * FROM WarrantyRecordsView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetWarrantyRecord')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetWarrantyRecord(@warranty_record_id INT)
    RETURNS TABLE
    AS
    RETURN (
      SELECT start_date, end_date
      FROM WarrantyRecords
      WHERE warranty_record_id = @warranty_record_id
    );
    ');
END

GO
SELECT start_date, end_date FROM dbo.GetWarrantyRecord(1);
--WarrantyRecords


--Departments
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='Departments')
CREATE TABLE Departments (
  department_id INT Identity,
  department_name VARCHAR(255) NOT NULL,
  CONSTRAINT PK_Departments PRIMARY KEY (department_id)
);

INSERT INTO Departments (department_name)
VALUES ('Müþteri hizmetleri'),
       ('Tamir elemanlarý'),
	   ('Depo çalýþanlarý');

GO
DROP PROCEDURE IF EXISTS GetDepartmentsByID;
GO
CREATE PROCEDURE GetDepartmentsByID
    @department_id INT
AS
BEGIN
    SELECT * FROM Departments WHERE department_id = @department_id;
END;

EXEC GetDepartmentsByID @department_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddDepartments;
GO
CREATE PROCEDURE SP_AddDepartments
  @department_name VARCHAR(255)
AS
BEGIN
  INSERT INTO Departments (department_name)
  VALUES (@department_name);
END
GO
Exec SP_AddDepartments 'Ýnsan kaynaklarý';

DROP PROCEDURE IF EXISTS SP_DeleteDepartments;
Go
Create Proc SP_DeleteDepartments
	@department_id int
As
	Delete From Departments Where @department_id = @department_id
Go
Exec SP_DeleteDepartments 1
Go
Alter Proc SP_DeleteDepartments
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Departments Where department_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteDepartments 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateDepartments;
GO
CREATE PROCEDURE UpdateDepartments
  @department_name VARCHAR(250),
  @new_department_name VARCHAR(250)
AS
BEGIN
  UPDATE Departments
  SET department_name = @new_department_name
  WHERE department_name = @department_name;
END;

EXEC UpdateDepartments @department_name = 'Müþteri hizmetleri' , @new_department_name = 'Yazýlýmcý';

GO
DROP VIEW IF EXISTS DepartmentsView;
GO
CREATE VIEW DepartmentsView WITH SCHEMABINDING
AS
SELECT D.department_id, D.department_name
FROM dbo.Departments D;

GO
SELECT * FROM DepartmentsView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetDepartment')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetDepartment(@department_id INT)
    RETURNS TABLE
    AS
    RETURN (
      SELECT department_name
      FROM Departments
      WHERE department_id = @department_id
    );
    ');
END

GO
SELECT department_name FROM dbo.GetDepartment(1);
--Departments


--StaffDepartments
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='StaffDepartments')
CREATE TABLE StaffDepartments (
  staff_departments_id INT Identity,
  department_id INT,
  staff_id INT,
  staff_departments varchar(250),
  CONSTRAINT PK_StaffDepartmentss_staff_departments_id PRIMARY KEY (staff_departments_id),
  CONSTRAINT FK_StaffDepartments_Departments FOREIGN KEY (department_id) REFERENCES Departments (department_id)
);

INSERT INTO StaffDepartments (staff_departments)
VALUES ('John - Müþteri hizmetleri'),
       ('Emily - Tamir elemanlarý'),
       ('David - Depo çalýþanlarý')


EXEC GetStaffDepartmentsByID @department_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddStaffDepartments;
GO
CREATE PROCEDURE SP_AddStaffDepartments
  @staff_departments varchar(250)
AS
BEGIN
  INSERT INTO StaffDepartments (staff_departments) 
  VALUES (@staff_departments);
END
GO
Exec SP_AddStaffDepartments 'Gizem - Ýnsan kaynaklarý';

DROP PROCEDURE IF EXISTS SP_DeleteStaffDepartments;
Go
Create Proc SP_DeleteStaffDepartments
	@staff_departments int
As
	Delete From StaffDepartments Where @staff_departments = @staff_departments
Go
Exec SP_DeleteStaffDepartments 1
Go
Alter Proc SP_DeleteStaffDepartments
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From StaffDepartments Where staff_departments = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteStaffDepartments 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateStaffDepartments;
GO
CREATE PROCEDURE UpdateStaffDepartments
  @staff_departments VARCHAR(250),
  @new_staff_departments VARCHAR(250)
AS
BEGIN
  UPDATE StaffDepartments
  SET staff_departments = @new_staff_departments
  WHERE staff_departments = @staff_departments;
END;

EXEC UpdateStaffDepartments @staff_departments = 'John - Müþteri hizmetleri' , @new_staff_departments = 'Umut - Yazýlýmcý';

GO
DROP VIEW IF EXISTS StaffDepartmentsView;
GO
CREATE VIEW StaffDepartmentsView WITH SCHEMABINDING
AS
SELECT SD.staff_departments
FROM dbo.StaffDepartments SD;

GO
SELECT * FROM StaffDepartmentsView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetStaffDepartments')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetStaffDepartments(@department_id INT)
    RETURNS TABLE
    AS
    RETURN (
        SELECT department_id, staff_departments
        FROM StaffDepartments
        WHERE department_id = @department_id
    );
    ');
END

GO
SELECT staff_departments FROM dbo.GetStaffDepartments(1);
--StaffDepartments


--Features
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='Features')
CREATE TABLE Features (
  feature_id INT PRIMARY KEY,
  feature_name VARCHAR(255) NOT NULL
);

INSERT INTO Features (feature_id, feature_name)
VALUES (1, 'Telefon özellikleri'),
       (2, 'Bilgisayar Özellikleri'),
       (3, 'Tablet Özellikleri')

GO
DROP PROCEDURE IF EXISTS GetFeaturesByID;
GO
CREATE PROCEDURE GetFeaturesByID
    @feature_id INT
AS
BEGIN
    SELECT * FROM Features WHERE feature_id = @feature_id;
END;

EXEC GetFeaturesByID @feature_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddFeatures;
GO
CREATE PROCEDURE SP_AddFeatures
  @feature_id INT,
  @feature_name VARCHAR(255)
AS
BEGIN
  INSERT INTO Features (feature_id, feature_name) 
  VALUES (@feature_id, @feature_name);
END
GO
Exec SP_AddFeatures 4, 'Televizyon Özellikleri';

DROP PROCEDURE IF EXISTS SP_DeleteFeatures;
Go
Create Proc SP_DeleteFeatures
	@feature_id int
As
	Delete From Features Where @feature_id = @feature_id
Go
Exec SP_DeleteFeatures 1
Go
Alter Proc SP_DeleteFeatures
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Features Where feature_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteFeatures 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateFeatures;
GO
CREATE PROCEDURE UpdateFeatures
  @feature_name VARCHAR(250),
  @new_feature_name VARCHAR(250)
AS
BEGIN
  UPDATE Features
  SET feature_name = @new_feature_name
  WHERE feature_name = @feature_name;
END;

EXEC UpdateFeatures @feature_name = 'Telefon özellikleri' , @new_feature_name = 'Akýllý saat özellikleri';

GO
DROP VIEW IF EXISTS FeaturesView;
GO
CREATE VIEW FeaturesView WITH SCHEMABINDING
AS
SELECT F.feature_id, F.feature_name
FROM dbo.Features F;

GO
SELECT * FROM FeaturesView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetFeatures')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetFeatures(@feature_id INT)
    RETURNS TABLE
    AS
    RETURN (
      SELECT feature_id, feature_name
      FROM Features
      WHERE feature_id = @feature_id 
    );
    ');
END

GO
SELECT feature_id, feature_name FROM dbo.GetFeatures(1);
--Features


--ProductFeatures
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='ProductFeatures')
CREATE TABLE ProductFeatures (
  product_features_id INT Identity,
  product_id INT,
  feature_id INT,
  product_features Varchar(250),
  Constraint PK_ProductFeatures_product_features_id PRIMARY KEY (product_features_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id),
  FOREIGN KEY (feature_id) REFERENCES Features(feature_id)
);

INSERT INTO ProductFeatures (product_features)
VALUES ('IP67 Su Geçirmezlik'),
       ('Hýzlý Þarj'),
       ('Çift SIM Desteði'),
       ('IP68 Su Geçirmezlik'),
       ('Geniþletilebilir Depolama');

GO
DROP PROCEDURE IF EXISTS GetProductFeaturesByID;
GO
CREATE PROCEDURE GetProductFeaturesByID
    @feature_id INT
AS
BEGIN
    SELECT feature_id, product_features FROM ProductFeatures WHERE feature_id = @feature_id;
END;

EXEC GetProductFeaturesByID @feature_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddProductFeatures;
GO
CREATE PROCEDURE SP_AddProductFeatures
  @product_features Varchar(250)
AS
BEGIN
  INSERT INTO ProductFeatures (product_features) 
  VALUES (@product_features);
END
GO
Exec SP_AddProductFeatures '4K EKRAN';

DROP PROCEDURE IF EXISTS SP_DeleteProductFeatures;
Go
Create Proc SP_DeleteProductFeatures
	@feature_id int
As
	Delete From ProductFeatures Where @feature_id = @feature_id
Go
Exec SP_DeleteProductFeatures 1
Go
Alter Proc SP_DeleteProductFeatures
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From ProductFeatures Where feature_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteProductFeatures 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateProductFeatures;
GO
CREATE PROCEDURE UpdateProductFeatures
  @product_features VARCHAR(250),
  @new_product_features VARCHAR(250)
AS
BEGIN
  UPDATE ProductFeatures
  SET @product_features = @new_product_features
  WHERE @product_features = @product_features;
END;

EXEC UpdateProductFeatures @product_features = 'IP67 Su Geçirmezlik' , @new_product_features = '40 MP kamera';

GO
DROP VIEW IF EXISTS ProductFeaturesView;
GO
CREATE VIEW ProductFeaturesView WITH SCHEMABINDING
AS
SELECT PF.feature_id, PF.product_features
FROM dbo.ProductFeatures PF;

GO
SELECT * FROM ProductFeaturesView;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetProductFeatures')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetProductFeatures(@feature_id INT)
    RETURNS TABLE
    AS
    RETURN (
      SELECT feature_id, product_features
      FROM ProductFeatures
      WHERE feature_id = @feature_id 
    );
    ');
END

GO
SELECT feature_id, product_features FROM dbo.GetProductFeatures(1);
--ProductFeatures


--Content
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='Content')
CREATE TABLE Content (
  content_id INT PRIMARY KEY,
  content_name VARCHAR(255) NOT NULL
);

GO
DROP PROCEDURE IF EXISTS GetContentByID;
GO
CREATE PROCEDURE GetContentByID
    @content_id INT
AS
BEGIN
    SELECT * FROM Content WHERE content_id = @content_id;
END;

EXEC GetContentByID @content_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddContent;
GO
CREATE PROCEDURE SP_AddContent
  @content_name INT
AS
BEGIN
  INSERT INTO Content (content_name) 
  VALUES (@content_name);
END
GO
Exec SP_AddContent 'Telefon içeriði'

DROP PROCEDURE IF EXISTS SP_DeleteContent;
Go
Create Proc SP_DeleteContent
	@content_id int
As
	Delete From Content Where @content_id = @content_id
Go
Exec SP_DeleteContent 1
Go
Alter Proc SP_DeleteContent
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Content Where content_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteContent 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateContent;
GO
CREATE PROCEDURE UpdateContent
  @content_name VARCHAR(250),
  @new_content_name VARCHAR(250)
AS
BEGIN
  UPDATE Content
  SET content_name = @new_content_name
  WHERE content_name = @content_name;
END;

EXEC UpdateContent @content_name = 'Telefon içeriði',  @new_content_name = 'Bilgisayar içeriði';
--Content


--ProductContents
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='ProductContents')
CREATE TABLE ProductContents (
  product_id INT,
  content_id INT,
  ProductContents_name VARCHAR(250),
  PRIMARY KEY (product_id, content_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id),
  FOREIGN KEY (content_id) REFERENCES Content(content_id)
);

GO
DROP PROCEDURE IF EXISTS GetProductContentsByID;
GO
CREATE PROCEDURE GetProductContentsByID
    @product_id INT
AS
BEGIN
    SELECT * FROM ProductContents WHERE product_id = @product_id;
END;

EXEC GetProductContentsByID @product_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddProductContents;
GO
CREATE PROCEDURE SP_AddProductContents
  @ProductContents_name VARCHAR(250)
AS
BEGIN
  INSERT INTO ProductContents (ProductContents_name) 
  VALUES (@ProductContents_name);
END
GO
Exec SP_AddProductContents 'Ekran kartý içeriði'

DROP PROCEDURE IF EXISTS SP_DeleteProductContents;
Go
Create Proc SP_DeleteProductContents
	@product_id int
As
	Delete From ProductContents Where @product_id = @product_id
Go
Exec SP_DeleteProductContents 1
Go
Alter Proc SP_DeleteProductContents
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From ProductContents Where product_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteProductContents 1, @msg output
Select @code
Select @msg

GO
DROP PROCEDURE IF EXISTS UpdateProductContents;
GO
CREATE PROCEDURE ProductContents
  @ProductContents_name VARCHAR(250),
  @new_ProductContents_name VARCHAR(250)
AS
BEGIN
  UPDATE ProductContents
  SET ProductContents_name = @new_ProductContents_name
  WHERE ProductContents_name = @ProductContents_name;
END;

EXEC UpdateProductContents @ProductContents_name = 'Ekran kartý içeriði',  @new_ProductContents_name = 'Ýþlemci içeriði';
--ProductContents


--Orders
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='Orders')
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

GO
DROP PROCEDURE IF EXISTS GetOrdersByID;
GO
CREATE PROCEDURE GetOrdersByID
    @order_id INT
AS
BEGIN
    SELECT * FROM Orders WHERE order_id = @order_id;
END;

EXEC GetOrdersByID @order_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddOrders;
GO
CREATE PROCEDURE SP_AddOrders
  @order_date DATE
AS
BEGIN
  INSERT INTO Orders (order_date) 
  VALUES (@order_date);
END
GO
Exec SP_AddOrders '2023-09-09'

DROP PROCEDURE IF EXISTS SP_DeleteOrders;
Go
Create Proc SP_DeleteOrders
	@order_id INT
As
	Delete From ProductContents Where @order_id = @order_id
Go
Exec SP_DeleteOrders 1
Go
Alter Proc SP_DeleteOrders
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Orders Where order_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteOrders 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateOrders;
GO
CREATE PROCEDURE UpdateOrders
  @order_date DATE,
  @new_order_date DATE
AS
BEGIN
  UPDATE UpdateOrders
  SET order_date = @new_order_date
  WHERE order_date = @order_date;
END;

EXEC UpdateOrders @order_date = '2023-09-09',  @new_order_date = '2023-08-08';
--Orders


--OrderDetails
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='OrderDetails')
CREATE TABLE OrderDetails (
  order_id INT,
  product_id INT,
  quantity INT,
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

GO
DROP PROCEDURE IF EXISTS GetOrderDetailsByID;
GO
CREATE PROCEDURE GetOrderDetailsByID
    @order_id INT
AS
BEGIN
    SELECT * FROM OrderDetails WHERE order_id = @order_id;
END;

EXEC GetOrderDetailsByID @order_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddOrderDetails;
GO
CREATE PROCEDURE SP_AddOrderDetails
  @quantity INT
AS
BEGIN
  INSERT INTO OrderDetails (quantity) 
  VALUES (@quantity);
END
GO
Exec SP_AddOrderDetails '202'

DROP PROCEDURE IF EXISTS SP_DeleteOrderDetails;
Go
Create Proc SP_DeleteOrderDetails
	@order_id INT
As
	Delete From OrderDetails Where @order_id = @order_id
Go
Exec SP_DeleteOrderDetails 1
Go
Alter Proc SP_DeleteOrderDetails
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From OrderDetails Where order_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteOrderDetails 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateOrderDetails;
GO
CREATE PROCEDURE UpdateOrderDetails
  @quantity INT,
  @new_quantity INT
AS
BEGIN
  UPDATE UpdateOrderDetails
  SET quantity = @new_quantity
  WHERE quantity = @quantity;
END;

EXEC UpdateOrderDetails @quantity = '2023-09-09',  @new_quantity = '2023-08-08';
--OrderDetails


--customerservice
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='customerservice')
CREATE TABLE customerservice (
  customerservice_id INT IDENTITY,
  customer_id INT,
  customerservice_name VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  phone_number VARCHAR(20),
  CONSTRAINT FK_customerservice_Customers FOREIGN KEY (customer_id) REFERENCES Customers (customer_id)
);

INSERT INTO customerservice (customerservice_name, address, phone_number)
VALUES
    ('Müþteri Temsilcisi Ayþe', 'ÝSTANBUL', '1234567890'),
    ('Müþteri Temsilcisi Fatma', 'ÝZMÝR', '0987654321'),
    ('Müþteri Temsilcisi Hayriye', 'BOLU', '9876543210');

GO
DROP PROCEDURE IF EXISTS GetcustomerserviceByID;
GO
CREATE PROCEDURE GetcustomerserviceByID
    @customerservice_id INT
AS
BEGIN
    SELECT * FROM customerservice WHERE customerservice_id = @customerservice_id;
END;

EXEC GetcustomerserviceByID @customerservice_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_Addcustomerservice;
GO
CREATE PROCEDURE SP_Addcustomerservice
  @customerservice_name VARCHAR(255),
  @address VARCHAR(255),
  @phone_number VARCHAR(20)
AS
BEGIN
  INSERT INTO customerservice (customerservice_name, address, phone_number)
  VALUES (@customerservice_name, @address, @phone_number);
END
GO
Exec SP_Addcustomerservice 'Müþteri Temsilcisi BÜÞRA', 'BURSA', '9876543510'

DROP PROCEDURE IF EXISTS SP_Deletecustomerservice;
Go
Create Proc SP_Deletecustomerservice
	@customerservice_id int
As
	Delete From customerservice Where @customerservice_id = @customerservice_id
Go
Exec SP_Deletecustomerservice 1
Go
Alter Proc SP_Deletecustomerservice
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From customerservice Where customerservice_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_Deletecustomerservice 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS Updatecustomerservice;
GO
CREATE PROCEDURE Updatecustomerservice
  @customerservice_name VARCHAR(250),
  @new_customerservice_name VARCHAR(250),
  @address VARCHAR(255),
  @new_address VARCHAR(255),
  @phone_number VARCHAR(20),
  @new_phone_number VARCHAR(20)
AS
BEGIN
  UPDATE customerservice
  SET customerservice_name = @new_customerservice_name,
      address = @new_address,
	  phone_number = @new_phone_number
  WHERE customerservice_name = @customerservice_name;
END;

EXEC Updatecustomerservice 
	@customerservice_name = 'Müþteri Temsilcisi Ayþe',
	@new_customerservice_name = 'Müþteri Temsilcisi Beyza',
	@address = 'ÝSTANBUL',
	@new_address = 'SAKARYA',
	@phone_number = '1234567890',
	@new_phone_number = '9876543210';

GO
SELECT * FROM customerservice;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetCustomerService')
BEGIN
    EXEC('
    CREATE FUNCTION dbo.GetCustomerService(@customerservice_id INT)
    RETURNS TABLE
    AS
    RETURN (
        SELECT customerservice_name, address, phone_number
        FROM customerservice
        WHERE customerservice_id = @customerservice_id
    );
    ');
END

GO
SELECT customerservice_name, address, phone_number FROM dbo.GetCustomerService(8);
--customerservice


--Campaigns
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='Campaigns')
CREATE TABLE Campaigns (
  campaign_id INT PRIMARY KEY,
  campaign_name VARCHAR(255) NOT NULL,
  start_date DATE,
  end_date DATE
);

GO
DROP PROCEDURE IF EXISTS GetCampaignsByID;
GO
CREATE PROCEDURE GetCampaignsByID
    @campaign_id INT
AS
BEGIN
    SELECT * FROM Campaigns WHERE campaign_id = @campaign_id;
END;

EXEC GetCampaignsByID @campaign_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddOrderCampaigns;
GO
CREATE PROCEDURE SP_AddOrderCampaigns
  @campaign_name VARCHAR(255)
AS
BEGIN
  INSERT INTO Campaigns (campaign_name) 
  VALUES (@campaign_name);
END
GO
Exec SP_AddOrderCampaigns 'Yaz kampanyasý'

DROP PROCEDURE IF EXISTS SP_DeleteCampaigns;
Go
Create Proc SP_DeleteCampaigns
	@campaign_id INT
As
	Delete From Campaigns Where @campaign_id = @campaign_id
Go
Exec SP_DeleteCampaigns 1
Go
Alter Proc SP_DeleteCampaigns
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From Campaigns Where campaign_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteCampaigns 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateCampaigns;
GO
CREATE PROCEDURE UpdateCampaigns
  @campaign_name VARCHAR(255),
  @new_campaign_name VARCHAR(255)
AS
BEGIN
  UPDATE UpdateCampaigns
  SET campaign_name = @new_campaign_name
  WHERE campaign_name = @campaign_name;
END;

EXEC UpdateCampaigns @campaign_name = 'Yaz kapmanyasý',  @new_campaign_name = 'Bahar kampanyasý';
--Campaigns


--CampaignDetails
GO
If Not Exists(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='CampaignDetails')
CREATE TABLE CampaignDetails (
  campaign_id INT,
  product_id INT,
  discount DECIMAL(10, 2),
  PRIMARY KEY (campaign_id, product_id),
  FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

GO
DROP PROCEDURE IF EXISTS GetCampaignDetailsByID;
GO
CREATE PROCEDURE GetCampaignDetailsByID
    @campaign_id INT
AS
BEGIN
    SELECT * FROM CampaignDetails WHERE campaign_id = @campaign_id;
END;

EXEC GetCampaignDetailsByID @campaign_id = 1;

GO
DROP PROCEDURE IF EXISTS SP_AddCampaignDetails;
GO
CREATE PROCEDURE SP_AddCampaignDetails
  @discount DECIMAL(10, 2)
AS
BEGIN
  INSERT INTO CampaignDetails (discount) 
  VALUES (@discount);
END
GO
Exec SP_AddCampaignDetails '2000.00'

DROP PROCEDURE IF EXISTS SP_DeleteCampaignDetails;
Go
Create Proc SP_DeleteCampaignDetails
	@campaign_id INT
As
	Delete From CampaignDetails Where @campaign_id = @campaign_id
Go
Exec SP_DeleteCampaignDetails 1
Go
Alter Proc SP_DeleteCampaignDetails
	@id int,
	@msg varchar(max) output
As
SET NOCOUNT ON
Begin Try
	Delete From CampaignDetails Where campaign_id = @id
End Try
Begin Catch
	Select @msg = ERROR_MESSAGE()
	Return Error_Number()
End Catch
Go
Declare @code int, @msg varchar(max);
Exec @code = SP_DeleteCampaignDetails 1, @msg output
Select @code
Select @msg

DROP PROCEDURE IF EXISTS UpdateCampaignDetails;
GO
CREATE PROCEDURE UpdateCampaignDetails
  @discount DECIMAL(10, 2),
  @new_discount DECIMAL(10, 2)
AS
BEGIN
  UPDATE UpdateCampaignDetails
  SET discount = @new_discount
  WHERE discount = @discount;
END;

EXEC UpdateCampaigns @discount = '2000.00',  @new_discount = '3000.000';
--CampaignDetails
