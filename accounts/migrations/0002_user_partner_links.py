from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ('partners','0001_initial'),
        ('accounts','0001_initial'),
    ]

    operations = [
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
    ]

