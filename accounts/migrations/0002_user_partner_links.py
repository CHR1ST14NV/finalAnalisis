from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ('partners', '0001_initial'),
        ('accounts', '0001_initial'),
    ]

    operations = [
        # Use SeparateDatabaseAndState to ensure MySQL column type matches
        # unsigned BIGINT of referenced PKs, while keeping Django state as FK.
        migrations.SeparateDatabaseAndState(
            database_operations=[
                migrations.RunSQL(
                    sql=(
                        "ALTER TABLE `accounts_user` "
                        "ADD COLUMN `distributor_id` bigint unsigned NULL, "
                        "ADD CONSTRAINT `accounts_user_distributor_id_f3263ce4_fk_partners_distributor_id` "
                        "FOREIGN KEY (`distributor_id`) REFERENCES `partners_distributor`(`id`);"
                    ),
                    reverse_sql=(
                        "ALTER TABLE `accounts_user` "
                        "DROP FOREIGN KEY `accounts_user_distributor_id_f3263ce4_fk_partners_distributor_id`, "
                        "DROP COLUMN `distributor_id`;"
                    ),
                ),
                migrations.RunSQL(
                    sql=(
                        "ALTER TABLE `accounts_user` "
                        "ADD COLUMN `retailer_id` bigint unsigned NULL, "
                        "ADD CONSTRAINT `accounts_user_retailer_id_939d72ed_fk_partners_retailer_id` "
                        "FOREIGN KEY (`retailer_id`) REFERENCES `partners_retailer`(`id`);"
                    ),
                    reverse_sql=(
                        "ALTER TABLE `accounts_user` "
                        "DROP FOREIGN KEY `accounts_user_retailer_id_939d72ed_fk_partners_retailer_id`, "
                        "DROP COLUMN `retailer_id`;"
                    ),
                ),
            ],
            state_operations=[
                migrations.AddField(
                    model_name='user',
                    name='distributor',
                    field=models.ForeignKey(blank=True, null=True, on_delete=models.deletion.SET_NULL, to='partners.distributor'),
                ),
                migrations.AddField(
                    model_name='user',
                    name='retailer',
                    field=models.ForeignKey(blank=True, null=True, on_delete=models.deletion.SET_NULL, to='partners.retailer'),
                ),
            ],
        ),
    ]
