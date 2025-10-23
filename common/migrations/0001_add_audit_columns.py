from django.db import migrations, connections


TABLES = [
    # Core domain tables lacking audit fields in preseeded DB
    'partners_distributor',
    'partners_retailer',
    'catalog_brand',
    'catalog_category',
    'catalog_product',
    'catalog_sku',
    'pricing_pricelist',
    'pricing_priceitem',
    'promo_promotion',
    'warehouses_warehouse',
    'warehouses_inventorybatch',
    'warehouses_replenishmentrule',
    'orders_orderitem',
    'orders_reservation',
    'orders_allocation',
    'fulfillment_carrier',
    'fulfillment_shipmentitem',
    'returns_buybackitem',
    # Some already have created_at/updated_at; we still ensure both and by_ids exist
    'orders_retailerorder',
    'fulfillment_shipment',
    'returns_buyback',
]


def column_exists(cursor, table: str, column: str) -> bool:
    cursor.execute(
        """
        SELECT COUNT(*)
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = %s
          AND COLUMN_NAME = %s
        """,
        [table, column],
    )
    return cursor.fetchone()[0] > 0


def apply(apps, schema_editor):
    # Use the same connection Django is migrating
    conn = connections[schema_editor.connection.alias]
    with conn.cursor() as cursor:
        for table in TABLES:
            # created_at
            if not column_exists(cursor, table, 'created_at'):
                cursor.execute(
                    f"ALTER TABLE `{table}` ADD COLUMN `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP"
                )
            # updated_at
            if not column_exists(cursor, table, 'updated_at'):
                cursor.execute(
                    f"ALTER TABLE `{table}` ADD COLUMN `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"
                )
            # created_by_id
            if not column_exists(cursor, table, 'created_by_id'):
                cursor.execute(
                    f"ALTER TABLE `{table}` ADD COLUMN `created_by_id` BIGINT UNSIGNED NULL"
                )
            # updated_by_id
            if not column_exists(cursor, table, 'updated_by_id'):
                cursor.execute(
                    f"ALTER TABLE `{table}` ADD COLUMN `updated_by_id` BIGINT UNSIGNED NULL"
                )


class Migration(migrations.Migration):
    atomic = False

    dependencies = [
        ('accounts', '0001_initial'),
        ('partners', '0001_initial'),
    ]

    operations = [
        migrations.RunPython(apply, reverse_code=migrations.RunPython.noop),
    ]

