USE master;
GO
IF DB_ID('QLSinhVien') IS NOT NULL
BEGIN
    ALTER DATABASE QLSinhVien SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QLSinhVien;
END
GO
CREATE DATABASE QLSinhVien;
GO
USE QLSinhVien;
GO

/* ---------- KHOA & MÔN HỌC ---------- */
CREATE TABLE Khoa (
    MaKhoa        VARCHAR(10)   NOT NULL PRIMARY KEY,
    TenKhoa       NVARCHAR(100) NOT NULL UNIQUE,
    NamThanhLap   INT           NULL CHECK (NamThanhLap >= 1900),
    SDT           VARCHAR(15)   NULL
);

CREATE TABLE MonHoc (
    MaMH      VARCHAR(10)   NOT NULL PRIMARY KEY,
    TenMH     NVARCHAR(150) NOT NULL,
    SoTinChi  INT           NOT NULL CHECK (SoTinChi BETWEEN 1 AND 6),
    MaKhoa    VARCHAR(10)   NOT NULL,
    CONSTRAINT FK_MonHoc_Khoa FOREIGN KEY (MaKhoa) REFERENCES Khoa(MaKhoa)
);

/* ---------- GIẢNG VIÊN  ---------- */
CREATE TABLE GiangVien (
    MaGV      VARCHAR(10)   NOT NULL PRIMARY KEY,
    HoTen     NVARCHAR(100) NOT NULL,
    NgaySinh  DATE          NULL,
    GioiTinh  NVARCHAR(3)   NOT NULL CHECK (GioiTinh IN (N'Nam', N'Nữ')),
    HocVi     NVARCHAR(30)  NULL,              
    Email     VARCHAR(100)  NULL UNIQUE,
    MaKhoa    VARCHAR(10)   NOT NULL,
    CONSTRAINT FK_GiangVien_Khoa FOREIGN KEY (MaKhoa) REFERENCES Khoa(MaKhoa)
);

/* ---------- SINH VIÊN ---------- */
CREATE TABLE Lop (
    MaLop    VARCHAR(10)  NOT NULL PRIMARY KEY,
    TenLop   NVARCHAR(50) NOT NULL,
    KhoaHoc  INT          NOT NULL,            
    MaKhoa   VARCHAR(10)  NOT NULL,
    MaGVCN   VARCHAR(10)  NULL,               
    CONSTRAINT FK_Lop_Khoa FOREIGN KEY (MaKhoa) REFERENCES Khoa(MaKhoa),
    CONSTRAINT FK_Lop_GVCN FOREIGN KEY (MaGVCN) REFERENCES GiangVien(MaGV)
);

CREATE TABLE SinhVien (
    MaSV      VARCHAR(10)   NOT NULL PRIMARY KEY,
    HoTen     NVARCHAR(100) NOT NULL,
    NgaySinh  DATE          NOT NULL,
    GioiTinh  NVARCHAR(3)   NOT NULL CHECK (GioiTinh IN (N'Nam', N'Nữ')),
    DiaChi    NVARCHAR(200) NULL,
    Email     VARCHAR(100)  NULL UNIQUE,
    SDT       VARCHAR(15)   NULL,
    MaLop     VARCHAR(10)   NOT NULL,
    CONSTRAINT FK_SinhVien_Lop FOREIGN KEY (MaLop) REFERENCES Lop(MaLop)
);

/* ---------- GIẢNG VIÊN & LỚP HỌC PHẦN ---------- */

CREATE TABLE LopHocPhan (
    MaLHP      VARCHAR(10)  NOT NULL PRIMARY KEY,
    MaMH       VARCHAR(10)  NOT NULL,
    MaGV       VARCHAR(10)  NOT NULL,
    HocKy      INT          NOT NULL CHECK (HocKy IN (1, 2, 3)),
    NamHoc     VARCHAR(9)   NOT NULL,          
    PhongHoc   VARCHAR(10)  NULL,
    SiSoToiDa  INT          NOT NULL DEFAULT 60 CHECK (SiSoToiDa > 0),
    CONSTRAINT FK_LHP_MonHoc   FOREIGN KEY (MaMH) REFERENCES MonHoc(MaMH),
    CONSTRAINT FK_LHP_GiangVien FOREIGN KEY (MaGV) REFERENCES GiangVien(MaGV)
);

/* ---------- ĐĂNG KÝ MÔN HỌC & KẾT QUẢ ---------- */
CREATE TABLE DangKy (
    MaSV        VARCHAR(10) NOT NULL,
    MaLHP       VARCHAR(10) NOT NULL,
    NgayDangKy  DATE        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_DangKy PRIMARY KEY (MaSV, MaLHP),
    CONSTRAINT FK_DangKy_SV  FOREIGN KEY (MaSV)  REFERENCES SinhVien(MaSV),
    CONSTRAINT FK_DangKy_LHP FOREIGN KEY (MaLHP) REFERENCES LopHocPhan(MaLHP)
);

CREATE TABLE KetQua (
    MaSV    VARCHAR(10)  NOT NULL,
    MaLHP   VARCHAR(10)  NOT NULL,
    DiemCC  DECIMAL(4,2) NULL CHECK (DiemCC BETWEEN 0 AND 10),   
    DiemGK  DECIMAL(4,2) NULL CHECK (DiemGK BETWEEN 0 AND 10),  
    DiemCK  DECIMAL(4,2) NULL CHECK (DiemCK BETWEEN 0 AND 10),   
    DiemTK  AS CAST(ROUND(DiemCC*0.1 + DiemGK*0.3 + DiemCK*0.6, 2) AS DECIMAL(4,2)) PERSISTED,
    CONSTRAINT PK_KetQua PRIMARY KEY (MaSV, MaLHP),
    CONSTRAINT FK_KetQua_DangKy FOREIGN KEY (MaSV, MaLHP) REFERENCES DangKy(MaSV, MaLHP)
);
GO