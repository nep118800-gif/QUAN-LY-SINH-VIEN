USE QLSinhVien;
GO

/* ---------- Khoa ---------- */
INSERT INTO Khoa (MaKhoa, TenKhoa, NamThanhLap, SDT) VALUES
('CNTT', N'Công nghệ thông tin',  2000, '0251111111'),
('KT',   N'Kinh tế',              1998, '0251222222'),
('NN',   N'Ngoại ngữ',            2003, '0251333333'),
('DT',   N'Điện - Điện tử',       1999, '0251444444'),
('SP',   N'Sư phạm',              2010, '0251555555');  

/* ---------- Môn học ---------- */
INSERT INTO MonHoc (MaMH, TenMH, SoTinChi, MaKhoa) VALUES
('MH001', N'Cơ sở dữ liệu',                    3, 'CNTT'),
('MH002', N'Cấu trúc dữ liệu và giải thuật',   3, 'CNTT'),
('MH003', N'Lập trình C++',                    3, 'CNTT'),
('MH004', N'Kinh tế vi mô',                    3, 'KT'),
('MH005', N'Nguyên lý kế toán',                3, 'KT'),
('MH006', N'Tiếng Anh chuyên ngành',           2, 'NN'),
('MH007', N'Mạch điện tử',                     3, 'DT'),
('MH008', N'Toán rời rạc',                     3, 'CNTT'),
('MH009', N'Trí tuệ nhân tạo',                 3, 'CNTT');  

/* ---------- Giảng viên ---------- */
INSERT INTO GiangVien (MaGV, HoTen, NgaySinh, GioiTinh, HocVi, Email, MaKhoa) VALUES
('GV001', N'Nguyễn Thanh Tùng', '1980-04-10', N'Nam', N'Tiến sĩ',  'tung.nt@university.edu.vn',  'CNTT'),
('GV002', N'Trần Thị Thu Hà',   '1985-09-22', N'Nữ',  N'Thạc sĩ', 'ha.ttt@university.edu.vn',   'CNTT'),
('GV003', N'Lê Văn Khánh',      '1978-01-15', N'Nam', N'Tiến sĩ',  'khanh.lv@university.edu.vn', 'KT'),
('GV004', N'Phạm Thị Mai',      '1988-06-30', N'Nữ',  N'Thạc sĩ', 'mai.pt@university.edu.vn',   'NN'),
('GV005', N'Hoàng Minh Nhật',   '1983-11-05', N'Nam', N'Thạc sĩ', 'nhat.hm@university.edu.vn',  'DT'),
('GV006', N'Đinh Quang Vinh',   '1990-02-27', N'Nam', N'Thạc sĩ', 'vinh.dq@university.edu.vn',  'CNTT'),
('GV007', N'Ngô Thị Yến',       '1987-08-12', N'Nữ',  N'Thạc sĩ', 'yen.nt@university.edu.vn',   'KT');  

/* ---------- Lớp sinh hoạt ---------- */
INSERT INTO Lop (MaLop, TenLop, KhoaHoc, MaKhoa, MaGVCN) VALUES
('CNTT01', N'Công nghệ thông tin 01', 2023, 'CNTT', 'GV001'),
('CNTT02', N'Công nghệ thông tin 02', 2023, 'CNTT', 'GV002'),
('KT01',   N'Kinh tế 01',             2023, 'KT',   'GV003'),
('KT02',   N'Kinh tế 02',             2024, 'KT',   NULL),    
('NN01',   N'Ngoại ngữ 01',           2023, 'NN',   'GV004'),
('DT01',   N'Điện - Điện tử 01',      2024, 'DT',   'GV005');

/* ---------- Sinh viên ---------- */
INSERT INTO SinhVien (MaSV, HoTen, NgaySinh, GioiTinh, DiaChi, Email, SDT, MaLop) VALUES
('SV001', N'Nguyễn Văn An',     '2005-03-12', N'Nam', N'Đồng Xoài, Bình Phước', 'an.nv@student.edu.vn',    '0901000001', 'CNTT01'),
('SV002', N'Trần Thị Bình',     '2005-07-25', N'Nữ',  N'Biên Hòa, Đồng Nai',    'binh.tt@student.edu.vn',  '0901000002', 'CNTT01'),
('SV003', N'Lê Hoàng Cường',    '2004-11-02', N'Nam', N'Thủ Đức, TP.HCM',       'cuong.lh@student.edu.vn', '0901000003', 'CNTT01'),
('SV004', N'Phạm Minh Dũng',    '2005-01-18', N'Nam', N'Long Khánh, Đồng Nai',  'dung.pm@student.edu.vn',  '0901000004', 'CNTT02'),
('SV005', N'Võ Thị Em',         '2005-09-09', N'Nữ',  N'Bình Dương',            'em.vt@student.edu.vn',    '0901000005', 'CNTT02'),
('SV006', N'Đặng Quốc Phong',   '2005-05-30', N'Nam', N'Vũng Tàu',              'phong.dq@student.edu.vn', '0901000006', 'KT01'),
('SV007', N'Bùi Thị Giang',     '2005-12-14', N'Nữ',  N'Đồng Xoài, Bình Phước', 'giang.bt@student.edu.vn', '0901000007', 'KT01'),
('SV008', N'Hoàng Văn Hải',     '2004-08-21', N'Nam', N'Tây Ninh',              'hai.hv@student.edu.vn',   '0901000008', 'KT01'),
('SV009', N'Ngô Thị Hương',     '2006-02-05', N'Nữ',  N'Biên Hòa, Đồng Nai',    'huong.nt@student.edu.vn', '0901000009', 'KT02'),
('SV010', N'Đỗ Anh Khoa',       '2006-04-17', N'Nam', N'Thủ Đức, TP.HCM',       'khoa.da@student.edu.vn',  '0901000010', 'KT02'),
('SV011', N'Lý Thị Lan',        '2005-06-11', N'Nữ',  N'Bình Dương',            'lan.lt@student.edu.vn',   '0901000011', 'NN01'),
('SV012', N'Trương Văn Minh',   '2005-10-03', N'Nam', N'Đồng Xoài, Bình Phước', 'minh.tv@student.edu.vn',  '0901000012', 'NN01'),
('SV013', N'Phan Thị Ngọc',     '2004-12-28', N'Nữ',  N'Long An',               'ngoc.pt@student.edu.vn',  '0901000013', 'NN01'),
('SV014', N'Vũ Đức Phát',       '2006-03-08', N'Nam', N'Biên Hòa, Đồng Nai',    'phat.vd@student.edu.vn',  '0901000014', 'DT01'),
('SV015', N'Mai Thị Quỳnh',     '2006-07-19', N'Nữ',  N'Vũng Tàu',              'quynh.mt@student.edu.vn', '0901000015', 'DT01'),
('SV016', N'Cao Văn Sơn',       '2005-03-12', N'Nam', N'Đồng Xoài, Bình Phước', 'son.cv@student.edu.vn',   NULL, 'CNTT02');  

/* ---------- Lớp học phần ---------- */
INSERT INTO LopHocPhan (MaLHP, MaMH, MaGV, HocKy, NamHoc, PhongHoc, SiSoToiDa) VALUES
('LHP001', 'MH001', 'GV001', 1, '2025-2026', 'A101', 60),
('LHP002', 'MH002', 'GV002', 1, '2025-2026', 'A102', 60),
('LHP003', 'MH003', 'GV006', 1, '2025-2026', 'B201', 50),
('LHP004', 'MH004', 'GV003', 1, '2025-2026', 'C101', 80),
('LHP005', 'MH005', 'GV003', 1, '2025-2026', 'C102', 80),
('LHP006', 'MH006', 'GV004', 1, '2025-2026', 'D101', 40),
('LHP007', 'MH007', 'GV005', 1, '2025-2026', 'E101', 50),
('LHP008', 'MH008', 'GV002', 1, '2025-2026', 'A103', 60),
('LHP009', 'MH003', 'GV006', 2, '2024-2025', 'B201', 50),
('LHP010', 'MH008', 'GV002', 2, '2024-2025', 'A103', 60);

/* ---------- Đăng ký ---------- */
INSERT INTO DangKy (MaSV, MaLHP, NgayDangKy) VALUES
-- HK2 2024-2025
('SV001','LHP009','2025-01-10'), ('SV002','LHP009','2025-01-10'),
('SV003','LHP009','2025-01-11'), ('SV004','LHP009','2025-01-11'),
('SV001','LHP010','2025-01-12'), ('SV002','LHP010','2025-01-12'),
('SV003','LHP010','2025-01-13'),
-- HK1 2025-2026
('SV001','LHP001','2025-08-20'), ('SV002','LHP001','2025-08-20'),
('SV003','LHP001','2025-08-21'), ('SV004','LHP001','2025-08-21'),
('SV005','LHP001','2025-08-22'),
('SV001','LHP002','2025-08-20'), ('SV002','LHP002','2025-08-20'),
('SV004','LHP002','2025-08-21'), ('SV005','LHP002','2025-08-22'),
('SV002','LHP003','2025-08-20'), ('SV003','LHP003','2025-08-21'),
('SV005','LHP003','2025-08-22'),
('SV006','LHP004','2025-08-23'), ('SV007','LHP004','2025-08-23'),
('SV008','LHP004','2025-08-24'),
('SV006','LHP005','2025-08-23'), ('SV007','LHP005','2025-08-23'),
('SV009','LHP005','2025-08-24'), ('SV010','LHP005','2025-08-24'),
('SV011','LHP006','2025-08-25'), ('SV012','LHP006','2025-08-25'),
('SV013','LHP006','2025-08-26'),
('SV014','LHP007','2025-08-26'), ('SV015','LHP007','2025-08-26'),
('SV001','LHP008','2025-08-27'), ('SV003','LHP008','2025-08-27'),
('SV004','LHP008','2025-08-27');   

/* ---------- Kết quả  ---------- */
INSERT INTO KetQua (MaSV, MaLHP, DiemCC, DiemGK, DiemCK) VALUES
('SV001','LHP009',9,8,8.5), ('SV002','LHP009',8,7,7.5),
('SV003','LHP009',7,6,5.5), ('SV004','LHP009',6,4,3.5),
('SV001','LHP010',9,9,9),   ('SV002','LHP010',8,6.5,7),
('SV003','LHP010',7,5,4.5),
('SV001','LHP001',9,8.5,9), ('SV002','LHP001',8,7,6.5),
('SV003','LHP001',7,6,5),   ('SV004','LHP001',8,7.5,8),
('SV005','LHP001',6,5,4),
('SV001','LHP002',9,8,8),   ('SV002','LHP002',7,6.5,7),
('SV004','LHP002',8,8,8.5), ('SV005','LHP002',5,4,3),
('SV002','LHP003',8,7,7.5), ('SV003','LHP003',7,6.5,6),
('SV005','LHP003',9,9,9.5),
('SV006','LHP004',8,7,7),   ('SV007','LHP004',7,6,6.5),
('SV008','LHP004',9,8.5,9),
('SV006','LHP005',8,7.5,8), ('SV007','LHP005',6,5,4.5),
('SV009','LHP005',9,9,8.5), ('SV010','LHP005',7,6,6),
('SV011','LHP006',8,8,8.5), ('SV012','LHP006',7,7,7),
('SV013','LHP006',9,8,9),
('SV014','LHP007',8,7,7),   ('SV015','LHP007',6,5.5,5);
GO