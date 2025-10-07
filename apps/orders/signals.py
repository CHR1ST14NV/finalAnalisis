from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Order
from apps.integrations.events import publish_event


@receiver(post_save, sender=Order)
def order_created(sender, instance: Order, created: bool, **kwargs):
    if created:
        publish_event("OrderCreated", {"order_id": str(instance.id), "status": instance.status})

