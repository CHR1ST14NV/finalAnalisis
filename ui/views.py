from __future__ import annotations

from typing import Any, Dict, List, Tuple

from django.apps import apps
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.core.paginator import Paginator
from django.forms import modelform_factory
from django.http import Http404, HttpRequest, HttpResponse
from django.shortcuts import get_object_or_404, redirect, render
from django.urls import reverse


def _get_model(app_label: str, model_name: str):
    try:
        return apps.get_model(app_label=app_label, model_name=model_name)
    except LookupError as e:
        raise Http404(str(e))


LIST_COLUMNS: Dict[str, List[str]] = {
    'catalog.brand': ['id', 'name', 'created_at'],
    'catalog.category': ['id', 'name', 'parent', 'created_at'],
    'catalog.product': ['id', 'name', 'brand', 'category', 'created_at'],
    'catalog.sku': ['id', 'product', 'code', 'is_active', 'created_at'],
    'partners.distributor': ['id', 'code', 'name', 'created_at'],
    'partners.retailer': ['id', 'code', 'name', 'distributor', 'created_at'],
    'warehouses.warehouse': ['id', 'code', 'name', 'created_at'],
    'warehouses.inventorybatch': ['id', 'warehouse', 'sku', 'lot', 'expires_at', 'qty_on_hand', 'qty_reserved'],
    'warehouses.replenishmentrule': ['id', 'sku', 'warehouse', 'min_qty', 'target_qty'],
    'orders.retailerorder': ['id', 'code', 'retailer', 'status', 'warehouse', 'created_at'],
    'orders.orderitem': ['id', 'order', 'sku', 'qty', 'unit_price', 'created_at'],
    'orders.reservation': ['id', 'order_item', 'batch', 'qty', 'created_at'],
    'orders.allocation': ['id', 'order_item', 'batch', 'qty', 'created_at'],
    'fulfillment.carrier': ['id', 'code', 'name', 'created_at'],
    'fulfillment.shipment': ['id', 'code', 'order', 'carrier', 'tracking', 'status', 'created_at'],
    'fulfillment.shipmentitem': ['id', 'shipment', 'order_item', 'qty', 'created_at'],
    'pricing.pricelist': ['id', 'name', 'currency', 'is_active', 'created_at'],
    'pricing.priceitem': ['id', 'pricelist', 'sku', 'amount', 'valid_from', 'valid_to'],
    'promo.promotion': ['id', 'name', 'percent_off', 'starts_at', 'ends_at', 'is_active'],
    'returns.buyback': ['id', 'retailer', 'created_at'],
    'returns.buybackitem': ['id', 'buyback', 'batch', 'qty', 'created_at'],
    'finance.creditterms': ['id', 'partner_type', 'partner_id', 'credit_limit', 'payment_terms_days'],
    'finance.settlement': ['id', 'period', 'partner_type', 'partner_id', 'created_at'],
    'finance.settlementline': ['id', 'settlement', 'order', 'amount', 'created_at'],
}


def _model_meta(model) -> Tuple[List[str], List[str]]:
    # columns to show and search
    default_fields = [f.name for f in model._meta.fields if f.name not in ('created_by', 'updated_by')]
    fields = LIST_COLUMNS.get(model._meta.label_lower, default_fields)
    fields = [f for f in fields if f in default_fields]
    search_fields = [f.name for f in model._meta.fields if f.get_internal_type() in ('CharField', 'TextField')]
    return fields, search_fields


def _can_write(request: HttpRequest, model) -> bool:
    u = request.user
    if getattr(u, 'is_superuser', False):
        return True
    if hasattr(u, 'has_role'):
        app = model._meta.app_label
        if u.has_role('ADMIN', 'HQ_OPERATOR'):
            return True
        if app in ('warehouses', 'fulfillment') and u.has_role('WAREHOUSE_OP'):
            return True
        if app == 'orders' and u.has_role('RETAILER'):
            return True
        if model._meta.label_lower == 'partners.retailer' and u.has_role('DISTRIBUTOR'):
            return True
    return False


@login_required(login_url='/admin/login/')
def ui_index(request: HttpRequest) -> HttpResponse:
    include_apps = ['accounts', 'partners', 'catalog', 'pricing', 'promo', 'warehouses', 'orders', 'fulfillment', 'returns', 'finance']
    app_models: Dict[str, List[Tuple[str, str]]] = {}
    for app_label in include_apps:
        try:
            config = apps.get_app_config(app_label)
        except LookupError:
            continue
        models = [(m.__name__, m._meta.verbose_name_plural.title()) for m in config.get_models() if m._meta.model_name != 'user']
        if models:
            app_models[app_label] = sorted(models, key=lambda x: x[0].lower())
    return render(request, 'ui/index.html', {'app_models': app_models})


@login_required(login_url='/admin/login/')
def model_list_view(request: HttpRequest, app_label: str, model_name: str) -> HttpResponse:
    model = _get_model(app_label, model_name)
    fields, search_fields = _model_meta(model)
    qs = model.objects.all().order_by('id')
    q = request.GET.get('q')
    if q and search_fields:
        from django.db.models import Q
        cond = Q()
        for f in search_fields:
            cond |= Q(**{f"{f}__icontains": q})
        qs = qs.filter(cond)
    paginator = Paginator(qs, 25)
    page = paginator.get_page(request.GET.get('page') or 1)
    ctx = {
        'app_label': app_label,
        'model_name': model_name,
        'fields': fields,
        'page_obj': page,
        'q': q or '',
    }
    return render(request, 'ui/list.html', ctx)


@login_required(login_url='/admin/login/')
def model_create_view(request: HttpRequest, app_label: str, model_name: str) -> HttpResponse:
    model = _get_model(app_label, model_name)
    if not _can_write(request, model):
        return redirect(reverse('ui-list', args=[app_label, model_name]))
    Form = modelform_factory(model, exclude=('created_by', 'updated_by'))
    if request.method == 'POST':
        form = Form(request.POST)
        if form.is_valid():
            obj = form.save(commit=False)
            if hasattr(obj, 'created_by_id'):
                obj.created_by = request.user
            if hasattr(obj, 'updated_by_id'):
                obj.updated_by = request.user
            obj.save()
            form.save_m2m()
            messages.success(request, 'Creado correctamente')
            return redirect(reverse('ui-list', args=[app_label, model_name]))
    else:
        form = Form()
    return render(request, 'ui/form.html', {'form': form, 'action': 'Crear', 'app_label': app_label, 'model_name': model_name})


@login_required(login_url='/admin/login/')
def model_update_view(request: HttpRequest, app_label: str, model_name: str, pk: int) -> HttpResponse:
    model = _get_model(app_label, model_name)
    obj = get_object_or_404(model, pk=pk)
    Form = modelform_factory(model, exclude=('created_by', 'updated_by'))
    if not _can_write(request, model):
        return redirect(reverse('ui-list', args=[app_label, model_name]))
    if request.method == 'POST':
        if not _can_write(request, model):
            return redirect(reverse('ui-list', args=[app_label, model_name]))
        form = Form(request.POST, instance=obj)
        if form.is_valid():
            obj = form.save(commit=False)
            if hasattr(obj, 'updated_by_id'):
                obj.updated_by = request.user
            obj.save()
            form.save_m2m()
            messages.success(request, 'Actualizado correctamente')
            return redirect(reverse('ui-list', args=[app_label, model_name]))
    else:
        form = Form(instance=obj)
    return render(request, 'ui/form.html', {'form': form, 'action': 'Editar', 'app_label': app_label, 'model_name': model_name})


@login_required(login_url='/admin/login/')
def model_delete_view(request: HttpRequest, app_label: str, model_name: str, pk: int) -> HttpResponse:
    model = _get_model(app_label, model_name)
    obj = get_object_or_404(model, pk=pk)
    if request.method == 'POST':
        obj.delete()
        messages.success(request, 'Eliminado correctamente')
        return redirect(reverse('ui-list', args=[app_label, model_name]))
    return render(request, 'ui/delete.html', {'object': obj, 'app_label': app_label, 'model_name': model_name})
