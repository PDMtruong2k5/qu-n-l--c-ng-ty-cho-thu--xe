-- Tạo Database
CREATE DATABASE QuanLyThueXe;
GO


-- Bảng Khách Hàng
CREATE TABLE KhachHang (
    MaKH INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    CMND VARCHAR(12) UNIQUE NOT NULL,
    SDT VARCHAR(15) NULL,
    DiaChi NVARCHAR(255) NULL,
    Email VARCHAR(100) UNIQUE NULL
);
GO

--- Bảng Xe
CREATE TABLE Xe (
    MaXe INT IDENTITY(1,1) PRIMARY KEY,
    BienSo VARCHAR(15) UNIQUE NOT NULL,
    HangXe NVARCHAR(50) NOT NULL,
    Model NVARCHAR(50) NOT NULL,
    NamSX INT NOT NULL CHECK (NamSX >= 1900 AND NamSX <= YEAR(GETDATE())),
    GiaThue DECIMAL(10,2) NOT NULL CHECK (GiaThue > 0),
    TrangThai NVARCHAR(20) NOT NULL DEFAULT N'Có sẵn' 
        CHECK (TrangThai IN (N'Có sẵn', N'Đang thuê', N'Bảo trì'))
);
GO


-- Bảng Nhân Viên
CREATE TABLE NhanVien (
    MaNV INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    ChucVu NVARCHAR(50) NULL,
    SDT VARCHAR(15) NULL,
    Email VARCHAR(100) UNIQUE NULL,
    DiaChi NVARCHAR(255) NULL
);
GO


-- Bảng Hợp Đồng Thuê Xe
CREATE TABLE HopDongThue (
    MaHD INT IDENTITY(1,1) PRIMARY KEY,
    MaKH INT NOT NULL,
    MaXe INT NOT NULL,
    MaNV INT NULL, 
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,
    TongTien DECIMAL(10,2) NOT NULL CHECK (TongTien >= 0),
    TrangThai NVARCHAR(20) NOT NULL DEFAULT N'Đang hiệu lực' 
        CHECK (TrangThai IN (N'Đang hiệu lực', N'Hoàn thành', N'Hủy bỏ')),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH) ON DELETE CASCADE,
    FOREIGN KEY (MaXe) REFERENCES Xe(MaXe) ON DELETE CASCADE,
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV) ON DELETE SET NULL
);
GO


-- Thêm CHECK CONSTRAINT kiểm tra ngày hợp lệ bằng cách dùng TRIGGER
CREATE TRIGGER trg_Check_NgayKetThuc
ON HopDongThue
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE NgayKetThuc <= NgayBatDau
    )
    BEGIN
        RAISERROR (N'NgayKetThuc phải lớn hơn NgayBatDau', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Bảng Hóa Đơn
CREATE TABLE HoaDon (
    MaHD INT IDENTITY(1,1) PRIMARY KEY,
    MaHopDong INT NOT NULL,
    NgayThanhToan DATE NOT NULL,
    SoTien DECIMAL(10,2) NOT NULL CHECK (SoTien >= 0),
    TrangThai NVARCHAR(20) NOT NULL DEFAULT N'Chưa thanh toán' 
        CHECK (TrangThai IN (N'Đã thanh toán', N'Chưa thanh toán')),
    FOREIGN KEY (MaHopDong) REFERENCES HopDongThue(MaHD) ON DELETE CASCADE
);
GO
-- Bảng Chăm Sóc Khách Hàng
CREATE TABLE ChamSocKH (
    MaCSKH INT IDENTITY(1,1) PRIMARY KEY,  
    MaKH INT NOT NULL,                     
    MaNV INT NULL, 
    NgayChamSoc DATETIME NOT NULL DEFAULT GETDATE(),  
    HinhThuc NVARCHAR(50) NOT NULL CHECK (HinhThuc IN (N'Gọi điện', N'Email', N'Tin nhắn', N'Gặp mặt')),  
    NoiDung NVARCHAR(500) NOT NULL,        
    GhiChu NVARCHAR(255) NULL,             
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH) ON DELETE CASCADE,  
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV) ON DELETE SET NULL  
);
GO

-- Bảng Bảo Trì Xe
CREATE TABLE BaoTriXe (
    MaBaoTri INT IDENTITY(1,1) PRIMARY KEY,  
    MaXe INT NOT NULL,                        
    NgayBaoTri DATE NOT NULL DEFAULT GETDATE(),  
    ChiPhi DECIMAL(10,2) NOT NULL CHECK (ChiPhi >= 0),  
    MoTa NVARCHAR(500) NOT NULL,  
    GhiChu NVARCHAR(255) NULL,  
    FOREIGN KEY (MaXe) REFERENCES Xe(MaXe) ON DELETE CASCADE  
);
GO
-- Chèn dữ liệu vào bảng KhachHang
INSERT INTO KhachHang (HoTen, CMND, SDT, DiaChi, Email) VALUES
(N'Nguyen Van An', N'123456789012', N'0987654321', N'Ha Noi', N'a@gmail.com'),
(N'Tran Thi Bac', N'123456789013', N'0978654321', N'Hai Phong', N'b@gmail.com'),
(N'Le Van Cam', N'123456789014', N'0967654321', N'Da Nang', N'c@gmail.com'),
(N'Pham Thi Dien', N'123456789015', N'0957654321', N'TP Ho Chi Minh', N'd@gmail.com'),
(N'Hoang Van Em', N'123456789016', N'0947654321', N'Can Tho', N'e@gmail.com'),
(N'Vu Thi Phuc', N'123456789017', N'0937654321', N'Hue', N'f@gmail.com'),
(N'Bui Van Gio', N'123456789018', N'0927654321', N'Quang Ninh', N'g@gmail.com'),
('Dang Thi Hoan', N'123456789019', N'0917654321', N'Binh Duong', N'h@gmail.com'),
(N'Nguyen Van In', N'123456789020', N'0907654321', N'Dong Nai', N'i@gmail.com'),
(N'Trinh Van Diem', N'123456789021', N'0897654321', N'Nha Trang', N'j@gmail.com'),
(N'Pham Thi Khoi', N'123456789022', N'0887654321', N'Vinh', N'k@gmail.com'),
(N'Le Van Loi', N'123456789023', N'0877654321', N'Quang Ngai', N'l@gmail.com'),
(N'Doan Van Mien', N'123456789024', N'0867654321', N'Bac Ninh', N'm@gmail.com'),
(N'Ngo Thi Nam', N'123456789025', N'0857654321', N'Thanh Hoa', N'n@gmail.com'),
(N'Mai Van Ouy', N'123456789026', N'0847654321', N'Thai Binh', N'o@gmail.com');

-- Chèn dữ liệu vào bảng Xe
INSERT INTO Xe (BienSo, HangXe, Model, NamSX, GiaThue, TrangThai) VALUES
(N'29A-12345', N'Toyota', N'Vios', 2020, 500000, N'Có sẵn'),
(N'30B-67890', N'Honda', N'City', 2021, 550000, N'Có sẵn'),
(N'31C-11122', N'Hyundai', N'Accent', 2019, 480000, N'Đang thuê'),
(N'32D-33344', N'Mazda', N'Mazda3', 2022, 600000, N'Có sẵn'),
(N'33E-55566', N'Kia', N'Cerato', 2020, 520000, N'Bảo trì'),
(N'34F-77788', N'Ford', N'Everest', 2021, 750000, N'Có sẵn'),
(N'35G-99900', N'Chevrolet', N'Spark', 2018, 350000, N'Có sẵn'),
(N'36H-22233', N'Suzuki', N'Swift', 2021, 530000, N'Đang thuê'),
(N'37I-44455', N'BMW', N'320i', 2023, 900000, N'Có sẵn'),
(N'38J-66677', N'Mercedes', N'C200', 2022, 950000, N'Có sẵn'),
(N'39K-88899', N'Audi', N'A4', 2021, 870000, N'Có sẵn'),
(N'40L-00011', N'VinFast', N'Lux A', 2020, 600000, N'Có sẵn'),
(N'41M-22233', N'Mitsubishi', N'Xpander', 2021, 700000, N'Đang thuê'),
(N'42N-44455', N'Nissan', N'Sunny', 2019, 450000, N'Có sẵn'),
(N'43O-66677', N'Lexus', N'RX350', 2023, 1100000, N'Có sẵn');

-- Chèn dữ liệu vào bảng NhanVien
INSERT INTO NhanVien (HoTen, ChucVu, SDT, Email, DiaChi) VALUES
(N'Nguyen Van Phai', N'Quản lý', N'0981234567', N'phai@gmail.com', N'Ha Noi'),
(N'Tran Thi Quynh', N'Nhân viên', N'0971234567', N'quynh@gmail.com', N'Hai Phong'),
(N'Le Van Rang', N'Nhân viên', N'0961234567', N'rang@gmail.com', N'Da Nang'),
(N'Pham Thi Sang', N'Nhân viên', N'0951234567', N'sang@gmail.com', N'TP Ho Chi Minh'),
(N'Hoang Van Thinh', N'Nhân viên', N'0941234567', N'thinh@gmail.com', N'Can Tho'),
(N'Vu Thi Uong', N'Nhân viên', N'0931234567', N'uong@gmail.com', N'Hue'),
(N'Bui Van Vu', N'Nhân viên', N'0921234567', N'vu@gmail.com', N'Quang Ninh'),
(N'Dang Thi Gam', N'Nhân viên', N'0911234567', N'Gam@gmail.com', N'Binh Duong'),
(N'Nguyen Van Xich', N'Nhân viên', N'0901234567', N'xich@gmail.com', N'Dong Nai'),
(N'Trinh Van Yen', N'Nhân viên', N'0891234567', N'yen@gmail.com', N'Nha Trang'),
(N'Pham Thi Danh', N'Nhân viên', N'0881234567', N'danh@gmail.com', N'Vinh'),
(N'Le Van Anh', N'Nhân viên', N'0871234567', N'anh@gmail.com', N'Quang Ngai'),
(N'Doan Van Bo', N'Nhân viên', N'0861234567', N'bo@gmail.com', N'Bac Ninh'),
(N'Ngo Thi Cam', N'Nhân viên', N'0851234567', N'cam@gmail.com', N'Thanh Hoa'),
(N'Mai Van Danh', N'Nhân viên', N'0841234567', N'dang@gmail.com', N'Thai Binh');

-- Chèn dữ liệu vào bảng HopDongThue
INSERT INTO HopDongThue (MaKH, MaXe, MaNV, NgayBatDau, NgayKetThuc, TongTien, TrangThai) VALUES
(1, 1, 1, N'2024-02-01', N'2024-02-05', 2500000, N'Hoàn thành'),
(2, 2, 2, N'2024-02-03', N'2024-02-07', 2750000, N'Hoàn thành'),
(3, 3, 3, N'2024-02-10', N'2024-02-14', 1920000, N'Hoàn thành'),
(4, 4, 4, N'2024-02-15', N'2024-02-20', 3000000, N'Hoàn thành'),
(5, 5, 5, N'2024-02-18', N'2024-02-22', 2600000, N'Hoàn thành'),
(6, 6, 6, N'2024-02-22', N'2024-02-26', 3000000, N'Hoàn thành'),
(7, 7, 7, N'2024-02-25', N'2024-02-28', 1400000, N'Hoàn thành'),
(8, 8, 8, N'2024-02-28', N'2024-03-05', 3180000, N'Đang hiệu lực'),
(9, 9, 9, N'2024-03-01', N'2024-03-06', 4500000, N'Đang hiệu lực'),
(10, 10, 10, N'2024-03-03', N'2024-03-10', 6650000, N'Đang hiệu lực'),
(11, 11, 11, N'2024-03-05', N'2024-03-10', 4350000, N'Đang hiệu lực'),
(12, 12, 12, N'2024-03-07', N'2024-03-12', 3000000, N'Đang hiệu lực'),
(13, 13, 13, N'2024-03-08', N'2024-03-14', 3600000, N'Đang hiệu lực'),
(14, 14, 14, N'2024-03-09', N'2024-03-15', 2500000, N'Đang hiệu lực'),
(15, 15, 15, N'2024-03-10', N'2024-03-16', 4200000, N'Đang hiệu lực');

-- Chèn dữ liệu vào bảng HoaDon
INSERT INTO HoaDon (MaHopDong, NgayThanhToan, SoTien, TrangThai) VALUES
(2, N'2024-02-05', 2500000, N'Đã thanh toán'),
(3, N'2024-02-07', 2750000, N'Đã thanh toán'),
(4, N'2024-02-14', 1920000, N'Đã thanh toán'),
(5, N'2024-02-20', 3000000, N'Đã thanh toán'),
(6, N'2024-02-22', 2600000, N'Đã thanh toán'),
(7, N'2024-02-26', 3000000, N'Đã thanh toán'),
(8, N'2024-02-28', 1400000, N'Đã thanh toán'),
(9, N'2024-03-01', 3180000, N'Chưa thanh toán'),
(10, N'2024-03-01', 4500000, N'Chưa thanh toán'),
(11, N'2024-03-03', 6650000, N'Chưa thanh toán'),
(12, N'2024-03-04', 4350000, N'Chưa thanh toán'),
(13, N'2024-03-05', 3000000, N'Chưa thanh toán'),
(14, N'2024-03-10', 3600000, N'Chưa thanh toán'),
(15, N'2024-03-11', 2500000, N'Chưa thanh toán'),
(16, N'2024-03-21', 4200000, N'Chưa thanh toán');


-- Chèn dữ liệu vào bảng BaoTriXe
INSERT INTO BaoTriXe (MaXe, NgayBaoTri, ChiPhi, MoTa, GhiChu) VALUES
(1, N'2024-01-15', 500000, N'Thay dầu máy', N'Không có vấn đề'),
(2, N'2024-01-20', 700000, N'Thay lốp xe', N'Lốp mòn'),
(3, N'2024-01-22', 800000, N'Bảo dưỡng động cơ', N'Động cơ yếu'),
(4, N'2024-01-28', 600000, N'Sửa phanh', N'Phanh kém'),
(5, N'2024-02-01', 1000000, N'Sơn lại xe', N'Trầy xước nhiều'),
(6, N'2024-02-05', 750000, N'Bảo dưỡng hệ thống lái', N'Vô lăng lệch'),
(7, N'2024-02-10', 500000, N'Vệ sinh nội thất', N'Bụi bẩn nhiều'),
(8, N'2024-02-15', 1200000, N'Thay acquy', N'Acquy yếu'),
(9, N'2024-02-18', 850000, N'Kiểm tra điện', N'Hệ thống điện lỗi'),
(10, N'2024-02-22', 680000, N'Sửa điều hòa', N'Điều hòa kém lạnh'),
(11, N'2024-02-25', 930000, N'Bảo dưỡng hộp số', N'Sang số khó'),
(12, N'2024-03-01', 780000, N'Thay dầu hộp số', N'Hộp số có tiếng kêu'),
(13, N'2024-03-05', 1100000, N'Bảo dưỡng toàn diện', N'Bảo trì định kỳ'),
(14, N'2024-03-08', 970000, N'Thay bugi', N'Khó khởi động'),
(15, N'2024-03-10', 1250000, N'Kiểm tra gầm xe', N'Gầm xe có tiếng động lạ');

-- Chèn dữ liệu vào bảng ChamSocKH
INSERT INTO ChamSocKH (MaKH, MaNV, NgayChamSoc, HinhThuc, NoiDung, GhiChu) VALUES
(1, 1, N'2024-02-01 10:00:00', N'Gọi điện', N'Hỏi thăm về trải nghiệm thuê xe', NULL),
(2, 2, N'2024-02-03 15:30:00', N'Email', N'Gửi phiếu khảo sát dịch vụ', NULL),
(3, 3, N'2024-02-07 09:45:00', N'Tin nhắn', N'Thông báo khuyến mãi mới', NULL),
(4, 4, N'2024-02-10 14:20:00', N'Gặp mặt', N'Tư vấn thuê xe dài hạn', N'Khách quan tâm xe VinFast'),
(5, 5, N'2024-02-12 11:10:00', N'Gọi điện', N'Nhắc khách kiểm tra xe sau khi thuê', NULL),
(6, 6, N'2024-02-15 16:00:00', N'Email', N'Cảm ơn khách hàng đã sử dụng dịch vụ', NULL),
(7, 7, N'2024-02-18 13:50:00', N'Gặp mặt', N'Hỗ trợ hướng dẫn sử dụng xe', N'Khách chưa quen với xe số tự động'),
(8, 8, N'2024-02-20 17:30:00', N'Gọi điện', N'Nhắc lịch bảo trì xe', NULL),
(9, 9, N'2024-02-22 12:00:00', N'Email', N'Cập nhật chương trình giảm giá', NULL),
(10, 10, N'2024-02-25 08:45:00', N'Tin nhắn', N'Mời khách hàng tham gia sự kiện lái thử', NULL),
(11, 11, N'2024-02-28 19:00:00', N'Gọi điện', N'Hỏi thăm về thái độ phục vụ của nhân viên', NULL),
(12, 12, N'2024-03-01 10:30:00', N'Email', N'Gửi hướng dẫn lái xe an toàn', NULL),
(13, 13, N'2024-03-05 16:40:00', N'Gặp mặt', N'Hỗ trợ đăng ký thuê xe dài hạn', N'Khách quan tâm xe SUV'),
(14, 14, N'2024-03-07 14:00:00', N'Tin nhắn', N'Thông báo xe mới về showroom', NULL),
(15, 15, N'2024-03-10 09:20:00', N'Gọi điện', N'Nhắc khách hoàn tất thanh toán hóa đơn', NULL);

-- In dữ liệu.
SELECT * FROM KhachHang
SELECT * FROM Xe
SELECT * FROM NhanVien
SELECT * FROM HoaDon
SELECT * FROM HopDongThue
SELECT * FROM BaoTriXe
SELECT * FROM ChamSocKH

--*. Các View
-- 1. View danh sách khách hàng và số lượng hợp đồng đã thuê
CREATE VIEW v_DanhSachKhachHang AS
SELECT KH.MaKH, KH.HoTen, KH.SDT, KH.Email, COUNT(HD.MaHD) AS SoLuongHopDong
FROM KhachHang KH
LEFT JOIN HopDongThue HD ON KH.MaKH = HD.MaKH
GROUP BY KH.MaKH, KH.HoTen, KH.SDT, KH.Email;
GO

-- 2. View danh sách xe có sẵn để thuê
CREATE VIEW v_XeCoSan AS
SELECT MaXe, BienSo, HangXe, Model, NamSX, GiaThue
FROM Xe
WHERE TrangThai = N'Có sẵn';
GO

-- 3. View tổng số tiền hóa đơn theo hợp đồng
CREATE VIEW v_TongTienHoaDon AS
SELECT MaHopDong, SUM(SoTien) AS TongTien
FROM HoaDon
GROUP BY MaHopDong;
GO

-- 4. View danh sách nhân viên và số hợp đồng đã xử lý
CREATE VIEW v_NhanVienHopDong AS
SELECT NV.MaNV, NV.HoTen, NV.ChucVu, COUNT(HD.MaHD) AS SoLuongHopDong
FROM NhanVien NV
LEFT JOIN HopDongThue HD ON NV.MaNV = HD.MaNV
GROUP BY NV.MaNV, NV.HoTen, NV.ChucVu;
GO

-- 5. View danh sách hợp đồng còn hiệu lực
CREATE VIEW v_HopDongHieuLuc AS
SELECT MaHD, MaKH, MaXe, NgayBatDau, NgayKetThuc, TongTien
FROM HopDongThue
WHERE TrangThai = N'Đang hiệu lực';
GO

-- 6. View tổng số tiền chi phí bảo trì xe theo từng năm
CREATE VIEW v_ChiPhiBaoTriNam AS
SELECT YEAR(NgayBaoTri) AS Nam, SUM(ChiPhi) AS TongChiPhi
FROM BaoTriXe
GROUP BY YEAR(NgayBaoTri);
GO

-- 7. View danh sách xe đang thuê với thông tin khách hàng
CREATE VIEW v_XeDangThue AS
SELECT X.MaXe, X.BienSo, X.HangXe, X.Model, KH.HoTen, HD.NgayBatDau, HD.NgayKetThuc
FROM Xe X
JOIN HopDongThue HD ON X.MaXe = HD.MaXe
JOIN KhachHang KH ON HD.MaKH = KH.MaKH
WHERE HD.TrangThai = N'Đang hiệu lực';
GO

-- 8. View tổng số lượng xe theo từng hãng
CREATE VIEW v_TongXeTheoHang AS
SELECT HangXe, COUNT(*) AS SoLuongXe
FROM Xe
GROUP BY HangXe;
GO

-- 9. View danh sách hóa đơn chưa thanh toán
CREATE VIEW v_HoaDonChuaThanhToan AS
SELECT MaHD, MaHopDong, NgayThanhToan, SoTien
FROM HoaDon
WHERE TrangThai = N'Chưa thanh toán';
GO
-- 10. VIEW Danh sách xe còn trống để thuê
CREATE VIEW XeConTrong AS
SELECT MaXe, BienSo, HangXe, Model, NamSX, GiaThue
FROM Xe
WHERE TrangThai = N'Có sẵn';
GO

-- 1. Kiểm tra danh sách khách hàng và số lượng hợp đồng đã thuê
SELECT * FROM v_DanhSachKhachHang;
-- 2. Kiểm tra danh sách xe có sẵn để thuê
SELECT * FROM v_XeCoSan;
-- 3. Kiểm tra tổng số tiền hóa đơn theo hợp đồng
SELECT * FROM v_TongTienHoaDon;
-- 4. Kiểm tra danh sách nhân viên và số hợp đồng đã xử lý
SELECT * FROM v_NhanVienHopDong;
-- 5. Kiểm tra danh sách hợp đồng còn hiệu lực
SELECT * FROM v_HopDongHieuLuc;
-- 6. Kiểm tra tổng số tiền chi phí bảo trì xe theo từng năm
SELECT * FROM v_ChiPhiBaoTriNam;
-- 7. Kiểm tra danh sách xe đang thuê với thông tin khách hàng
SELECT * FROM v_XeDangThue;
-- 8. Kiểm tra tổng số lượng xe theo từng hãng
SELECT * FROM v_TongXeTheoHang;
-- 9. Kiểm tra danh sách hóa đơn chưa thanh toán
SELECT * FROM v_HoaDonChuaThanhToan;
-- 10. VIEW Danh sách xe còn trống để thuê
SELECT * FROM XeConTrong;

--*. Các procedure
--1. Thêm khách hàng mới
DROP PROCEDURE IF EXISTS sp_ThemKhachHang;
GO
CREATE PROCEDURE sp_ThemKhachHang
    @HoTen NVARCHAR(100),
    @CMND VARCHAR(12),
    @SDT VARCHAR(15),
    @DiaChi NVARCHAR(255),
    @Email VARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM KhachHang WHERE CMND = @CMND OR Email = @Email)
    BEGIN
        PRINT N'Khách hàng đã tồn tại!';
        RETURN;
    END
    
    INSERT INTO KhachHang (HoTen, CMND, SDT, DiaChi, Email)
    VALUES (@HoTen, @CMND, @SDT, @DiaChi, @Email);
    
    PRINT N'Thêm khách hàng thành công!';
END;
GO
EXEC sp_ThemKhachHang N'Nguyen Tan Binh', N'1234567810000', N'0987651234', N'Bac Ninh', N'b_new@gmail.com';
SELECT * FROM KhachHang;

--2. Xóa khách hàng theo số điện thoại
IF OBJECT_ID(N'DeleteCustomerByPhone', N'P') IS NOT NULL
    DROP PROCEDURE DeleteCustomerByPhone;
GO
CREATE PROCEDURE DeleteCustomerByPhone
    @SoDT NVARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;
    -- Kiểm tra khách hàng có tồn tại không
    IF EXISTS (SELECT 1 FROM KhachHang WHERE SDT = @SoDT)
    BEGIN
        -- Kiểm tra khách hàng có hợp đồng thuê xe không
        IF EXISTS (SELECT 1 FROM HopDongThue WHERE MaKH = (SELECT MaKH FROM KhachHang WHERE SDT = @SoDT))
        BEGIN
            PRINT N'Không thể xóa khách hàng vì đang có hợp đồng thuê xe!';
        END
        ELSE
        BEGIN
            -- Xóa khách hàng
            DELETE FROM KhachHang WHERE SDT = @SoDT;
            PRINT N'Xóa khách hàng thành công!';
        END
    END
    ELSE
    BEGIN
        PRINT N'Không tìm thấy khách hàng với số điện thoại này!';
    END
END;
GO
-- Gọi Procedure xóa khách hàng
EXEC DeleteCustomerByPhone N'0987651234';
EXEC DeleteCustomerByPhone N'0978654321';
SELECT * FROM KhachHang;

--3. Tìm kiếm khách hàng theo số điện thoại
IF OBJECT_ID(N'FindCustomerByPhone', N'P') IS NOT NULL
    DROP PROCEDURE FindCustomerByPhone;
GO
CREATE PROCEDURE FindCustomerByPhone
    @SoDT NVARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;
    -- Kiểm tra khách hàng có tồn tại không
    IF EXISTS (SELECT 1 FROM KhachHang WHERE SDT = @SoDT)
    BEGIN
        -- Trả về thông tin khách hàng
        SELECT * FROM KhachHang WHERE SDT = @SoDT;
    END
    ELSE
    BEGIN
        PRINT N'Không tìm thấy khách hàng với số điện thoại này!';
    END
END;
GO
-- Gọi Procedure tìm kiếm khách hàng
EXEC FindCustomerByPhone N'0978654321';
EXEC FindCustomerByPhone N'09876512345';

-- 4. Thêm xe mới
IF OBJECT_ID(N'AddCar', N'P') IS NOT NULL
    DROP PROCEDURE AddCar;
GO

CREATE PROCEDURE AddCar
    @BienSo NVARCHAR(20),
    @HangXe NVARCHAR(50),
    @Model NVARCHAR(50),
    @NamSX INT,
    @GiaThue DECIMAL(18,2),
    @TrangThai NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Xe (BienSo, HangXe, Model, NamSX, GiaThue, TrangThai)
    VALUES (@BienSo, @HangXe, @Model, @NamSX, @GiaThue, @TrangThai);

    PRINT N'Thêm xe thành công!';
END;
GO
EXEC AddCar N'51A-12345', N'Toyota', N'Camry', 2022, 500000, N'Có sẵn';
EXEC AddCar N'51B-67890', N'Honda', N'Civic', 2021, 450000, N'Có sẵn';
EXEC AddCar N'51C-54321', N'Ford', N'Focus', 2020, 400000, N'Đang thuê';
EXEC AddCar N'51D-98765', N'Hyundai', N'Accent', 2019, 350000, N'Có sẵn';
EXEC AddCar N'51E-11223', N'Kia', N'Sorento', 2023, 600000, N'Có sẵn';
SELECT * FROM Xe;

--5. Xóa xe theo biển số 
IF OBJECT_ID(N'DeleteCarByBienSo', N'P') IS NOT NULL
    DROP PROCEDURE DeleteCarByBienSo;
GO

CREATE PROCEDURE DeleteCarByBienSo
    @BienSo NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    -- Kiểm tra xe có tồn tại không
    IF EXISTS (SELECT 1 FROM Xe WHERE BienSo = @BienSo)
    BEGIN
        -- Kiểm tra xe có đang được thuê không
        IF EXISTS (SELECT 1 FROM HopDongThue WHERE MaXe = (SELECT MaXe FROM Xe WHERE BienSo = @BienSo))
        BEGIN
            PRINT N'Không thể xóa xe vì đang có hợp đồng thuê!';
        END
        ELSE
        BEGIN
            -- Xóa xe
            DELETE FROM Xe WHERE BienSo = @BienSo;
            PRINT N'Xóa xe thành công!';
        END
    END
    ELSE
    BEGIN
        PRINT N'Không tìm thấy xe với biển số này!';
    END
END;
GO
-- Gọi procedure mới
EXEC DeleteCarByBienSo N'51A-12345';
EXEC DeleteCarByBienSo N'51B-67890';
EXEC DeleteCarByBienSo N'51C-54321';
EXEC DeleteCarByBienSo N'51D-98765';
EXEC DeleteCarByBienSo N'51E-11223';
SELECT * FROM Xe;

--6. Tìm kiếm xe theo biển số
IF OBJECT_ID(N'FindCarByBienSo', N'P') IS NOT NULL
    DROP PROCEDURE FindCarByBienSo;
GO
CREATE PROCEDURE FindCarByBienSo
    @BienSo NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    -- Kiểm tra xe có tồn tại không
    IF EXISTS (SELECT 1 FROM Xe WHERE BienSo = @BienSo)
    BEGIN
        -- Trả về thông tin xe
        SELECT * FROM Xe WHERE BienSo = @BienSo;
    END
    ELSE
    BEGIN
        PRINT N'Không tìm thấy xe với biển số này!';
    END
END;
GO
EXEC DeleteCarByBienSo N'51E-11223';
EXEC FindCarByBienSo N'33E-55566';

-- 7. Thống kê số lượng xe đã thuê theo tháng
IF OBJECT_ID(N'ThongKeXeThueTheoThang', N'P') IS NOT NULL
    DROP PROCEDURE ThongKeXeThueTheoThang;
GO
CREATE PROCEDURE ThongKeXeThueTheoThang
    @Nam INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Thống kê số lượng xe đã thuê theo từng tháng trong năm
    SELECT 
        MONTH(NgayBatDau) AS Thang,
        COUNT(*) AS SoLuongXeThue
    FROM HopDongThue
    WHERE YEAR(NgayBatDau) = @Nam
    GROUP BY MONTH(NgayBatDau)
    ORDER BY Thang;

    -- Kiểm tra nếu không có dữ liệu
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT N'Không có dữ liệu thuê xe trong năm ' + CAST(@Nam AS NVARCHAR(4));
    END
END;
GO
-- Gọi Procedure thống kê xe thuê theo năm 2024
EXEC ThongKeXeThueTheoThang @Nam = 2024;

-- 8. Tìm kiếm xe theo trạng thái
ALTER PROCEDURE sp_TimKiemXe  
    @TrangThai NVARCHAR(20)  
AS  
BEGIN  
    -- In ra thông báo kiểm tra đầu vào  
    PRINT N'Trạng thái tìm kiếm: ' + @TrangThai;  

    -- Kiểm tra nếu bảng không có dữ liệu phù hợp  
    IF NOT EXISTS (SELECT 1 FROM Xe WHERE LTRIM(RTRIM(TrangThai)) = LTRIM(RTRIM(@TrangThai)))  
    BEGIN  
        PRINT N'Không tìm thấy xe với trạng thái: ' + @TrangThai;  
        RETURN;  
    END  

    -- Trả về danh sách xe phù hợp  
    SELECT * FROM Xe WHERE LTRIM(RTRIM(TrangThai)) = LTRIM(RTRIM(@TrangThai));  
END;  
GO  
-- Tìm kiếm xe theo trạng thái
EXEC sp_TimKiemXe @TrangThai = N'Có sẵn';
GO

-- 9. Cập nhật trạng thái xe sau khi trả
ALTER PROCEDURE sp_CapNhatTrangThaiXe  
    @MaXe INT  
AS  
BEGIN  
    -- Kiểm tra xem xe có tồn tại không  
    IF NOT EXISTS (SELECT 1 FROM Xe WHERE MaXe = @MaXe)  
    BEGIN  
        PRINT N'Không tìm thấy xe với MaXe = ' + CAST(@MaXe AS NVARCHAR);  
        RETURN;  
    END  

    -- Cập nhật trạng thái xe  
    UPDATE Xe  
    SET TrangThai = N'Có sẵn'  
    WHERE MaXe = @MaXe;  

    PRINT N'Cập nhật trạng thái xe thành công!';  

    -- Hiển thị thông tin xe sau khi cập nhật  
    SELECT * FROM Xe WHERE MaXe = @MaXe;  
END;  
GO  
EXEC sp_CapNhatTrangThaiXe @MaXe = 17;  
GO  

-- 10. Thống kê số lượng xe theo trạng thái
CREATE PROCEDURE sp_ThongKeXe
AS
BEGIN
    SELECT TrangThai, COUNT(*) AS SoLuong FROM Xe
    GROUP BY TrangThai;
END;
GO
-- Thống kê số lượng xe theo trạng thái
EXEC sp_ThongKeXe;
GO

-- Trigger 1: Kiểm tra tuổi của xe khi thêm vào hệ thống
DROP TRIGGER IF EXISTS trg_Check_NamSX;
GO

CREATE TRIGGER trg_Check_NamSX
ON Xe
FOR INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE NamSX < 1900 OR NamSX > YEAR(GETDATE()))
    BEGIN
        RAISERROR (N'Năm sản xuất không hợp lệ!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
INSERT INTO Xe (BienSo, HangXe, Model, NamSX, GiaThue, TrangThai) 
VALUES (N'51B-67890', N'Ford Ranger',N'City', 2023, 700000, N'Có sẵn'); 


-- Trigger 2: Cập nhật trạng thái xe khi có hợp đồng thuê
DROP TRIGGER IF EXISTS trg_Update_TrangThai_Xe;
GO

CREATE TRIGGER trg_Update_TrangThai_Xe
ON HopDongThue
AFTER INSERT
AS
BEGIN
    UPDATE Xe
    SET TrangThai = N'Đang thuê'
    WHERE MaXe IN (SELECT MaXe FROM inserted);
END;
GO


-- Trigger 3: Đảm bảo khách hàng không thuê cùng một xe hai lần chưa trả
CREATE TRIGGER trg_Check_Duplicate_Rental
ON HopDongThue
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN HopDongThue h ON i.MaKH = h.MaKH AND i.MaXe = h.MaXe AND h.NgayKetThuc IS NULL
    )
    BEGIN
        RAISERROR (N'Khách hàng đã thuê xe này và chưa trả!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger 4: Tự động cập nhật trạng thái xe khi xe được trả
CREATE TRIGGER trg_Return_Xe
ON HopDongThue
AFTER UPDATE
AS
BEGIN
    IF UPDATE(NgayKetThuc)
    BEGIN
        UPDATE Xe
        SET TrangThai = N'Có sẵn'
        WHERE MaXe IN (SELECT MaXe FROM inserted WHERE NgayKetThuc IS NOT NULL);
    END
END;
GO

-- Trigger 5: Kiểm tra số điện thoại hợp lệ của khách hàng
CREATE TRIGGER trg_Check_SDT_KhachHang
ON KhachHang
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE SDT NOT LIKE N'[0-9]%')
    BEGIN
        RAISERROR (N'Số điện thoại không hợp lệ!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger 6: Kiểm tra định dạng email của nhân viên
CREATE TRIGGER trg_Check_Email_NhanVien
ON NhanVien
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Email NOT LIKE N'%@%.%')
    BEGIN
        RAISERROR (N'Email không hợp lệ!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger 7: Không cho phép xóa nhân viên nếu họ có hợp đồng đang hoạt động
CREATE TRIGGER trg_Prevent_Delete_NhanVien
ON NhanVien
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM deleted d JOIN HopDongThue h ON d.MaNV = h.MaNV WHERE h.NgayKetThuc IS NULL)
    BEGIN
        RAISERROR (N'Không thể xóa nhân viên có hợp đồng đang hoạt động!', 16, 1);
        RETURN;
    END
    DELETE FROM NhanVien WHERE MaNV IN (SELECT MaNV FROM deleted);
END;
GO

-- Trigger 8: Không cho phép xóa khách hàng nếu họ có hợp đồng chưa trả
CREATE TRIGGER trg_Prevent_Delete_KhachHang
ON KhachHang
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM deleted d JOIN HopDongThue h ON d.MaKH = h.MaKH WHERE h.NgayKetThuc IS NULL)
    BEGIN
        RAISERROR (N'Không thể xóa khách hàng có hợp đồng chưa trả!', 16, 1);
        RETURN;
    END
    DELETE FROM KhachHang WHERE MaKH IN (SELECT MaKH FROM deleted);
END;
GO

-- Trigger 9: Kiểm tra giá thuê xe không được âm
CREATE TRIGGER trg_Check_GiaThue
ON Xe
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE GiaThue <= 0)
    BEGIN
        RAISERROR (N'Giá thuê phải lớn hơn 0!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger 10: Tự động ghi log khi thêm hợp đồng mới
DROP TRIGGER IF EXISTS trg_Log_New_HopDong;
GO

CREATE TRIGGER trg_Log_New_HopDong
ON HopDongThue
AFTER INSERT
AS
BEGIN
    INSERT INTO LogTable (MoTa, ThoiGian)
    SELECT CONCAT(N'Hợp đồng mới được thêm: ', MaHD), GETDATE()
    FROM inserted;
END;
GO

-- ================================
-- KIỂM TRA HOẠT ĐỘNG CỦA CÁC TRIGGER
-- ================================

-- Test Trigger 1: Kiểm tra năm sản xuất xe
PRINT N'==== Test Trigger 1: Kiểm tra năm sản xuất xe ===='
BEGIN TRY
    INSERT INTO Xe (BienSo, HangXe, NamSX, GiaThue, TrangThai) 
    VALUES (N'30A-12345', N'Toyota Camry', 1800, 500000, N'Có sẵn');
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH
GO


-- Test Trigger 3: Không cho khách hàng thuê xe chưa trả
DECLARE @MaXe INT;

-- Lấy MaXe của một xe mà khách hàng đang thuê nhưng chưa trả
SELECT TOP 1 @MaXe = MaXe 
FROM HopDongThue 
WHERE MaKH = 1 AND NgayKetThuc IS NULL
ORDER BY NgayBatDau DESC;

-- Nếu không tìm thấy MaXe, báo lỗi và dừng lại
IF @MaXe IS NULL
BEGIN
    PRINT N'Không tìm thấy xe nào mà khách đang thuê để kiểm tra Trigger.';
    RETURN;
END

PRINT N'==== Test Trigger 3: Không cho khách thuê xe chưa trả ====';

BEGIN TRY
    INSERT INTO HopDongThue (MaKH, MaXe, NgayBatDau, NgayKetThuc) 
    VALUES (1, @MaXe, N'2025-03-20', NULL);
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
GO


DECLARE @MaXe INT;

-- Lấy MaXe của hợp đồng thuê gần nhất (hoặc theo một điều kiện cụ thể)
SELECT TOP 1 @MaXe = MaXe FROM HopDongThue ORDER BY NgayBatDau DESC;

-- Nếu không tìm thấy MaXe, báo lỗi
IF @MaXe IS NULL
BEGIN
    PRINT N'Không tìm thấy MaXe phù hợp để cập nhật.';
    RETURN;
END

PRINT N'==== Test Trigger 4: Cập nhật trạng thái xe khi xe được trả ====';

-- Cập nhật NgayKetThuc để kích hoạt Trigger
UPDATE HopDongThue 
SET NgayKetThuc = '2025-03-21'
WHERE MaXe = @MaXe;

-- Kiểm tra trạng thái xe sau khi cập nhật
SELECT * FROM Xe WHERE MaXe = @MaXe;
GO

-- Test Trigger 5: Kiểm tra số điện thoại khách hàng
PRINT N'==== Test Trigger 5: Kiểm tra số điện thoại khách hàng ===='
BEGIN TRY
    INSERT INTO KhachHang (HoTen, SDT, Email) 
    VALUES (N'Nguyen Van A', N'ABC123', N'test@gmail.com');
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH
GO

-- Test Trigger 6: Kiểm tra email nhân viên
PRINT N'==== Test Trigger 6: Kiểm tra email nhân viên ===='
BEGIN TRY
    INSERT INTO NhanVien (HoTen, Email) 
    VALUES (N'Tran Van B', N'emailkhonghople');
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH
GO

-- Test Trigger 7: Không cho xóa nhân viên có hợp đồng chưa kết thúc
PRINT N'==== Test Trigger 7: Không cho xóa nhân viên có hợp đồng chưa kết thúc ===='
BEGIN TRY
    DELETE FROM NhanVien WHERE MaNV = 1;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH
GO

-- Test Trigger 8: Không cho xóa khách hàng có hợp đồng chưa trả
PRINT N'==== Test Trigger 8: Không cho xóa khách hàng có hợp đồng chưa trả ===='
BEGIN TRY
    DELETE FROM KhachHang WHERE MaKH = 1;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH
GO

-- Test Trigger 9: Không cho phép giá thuê xe âm
PRINT N'==== Test Trigger 9: Không cho phép giá thuê xe âm ===='
BEGIN TRY
    INSERT INTO Xe (BienSo, HangXe, NamSX, GiaThue, TrangThai) 
    VALUES (N'51C-98765', N'BMW X5', 2022, -100000, N'Có sẵn');
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH
GO


--- Mã hóa các cột nhạy cảm (Column-level encryption)
-- 1. Tạo Master Key nếu chưa có
CREATE MASTER KEY ENCRYPTION BY PASSWORD = N'StrongPassword123!';
GO
-- 2. Tạo Certificate
CREATE CERTIFICATE CustomerCert
WITH SUBJECT = N'Certificate for Column Encryption';
GO
SELECT name, subject FROM sys.certificates WHERE name = N'CustomerCert';

-- 3. Tạo Database Encryption Key
CREATE SYMMETRIC KEY CustomerSymmetricKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE CustomerCert;
GO
SELECT name, algorithm_desc FROM sys.symmetric_keys WHERE name = N'CustomerSymmetricKey';

-- 4. Bật Transparent Data Encryption (TDE) nếu cần (cho toàn bộ database)
USE QuanLyThueXe;
GO
CREATE DATABASE ENCRYPTION KEY  
WITH ALGORITHM = AES_256  
ENCRYPTION BY SERVER CERTIFICATE CustomerCert;
GO
ALTER DATABASE QuanLyThueXe SET ENCRYPTION ON;
GO

-- 5. Tạo bảng KhachHang
CREATE SYMMETRIC KEY EmailKey WITH ALGORITHM = AES_256 ENCRYPTION BY PASSWORD =N'truongpham111';

-- 6. Mở khóa Symmetric Key để sử dụng
OPEN SYMMETRIC KEY EmailKey DECRYPTION BY PASSWORD = N'truongpham111';

-- 7. Mã hóa Email khi chèn dữ liệu vào bảng KhachHang
IF NOT EXISTS (SELECT 1 FROM KhachHang WHERE CMND = N'123456789')
BEGIN
INSERT INTO KhachHang (HoTen, CMND,SDT,DiaChi, Email)
VALUES (N'Nguyen Van A', N'123456789',N'099999999',N'Bac Ninh', ENCRYPTBYKEY(KEY_GUID(N'CustomerSymmetricKey'), N'nguyenvana@example.com'));
END
ELSE
BEGIN
    PRINT N'Khách hàng với CMND này đã tồn tại!';
END
SELECT * FROM KhachHang;
-- 8. Xóa dữ liệu trong bảng KhachHang (nếu cần)
-- DELETE FROM KhachHang;
-- GO

-- 9. Giải mã dữ liệu khi truy vấn bảng KhachHang
SELECT MaKH, HoTen,CMND,SDT,DiaChi,
       CONVERT(NVARCHAR(MAX), DECRYPTBYKEY(Email)) AS EmailGiaiMa
FROM KhachHang;
GO

-- 10. Đóng khóa sau khi sử dụng
CLOSE SYMMETRIC KEY CustomerSymmetricKey;
GO

-- Phân quyền và cấp quyền
-- Tạo login cho các người dùng
CREATE LOGIN admin WITH PASSWORD = N'password_admin';
CREATE LOGIN manager WITH PASSWORD = N'password_manager';
CREATE LOGIN customer WITH PASSWORD = N'password_customer';

-- Tạo user trong cơ sở dữ liệu
USE QuanLyThueXe;  -- Thay BTL_SQL bằng tên thực tế của cơ sở dữ liệu nếu khác

CREATE USER admin FOR LOGIN admin;
CREATE USER manager FOR LOGIN manager;
CREATE USER customer FOR LOGIN customer;

-- Cấp quyền db_owner cho admin
ALTER ROLE db_owner ADD MEMBER admin;

-- Cấp quyền db_datareader và db_datawriter cho manager
ALTER ROLE db_datareader ADD MEMBER manager;
ALTER ROLE db_datawriter ADD MEMBER manager;

-- Cấp quyền db_datareader cho customer
ALTER ROLE db_datareader ADD MEMBER customer;

-- Kiểm tra quyền của user
SELECT DP1.name AS DatabaseRole, DP2.name AS DatabaseUser
FROM   sys.database_role_members AS DRM
       RIGHT OUTER JOIN sys.database_principals AS DP1
       ON DP1.principal_id = DRM.role_principal_id
       RIGHT OUTER JOIN sys.database_principals AS DP2
       ON DP2.principal_id = DRM.member_principal_id
WHERE  DP2.name IN (N'admin', N'manager', N'customer');
