-- 8. Buat table produk
CREATE TABLE produk (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    kode VARCHAR(10) UNIQUE,
    nama VARCHAR(45) NOT NULL,
    harga DOUBLE NOT NULL,
    stok INT NOT NULL,
    jenis_produk_id INT NOT NULL REFERENCES jenis_produk(id)
);

-- 9. Buat table pesanan_items
CREATE TABLE pesanan_items (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    pesanan_id INT NOT NULL REFERENCES pesanan(id),
    produk_id INT NOT NULL REFERENCES produk(id),
    jumlah INT NOT NULL,
    subtotal DOUBLE NOT NULL
);

-- 10. Buat table vendor
CREATE TABLE vendor (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(45) NOT NULL,
    alamat TEXT,
    kontak VARCHAR(20)
);

-- 11. Buat table pembelian
CREATE TABLE pembelian (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    tanggal DATE NOT NULL,
    total DOUBLE NOT NULL,
    vendor_id INT NOT NULL REFERENCES vendor(id)
);
