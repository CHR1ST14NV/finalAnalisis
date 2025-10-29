#!/usr/bin/env python
"""Punto de entrada de Django (Grupo #6).

Arranca con `core.settings` y está listo para ejecutarse en Docker.
"""
import os
import sys


def main() -> None:
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)


if __name__ == "__main__":
    main()
