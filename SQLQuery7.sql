create table Asm4_MUCPHIS(
MaMP INT PRIMARY KEY identity(1,1),
Dongia DECIMAL(12,4) NOT NULL check(Dongia >= 0) default 0,
Mota NTEXT not null
);
create table Asm4_NHACUNGCAPS(
    MaNhaCC INT PRIMARY KEY identity(1,1),
	TenNhaCC Nvarchar(255) NOT NULL Unique,
	DiaChi varchar(255) NOT NULL,
	MaSoThue INT NOT NULL unique,
	SoDT varchar(15) not null unique check(SoDT like '0%')
);
create table Asm4_LOAIDICHVUS(
	MaLoaiDV INT PRIMARY KEY identity(1,1) ,
	TenLoaiDV Nvarchar(255) NOT NULL unique,
);
create table Asm4_DONGXES(
	Dongxe varchar(100) PRIMARY KEY,
	Hangxe varchar(100) NOT NULL,
	SoChoNgoi INT NOT NULL check(SoChoNgoi >= 1) default 1,
);
create table Asm4_DANGKYDICHVUS(
	MaDKCC INT PRIMARY KEY identity(1,1),
	MaNhaCC INT FOREIGN KEY REFERENCES Asm4_NHACUNGCAPS(MaNhaCC) NOT NULL,
	MaLoaiCC INT FOREIGN KEY  REFERENCES Asm4_LOAIDICHVUS(MaLoaiDV) NOT NULL,
	MaMP INT FOREIGN KEY REFERENCES Asm4_MUCPHIS(MaMP) NOT NULL,
	Dongxe varchar(100) FOREIGN KEY REFERENCES Asm4_DONGXES(Dongxe) NOT NULL,
	NgayBatDauCungCap DATE NOT NULL ,
	NgayKetThucCungCap DATE NOT NULL ,
	SoLuongXeDangKY INT NOT NULL check(SoLuongXeDangKY >= 0) default 0,
);



--Drop table Asm4_DANGKYDICHVUS;
--Drop table Asm4_LOAIDICHVUS;
--Drop table Asm4_DONGXES;
--Drop table Asm4_NHACUNGCAPS;
--Drop table Asm4_MUCPHIS;

select * from Asm4_DANGKYDICHVUS;
select * from Asm4_DONGXES;
select * from Asm4_LOAIDICHVUS;
select * from Asm4_MUCPHIS;
select * from Asm4_NHACUNGCAPS;


--Câu 3: Liệt kê những dòng xe có số chỗ ngồi trên 5 chỗ
select * from Asm4_DONGXES where SoChoNgoi > 5;

--Câu 4: Liệt kê thông tin của các nhà cung cấp đã từng đăng ký cung cấp những dòng xe 
--thuộc hãng xe “Toyota” với mức phí có đơn giá là 15.000 VNĐ/km hoặc những
--dòng xe thuộc hãng xe “KIA” với mức phí có đơn giá là 20.000 VNĐ/km
select * from Asm4_NHACUNGCAPS where MaNhaCC in 
(select MaNhaCC from Asm4_DANGKYDICHVUS where ( Dongxe in (select Dongxe from Asm4_DONGXES where Hangxe like 'Toyota') and MaMP in 
( select MaMP from Asm4_MUCPHIS where Dongia = 15 ) ) 
or (Dongxe in (select Dongxe from Asm4_DONGXES where Hangxe like 'KIA' )
 and  MaMP in  ( select MaMP from Asm4_MUCPHIS where Dongia = 20 ) ) 
 
 );

 --chữa cách 2 <khuyên ko nên do chậm hơn>
 select distinct B.* from Asm4_DANGKYDICHVUS A
 inner join Asm4_NHACUNGCAPS B on A.MaNhaCC = B.MaNhaCC
inner join Asm4_MUCPHIS C on A.MaMP = C.MaMP 
 inner join Asm4_DONGXES D on A.Dongxe = D.Dongxe
where (D.Dongxe like 'Toyota' and C.Dongia = 15) or 
(D.Dongxe like 'KIA' and C.Dongia = 20);

--Câu 5: Liệt kê thông tin toàn bộ nhà cung cấp được sắp xếp tăng dần theo tên nhà cung cấp và giảm dần theo mã số thuế

select * from Asm4_NHACUNGCAPS order by TenNhaCC asc, MaSoThue desc;

--Câu 6: Đếm số lần đăng ký cung cấp phương tiện tương ứng cho từng nhà cung cấp với
--yêu cầu chỉ đếm cho những nhà cung cấp thực hiện đăng ký cung cấp có ngày  bắt đầu cung cấp là “20/11/2015”

select MaNhaCC,count(MaDKCC) as SolanCungcap from  Asm4_DANGKYDICHVUS 
where NgayBatDauCungCap >= '2015-11-20' group by MaNhaCC;



--Câu 7: Liệt kê tên của toàn bộ các hãng xe có trong cơ sở dữ liệu với yêu cầu mỗi hãng xe chỉ được liệt kê một lần

select Distinct Hangxe from Asm4_DONGXES;

--Câu 8: Liệt kê MaDKCC, MaNhaCC, TenNhaCC, DiaChi, MaSoThue, TenLoaiDV, DonGia, HangXe, NgayBatDauCC, NgayKetThucCC 
--của tất cả các lần đăng ký cung cấp phương tiện với yêu cầu những nhà cung cấp nào chưa từng thực hiện đăng ký cung cấp
--phương tiện thì cũng liệt kê thông tin những nhà cung cấp đó ra

select *  from  Asm4_DANGKYDICHVUS A
right join Asm4_NHACUNGCAPS B on A.MaNhaCC = B.MaNhaCC
right join Asm4_DONGXES C on A.Dongxe = C.Dongxe
right join Asm4_LOAIDICHVUS D on A.MaLoaiCC = D.MaLoaiDV
right join Asm4_MUCPHIS E on A.MaMP = E.MaMP Order by TenNhaCC asc;

--chữa

select Distinct a.MaDKCC,a.MaNhaCC,B.TenNhaCC,B.DiaChi,
B.MaSoThue,E.TenLoaiDV, C.DonGia, D.Hangxe, A.NgayBatDauCungCap, A.NgayKetThucCungCap  from  Asm4_DANGKYDICHVUS A
right join Asm4_NHACUNGCAPS B on A.MaNhaCC = B.MaNhaCC
left join Asm4_MUCPHIS C on A.MaMP = C.MaMP 
Left join Asm4_DONGXES D on A.Dongxe = D.Dongxe
left join Asm4_LOAIDICHVUS E on A.MaLoaiCC = E.MaLoaiDV
;


--Câu 9: Liệt kê thông tin của các nhà cung cấp đã từng đăng ký cung cấp phương tiện
--thuộc dòng xe “Hiace” hoặc từng đăng ký cung cấp phương tiện thuộc dòng xe “Cerato”

select * from Asm4_NHACUNGCAPS where MaNhaCC in 
(select MaNhaCC from Asm4_DANGKYDICHVUS where Dongxe like 'Hiace' or Dongxe like 'Cerato') 

--chữa 


select * from Asm4_NHACUNGCAPS where MaNhaCC in 
(select MaNhaCC from Asm4_DANGKYDICHVUS where Dongxe in ('Hiace','Cerato')) 


--Câu 10: Liệt kê thông tin của các nhà cung cấp chưa từng thực hiện đăng ký cung cấp phương tiện lần nào cả.

select * from Asm4_NHACUNGCAPS where MaNhaCC in 
(select MaNhaCC from Asm4_DANGKYDICHVUS where Dongxe like null ); --sai

--chữa

select * from Asm4_NHACUNGCAPS where MaNhaCC not in
(select MaNhaCC from Asm4_DANGKYDICHVUS)