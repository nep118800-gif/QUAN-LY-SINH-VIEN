USE QLSinhVien;
GO

CREATE OR ALTER VIEW vw_DiemTBSV AS
SELECT kq.MaSV,
       CAST(SUM(kq.DiemTK * m.SoTinChi) / SUM(m.SoTinChi) AS DECIMAL(4,2)) AS DiemTB
FROM KetQua kq
JOIN LopHocPhan lhp ON kq.MaLHP = lhp.MaLHP
JOIN MonHoc m ON lhp.MaMH = m.MaMH
WHERE kq.DiemTK IS NOT NULL
GROUP BY kq.MaSV;
GO

/* PHẦN 1. QUẢN LÝ SINH VIÊN */
-- Danh sách tất cả sinh viên
SELECT * FROM SinhVien;

-- Mã SV, họ tên, ngày sinh, giới tính
SELECT MaSV, HoTen, NgaySinh, GioiTinh FROM SinhVien;

-- Tìm sinh viên theo mã
SELECT * FROM SinhVien WHERE MaSV = 'SV001';

-- Tìm sinh viên theo họ tên
SELECT * FROM SinhVien WHERE HoTen LIKE N'%Nguyễn Văn An%';

-- Sinh viên nam
SELECT * FROM SinhVien WHERE GioiTinh = N'Nam';

-- Sinh viên nữ
SELECT * FROM SinhVien WHERE GioiTinh = N'Nữ';

-- Sinh viên có ngày sinh trong một khoảng thời gian
SELECT MaSV, HoTen, NgaySinh FROM SinhVien
WHERE NgaySinh BETWEEN '2005-01-01' AND '2005-06-30';

-- Sắp xếp theo ngày sinh tăng dần
SELECT MaSV, HoTen, NgaySinh FROM SinhVien ORDER BY NgaySinh ASC;

-- Sinh viên thuộc một khoa cụ thể (CNTT)
SELECT sv.MaSV, sv.HoTen, l.TenLop, k.TenKhoa
FROM SinhVien sv
JOIN Lop l  ON sv.MaLop = l.MaLop
JOIN Khoa k ON l.MaKhoa = k.MaKhoa
WHERE k.MaKhoa = 'CNTT';

-- Sinh viên có email thuộc một tên miền
SELECT MaSV, HoTen, Email FROM SinhVien WHERE Email LIKE '%@student.edu.vn';

-- Tổng số sinh viên
SELECT COUNT(*) AS TongSinhVien FROM SinhVien;

-- Số lượng sinh viên theo giới tính
SELECT GioiTinh, COUNT(*) AS SoLuong FROM SinhVien GROUP BY GioiTinh;

-- Số lượng sinh viên theo khóa học
SELECT l.KhoaHoc, COUNT(sv.MaSV) AS SoLuong
FROM Lop l
JOIN SinhVien sv ON sv.MaLop = l.MaLop
GROUP BY l.KhoaHoc
ORDER BY l.KhoaHoc;

-- Số lượng sinh viên theo từng lớp
SELECT l.MaLop, l.TenLop, COUNT(sv.MaSV) AS SoLuong
FROM Lop l
LEFT JOIN SinhVien sv ON sv.MaLop = l.MaLop
GROUP BY l.MaLop, l.TenLop;

-- Sinh viên có năm sinh sớm nhất và muộn nhất
SELECT MaSV, HoTen, NgaySinh
FROM SinhVien
WHERE YEAR(NgaySinh) IN (SELECT MIN(YEAR(NgaySinh)) FROM SinhVien
                         UNION
                         SELECT MAX(YEAR(NgaySinh)) FROM SinhVien)
ORDER BY NgaySinh;

-- Sinh viên có cùng ngày sinh
SELECT MaSV, HoTen, NgaySinh
FROM SinhVien
WHERE NgaySinh IN (SELECT NgaySinh FROM SinhVien GROUP BY NgaySinh HAVING COUNT(*) > 1)
ORDER BY NgaySinh;

-- Sinh viên chưa có email hoặc số điện thoại
SELECT MaSV, HoTen, Email, SDT FROM SinhVien WHERE Email IS NULL OR SDT IS NULL;

-- Khoa có số lượng sinh viên đông nhất
SELECT TOP 1 WITH TIES k.MaKhoa, k.TenKhoa, COUNT(sv.MaSV) AS SoSV
FROM Khoa k
JOIN Lop l ON l.MaKhoa = k.MaKhoa
JOIN SinhVien sv ON sv.MaLop = l.MaLop
GROUP BY k.MaKhoa, k.TenKhoa
ORDER BY COUNT(sv.MaSV) DESC;

-- Sinh viên có email hoặc số điện thoại trùng lặp
SELECT sv.MaSV, sv.HoTen, sv.Email, sv.SDT
FROM SinhVien sv
WHERE EXISTS (SELECT 1 FROM SinhVien s2 WHERE s2.MaSV <> sv.MaSV AND s2.Email = sv.Email)
   OR EXISTS (SELECT 1 FROM SinhVien s2 WHERE s2.MaSV <> sv.MaSV AND s2.SDT   = sv.SDT);

-- Xếp hạng sinh viên theo điểm trung bình từ cao xuống thấp
SELECT RANK() OVER (ORDER BY d.DiemTB DESC) AS Hang, sv.MaSV, sv.HoTen, d.DiemTB
FROM vw_DiemTBSV d
JOIN SinhVien sv ON sv.MaSV = d.MaSV
ORDER BY Hang;

/*  PHẦN 2. QUẢN LÝ MÔN HỌC VÀ KHOA */
--  Danh sách tất cả các khoa
SELECT * FROM Khoa;

-- Danh sách tất cả môn học
SELECT * FROM MonHoc;

-- Tìm khoa theo mã khoa
SELECT * FROM Khoa WHERE MaKhoa = 'CNTT';

-- Tìm môn học theo mã môn
SELECT * FROM MonHoc WHERE MaMH = 'MH001';

-- Tìm môn học theo tên môn
SELECT * FROM MonHoc WHERE TenMH LIKE N'%dữ liệu%';

-- Môn học có số tín chỉ lớn hơn 3
SELECT * FROM MonHoc WHERE SoTinChi > 3;

-- Sắp xếp môn học theo số tín chỉ tăng dần
SELECT * FROM MonHoc ORDER BY SoTinChi ASC, TenMH;

-- Tổng số khoa
SELECT COUNT(*) AS TongSoKhoa FROM Khoa;

-- Tổng số môn học
SELECT COUNT(*) AS TongSoMonHoc FROM MonHoc;

-- Số lượng môn học của từng khoa
SELECT k.MaKhoa, k.TenKhoa, COUNT(m.MaMH) AS SoMon
FROM Khoa k
LEFT JOIN MonHoc m ON m.MaKhoa = k.MaKhoa
GROUP BY k.MaKhoa, k.TenKhoa;

-- Tổng số tín chỉ của tất cả môn học
SELECT SUM(SoTinChi) AS TongTinChi FROM MonHoc;

-- Môn học có số tín chỉ từ 2 đến 4
SELECT * FROM MonHoc WHERE SoTinChi BETWEEN 2 AND 4;

-- Khoa có nhiều môn học nhất
SELECT TOP 1 WITH TIES k.MaKhoa, k.TenKhoa, COUNT(m.MaMH) AS SoMon
FROM Khoa k
JOIN MonHoc m ON m.MaKhoa = k.MaKhoa
GROUP BY k.MaKhoa, k.TenKhoa
ORDER BY COUNT(m.MaMH) DESC;

--  học có số tín chỉ cao nhất
SELECT * FROM MonHoc WHERE SoTinChi = (SELECT MAX(SoTinChi) FROM MonHoc);

-- Tên khoa và các môn học trực thuộc (JOIN)
SELECT k.TenKhoa, m.MaMH, m.TenMH, m.SoTinChi
FROM Khoa k
JOIN MonHoc m ON m.MaKhoa = k.MaKhoa
ORDER BY k.TenKhoa, m.MaMH;

-- Khoa chưa có môn học nào
SELECT k.MaKhoa, k.TenKhoa
FROM Khoa k
WHERE NOT EXISTS (SELECT 1 FROM MonHoc m WHERE m.MaKhoa = k.MaKhoa);

-- Môn học chưa có sinh viên đăng ký
SELECT m.MaMH, m.TenMH
FROM MonHoc m
WHERE NOT EXISTS (SELECT 1
                  FROM LopHocPhan lhp
                  JOIN DangKy dk ON dk.MaLHP = lhp.MaLHP
                  WHERE lhp.MaMH = m.MaMH);

-- Khoa có số môn học nhiều hơn số môn trung bình của các khoa
SELECT k.MaKhoa, k.TenKhoa, COUNT(m.MaMH) AS SoMon
FROM Khoa k
LEFT JOIN MonHoc m ON m.MaKhoa = k.MaKhoa
GROUP BY k.MaKhoa, k.TenKhoa
HAVING COUNT(m.MaMH) > (SELECT AVG(CAST(c.SoMon AS FLOAT))
                        FROM (SELECT COUNT(m2.MaMH) AS SoMon
                              FROM Khoa k2
                              LEFT JOIN MonHoc m2 ON m2.MaKhoa = k2.MaKhoa
                              GROUP BY k2.MaKhoa) c);

-- Môn học có số tín chỉ bằng số tín chỉ cao nhất trong khoa của nó
SELECT m.MaMH, m.TenMH, m.SoTinChi, k.TenKhoa
FROM MonHoc m
JOIN Khoa k ON k.MaKhoa = m.MaKhoa
WHERE m.SoTinChi = (SELECT MAX(m2.SoTinChi) FROM MonHoc m2 WHERE m2.MaKhoa = m.MaKhoa);

-- Xếp hạng khoa theo tổng số tín chỉ của các môn trực thuộc
SELECT RANK() OVER (ORDER BY ISNULL(SUM(m.SoTinChi), 0) DESC) AS Hang,
       k.MaKhoa, k.TenKhoa, ISNULL(SUM(m.SoTinChi), 0) AS TongTinChi
FROM Khoa k
LEFT JOIN MonHoc m ON m.MaKhoa = k.MaKhoa
GROUP BY k.MaKhoa, k.TenKhoa
ORDER BY Hang;

/* PHẦN 3. QUẢN LÝ GIẢNG VIÊN VÀ LỚP */

-- Danh sách tất cả giảng viên
SELECT * FROM GiangVien;

-- Danh sách tất cả các lớp
SELECT * FROM Lop;

-- Tìm giảng viên theo mã
SELECT * FROM GiangVien WHERE MaGV = 'GV001';

-- Tìm giảng viên theo họ tên
SELECT * FROM GiangVien WHERE HoTen LIKE N'%Tùng%';

-- Tìm lớp theo mã lớp
SELECT * FROM Lop WHERE MaLop = 'CNTT01';

-- Danh sách giảng viên theo giới tính
SELECT * FROM GiangVien WHERE GioiTinh = N'Nữ';

-- Sắp xếp giảng viên theo họ tên
SELECT * FROM GiangVien ORDER BY HoTen;

-- Số lượng giảng viên theo từng khoa
SELECT k.MaKhoa, k.TenKhoa, COUNT(gv.MaGV) AS SoGV
FROM Khoa k
LEFT JOIN GiangVien gv ON gv.MaKhoa = k.MaKhoa
GROUP BY k.MaKhoa, k.TenKhoa;

-- Số lượng sinh viên trong từng lớp
SELECT l.MaLop, l.TenLop, COUNT(sv.MaSV) AS SoSV
FROM Lop l
LEFT JOIN SinhVien sv ON sv.MaLop = l.MaLop
GROUP BY l.MaLop, l.TenLop;

-- Lớp có số sinh viên vượt quá 40 (dữ liệu mẫu nhỏ nên có thể rỗng)
SELECT l.MaLop, l.TenLop, COUNT(sv.MaSV) AS SoSV
FROM Lop l
JOIN SinhVien sv ON sv.MaLop = l.MaLop
GROUP BY l.MaLop, l.TenLop
HAVING COUNT(sv.MaSV) > 40;

-- Giảng viên thuộc một khoa cụ thể (CNTT)
SELECT gv.MaGV, gv.HoTen, gv.HocVi
FROM GiangVien gv
WHERE gv.MaKhoa = 'CNTT';

-- Tên lớp và tên giảng viên chủ nhiệm
SELECT l.MaLop, l.TenLop, gv.HoTen AS GiangVienChuNhiem
FROM Lop l
JOIN GiangVien gv ON gv.MaGV = l.MaGVCN;

-- Giảng viên chưa được phân công giảng dạy
SELECT gv.MaGV, gv.HoTen
FROM GiangVien gv
WHERE NOT EXISTS (SELECT 1 FROM LopHocPhan lhp WHERE lhp.MaGV = gv.MaGV);

-- Lớp chưa có giảng viên chủ nhiệm
SELECT MaLop, TenLop FROM Lop WHERE MaGVCN IS NULL;

-- Giảng viên giảng dạy nhiều môn học nhất
SELECT TOP 1 WITH TIES gv.MaGV, gv.HoTen, COUNT(DISTINCT lhp.MaMH) AS SoMon
FROM GiangVien gv
JOIN LopHocPhan lhp ON lhp.MaGV = gv.MaGV
GROUP BY gv.MaGV, gv.HoTen
ORDER BY COUNT(DISTINCT lhp.MaMH) DESC;

-- Lớp có số sinh viên đông nhất
SELECT TOP 1 WITH TIES l.MaLop, l.TenLop, COUNT(sv.MaSV) AS SoSV
FROM Lop l
JOIN SinhVien sv ON sv.MaLop = l.MaLop
GROUP BY l.MaLop, l.TenLop
ORDER BY COUNT(sv.MaSV) DESC;

-- Số lớp do từng giảng viên chủ nhiệm
SELECT gv.MaGV, gv.HoTen, COUNT(l.MaLop) AS SoLopChuNhiem
FROM GiangVien gv
LEFT JOIN Lop l ON l.MaGVCN = gv.MaGV
GROUP BY gv.MaGV, gv.HoTen;

-- Giảng viên có số lớp chủ nhiệm nhiều hơn mức trung bình
SELECT gv.MaGV, gv.HoTen, COUNT(l.MaLop) AS SoLopChuNhiem
FROM GiangVien gv
LEFT JOIN Lop l ON l.MaGVCN = gv.MaGV
GROUP BY gv.MaGV, gv.HoTen
HAVING COUNT(l.MaLop) > (SELECT AVG(CAST(c.SoLop AS FLOAT))
                         FROM (SELECT COUNT(l2.MaLop) AS SoLop
                               FROM GiangVien g2
                               LEFT JOIN Lop l2 ON l2.MaGVCN = g2.MaGV
                               GROUP BY g2.MaGV) c);

--  Xếp hạng các lớp theo số lượng sinh viên
SELECT RANK() OVER (ORDER BY COUNT(sv.MaSV) DESC) AS Hang,
       l.MaLop, l.TenLop, COUNT(sv.MaSV) AS SoSV
FROM Lop l
LEFT JOIN SinhVien sv ON sv.MaLop = l.MaLop
GROUP BY l.MaLop, l.TenLop
ORDER BY Hang;

-- Giảng viên quản lý nhiều sinh viên nhất qua các lớp chủ nhiệm
SELECT TOP 1 WITH TIES gv.MaGV, gv.HoTen, COUNT(sv.MaSV) AS SoSVQuanLy
FROM GiangVien gv
JOIN Lop l ON l.MaGVCN = gv.MaGV
JOIN SinhVien sv ON sv.MaLop = l.MaLop
GROUP BY gv.MaGV, gv.HoTen
ORDER BY COUNT(sv.MaSV) DESC;

/* ĐĂNG KÝ MÔN HỌC VÀ KẾT QUẢ */
-- Danh sách tất cả lượt đăng ký môn học
SELECT dk.MaSV, sv.HoTen, dk.MaLHP, m.TenMH, lhp.HocKy, lhp.NamHoc, dk.NgayDangKy
FROM DangKy dk
JOIN SinhVien sv    ON sv.MaSV = dk.MaSV
JOIN LopHocPhan lhp ON lhp.MaLHP = dk.MaLHP
JOIN MonHoc m       ON m.MaMH = lhp.MaMH
ORDER BY dk.NgayDangKy, dk.MaSV;

-- Môn học mà một sinh viên đã đăng ký (SV001)
SELECT m.MaMH, m.TenMH, lhp.MaLHP, lhp.HocKy, lhp.NamHoc
FROM DangKy dk
JOIN LopHocPhan lhp ON lhp.MaLHP = dk.MaLHP
JOIN MonHoc m       ON m.MaMH = lhp.MaMH
WHERE dk.MaSV = 'SV001';

-- Sinh viên đăng ký một môn học cụ thể (MH001)
SELECT sv.MaSV, sv.HoTen, lhp.MaLHP
FROM DangKy dk
JOIN SinhVien sv    ON sv.MaSV = dk.MaSV
JOIN LopHocPhan lhp ON lhp.MaLHP = dk.MaLHP
WHERE lhp.MaMH = 'MH001';

-- Sinh viên đã đăng ký môn học trong một học kỳ (HK1 2025-2026)
SELECT DISTINCT sv.MaSV, sv.HoTen
FROM DangKy dk
JOIN SinhVien sv    ON sv.MaSV = dk.MaSV
JOIN LopHocPhan lhp ON lhp.MaLHP = dk.MaLHP
WHERE lhp.HocKy = 1 AND lhp.NamHoc = '2025-2026';

-- Sinh viên có điểm thi (điểm cuối kỳ)
SELECT DISTINCT sv.MaSV, sv.HoTen
FROM KetQua kq
JOIN SinhVien sv ON sv.MaSV = kq.MaSV
WHERE kq.DiemCK IS NOT NULL;

-- Số môn học mà từng sinh viên đã đăng ký
SELECT sv.MaSV, sv.HoTen, COUNT(dk.MaLHP) AS SoMonDangKy
FROM SinhVien sv
LEFT JOIN DangKy dk ON dk.MaSV = sv.MaSV
GROUP BY sv.MaSV, sv.HoTen
ORDER BY SoMonDangKy DESC;

-- Số sinh viên đăng ký từng môn học
SELECT m.MaMH, m.TenMH, COUNT(dk.MaSV) AS SoSVDangKy
FROM MonHoc m
LEFT JOIN LopHocPhan lhp ON lhp.MaMH = m.MaMH
LEFT JOIN DangKy dk      ON dk.MaLHP = lhp.MaLHP
GROUP BY m.MaMH, m.TenMH;

-- Điểm trung bình của từng sinh viên
SELECT sv.MaSV, sv.HoTen, d.DiemTB
FROM SinhVien sv
JOIN vw_DiemTBSV d ON d.MaSV = sv.MaSV
ORDER BY sv.MaSV;

-- Điểm trung bình của từng môn học
SELECT m.MaMH, m.TenMH, CAST(AVG(kq.DiemTK) AS DECIMAL(4,2)) AS DiemTB
FROM MonHoc m
JOIN LopHocPhan lhp ON lhp.MaMH = m.MaMH
JOIN KetQua kq      ON kq.MaLHP = lhp.MaLHP
GROUP BY m.MaMH, m.TenMH;

-- Sinh viên có điểm môn học >= 8
SELECT sv.MaSV, sv.HoTen, m.TenMH, kq.DiemTK
FROM KetQua kq
JOIN SinhVien sv    ON sv.MaSV = kq.MaSV
JOIN LopHocPhan lhp ON lhp.MaLHP = kq.MaLHP
JOIN MonHoc m       ON m.MaMH = lhp.MaMH
WHERE kq.DiemTK >= 8
ORDER BY kq.DiemTK DESC;

-- Sinh viên chưa đăng ký môn học nào
SELECT sv.MaSV, sv.HoTen
FROM SinhVien sv
WHERE NOT EXISTS (SELECT 1 FROM DangKy dk WHERE dk.MaSV = sv.MaSV);

-- Môn học chưa có sinh viên đăng ký
SELECT m.MaMH, m.TenMH
FROM MonHoc m
WHERE NOT EXISTS (SELECT 1
                  FROM LopHocPhan lhp
                  JOIN DangKy dk ON dk.MaLHP = lhp.MaLHP
                  WHERE lhp.MaMH = m.MaMH);

-- Số sinh viên đạt / không đạt theo từng môn học
SELECT m.MaMH, m.TenMH,
       SUM(CASE WHEN kq.DiemTK >= 4 THEN 1 ELSE 0 END) AS SoDat,
       SUM(CASE WHEN kq.DiemTK <  4 THEN 1 ELSE 0 END) AS SoKhongDat
FROM MonHoc m
JOIN LopHocPhan lhp ON lhp.MaMH = m.MaMH
JOIN KetQua kq      ON kq.MaLHP = lhp.MaLHP
GROUP BY m.MaMH, m.TenMH;

-- Sinh viên đăng ký nhiều môn học nhất trong một học kỳ (HK1 2025-2026)
SELECT TOP 1 WITH TIES sv.MaSV, sv.HoTen, COUNT(*) AS SoMon
FROM DangKy dk
JOIN SinhVien sv    ON sv.MaSV = dk.MaSV
JOIN LopHocPhan lhp ON lhp.MaLHP = dk.MaLHP
WHERE lhp.HocKy = 1 AND lhp.NamHoc = '2025-2026'
GROUP BY sv.MaSV, sv.HoTen
ORDER BY COUNT(*) DESC;

-- Sinh viên có điểm trung bình cao nhất
SELECT TOP 1 WITH TIES sv.MaSV, sv.HoTen, d.DiemTB
FROM vw_DiemTBSV d
JOIN SinhVien sv ON sv.MaSV = d.MaSV
ORDER BY d.DiemTB DESC;

-- Sinh viên đã đăng ký nhưng chưa có kết quả học tập
SELECT sv.MaSV, sv.HoTen, dk.MaLHP, m.TenMH
FROM DangKy dk
JOIN SinhVien sv    ON sv.MaSV = dk.MaSV
JOIN LopHocPhan lhp ON lhp.MaLHP = dk.MaLHP
JOIN MonHoc m       ON m.MaMH = lhp.MaMH
WHERE NOT EXISTS (SELECT 1 FROM KetQua kq
                  WHERE kq.MaSV = dk.MaSV AND kq.MaLHP = dk.MaLHP AND kq.DiemTK IS NOT NULL);

-- Sinh viên đăng ký TẤT CẢ lớp học phần của một học kỳ (HK2 2024-2025)
SELECT sv.MaSV, sv.HoTen
FROM SinhVien sv
WHERE NOT EXISTS (
    SELECT 1 FROM LopHocPhan lhp
    WHERE lhp.HocKy = 2 AND lhp.NamHoc = '2024-2025'
      AND NOT EXISTS (SELECT 1 FROM DangKy dk
                      WHERE dk.MaSV = sv.MaSV AND dk.MaLHP = lhp.MaLHP));

-- Môn học có điểm trung bình cao hơn điểm trung bình chung toàn trường
SELECT m.MaMH, m.TenMH, CAST(AVG(kq.DiemTK) AS DECIMAL(4,2)) AS DiemTB
FROM MonHoc m
JOIN LopHocPhan lhp ON lhp.MaMH = m.MaMH
JOIN KetQua kq      ON kq.MaLHP = lhp.MaLHP
GROUP BY m.MaMH, m.TenMH
HAVING AVG(kq.DiemTK) > (SELECT AVG(DiemTK) FROM KetQua);

-- Xếp hạng sinh viên theo điểm trung bình trong từng lớp
SELECT l.MaLop, RANK() OVER (PARTITION BY l.MaLop ORDER BY d.DiemTB DESC) AS HangTrongLop,
       sv.MaSV, sv.HoTen, d.DiemTB
FROM vw_DiemTBSV d
JOIN SinhVien sv ON sv.MaSV = d.MaSV
JOIN Lop l       ON l.MaLop = sv.MaLop
ORDER BY l.MaLop, HangTrongLop;

-- Sinh viên có kết quả học tập tốt nhất trong từng khoa
SELECT t.TenKhoa, t.MaSV, t.HoTen, t.DiemTB
FROM (SELECT k.TenKhoa, sv.MaSV, sv.HoTen, d.DiemTB,
             RANK() OVER (PARTITION BY k.MaKhoa ORDER BY d.DiemTB DESC) AS Hang
      FROM vw_DiemTBSV d
      JOIN SinhVien sv ON sv.MaSV = d.MaSV
      JOIN Lop l       ON l.MaLop = sv.MaLop
      JOIN Khoa k      ON k.MaKhoa = l.MaKhoa) t
WHERE t.Hang = 1
ORDER BY t.TenKhoa;
GO