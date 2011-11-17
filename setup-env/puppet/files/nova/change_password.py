#!/usr/bin/env python
import sys
from django.core.management import setup_environ
import settings
setup_environ(settings)

from django.contrib.auth.models import User

user = User.objects.get(username=sys.argv[1])
user.set_password(sys.argv[2])
user.save()
