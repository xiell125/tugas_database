-- Worksheet 6 - Stored Procedures and Functions

-- SOAL 6.1.1: Procedure to update product prices by product type
DELIMITER $$
CREATE PROCEDURE pro_naikan_harga(
    IN jenis_produk_id INT,
    IN persentase_kenaikan INT
)
BEGIN
    UPDATE produk 
    SET harga_jual = harga_jual + (harga_jual * persentase_kenaikan / 100)
    WHERE jenis_produk_id = jenis_produk_id;
END $$
DELIMITER ;

-- SOAL 6.1.2: Function to calculate age from birth date
DELIMITER $$
CREATE FUNCTION umur(tgl_lahir DATE)
RETURNS INT
BEGIN
    DECLARE umur INT;
    SET umur = YEAR(CURDATE()) - YEAR(tgl_lahir);
    
    -- Adjust age if birthday hasn't occurred yet this year
    IF DATE_FORMAT(CURDATE(), '%m%d') < DATE_FORMAT(tgl_lahir, '%m%d') THEN
        SET umur = umur - 1;
    END IF;
    
    RETURN umur;
END $$
DELIMITER ;

-- SOAL 6.1.3: Function to categorize product prices
DELIMITER $$
CREATE FUNCTION kategori_harga(harga DOUBLE)
RETURNS VARCHAR(20)
BEGIN
    DECLARE kategori VARCHAR(20);
    
    IF harga <= 500000 THEN
        SET kategori = 'murah';
    ELSEIF harga <= 3000000 THEN
        SET kategori = 'sedang';
    ELSEIF harga <= 10000000 THEN
        SET kategori = 'mahal';
    ELSE
        SET kategori = 'sangat mahal';
    END IF;
    
    RETURN kategori;
END $$
DELIMITER ;


-- Worksheet 7 - Triggers and Procedures

-- Add status_pembayaran column to pembayaran table
ALTER TABLE pembayaran ADD COLUMN status_pembayaran VARCHAR(25);

-- SOAL 6.2.1: Trigger to check payment status
DELIMITER $$
CREATE TRIGGER cek_pembayaran BEFORE INSERT ON pembayaran
FOR EACH ROW
BEGIN
    DECLARE total_bayar DECIMAL(10, 2);
    DECLARE total_pesanan DECIMAL(10, 2);
    
    -- Calculate total payments made for this order
    SELECT COALESCE(SUM(jumlah), 0) INTO total_bayar 
    FROM pembayaran 
    WHERE pesanan_id = NEW.pesanan_id;
    
    -- Get total order amount
    SELECT total INTO total_pesanan 
    FROM pesanan 
    WHERE id = NEW.pesanan_id;
    
    -- Update payment status if fully paid
    IF (total_bayar + NEW.jumlah) >= total_pesanan THEN
        SET NEW.status_pembayaran = 'Lunas';
    ELSE
        SET NEW.status_pembayaran = 'Belum Lunas';
    END IF;
END $$
DELIMITER ;

-- SOAL 6.2.2: Stored Procedure to reduce product stock
DELIMITER $$
CREATE PROCEDURE kurangi_stok(
    IN produk_id INT,
    IN jumlah_pesanan INT
)
BEGIN
    UPDATE produk
    SET stok = stok - jumlah_pesanan
    WHERE id = produk_id;
END $$
DELIMITER ;

-- SOAL 6.2.3: Trigger to reduce stock after order items are inserted
DELIMITER $$
CREATE TRIGGER trig_kurangi_stok AFTER INSERT ON pesanan_items
FOR EACH ROW
BEGIN
    -- Call the stored procedure to reduce stock
    CALL kurangi_stok(NEW.produk_id, NEW.qty);
END $$
DELIMITER ;

-- Example payment insertion (for testing)
INSERT INTO pembayaran (no_kuitansi, tanggal, jumlah, ke, pesanan_id, status_pembayaran)
VALUES ('KWI001', '2023-03-03', 200000, 1, 1, NULL);