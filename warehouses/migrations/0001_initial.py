from django.db import migrations, models
import django.db.models.deletion
from django.conf import settings


class Migration(migrations.Migration):
    initial = True

    dependencies = [
        ('catalog', '0001_initial'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Warehouse',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('code', models.CharField(max_length=32, unique=True)),
                ('name', models.CharField(max_length=120)),
                ('created_by', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='created_warehouses', to=settings.AUTH_USER_MODEL)),
                ('updated_by', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='updated_warehouses', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='InventoryBatch',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('lot', models.CharField(max_length=64)),
                ('expires_at', models.DateField(blank=True, null=True)),
                ('qty_on_hand', models.IntegerField()),
                ('qty_reserved', models.IntegerField(default=0)),
                ('created_by', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='created_inventorybatchs', to=settings.AUTH_USER_MODEL)),
                ('updated_by', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='updated_inventorybatchs', to=settings.AUTH_USER_MODEL)),
                ('sku', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='catalog.sku')),
                ('warehouse', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, related_name='batches', to='warehouses.warehouse')),
            ],
            options={'indexes': [models.Index(fields=['warehouse', 'sku', 'expires_at'], name='warehouses__warehouse_6a59b1_idx')]},
        ),
        migrations.CreateModel(
            name='ReplenishmentRule',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('min_qty', models.IntegerField(default=0)),
                ('target_qty', models.IntegerField(default=0)),
                ('created_by', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='created_replenishmentrules', to=settings.AUTH_USER_MODEL)),
                ('updated_by', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='updated_replenishmentrules', to=settings.AUTH_USER_MODEL)),
                ('sku', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='catalog.sku')),
                ('warehouse', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='warehouses.warehouse')),
            ],
        ),
        migrations.AlterUniqueTogether(name='inventorybatch', unique_together={(('warehouse', 'sku', 'lot'),)}),
        migrations.AlterUniqueTogether(name='replenishmentrule', unique_together={(('sku', 'warehouse'),)}),
    ]

