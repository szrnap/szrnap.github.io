USE [master]
GO
/****** Object:  Database [LFontaVizsga]    Script Date: 2021. 08. 16. 14:54:16 ******/
CREATE DATABASE [LFontaVizsga]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LFontaVizsga', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\LFontaVizsga.mdf' , SIZE = 51200KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
 FILEGROUP [LFonta_Data]  DEFAULT
( NAME = N'LFonta_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\LFonta_Data.ndf' , SIZE = 51200KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'LFontaVizsga_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\LFontaVizsga_log.ldf' , SIZE = 51200KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [LFontaVizsga] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [LFontaVizsga].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [LFontaVizsga] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [LFontaVizsga] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [LFontaVizsga] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [LFontaVizsga] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [LFontaVizsga] SET ARITHABORT OFF 
GO
ALTER DATABASE [LFontaVizsga] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [LFontaVizsga] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [LFontaVizsga] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [LFontaVizsga] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [LFontaVizsga] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [LFontaVizsga] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [LFontaVizsga] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [LFontaVizsga] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [LFontaVizsga] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [LFontaVizsga] SET  DISABLE_BROKER 
GO
ALTER DATABASE [LFontaVizsga] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [LFontaVizsga] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [LFontaVizsga] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [LFontaVizsga] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [LFontaVizsga] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [LFontaVizsga] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [LFontaVizsga] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [LFontaVizsga] SET RECOVERY FULL 
GO
ALTER DATABASE [LFontaVizsga] SET  MULTI_USER 
GO
ALTER DATABASE [LFontaVizsga] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [LFontaVizsga] SET DB_CHAINING OFF 
GO
ALTER DATABASE [LFontaVizsga] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [LFontaVizsga] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [LFontaVizsga] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [LFontaVizsga] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'LFontaVizsga', N'ON'
GO
ALTER DATABASE [LFontaVizsga] SET QUERY_STORE = OFF
GO
USE [LFontaVizsga]
GO
/****** Object:  ApplicationRole [WebApp]    Script Date: 2021. 08. 16. 14:54:16 ******/
/* To avoid disclosure of passwords, the password is generated in script. */
declare @idx as int
declare @randomPwd as nvarchar(64)
declare @rnd as float
select @idx = 0
select @randomPwd = N''
select @rnd = rand((@@CPU_BUSY % 100) + ((@@IDLE % 100) * 100) + 
       (DATEPART(ss, GETDATE()) * 10000) + ((cast(DATEPART(ms, GETDATE()) as int) % 100) * 1000000))
while @idx < 64
begin
   select @randomPwd = @randomPwd + char((cast((@rnd * 83) as int) + 43))
   select @idx = @idx + 1
select @rnd = rand()
end
declare @statement nvarchar(4000)
select @statement = N'CREATE APPLICATION ROLE [WebApp] WITH DEFAULT_SCHEMA = [dbo], ' + N'PASSWORD = N' + QUOTENAME(@randomPwd,'''')
EXEC dbo.sp_executesql @statement
GO
/****** Object:  User [LFontaSec]    Script Date: 2021. 08. 16. 14:54:16 ******/
CREATE USER [LFontaSec] FOR LOGIN [LFontaSec] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [LFontaRO]    Script Date: 2021. 08. 16. 14:54:16 ******/
CREATE USER [LFontaRO] FOR LOGIN [LFontaRO] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [LFontaAdmin]    Script Date: 2021. 08. 16. 14:54:16 ******/
CREATE USER [LFontaAdmin] FOR LOGIN [LFontaAdmin] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [Write]    Script Date: 2021. 08. 16. 14:54:16 ******/
CREATE ROLE [Write]
GO
/****** Object:  DatabaseRole [Sec]    Script Date: 2021. 08. 16. 14:54:16 ******/
CREATE ROLE [Sec]
GO
/****** Object:  DatabaseRole [CallCenter]    Script Date: 2021. 08. 16. 14:54:16 ******/
CREATE ROLE [CallCenter]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [LFontaSec]
GO
ALTER ROLE [CallCenter] ADD MEMBER [LFontaRO]
GO
ALTER ROLE [db_datareader] ADD MEMBER [LFontaRO]
GO
ALTER ROLE [db_owner] ADD MEMBER [LFontaAdmin]
GO
/****** Object:  UserDefinedFunction [dbo].[Number3]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Number3] (@N smallint) RETURNS varchar(1000) AS
		BEGIN
			IF @N = 0 RETURN NULL
			DECLARE @H varchar(50) = CHOOSE(@N/100,'egy', 'kettő', 'három', 'négy', 
				'öt', 'hat', 'hét', 'nyolc', 'kilenc') + 'száz'
			DECLARE @T varchar(50) = CHOOSE((@N-@N/100*100)/10,'tíz', 'húsz', 'harminc', 
				'negyven', 'ötven', 'hatvan', 'hetven', 'nyolcvan', 'kilencven')
			DECLARE @E varchar(50) = CHOOSE(@N % 10,'egy', 'kettő', 'három', 'négy', 
				'öt', 'hat', 'hét', 'nyolc', 'kilenc')
			IF @T = 'tíz' AND @E IS NOT NULL SET @T = 'tizen'
			ELSE IF @T = 'húsz' AND @E IS NOT NULL SET @T = 'huszon'
			RETURN ISNULL(@H,'') + ISNULL(@T,'') + ISNULL(@E,'')
		END
GO
/****** Object:  Table [dbo].[Partner]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Partner](
	[PartnerID] [int] IDENTITY(1,1) NOT NULL,
	[PartnerName] [varchar](200) NOT NULL,
	[PartnerCountryCode] [char](2) NOT NULL,
	[PartnerPostalCode] [varchar](10) NOT NULL,
	[PartnerCity] [varchar](30) NOT NULL,
	[PartnerAdress] [varchar](100) NOT NULL,
	[VATID] [tinyint] NOT NULL,
	[IsStore] [bit] NOT NULL,
	[IsCustomer] [bit] NOT NULL,
	[IsSupplier] [bit] NOT NULL,
	[IsShipper] [bit] NOT NULL,
	[GPS] [geography] NULL,
 CONSTRAINT [PK_Partner_PartnerID] PRIMARY KEY CLUSTERED 
(
	[PartnerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data] TEXTIMAGE_ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[PersonName]  AS (concat([PersonTitle],' ',[PersonFirstName],' ',[PersonMiddleName],' ',[PersonLastName])),
	[PersonTitle] [varchar](10) NULL,
	[PersonFirstName] [varchar](30) NOT NULL,
	[PersonMiddleName] [varchar](30) NULL,
	[PersonLastName] [varchar](30) NOT NULL,
	[GenderCode] [int] NOT NULL,
	[PersonPhoneNumber] [varchar](50) NOT NULL,
	[PersonEmail] [varchar](100) NULL,
 CONSTRAINT [PK_Person_PersonID] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[Building]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Building](
	[BuildingID] [int] IDENTITY(1,1) NOT NULL,
	[ParterID] [int] NOT NULL,
	[PartnerContPersonID] [int] NOT NULL,
	[BuildingCountryCode] [char](2) NOT NULL,
	[BuildingPostalCode] [varchar](10) NOT NULL,
	[BuildingCity] [varchar](30) NOT NULL,
	[BuildingAdress] [varchar](50) NOT NULL,
	[BuildingComponent] [char](8) NULL,
	[BuildingLevel] [char](3) NULL,
	[RoomNo] [varchar](30) NULL,
	[DeviceID] [int] NOT NULL,
	[DeviceMedium] [varchar](20) NULL,
	[DeviceHeatOrCool] [varchar](20) NULL,
	[ContractTypeID] [tinyint] NOT NULL,
	[PaymentTypeID] [tinyint] NOT NULL,
	[DevicePicture] [varchar](200) NULL,
	[GPS] [geography] NULL,
 CONSTRAINT [PK_Building_BuildingID] PRIMARY KEY CLUSTERED 
(
	[BuildingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data] TEXTIMAGE_ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[PartnerContPerson]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PartnerContPerson](
	[PartnerContPersonID] [int] IDENTITY(1,1) NOT NULL,
	[PartnerID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
 CONSTRAINT [PK_PartnerContPerson_PartnerContPersonID] PRIMARY KEY CLUSTERED 
(
	[PartnerContPersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  View [dbo].[egy]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[egy] AS
Select PE.PersonName, P.PartnerName, B.BuildingCity, B.BuildingAdress
From Building B
Left Join Partner P on P.PartnerID=B.ParterID
Left Join PartnerContPerson PCP on P.PartnerID=PCP.PartnerID
Left Join Person PE on PE.PersonID=PCP.PersonID
GO
/****** Object:  Table [dbo].[Contract]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract](
	[ContractID] [int] IDENTITY(1,1) NOT NULL,
	[ContractNo] [int] NOT NULL,
	[ParterID] [int] NOT NULL,
	[ContractTypeID] [tinyint] NOT NULL,
	[PaymentTypeID] [tinyint] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
 CONSTRAINT [PK_Contract_ContractID] PRIMARY KEY CLUSTERED 
(
	[ContractID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[DictContract]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictContract](
	[ContractTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ContractTypeName] [varchar](30) NOT NULL,
	[ContractTypeNameE] [varchar](30) NOT NULL,
	[ContractTypeNameD] [varchar](30) NOT NULL,
 CONSTRAINT [PK_DictContract_ContractTypeID] PRIMARY KEY CLUSTERED 
(
	[ContractTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  View [dbo].[ketto]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[ketto] AS
Select P.PartnerName, C.EndDate, PE.PersonName,PE.GenderCode, PE.PersonPhoneNumber, PE.PersonEmail
From Contract C
Left Join Partner P on P.PartnerID=C.ParterID
Left Join DictContract DC on DC.ContractTypeID=C.ContractTypeID
Left Join PartnerContPerson PCP on P.PartnerID=PCP.PartnerID
Left Join Person PE on PE.PersonID=PCP.PersonID
Where DC.ContractTypeID = 1
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeName]  AS (concat([EmployeeTitle],' ',[EmployeeFirstName],' ',[EmployeeMiddleName],' ',[EmployeeLastName])),
	[EmployeeTitle] [varchar](10) NULL,
	[EmployeeFirstName] [varchar](30) NOT NULL,
	[EmployeeMiddleName] [varchar](30) NULL,
	[EmployeeLastName] [varchar](30) NOT NULL,
	[GenderCode] [int] NOT NULL,
	[EmployeeCountryCode] [char](2) NOT NULL,
	[EmployeePostalCode] [varchar](10) NOT NULL,
	[EmployeeCity] [varchar](255) NOT NULL,
	[EmployeeAdress] [varchar](255) NOT NULL,
	[EmployeeCountryCodeI] [char](2) NULL,
	[EmployeePostalCodeI] [varchar](10) NULL,
	[EmployeeCityI] [varchar](30) NULL,
	[EmployeeAdressI] [varchar](50) NULL,
	[EmployeeBankAccountNo] [varchar](24) NOT NULL,
	[EmployeePhoneNo] [varchar](100) NOT NULL,
	[EmployeeEmail] [varchar](50) NULL,
	[UserID] [int] NOT NULL,
	[EmployeeNote] [varchar](300) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Employee_EmployeeID] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[Car]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Car](
	[CarID] [int] IDENTITY(1,1) NOT NULL,
	[LisensePlateNo] [varchar](30) NULL,
	[CarType] [varchar](30) NOT NULL,
	[CarModel] [varchar](30) NOT NULL,
	[ChassesNo] [varchar](30) NOT NULL,
	[IsOwn] [bit] NOT NULL,
	[IsLeasing] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[Zertificate] [date] NOT NULL,
	[Service] [date] NOT NULL,
 CONSTRAINT [PK_Car_CarID] PRIMARY KEY CLUSTERED 
(
	[CarID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[EmployeeCar]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeCar](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[CarID] [int] NOT NULL,
 CONSTRAINT [PK_EmployeeCar_EmployeeID] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  View [dbo].[harom]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[harom] AS
Select E.EmployeeName, E.EmployeePhoneNo, E.EmployeeEmail, C.CarModel, CarType
From Employee E
Left Join EmployeeCar EC on EC.EmployeeID=E.EmployeeID
Left Join Car C on C.CarID=EC.CarID

GO
/****** Object:  Table [dbo].[Device]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Device](
	[DeviceID] [int] IDENTITY(1,1) NOT NULL,
	[DeviceName] [varchar](30) NULL,
	[DiveceType] [varchar](30) NULL,
	[PumpNo] [varchar](20) NULL,
	[PumpType] [varchar](30) NULL,
	[SwitchCabinetNo] [varchar](30) NULL,
	[SwitchCabinetType] [varchar](30) NULL,
	[MotorBellValveNo] [varchar](30) NULL,
	[MotorBellValveType] [varchar](30) NULL,
	[MagneticVelveNo] [varchar](30) NULL,
	[MagneticVelveType] [varchar](30) NULL,
	[MembraneVesselNo] [varchar](30) NULL,
	[MembraneVesseltype] [varchar](30) NULL,
	[ControllvesselNo] [varchar](30) NULL,
	[ControllvesselType] [varchar](30) NULL,
	[CPUNo] [varchar](30) NULL,
	[CPUType] [varchar](30) NULL,
	[ContractTypeID] [tinyint] NOT NULL,
	[PaymentTypeID] [tinyint] NOT NULL,
	[DevicePicture] [varchar](300) NULL,
 CONSTRAINT [PK_Device_DeviceID] PRIMARY KEY CLUSTERED 
(
	[DeviceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[DictCountry]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictCountry](
	[CountryCode] [char](2) NOT NULL,
	[CountryName] [varchar](200) NOT NULL,
	[CountryNameE] [varchar](200) NOT NULL,
	[CountryISO3] [char](3) NOT NULL,
 CONSTRAINT [PK_DictCountry_CountryCode] PRIMARY KEY CLUSTERED 
(
	[CountryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[DictGender]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictGender](
	[GenderCode] [int] NOT NULL,
	[GenderName] [varchar](30) NOT NULL,
 CONSTRAINT [PK_DictGender_GenderCode] PRIMARY KEY CLUSTERED 
(
	[GenderCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[DictMovement]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictMovement](
	[MovementTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[MovementTypeName] [varchar](30) NULL,
	[MovementTypeNameL] [varchar](30) NULL,
	[MovementTypeNameD] [varchar](30) NULL,
 CONSTRAINT [PK_DictMovement_MovementTypeID] PRIMARY KEY CLUSTERED 
(
	[MovementTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[DictPaymentType]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictPaymentType](
	[PaymentTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[PaymentTypeCode] [char](2) NOT NULL,
	[PaymentName] [varchar](30) NOT NULL,
	[PaymentNameE] [varchar](30) NOT NULL,
	[PaymentNameD] [varchar](30) NOT NULL,
 CONSTRAINT [PK_DictPaymentType_PaymentTypeID] PRIMARY KEY CLUSTERED 
(
	[PaymentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[DictUser]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictUser](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](30) NOT NULL,
	[UserLogin] [varchar](30) NOT NULL,
	[AdminRole] [bit] NOT NULL,
	[EmpRoll] [bit] NOT NULL,
	[SapRoll] [bit] NOT NULL,
	[CapRoll] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_DictUser_UserID] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[DictVAT]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DictVAT](
	[VATID] [tinyint] IDENTITY(1,1) NOT NULL,
	[VATName] [varchar](30) NOT NULL,
	[VATPercent] [money] NOT NULL,
	[FromDate] [date] NOT NULL,
	[ToDate] [date] NULL,
 CONSTRAINT [PK_DictVAT_VATID] PRIMARY KEY CLUSTERED 
(
	[VATID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice](
	[InvoiceID] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceNo] [varchar](30) NOT NULL,
	[InvoiceDate] [datetime2](7) NOT NULL,
	[PaymentDeadline] [date] NOT NULL,
	[PartnerID] [int] NULL,
	[ContractTypeID] [int] NULL,
	[PaymentTypeID] [char](2) NOT NULL,
	[Price] [money] NOT NULL,
	[VATID] [tinyint] NOT NULL,
	[IsIn] [bit] NOT NULL,
	[IsOut] [bit] NOT NULL,
 CONSTRAINT [PK_Invoice_InvoiceID] PRIMARY KEY CLUSTERED 
(
	[InvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[Movement]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Movement](
	[MovementID] [int] IDENTITY(1,1) NOT NULL,
	[MovementTypeID] [tinyint] NOT NULL,
	[PartsID] [int] NOT NULL,
	[MovementDate] [datetime2](7) NULL,
	[FromStorageID] [int] NULL,
	[ToStorageID] [int] NULL,
	[ModifyDate] [datetime2](7) NOT NULL,
	[Amount] [int] NOT NULL,
 CONSTRAINT [PK_Movement_MovementID] PRIMARY KEY CLUSTERED 
(
	[MovementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[Parts]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Parts](
	[PartsID] [int] IDENTITY(1,1) NOT NULL,
	[PartsNo] [int] NOT NULL,
	[PartsName] [varchar](30) NOT NULL,
	[Weight] [int] NULL,
	[PartsCategoryID] [int] NOT NULL,
	[Price] [money] NULL,
 CONSTRAINT [PK_Parts_PartsID] PRIMARY KEY CLUSTERED 
(
	[PartsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[PartsCategory]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PartsCategory](
	[PartsCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[PartsCategoryName] [varchar](30) NOT NULL,
 CONSTRAINT [PK_PartsCategory_PartsCategoryID] PRIMARY KEY CLUSTERED 
(
	[PartsCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[PostalCode]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PostalCode](
	[PostalCodeID] [int] IDENTITY(1,1) NOT NULL,
	[PostalCode] [varchar](10) NOT NULL,
	[City] [varchar](100) NOT NULL,
	[CountryCode] [char](2) NOT NULL,
 CONSTRAINT [PK_PostalCode_PostalCodeID] PRIMARY KEY CLUSTERED 
(
	[PostalCodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[Service]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Service](
	[ServiceID] [int] IDENTITY(1,1) NOT NULL,
	[ServiceName] [varchar](30) NOT NULL,
	[ServicePreis] [money] NOT NULL,
	[FromDate] [date] NOT NULL,
	[ToDate] [date] NULL,
 CONSTRAINT [PK_Service_ServiceID] PRIMARY KEY CLUSTERED 
(
	[ServiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[ServiceOrder]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceOrder](
	[ServiceOrderID] [int] IDENTITY(1,1) NOT NULL,
	[ServiceOrderNo] [int] NULL,
	[PartnerID] [int] NOT NULL,
	[BuildingID] [int] NOT NULL,
	[OrderDate] [date] NOT NULL,
	[ContractID] [int] NOT NULL,
	[ContractTypeID] [tinyint] NOT NULL,
	[PaymentTypeID] [tinyint] NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[ServiceID] [int] NOT NULL,
 CONSTRAINT [PK_ServiceOrder_ServiceOrderID] PRIMARY KEY CLUSTERED 
(
	[ServiceOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[Stock]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stock](
	[StockID] [int] IDENTITY(1,1) NOT NULL,
	[PartsID] [int] NULL,
	[Piece] [smallint] NULL,
	[StorageID] [int] NULL,
 CONSTRAINT [PK_Stock_StockID] PRIMARY KEY CLUSTERED 
(
	[StockID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
/****** Object:  Table [dbo].[Storage]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Storage](
	[StorageID] [int] IDENTITY(1,1) NOT NULL,
	[CarID] [int] NULL,
	[StorageName] [varchar](30) NULL,
	[StorageCountryCode] [char](2) NOT NULL,
	[StoragePostalCode] [varchar](10) NOT NULL,
	[StorageCity] [varchar](30) NOT NULL,
	[StorageAdress] [varchar](50) NOT NULL,
	[PaymentTypeID] [tinyint] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[IsOwn] [bit] NOT NULL,
	[IsRent] [bit] NOT NULL,
 CONSTRAINT [PK_Storage_StorageID] PRIMARY KEY CLUSTERED 
(
	[StorageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
) ON [LFonta_Data]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NonClusteredIndexBulding]    Script Date: 2021. 08. 16. 14:54:17 ******/
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndexBulding] ON [dbo].[Building]
(
	[BuildingCity] ASC,
	[BuildingAdress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NonClusteredIndex]    Script Date: 2021. 08. 16. 14:54:17 ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex] ON [dbo].[Partner]
(
	[PartnerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
/****** Object:  Index [NonClusteredIndex]    Script Date: 2021. 08. 16. 14:54:17 ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex] ON [dbo].[Person]
(
	[PersonName] ASC,
	[PersonPhoneNumber] ASC,
	[PersonEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [LFonta_Data]
GO
ALTER TABLE [dbo].[Invoice] ADD  CONSTRAINT [DF_LFontatest_Invoice_InvoiceDate]  DEFAULT (sysdatetime()) FOR [InvoiceDate]
GO
ALTER TABLE [dbo].[Invoice] ADD  CONSTRAINT [DF_LFontatest_Invoice_PaymentTypeID]  DEFAULT ((3)) FOR [PaymentTypeID]
GO
ALTER TABLE [dbo].[Movement] ADD  CONSTRAINT [DF_Movement_MovementDate]  DEFAULT (sysdatetime()) FOR [MovementDate]
GO
ALTER TABLE [dbo].[Movement] ADD  CONSTRAINT [DF_Movement_ModifyDate]  DEFAULT (sysdatetime()) FOR [ModifyDate]
GO
ALTER TABLE [dbo].[Building]  WITH NOCHECK ADD  CONSTRAINT [FK_Building_Device_DeviceID] FOREIGN KEY([DeviceID])
REFERENCES [dbo].[Device] ([DeviceID])
GO
ALTER TABLE [dbo].[Building] CHECK CONSTRAINT [FK_Building_Device_DeviceID]
GO
ALTER TABLE [dbo].[Building]  WITH NOCHECK ADD  CONSTRAINT [FK_Building_DictCountry_CountryCode] FOREIGN KEY([BuildingCountryCode])
REFERENCES [dbo].[DictCountry] ([CountryCode])
GO
ALTER TABLE [dbo].[Building] CHECK CONSTRAINT [FK_Building_DictCountry_CountryCode]
GO
ALTER TABLE [dbo].[Building]  WITH NOCHECK ADD  CONSTRAINT [FK_Building_Partner_PartnerID] FOREIGN KEY([ParterID])
REFERENCES [dbo].[Partner] ([PartnerID])
GO
ALTER TABLE [dbo].[Building] CHECK CONSTRAINT [FK_Building_Partner_PartnerID]
GO
ALTER TABLE [dbo].[Building]  WITH NOCHECK ADD  CONSTRAINT [FK_Building_PartnerContPerson_PartnerContPersonID] FOREIGN KEY([PartnerContPersonID])
REFERENCES [dbo].[PartnerContPerson] ([PartnerContPersonID])
GO
ALTER TABLE [dbo].[Building] CHECK CONSTRAINT [FK_Building_PartnerContPerson_PartnerContPersonID]
GO
ALTER TABLE [dbo].[Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract_DictContract_ContractTypeID] FOREIGN KEY([ContractTypeID])
REFERENCES [dbo].[DictContract] ([ContractTypeID])
GO
ALTER TABLE [dbo].[Contract] CHECK CONSTRAINT [FK_Contract_DictContract_ContractTypeID]
GO
ALTER TABLE [dbo].[Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract_DictPaymentType_PaymentTypeID] FOREIGN KEY([PaymentTypeID])
REFERENCES [dbo].[DictPaymentType] ([PaymentTypeID])
GO
ALTER TABLE [dbo].[Contract] CHECK CONSTRAINT [FK_Contract_DictPaymentType_PaymentTypeID]
GO
ALTER TABLE [dbo].[Employee]  WITH NOCHECK ADD  CONSTRAINT [FK_Employee_DictCountry_CountryCode] FOREIGN KEY([EmployeeCountryCodeI])
REFERENCES [dbo].[DictCountry] ([CountryCode])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_DictCountry_CountryCode]
GO
ALTER TABLE [dbo].[Employee]  WITH NOCHECK ADD  CONSTRAINT [FK_Employee_DictGender_GenderCode] FOREIGN KEY([GenderCode])
REFERENCES [dbo].[DictGender] ([GenderCode])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_DictGender_GenderCode]
GO
ALTER TABLE [dbo].[Employee]  WITH NOCHECK ADD  CONSTRAINT [FK_Employee_DictUser_UserID] FOREIGN KEY([UserID])
REFERENCES [dbo].[DictUser] ([UserID])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_DictUser_UserID]
GO
ALTER TABLE [dbo].[EmployeeCar]  WITH NOCHECK ADD  CONSTRAINT [FK_EmployeeCar_Car_CarID] FOREIGN KEY([CarID])
REFERENCES [dbo].[Car] ([CarID])
GO
ALTER TABLE [dbo].[EmployeeCar] CHECK CONSTRAINT [FK_EmployeeCar_Car_CarID]
GO
ALTER TABLE [dbo].[EmployeeCar]  WITH NOCHECK ADD  CONSTRAINT [FK_EmployeeCar_Employee_EmployeeID] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([EmployeeID])
GO
ALTER TABLE [dbo].[EmployeeCar] CHECK CONSTRAINT [FK_EmployeeCar_Employee_EmployeeID]
GO
ALTER TABLE [dbo].[Movement]  WITH NOCHECK ADD  CONSTRAINT [FK_Movement_DictMovement_MovementTypeID] FOREIGN KEY([MovementTypeID])
REFERENCES [dbo].[DictMovement] ([MovementTypeID])
GO
ALTER TABLE [dbo].[Movement] CHECK CONSTRAINT [FK_Movement_DictMovement_MovementTypeID]
GO
ALTER TABLE [dbo].[Movement]  WITH NOCHECK ADD  CONSTRAINT [FK_Movement_Parts_PartsID] FOREIGN KEY([PartsID])
REFERENCES [dbo].[Parts] ([PartsID])
GO
ALTER TABLE [dbo].[Movement] CHECK CONSTRAINT [FK_Movement_Parts_PartsID]
GO
ALTER TABLE [dbo].[Partner]  WITH NOCHECK ADD  CONSTRAINT [FK_Partner_DictCountry_CountryCode] FOREIGN KEY([PartnerCountryCode])
REFERENCES [dbo].[DictCountry] ([CountryCode])
GO
ALTER TABLE [dbo].[Partner] CHECK CONSTRAINT [FK_Partner_DictCountry_CountryCode]
GO
ALTER TABLE [dbo].[Partner]  WITH NOCHECK ADD  CONSTRAINT [FK_Partner_DictVAT_VATID] FOREIGN KEY([VATID])
REFERENCES [dbo].[DictVAT] ([VATID])
GO
ALTER TABLE [dbo].[Partner] CHECK CONSTRAINT [FK_Partner_DictVAT_VATID]
GO
ALTER TABLE [dbo].[PartnerContPerson]  WITH NOCHECK ADD  CONSTRAINT [FK_PartnerContPerson_Partner_PartnerID] FOREIGN KEY([PartnerID])
REFERENCES [dbo].[Partner] ([PartnerID])
GO
ALTER TABLE [dbo].[PartnerContPerson] CHECK CONSTRAINT [FK_PartnerContPerson_Partner_PartnerID]
GO
ALTER TABLE [dbo].[PartnerContPerson]  WITH NOCHECK ADD  CONSTRAINT [FK_PartnerContPerson_Person_PersonID] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PartnerContPerson] CHECK CONSTRAINT [FK_PartnerContPerson_Person_PersonID]
GO
ALTER TABLE [dbo].[Parts]  WITH NOCHECK ADD  CONSTRAINT [FK_Parts_PartsCategory_PartsCategoryID] FOREIGN KEY([PartsCategoryID])
REFERENCES [dbo].[PartsCategory] ([PartsCategoryID])
GO
ALTER TABLE [dbo].[Parts] CHECK CONSTRAINT [FK_Parts_PartsCategory_PartsCategoryID]
GO
ALTER TABLE [dbo].[Person]  WITH NOCHECK ADD  CONSTRAINT [FK_Person_DictGender_GenderCode] FOREIGN KEY([GenderCode])
REFERENCES [dbo].[DictGender] ([GenderCode])
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_DictGender_GenderCode]
GO
ALTER TABLE [dbo].[ServiceOrder]  WITH NOCHECK ADD  CONSTRAINT [FK_ServiceOrder_Building_BuildingID] FOREIGN KEY([BuildingID])
REFERENCES [dbo].[Building] ([BuildingID])
GO
ALTER TABLE [dbo].[ServiceOrder] CHECK CONSTRAINT [FK_ServiceOrder_Building_BuildingID]
GO
ALTER TABLE [dbo].[ServiceOrder]  WITH NOCHECK ADD  CONSTRAINT [FK_ServiceOrder_Contract_ContractID] FOREIGN KEY([ContractID])
REFERENCES [dbo].[Contract] ([ContractID])
GO
ALTER TABLE [dbo].[ServiceOrder] CHECK CONSTRAINT [FK_ServiceOrder_Contract_ContractID]
GO
ALTER TABLE [dbo].[ServiceOrder]  WITH NOCHECK ADD  CONSTRAINT [FK_ServiceOrder_DictContract_ContractTypeID] FOREIGN KEY([ContractTypeID])
REFERENCES [dbo].[DictContract] ([ContractTypeID])
GO
ALTER TABLE [dbo].[ServiceOrder] CHECK CONSTRAINT [FK_ServiceOrder_DictContract_ContractTypeID]
GO
ALTER TABLE [dbo].[ServiceOrder]  WITH NOCHECK ADD  CONSTRAINT [FK_ServiceOrder_Partner_PartnerID] FOREIGN KEY([PartnerID])
REFERENCES [dbo].[Partner] ([PartnerID])
GO
ALTER TABLE [dbo].[ServiceOrder] CHECK CONSTRAINT [FK_ServiceOrder_Partner_PartnerID]
GO
ALTER TABLE [dbo].[ServiceOrder]  WITH NOCHECK ADD  CONSTRAINT [FK_ServiceOrder_Service_ServiceID] FOREIGN KEY([ServiceID])
REFERENCES [dbo].[Service] ([ServiceID])
GO
ALTER TABLE [dbo].[ServiceOrder] CHECK CONSTRAINT [FK_ServiceOrder_Service_ServiceID]
GO
ALTER TABLE [dbo].[Stock]  WITH NOCHECK ADD  CONSTRAINT [FK_Stock_Parts_PartsID] FOREIGN KEY([PartsID])
REFERENCES [dbo].[Parts] ([PartsID])
GO
ALTER TABLE [dbo].[Stock] CHECK CONSTRAINT [FK_Stock_Parts_PartsID]
GO
ALTER TABLE [dbo].[Stock]  WITH NOCHECK ADD  CONSTRAINT [FK_Stock_Storage_StorageID] FOREIGN KEY([StorageID])
REFERENCES [dbo].[Storage] ([StorageID])
GO
ALTER TABLE [dbo].[Stock] CHECK CONSTRAINT [FK_Stock_Storage_StorageID]
GO
ALTER TABLE [dbo].[Storage]  WITH NOCHECK ADD  CONSTRAINT [FK_Storage_Car_CarID] FOREIGN KEY([CarID])
REFERENCES [dbo].[Car] ([CarID])
GO
ALTER TABLE [dbo].[Storage] CHECK CONSTRAINT [FK_Storage_Car_CarID]
GO
ALTER TABLE [dbo].[Storage]  WITH NOCHECK ADD  CONSTRAINT [FK_Storage_DictCountry_CountryCode] FOREIGN KEY([StorageCountryCode])
REFERENCES [dbo].[DictCountry] ([CountryCode])
GO
ALTER TABLE [dbo].[Storage] CHECK CONSTRAINT [FK_Storage_DictCountry_CountryCode]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [CHK_LFontatest_Emloyee_EmployeeBankAccountNo24] CHECK  ((len([EmployeeBankAccountNo])=(24) OR len([EmployeeBankAccountNo])=(16)))
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [CHK_LFontatest_Emloyee_EmployeeBankAccountNo24]
GO
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD  CONSTRAINT [CHK_LFontatest_Invoice_InvoiceDate] CHECK  (([InvoiceDate]<=sysdatetime()))
GO
ALTER TABLE [dbo].[Invoice] CHECK CONSTRAINT [CHK_LFontatest_Invoice_InvoiceDate]
GO
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD  CONSTRAINT [CHK_LFontatest_Invoice_PaymentTypeID] CHECK  (([PaymentTypeID]>=(1) AND [PaymentTypeID]<=(3)))
GO
ALTER TABLE [dbo].[Invoice] CHECK CONSTRAINT [CHK_LFontatest_Invoice_PaymentTypeID]
GO
/****** Object:  StoredProcedure [dbo].[InsertBuilding]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create   Proc [dbo].[InsertBuilding]
@PartnerID int=Null,
@PartnerConPersonID int=Null,
@BulildingCountryCod char(2)=Null,
@BuildingPostalCode varchar(10)=Null,
@BuildingCity varchar(30)=Null,
@BuildingAdress varchar(50)=Null,
@BuildingComponent char(8),
@BuildingLevel char(3),
@RoomNo varchar(30),
@DeviceID int=Null,
@DeviceMedium varchar(20),
@DeviceHeatOrCool varchar(20),
@ContractTypeID tinyint=Null,
@PaymentTypeID tinyint=Null,
@DevicePicture varchar(300),
@GPS geography
As
Begin
IF Len(@BuildingPostalCode)<>4
Return 1
Else
Insert Building(ParterID,PartnerContPersonID,BuildingCountryCode,BuildingPostalCode,BuildingCity,BuildingAdress,BuildingComponent,BuildingLevel,RoomNo,DeviceID,DeviceMedium,DeviceHeatOrCool,ContractTypeID,PaymentTypeID,DevicePicture,GPS)
Values (@PartnerID,@PartnerConPersonID,@BulildingCountryCod,@BuildingPostalCode,@BuildingCity,@BuildingAdress,@BuildingComponent,@BuildingLevel,@RoomNo,@DeviceID,@DeviceMedium,@DeviceHeatOrCool,@ContractTypeID,@PaymentTypeID,@DevicePicture,@GPS)
End
GO
/****** Object:  StoredProcedure [dbo].[InsertMovement]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create   Proc [dbo].[InsertMovement]
@MovementTypeID tinyint=Null,
@PartsID int=Null,
@MovementDate datetime2,
@FromStorageID int,
@ToStorageID int,
@Amount int=NULL
As
Begin
Insert Movement(MovementTypeID, PartsID, MovementDate, FromStorageID, ToStorageID,Amount)
Values (@MovementTypeID,@PartsID,@MovementDate, @FromStorageID, @ToStorageID, @Amount)
End
GO
/****** Object:  StoredProcedure [dbo].[InsertParts]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create   Proc [dbo].[InsertParts]
@PartsNo int=Null,
@PartsName varchar(30)=Null,
@Weight int,
@PartsCategoryID int =Null,
@Price money
As
Begin
IF Len(@PartsNo)<>7
Return 1
Else If Len(@Price)<0
Return 2
Else If Exists(Select* From Parts Where Parts.PartsNo=@PartsNo)
Return 3
Else
Insert Parts(PartsNo, PartsName, Weight, PartsCategoryID, Price)
Values (@PartsNo, @PartsName, @Weight,@PartsCategoryID, @Price)
End
GO
/****** Object:  StoredProcedure [dbo].[InsertPerson]    Script Date: 2021. 08. 16. 14:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create   Proc [dbo].[InsertPerson]
@PersonName varchar(103)=Null,
@PersonTitle varchar(10)=Null,
@PersonFirstName varchar(10)=NULL,
@PersonMiddleName varchar(30) =Null,
@PersonLastName varchar(100)=NULL,
@GenderCode int=NULL,
@PersonPhoneNumber varchar=NULL,
@PersonEmail varchar(50)
As
Begin
IF @GenderCode <1 or @GenderCode >2
Return 1
Else If Exists(Select* From Person Where PersonName=@PersonName)
Return 2
Else
Insert Person(PersonTitle,PersonFirstName,PersonMiddleName,PersonLastName,GenderCode,PersonPhoneNumber,PersonEmail)
Values (@PersonTitle,@PersonFirstName,@PersonMiddleName,@PersonLastName,@GenderCode,@PersonPhoneNumber,@PersonEmail)
End
GO
USE [master]
GO
ALTER DATABASE [LFontaVizsga] SET  READ_WRITE 
GO
