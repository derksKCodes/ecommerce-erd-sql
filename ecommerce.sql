-- Database creation
CREATE DATABASE ecommerce_db;

USE ecommerce_db;

-- Brand table
CREATE TABLE
    brand (
        brand_id INT AUTO_INCREMENT PRIMARY KEY,
        brand_name VARCHAR(100) NOT NULL,
        brand_description TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );

-- Product category table
CREATE TABLE
    product_category (
        category_id INT AUTO_INCREMENT PRIMARY KEY,
        category_name VARCHAR(100) NOT NULL,
        parent_category_id INT NULL,
        category_description TEXT,
        FOREIGN KEY (parent_category_id) REFERENCES product_category (category_id)
    );

-- Size category table
CREATE TABLE
    size_category (
        size_category_id INT AUTO_INCREMENT PRIMARY KEY,
        category_name VARCHAR(50) NOT NULL,
        description VARCHAR(255)
    );

-- Size options table
CREATE TABLE
    size_option (
        size_id INT AUTO_INCREMENT PRIMARY KEY,
        size_category_id INT NOT NULL,
        size_value VARCHAR(20) NOT NULL,
        FOREIGN KEY (size_category_id) REFERENCES size_category (size_category_id)
    );

-- Color table
CREATE TABLE
    color (
        color_id INT AUTO_INCREMENT PRIMARY KEY,
        color_name VARCHAR(50) NOT NULL,
        color_code VARCHAR(7) NOT NULL
    );

-- Attribute type table
CREATE TABLE
    attribute_type (
        attribute_type_id INT AUTO_INCREMENT PRIMARY KEY,
        type_name VARCHAR(50) NOT NULL,
        data_type ENUM ('text', 'number', 'boolean', 'date') NOT NULL
    );

-- Attribute category table
CREATE TABLE
    attribute_category (
        attribute_category_id INT AUTO_INCREMENT PRIMARY KEY,
        category_name VARCHAR(100) NOT NULL,
        description TEXT
    );

-- Product table
CREATE TABLE
    product (
        product_id INT AUTO_INCREMENT PRIMARY KEY,
        category_id INT NOT NULL,
        brand_id INT NOT NULL,
        product_name VARCHAR(255) NOT NULL,
        product_description TEXT,
        base_price DECIMAL(10, 2) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (category_id) REFERENCES product_category (category_id),
        FOREIGN KEY (brand_id) REFERENCES brand (brand_id)
    );

-- Product variation table
CREATE TABLE
    product_variation (
        variation_id INT AUTO_INCREMENT PRIMARY KEY,
        product_id INT NOT NULL,
        variation_name VARCHAR(100) NOT NULL,
        FOREIGN KEY (product_id) REFERENCES product (product_id)
    );

-- Product item table
CREATE TABLE
    product_item (
        item_id INT AUTO_INCREMENT PRIMARY KEY,
        product_id INT NOT NULL,
        sku VARCHAR(50) UNIQUE NOT NULL,
        quantity_in_stock INT NOT NULL DEFAULT 0,
        price DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY (product_id) REFERENCES product (product_id)
    );

-- Product image table
CREATE TABLE
    product_image (
        image_id INT AUTO_INCREMENT PRIMARY KEY,
        product_id INT NOT NULL,
        image_url VARCHAR(255) NOT NULL,
        is_primary BOOLEAN DEFAULT FALSE,
        FOREIGN KEY (product_id) REFERENCES product (product_id)
    );

-- Product attribute table
CREATE TABLE
    product_attribute (
        attribute_id INT AUTO_INCREMENT PRIMARY KEY,
        product_id INT NOT NULL,
        attribute_category_id INT NOT NULL,
        attribute_type_id INT NOT NULL,
        attribute_name VARCHAR(100) NOT NULL,
        attribute_value TEXT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES product (product_id),
        FOREIGN KEY (attribute_category_id) REFERENCES attribute_category (attribute_category_id),
        FOREIGN KEY (attribute_type_id) REFERENCES attribute_type (attribute_type_id)
    );

-- Product item variation values (junction table)
CREATE TABLE
    item_variation_values (
        item_id INT NOT NULL,
        variation_id INT NOT NULL,
        size_id INT NULL,
        color_id INT NULL,
        PRIMARY KEY (item_id, variation_id),
        FOREIGN KEY (item_id) REFERENCES product_item (item_id),
        FOREIGN KEY (variation_id) REFERENCES product_variation (variation_id),
        FOREIGN KEY (size_id) REFERENCES size_option (size_id),
        FOREIGN KEY (color_id) REFERENCES color (color_id)
    );