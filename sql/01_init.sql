-- Inicialización de base de datos para canal omnicanal one‑pallet
-- Motor: MySQL 8 (InnoDB), 3FN, claves y índices pensados para consultas operativas.

CREATE DATABASE IF NOT EXISTS final_analisis CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE final_analisis;

-- =========================
-- Cuentas y roles (accounts)
-- =========================
CREATE TABLE accounts_role (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(32) NOT NULL, -- ADMIN, HQ_OPERATOR, DISTRIBUTOR, RETAILER, WAREHOUSE_OP
  name VARCHAR(64) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_role_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE accounts_user (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  username VARCHAR(150) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(128) NOT NULL,
  first_name VARCHAR(150) NOT NULL DEFAULT '',
  last_name VARCHAR(150) NOT NULL DEFAULT '',
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  is_staff TINYINT(1) NOT NULL DEFAULT 0,
  is_superuser TINYINT(1) NOT NULL DEFAULT 0,
  last_login DATETIME NULL,
  date_joined DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_user_username (username),
  UNIQUE KEY uq_user_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE accounts_user_roles (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  role_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_user_role (user_id, role_id),
  CONSTRAINT fk_userroles_user FOREIGN KEY (user_id) REFERENCES accounts_user(id),
  CONSTRAINT fk_userroles_role FOREIGN KEY (role_id) REFERENCES accounts_role(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Partners (distribuidores y retailers)
-- =========================
CREATE TABLE partners_distributor (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(32) NOT NULL,
  name VARCHAR(120) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_distributor_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE partners_retailer (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(32) NOT NULL,
  name VARCHAR(120) NOT NULL,
  distributor_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_retailer_code (code),
  KEY ix_retailer_distributor (distributor_id),
  CONSTRAINT fk_retailer_distributor FOREIGN KEY (distributor_id) REFERENCES partners_distributor(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Catálogo (brands, categories, products, skus)
-- =========================
CREATE TABLE catalog_brand (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(120) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_brand_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE catalog_category (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(120) NOT NULL,
  parent_id BIGINT UNSIGNED NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_category_name (name),
  KEY ix_category_parent (parent_id),
  CONSTRAINT fk_category_parent FOREIGN KEY (parent_id) REFERENCES catalog_category(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE catalog_product (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(200) NOT NULL,
  brand_id BIGINT UNSIGNED NULL,
  category_id BIGINT UNSIGNED NULL,
  PRIMARY KEY (id),
  KEY ix_product_brand (brand_id),
  KEY ix_product_category (category_id),
  CONSTRAINT fk_product_brand FOREIGN KEY (brand_id) REFERENCES catalog_brand(id),
  CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES catalog_category(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE catalog_sku (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  product_id BIGINT UNSIGNED NOT NULL,
  code VARCHAR(64) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  UNIQUE KEY uq_sku_code (code),
  KEY ix_sku_product (product_id),
  CONSTRAINT fk_sku_product FOREIGN KEY (product_id) REFERENCES catalog_product(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Pricing
-- =========================
CREATE TABLE pricing_pricelist (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(120) NOT NULL,
  currency CHAR(3) NOT NULL DEFAULT 'USD',
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  UNIQUE KEY uq_pricelist_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pricing_priceitem (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  pricelist_id BIGINT UNSIGNED NOT NULL,
  sku_id BIGINT UNSIGNED NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  valid_from DATETIME NOT NULL,
  valid_to DATETIME NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_priceitem (pricelist_id, sku_id, valid_from),
  KEY ix_priceitem_sku (sku_id),
  CONSTRAINT fk_priceitem_pricelist FOREIGN KEY (pricelist_id) REFERENCES pricing_pricelist(id),
  CONSTRAINT fk_priceitem_sku FOREIGN KEY (sku_id) REFERENCES catalog_sku(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Promociones
-- =========================
CREATE TABLE promo_promotion (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(120) NOT NULL,
  percent_off DECIMAL(5,2) NOT NULL DEFAULT 0.00,
  starts_at DATETIME NOT NULL,
  ends_at DATETIME NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE promo_promotion_skus (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  promotion_id BIGINT UNSIGNED NOT NULL,
  sku_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_promo_sku (promotion_id, sku_id),
  CONSTRAINT fk_promo_sku_promo FOREIGN KEY (promotion_id) REFERENCES promo_promotion(id),
  CONSTRAINT fk_promo_sku_sku FOREIGN KEY (sku_id) REFERENCES catalog_sku(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Almacenes e inventario one‑pallet
-- =========================
CREATE TABLE warehouses_warehouse (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(32) NOT NULL,
  name VARCHAR(120) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_warehouse_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE warehouses_inventorybatch (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  warehouse_id BIGINT UNSIGNED NOT NULL,
  sku_id BIGINT UNSIGNED NOT NULL,
  lot VARCHAR(64) NOT NULL,
  expires_at DATE NULL,
  qty_on_hand INT NOT NULL,
  qty_reserved INT NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE KEY uq_batch (warehouse_id, sku_id, lot),
  KEY ix_batch_fefo (warehouse_id, sku_id, expires_at),
  CONSTRAINT fk_batch_wh FOREIGN KEY (warehouse_id) REFERENCES warehouses_warehouse(id),
  CONSTRAINT fk_batch_sku FOREIGN KEY (sku_id) REFERENCES catalog_sku(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE warehouses_replenishmentrule (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  sku_id BIGINT UNSIGNED NOT NULL,
  warehouse_id BIGINT UNSIGNED NOT NULL,
  min_qty INT NOT NULL DEFAULT 0,
  target_qty INT NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE KEY uq_replenish (sku_id, warehouse_id),
  CONSTRAINT fk_replenish_sku FOREIGN KEY (sku_id) REFERENCES catalog_sku(id),
  CONSTRAINT fk_replenish_wh FOREIGN KEY (warehouse_id) REFERENCES warehouses_warehouse(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Órdenes y reservas/asignaciones
-- =========================
CREATE TABLE orders_retailerorder (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(32) NOT NULL,
  retailer_id BIGINT UNSIGNED NOT NULL,
  status VARCHAR(16) NOT NULL, -- DRAFT, PLACED, ALLOCATED, PICKED, SHIPPED, DELIVERED, CANCELLED
  warehouse_id BIGINT UNSIGNED NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_order_code (code),
  KEY ix_order_retailer (retailer_id),
  KEY ix_order_status_created (status, created_at),
  CONSTRAINT fk_order_retailer FOREIGN KEY (retailer_id) REFERENCES partners_retailer(id),
  CONSTRAINT fk_order_wh FOREIGN KEY (warehouse_id) REFERENCES warehouses_warehouse(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE orders_orderitem (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id BIGINT UNSIGNED NOT NULL,
  sku_id BIGINT UNSIGNED NOT NULL,
  qty INT NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id),
  KEY ix_item_order (order_id),
  KEY ix_item_sku (sku_id),
  CONSTRAINT fk_item_order FOREIGN KEY (order_id) REFERENCES orders_retailerorder(id),
  CONSTRAINT fk_item_sku FOREIGN KEY (sku_id) REFERENCES catalog_sku(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE orders_reservation (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_item_id BIGINT UNSIGNED NOT NULL,
  batch_id BIGINT UNSIGNED NOT NULL,
  qty INT NOT NULL,
  created_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  KEY ix_res_item (order_item_id),
  KEY ix_res_batch (batch_id),
  CONSTRAINT fk_res_item FOREIGN KEY (order_item_id) REFERENCES orders_orderitem(id),
  CONSTRAINT fk_res_batch FOREIGN KEY (batch_id) REFERENCES warehouses_inventorybatch(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE orders_allocation (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_item_id BIGINT UNSIGNED NOT NULL,
  batch_id BIGINT UNSIGNED NOT NULL,
  qty INT NOT NULL,
  created_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  KEY ix_alloc_item (order_item_id),
  KEY ix_alloc_batch (batch_id),
  CONSTRAINT fk_alloc_item FOREIGN KEY (order_item_id) REFERENCES orders_orderitem(id),
  CONSTRAINT fk_alloc_batch FOREIGN KEY (batch_id) REFERENCES warehouses_inventorybatch(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Fulfillment (carriers y shipments)
-- =========================
CREATE TABLE fulfillment_carrier (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(32) NOT NULL,
  name VARCHAR(120) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_carrier_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE fulfillment_shipment (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(32) NOT NULL,
  order_id BIGINT UNSIGNED NOT NULL,
  carrier_id BIGINT UNSIGNED NULL,
  tracking VARCHAR(64) NOT NULL,
  status VARCHAR(16) NOT NULL, -- CREATED, DISPATCHED, DELIVERED, CANCELLED
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_shipment_code (code),
  UNIQUE KEY uq_shipment_tracking (tracking),
  KEY ix_ship_order (order_id),
  CONSTRAINT fk_ship_order FOREIGN KEY (order_id) REFERENCES orders_retailerorder(id),
  CONSTRAINT fk_ship_carrier FOREIGN KEY (carrier_id) REFERENCES fulfillment_carrier(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE fulfillment_shipmentitem (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  shipment_id BIGINT UNSIGNED NOT NULL,
  order_item_id BIGINT UNSIGNED NOT NULL,
  qty INT NOT NULL,
  PRIMARY KEY (id),
  KEY ix_shipitem_ship (shipment_id),
  KEY ix_shipitem_item (order_item_id),
  CONSTRAINT fk_shipitem_ship FOREIGN KEY (shipment_id) REFERENCES fulfillment_shipment(id),
  CONSTRAINT fk_shipitem_item FOREIGN KEY (order_item_id) REFERENCES orders_orderitem(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Devoluciones/Buybacks
-- =========================
CREATE TABLE returns_buyback (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  retailer_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  KEY ix_buyback_retailer (retailer_id),
  CONSTRAINT fk_buyback_retailer FOREIGN KEY (retailer_id) REFERENCES partners_retailer(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE returns_buybackitem (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  buyback_id BIGINT UNSIGNED NOT NULL,
  batch_id BIGINT UNSIGNED NOT NULL,
  qty INT NOT NULL,
  PRIMARY KEY (id),
  KEY ix_bb_item_bb (buyback_id),
  KEY ix_bb_item_batch (batch_id),
  CONSTRAINT fk_bb_item_bb FOREIGN KEY (buyback_id) REFERENCES returns_buyback(id),
  CONSTRAINT fk_bb_item_batch FOREIGN KEY (batch_id) REFERENCES warehouses_inventorybatch(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Finanzas (crédito y liquidaciones)
-- =========================
CREATE TABLE finance_creditterms (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  partner_type ENUM('DISTRIBUTOR','RETAILER') NOT NULL,
  partner_id BIGINT UNSIGNED NOT NULL,
  credit_limit DECIMAL(12,2) NOT NULL DEFAULT 0,
  payment_terms_days INT NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  KEY ix_credit_partner (partner_type, partner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE finance_settlement (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  period VARCHAR(16) NOT NULL,
  partner_type ENUM('DISTRIBUTOR','RETAILER') NOT NULL,
  partner_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  KEY ix_settle_partner (partner_type, partner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE finance_settlementline (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  settlement_id BIGINT UNSIGNED NOT NULL,
  order_id BIGINT UNSIGNED NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id),
  KEY ix_settleline_settle (settlement_id),
  KEY ix_settleline_order (order_id),
  CONSTRAINT fk_settleline_settle FOREIGN KEY (settlement_id) REFERENCES finance_settlement(id),
  CONSTRAINT fk_settleline_order FOREIGN KEY (order_id) REFERENCES orders_retailerorder(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Índices adicionales de consulta
CREATE INDEX ix_batch_wh_sku_qty ON warehouses_inventorybatch (warehouse_id, sku_id, qty_on_hand);
CREATE INDEX ix_order_created ON orders_retailerorder (created_at);

-- Reglas de negocio a nivel motor (checks simples)
ALTER TABLE warehouses_inventorybatch
  ADD CONSTRAINT chk_qty_on_hand CHECK (qty_on_hand >= 0),
  ADD CONSTRAINT chk_qty_reserved CHECK (qty_reserved >= 0);

ALTER TABLE orders_orderitem
  ADD CONSTRAINT chk_item_qty CHECK (qty > 0);

ALTER TABLE orders_reservation
  ADD CONSTRAINT chk_res_qty CHECK (qty > 0);

ALTER TABLE orders_allocation
  ADD CONSTRAINT chk_alloc_qty CHECK (qty > 0);

