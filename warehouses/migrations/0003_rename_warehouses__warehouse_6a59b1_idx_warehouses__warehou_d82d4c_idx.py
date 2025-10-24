from django.db import migrations, connections


def _index_exists(cursor, table: str, index: str) -> bool:
    cursor.execute(
        """
        SELECT COUNT(1)
        FROM information_schema.statistics
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = %s
          AND INDEX_NAME = %s
        """,
        [table, index],
    )
    row = cursor.fetchone()
    return bool(row and row[0] > 0)


def safe_rename_index(apps, schema_editor):
    # This migration renames an index created in earlier versions. On some DBs
    # the index may already have the new name (or may not exist). Make it safe.
    conn = connections[schema_editor.connection.alias]
    table = 'warehouses_inventorybatch'
    old_name = 'warehouses__warehouse_6a59b1_idx'
    new_name = 'warehouses__warehou_d82d4c_idx'
    with conn.cursor() as cursor:
        if _index_exists(cursor, table, new_name):
            return
        if _index_exists(cursor, table, old_name):
            cursor.execute(f"ALTER TABLE `{table}` RENAME INDEX `{old_name}` TO `{new_name}`")
        # else: nothing to do


class Migration(migrations.Migration):

    dependencies = [
        ('warehouses', '0002_rename_warehouses__warehouse_6a59b1_idx_warehouses__warehou_d82d4c_idx_and_more'),
    ]

    operations = [
        migrations.RunPython(safe_rename_index, reverse_code=migrations.RunPython.noop),
    ]
